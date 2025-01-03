/**
 * pretty sure we're not capturing Tasks that exist within tracking period, but are under threshold
 */

public with sharing class TaskTriggerHandler extends fflib_SObjectDomain {
  fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new List<SObjectType>{
      Task.SObjectType,
      Event.SObjectType,
      Status__c.SObjectType,
      Outbound_Contact_Activation__c.SObjectType,
      Prospecting_Effort__c.SObjectType
    }
  );
  private static Settings__mdt setting = CustomMetadataCache.setting;

  public TaskTriggerHandler(List<Task> sObjectList) {
    super(sObjectList);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<Task> sObjectList) {
      return new TaskTriggerHandler(sObjectList);
    }
  }

  public static void onAfterInsertTrigger(List<SObject> newRecords) {
    new TaskTriggerHandler(newRecords).onAfterInsert();
  }

  /**
   * (not sure about this, but need to check)
   * pretty sure I'm missing rollup of prospecting activities to already existing Statuses
   *
   * I need to rollup meeting stats if the corresponding contact is activated, currently I'm just creating statuses for meetings, not rolling up
   */
  public override void onAfterInsert() {
    List<Task> contactTasks = new List<Task>();
    Set<Id> contactIds = new Set<Id>();
    for (Task t : (List<Task>) Records) {
      if (t.WhoId != null && t.WhoId.getSobjectType() == Contact.SObjectType) {
        contactTasks.add(t);
        contactIds.add(t.WhoId);
      }
    }

    if (contactTasks.isEmpty()) {
      return;
    }

    List<Task> ioOwnedTasks = new List<Task>();
    List<Contact> activeContacts = new ContactSelector()
      .selectEligibleContactsByContactIds(contactIds);
    Set<Id> activeContactIds = Pluck.ids(activeContacts);
    for (Task t : contactTasks) {
      if (
        PermissionsCache.ioUserIds.contains(t.OwnerId) &&
        activeContactIds.contains(t.WhoId)
      ) {
        ioOwnedTasks.add(t);
      }
    }

    // only run for active contact, io-owned tasks
    if (ioOwnedTasks.isEmpty()) {
      return;
    }

    /**
     * there might be possibility for 2 apcOcas to be created for same contact, if both apc and meeting activation are triggered
     */
    Map<Id, SObject> ocaByContactId = Mapper.singleById(
      new RollupEngine().createAndUpdateOcasViaActivityPerContact(ioOwnedTasks),
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
    );

    System.debug(JSON.serializePretty(ocaByContactId.values()));

    List<Outbound_Contact_Activation__c> meetingSetOcas = new RollupEngine()
      .createAndUpdateOcasViaMeetingSet(ioOwnedTasks, activeContacts);
    List<Outbound_Contact_Activation__c> uniqueMeetingSetOcas = new List<Outbound_Contact_Activation__c>();

    for (Outbound_Contact_Activation__c meetingSetOca : meetingSetOcas) {
      if (ocaByContactId.containsKey(meetingSetOca.Contact__c)) {
        Outbound_Contact_Activation__c oca = (Outbound_Contact_Activation__c) ocaByContactId.get(
          meetingSetOca.Contact__c
        );
        oca.Meetings__c = meetingSetOca.Meetings__c;
        oca.First_Meeting_Date__c = meetingSetOca.First_Meeting_Date__c;
        oca.Last_Meeting_Date__c = meetingSetOca.Last_Meeting_Date__c;
        ocaByContactId.put(oca.Contact__c, oca);
      } else {
        uniqueMeetingSetOcas.add(meetingSetOca);
      }
    }

    List<Status__c> newAndUpdatedStatuses = new RollupEngine()
      .createContactsPerAccountStatuses(
        (List<Outbound_Contact_Activation__c>) ocaByContactId.values()
      );
    ocaByContactId.putAll(
      Mapper.singleById(
        uniqueMeetingSetOcas,
        C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
      )
    );

    if (CustomMetadataCache.setting.Meeting_Object__c == C.TASK_NAME) {
      List<Status__c> meetingSetStatuses = new RollupEngine()
        .createAndUpdateMeetingSetStatuses(meetingSetOcas, activeContacts);
      newAndUpdatedStatuses.addAll(meetingSetStatuses);
    }
    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      newAndUpdatedStatuses,
      C.STATUS_ACCOUNT_FIELD
    );
    for (
      Outbound_Contact_Activation__c oca : (List<Outbound_Contact_Activation__c>) ocaByContactId.values()
    ) {
      if (statusByAccountId.containsKey(oca.Contact__r.AccountId)) {
        this.uow.registerRelationship(
          oca,
          Outbound_Contact_Activation__c.Outbound_Status__c,
          (Status__c) statusByAccountId.get(oca.Contact__r.AccountId)
        );
      }
    }

    List<Outbound_Contact_Activation__c> allOcasUnderStatus = new OutboundContactActivationSelector()
      .selectCurrentActivationsByAccountIdsNotInIds(
        statusByAccountId.keyset(),
        Pluck.ids(ocaByContactId.values())
      );
    allOcasUnderStatus.addAll(
      (List<Outbound_Contact_Activation__c>) ocaByContactId.values()
    );

    newAndUpdatedStatuses = StatusHelper.rollupOcasToStatuses(
      newAndUpdatedStatuses,
      allOcasUnderStatus
    );

    List<Status__c> oldStatuses = new StatusSelector()
      .selectByIds(Pluck.ids(newAndUpdatedStatuses));
    this.uow = new PipelineHistoryEngine()
      .maintainHistoryForProspectingStatuses(
        newAndUpdatedStatuses,
        oldStatuses,
        allOcasUnderStatus,
        ioOwnedTasks,
        this.uow
      );

    // need to clear reference to avoid `INVALID_FIELD, Cannot specify both an external ID reference {} and a salesforce id, {}`
    for (
      Outbound_Contact_Activation__c oca : (List<Outbound_Contact_Activation__c>) ocaByContactId.values()
    ) {
      oca.Activated_By__r = null;
      oca.Contact__r = null;
      oca.Outbound_Status__r = null;
    }
    this.uow.registerUpsert(ocaByContactId.values());
    this.uow.registerUpsert(newAndUpdatedStatuses);
    this.uow.commitWork();
  }

  /**
   * create new OS, or roll it up if it already exists
   */
  private String getTaskQueryWithBaseTaskFieldsFilteredByIds(
    List<Id> idsToFilterBy
  ) {
    List<String> taskFields = OBMetrixSettingsService.TASKS_FIELDS;
    String userField = String.isNotBlank(setting.User_Credit_Field__c) &&
      setting.Meeting_Object__c == 'Task'
      ? setting.User_Credit_Field__c
      : 'OwnerId';
    if (!taskFields.contains(userField)) {
      taskFields.add(userField);
    }

    List<String> taskOpFields = new List<String>();
    for (
      OBNDSelectOption wrp : OBMetricFieldPickListController.getFieldList(
        'Task',
        'Text'
      )
    ) {
      taskOpFields.add(wrp.value);
    }
    taskOpFields.add(userField);
    String query =
      'SELECT ' +
      String.join(taskOpFields, ', ') +
      ', WhoId, CreatedDate ' +
      ' FROM TASK ' +
      ' WHERE Id IN (' +
      String.join(idsToFilterBy, ',') +
      ') ' +
      ' WITH USER_MODE';
    return query;
  }
}