public with sharing class PipelineHistoryEngine {
  public PipelineHistoryEngine() {
  }

  /**
   * @description creates new Pipeline Histories when a Status record is created or when its Prospecting Status is changed...
   *              or updates existing Pipeline Histories when a Status has new prospecting activity which does not change the Prospecting Status
   * @param statuses - the new and updated Status records
   * @param oldStatuses - the old Status records
   * @param allOcasUnderStatus - all Outbound Contact Activations under the Status records
   * @param newlyProcessedTasks - the new and updated Task records which prompted the reevaluation of Pipeline Histories
   */
  public fflib_SObjectUnitOfWork maintainHistoryForProspectingStatuses(
    List<Status__c> statuses,
    List<Status__c> oldStatuses,
    List<Outbound_Contact_Activation__c> allOcasUnderStatus,
    List<Task> newlyProcessedTasks,
    fflib_SObjectUnitOfWork uow
  ) {
    Map<Id, List<SObject>> ocasByContactId = Mapper.byId(
      allOcasUnderStatus,
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
    );

    Set<Id> statusIds = Pluck.ids(statuses);
    statusIds.remove(null);

    // Prepare a map to hold existing Pipeline Histories
    Map<Id, List<SObject>> pipelineHistoriesByOsId = Mapper.byId(
      new PipelineHistorySelector().selectHistoriesByStatusIds(statusIds),
      C.PROSPECTING_EFFORT_OS_FIELD
    );

    // prep a map of Contacts by Account Id so we can get contacts via the Status__c.Account__c field
    Map<Id, List<Contact>> activatedContactsByAccountId = Mapper.byId(
      new ContactSelector().selectContactsByIds(ocasByContactId.keySet()),
      C.ACCOUNT_ID_FIELD
    );

    Map<Id, SObject> oldStatusById = Mapper.singleById(oldStatuses);

    Map<Id, List<Task>> tasksByWhoId = Mapper.byId(
      newlyProcessedTasks,
      C.ACTIVITY_WHO_ID_FIELD
    );

    List<Prospecting_Effort__c> maintainedPipelineHistories = new List<Prospecting_Effort__c>();
    // Iterate over newAndUpdatedStatuses to create or update Pipeline History records
    for (Status__c status : statuses) {
      // If entry does not have an ID, it's new & we need a new Pipeline History record to reflect the OS Prospecting Status
      boolean isNew = (status.Id == null);
      boolean statusChanged =
        !isNew &&
        oldStatusById.containsKey(status.Id) &&
        oldStatusById.get(status.Id).get(C.STATUS_PROSPECTING_STATUS_FIELD) !=
        status.Prospecting_Status__c;

      // Skip processing if the status is not new, has not changed, and there is no existing Pipeline History record
      if (
        !isNew &&
        !statusChanged &&
        pipelineHistoriesByOsId.get(status.Id) == null
      ) {
        continue;
      }

      if (isNew || statusChanged) {
        Prospecting_Effort__c newPipelineHistory = PipelineHistoryHelper.createNew(
          status
        );

        for (
          Contact activatedContact : activatedContactsByAccountId.get(
            status.Account__c
          )
        ) {
          if (isNew) {
            newPipelineHistory = addOcasToPipelineHistory(
              newPipelineHistory,
              (List<Outbound_Contact_Activation__c>) ocasByContactId.get(
                activatedContact.Id
              )
            );
          }
          newPipelineHistory = incrementTaskIds(
            newPipelineHistory,
            tasksByWhoId.containsKey(activatedContact.Id)
              ? tasksByWhoId.get(activatedContact.Id)
              : new List<Task>()
          );
        }

        if (statusChanged) {
          newPipelineHistory = incrementPipelineHistoryByStatusDelta(
            newPipelineHistory,
            (Status__c) oldStatusById.get(status.Id),
            status
          );
        }

        uow.registerNew(newPipelineHistory);
        uow.registerRelationship(
          newPipelineHistory,
          Prospecting_Effort__c.Outbound_Status__c,
          status
        );
      } else if (pipelineHistoriesByOsId.containsKey(status.Id)) {
        Prospecting_Effort__c relevantHistory;

        for (SObject history : pipelineHistoriesByOsId.get(status.Id)) {
          if (
            history.get(C.PROSPECTING_EFFORT_STATUS_FIELD) ==
            C.PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME.get(
              status.Prospecting_Status__c
            )
          ) {
            relevantHistory = (Prospecting_Effort__c) history;
            break;
          }
        }

        relevantHistory = incrementPipelineHistoryByStatusDelta(
          relevantHistory,
          (Status__c) oldStatusById.get(status.Id),
          status
        );
        for (
          Contact activatedContact : activatedContactsByAccountId.get(
            status.Account__c
          )
        ) {
          relevantHistory = incrementTaskIds(
            relevantHistory,
            tasksByWhoId.containsKey(activatedContact.Id)
              ? tasksByWhoId.get(activatedContact.Id)
              : new List<Task>()
          );
        }

        uow.registerDirty(relevantHistory);
      }
    }

    return uow;
  }

  // helper
  private static Prospecting_Effort__c addOcasToPipelineHistory(
    Prospecting_Effort__c pipelineHistory,
    List<Outbound_Contact_Activation__c> ocas
  ) {
    for (Outbound_Contact_Activation__c oca : ocas) {
      pipelineHistory = PipelineHistoryHelper.incrementPipelineHistory(
        pipelineHistory,
        oca
      );
    }
    return pipelineHistory;
  }

  private static Prospecting_Effort__c incrementTaskIds(
    Prospecting_Effort__c pipelineHistory,
    List<Task> tasks
  ) {
    String newTaskIdsString = '';
    for (Task task : tasks) {
      newTaskIdsString += String.valueOf(task.Id) + ',';
    }
    if (String.isNotBlank(pipelineHistory.Task_Ids__c)) {
      newTaskIdsString = pipelineHistory.Task_Ids__c + ',' + newTaskIdsString;
    }
    pipelineHistory.Task_Ids__c = newTaskIdsString.trim().removeEnd(',');
    return pipelineHistory;
  }

  private Prospecting_Effort__c incrementPipelineHistoryByStatusDelta(
    Prospecting_Effort__c pipelineHistory,
    Status__c baseStatus,
    Status__c compareStatus
  ) {
    pipelineHistory.Dials__c +=
      compareStatus.Total_Outbound_Calls__c -
      baseStatus.Total_Outbound_Calls__c;
    pipelineHistory.Meetings__c +=
      compareStatus.Total_Meetings__c - baseStatus.Total_Meetings__c;
    pipelineHistory.Inbound_Emails__c +=
      compareStatus.Total_Inbound_Emails__c -
      baseStatus.Total_Inbound_Emails__c;
    pipelineHistory.Outbound_Emails__c +=
      compareStatus.Total_Outbound_Emails__c -
      baseStatus.Total_Outbound_Emails__c;
    pipelineHistory.Call_Connects__c +=
      compareStatus.Total_Call_Connects__c - baseStatus.Total_Call_Connects__c;
    pipelineHistory.Inmails__c +=
      compareStatus.Total_Inmails__c - baseStatus.Total_Inmails__c;
    pipelineHistory.Gifts__c +=
      compareStatus.Total_Gifts__c - baseStatus.Total_Gifts__c;
    return pipelineHistory;
  }
}