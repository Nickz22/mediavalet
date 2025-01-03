global class RetroactiveActivationBatch implements Database.Batchable<sObject>, Database.Stateful {
  // private Integer daysAgo;
  // DateTime dateXDaysAgo;
  // Map<Id, Integer> prospectingActivityCountByAccountId;
  // Map<Id, Integer> meetingCountByAccountId;
  // @TestVisible
  // Map<Id, Set<Id>> eligibleTaskIdsByAccountId = new Map<Id, Set<Id>>();
  // Set<String> closedOpportunityStages = new Set<String>();
  // Set<String> openOpportunityStages = new Set<String>();

  // static final Integer WAIT_PERIOD = Integer.valueOf(
  //   CustomMetadataCache.setting.Wait_Period__c
  // );
  // static final Integer TRACKING_PERIOD = Integer.valueOf(
  //   CustomMetadataCache.setting.Timeframe_Days_Contact1__c
  // );

  global RetroactiveActivationBatch(Integer daysAgo) {
    // this.daysAgo = daysAgo;
    // this.dateXDaysAgo = DateTime.now().addDays(-daysAgo);
    // for (OpportunityStage stage : [
    //   SELECT MasterLabel, IsClosed
    //   FROM OpportunityStage
    // ]) {
    //   if (stage.IsClosed) {
    //     closedOpportunityStages.add(stage.MasterLabel);
    //   } else {
    //     openOpportunityStages.add(stage.MasterLabel);
    //   }
    // }
  }

  // Start method returning the Database.QueryLocator with the needed query
  global Database.QueryLocator start(Database.BatchableContext BC) {
    // Set<Id> ioUserIds = PermissionsCache.ioUserIds;
    // return Database.getQueryLocator(this.getQuery());
    return Database.getQueryLocator('');
  }

  // private String getQuery() {
  //   return 'SELECT Id, WhoId, CreatedDate, Subject ' +
  //     'FROM Task ' +
  //     'WHERE CreatedDate >= ' +
  //     this.dateXDaysAgo.format('yyyy-MM-dd\'T\'HH:mm:ss') +
  //     'Z' +
  //     ' ' +
  //     'AND OwnerId IN :ioUserIds ' +
  //     'AND WhoId IN (SELECT Id FROM Contact WHERE OwnerId IN: ioUserIds) ' +
  //     'WITH USER_MODE ' +
  //     'ORDER BY CreatedDate ASC ';
  // }

  // Execute method processing fetched Tasks
  global void execute(Database.BatchableContext BC, List<Task> retroTasks) {
    // this.getEligibleTaskIdsByAccountId(retroTasks);
  }

  // @TestVisible
  // private void getEligibleTaskIdsByAccountId(List<Task> retroTasks) {
  //   Map<Id, Contact> contactById = new Map<Id, Contact>(
  //     new ContactSelector()
  //       .selectContactsByIds(Pluck.ids(retroTasks, C.ACTIVITY_WHO_ID_FIELD))
  //   );

  //   DateTime lastTaskCreatedTime = retroTasks[retroTasks.size() - 1]
  //     .CreatedDate;
  //   Map<Id, Opportunity> opportunityById = new Map<Id, Opportunity>(
  //     new OpportunitySelector()
  //       .selectOpportunitiesByAccountIds(
  //         Pluck.ids(contactById.values(), C.ACCOUNT_ID_FIELD)
  //       )
  //   );
  //   Map<Id, List<OpportunityHistory>> stageHistoriesByAccountId = new Map<Id, List<OpportunityHistory>>();
  //   for (
  //     OpportunityHistory history : new OpportunityHistorySelector2()
  //       .selectByOpportunityIds(opportunityById.keyset())
  //   ) {
  //     Id accountId = opportunityById.get(history.OpportunityId).AccountId;
  //     if (!stageHistoriesByAccountId.containsKey(accountId)) {
  //       stageHistoriesByAccountId.put(
  //         accountId,
  //         new List<OpportunityHistory>()
  //       );
  //     }
  //     stageHistoriesByAccountId.get(accountId).add(history);
  //   }
  //   Date firstTaskCreatedDate = retroTasks[0].CreatedDate.date();
  //   Date lowerDateThreshold = firstTaskCreatedDate.addDays(-TRACKING_PERIOD);
  //   // does this have to go back via wait period or via the timeframe_contacts?
  //   Map<Id, List<Task>> priorTasksWithinWaitPeriodByContactId = Mapper.byId(
  //     [
  //       SELECT WhoId, CreatedDate, Subject
  //       FROM Task
  //       WHERE
  //         CreatedDate < :firstTaskCreatedDate
  //         AND CreatedDate > :lowerDateThreshold
  //         AND WhoId IN :contactById.keyset()
  //       ORDER BY CreatedDate DESC
  //     ],
  //     C.ACTIVITY_WHO_ID_FIELD
  //   );
  //   Map<Id, SObject> ocaByContactId = Mapper.singleById(
  //     [
  //       SELECT Contact__c
  //       FROM Outbound_Contact_Activation__c
  //       WHERE Contact__c IN :contactById.keyset() AND Is_Current__c = TRUE
  //     ],
  //     C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
  //   );

  //   Map<Id, List<Task>> tasksByContactId = Mapper.byId(
  //     retroTasks,
  //     C.ACTIVITY_WHO_ID_FIELD
  //   );
  //   List<Outbound_Contact_Activation__c> ocas = new List<Outbound_Contact_Activation__c>();
  //   for (Id contactId : tasksByContactId.keyset()) {
  //     Contact contact = contactById.get(contactId);
  //     Id accountId = contact.AccountId;
  //     List<Task> priorTasksWithinWaitPeriod = priorTasksWithinWaitPeriodByContactId.get(
  //       contactId
  //     );
  //     List<OpportunityHistory> oppHistories = stageHistoriesByAccountId.get(
  //       accountId
  //     );
  //     // don't create dupe activations for contact
  //     if (ocaByContactId.keyset().contains(contactId)) {
  //       continue;
  //     }

  //     Date latestTaskCreatedDateOutsideRetroWindow = priorTasksWithinWaitPeriod
  //       ?.get(0)
  //       ?.CreatedDate
  //       ?.date();
  //     for (Task retroTask : tasksByContactId.get(contactId)) {
  //       Boolean didTaskExistBeforeWindowWithinTrackingPeriod = false;
  //       if (latestTaskCreatedDateOutsideRetroWindow != null) {
  //         // first do task-driven exclusion of retro tasks
  //         Integer daysBetweenRetroTaskAndPriorTaskCreatedDate = Math.abs(
  //           retroTask
  //             .CreatedDate.date()
  //             .daysBetween(latestTaskCreatedDateOutsideRetroWindow)
  //         );
  //         didTaskExistBeforeWindowWithinTrackingPeriod =
  //           latestTaskCreatedDateOutsideRetroWindow <
  //           retroTask.CreatedDate.date() &&
  //           daysBetweenRetroTaskAndPriorTaskCreatedDate <= TRACKING_PERIOD;
  //       }

  //       Boolean oppHistoryPredatesTaskWithinWaitPeriod = false;
  //       Boolean openOpportunityExists = false;
  //       if (
  //         !didTaskExistBeforeWindowWithinTrackingPeriod && oppHistories != null
  //       ) {
  //         for (OpportunityHistory oppHistory : oppHistories) {
  //           Date taskCreatedDate = retroTask.CreatedDate.date();
  //           Date oppHistoryCreatedDate = oppHistory.CreatedDate.date();
  //           Integer daysBetweenOppStageChangeAndTaskCreatedDate = Math.abs(
  //             oppHistoryCreatedDate.daysBetween(taskCreatedDate)
  //           );
  //           oppHistoryPredatesTaskWithinWaitPeriod =
  //             oppHistoryCreatedDate < taskCreatedDate &&
  //             daysBetweenOppStageChangeAndTaskCreatedDate <= WAIT_PERIOD;
  //           openOpportunityExists = !opportunityById.get(
  //               oppHistory.OpportunityId
  //             )
  //             .IsClosed;
  //         }
  //       }

  //       if (
  //         !didTaskExistBeforeWindowWithinTrackingPeriod &&
  //         !oppHistoryPredatesTaskWithinWaitPeriod &&
  //         !openOpportunityExists
  //       ) {
  //         if (!this.eligibleTaskIdsByAccountId.containsKey(accountId)) {
  //           this.eligibleTaskIdsByAccountId.put(
  //             accountId,
  //             new Set<Id>{ retroTask.Id }
  //           );
  //         } else {
  //           this.eligibleTaskIdsByAccountId.get(accountId).add(retroTask.Id);
  //         }
  //       }
  //     }
  //   }
  // }

  global void finish(Database.BatchableContext BC) {
    // System.debug(this.eligibleTaskIdsByAccountId);
    // Map<Id, Account> accountById = new Map<Id, Account>(
    //   [SELECT Id, Name FROM Account]
    // );
    // Map<Id, Contact> contactById = new Map<Id, Contact>(
    //   [SELECT Id, LastName FROM Contact]
    // );
    // Map<Id, Task> taskById = new Map<Id, Task>(
    //   [SELECT Id, Subject, WhoId, CreatedDate FROM Task]
    // );
    // System.debug('Naming eligible Accounts...');
    // for (Id accountId : this.eligibleTaskIdsByAccountId.keySet()) {
    //   Account acc = accountById.get(accountId);
    //   System.debug('Eligible Account ' + acc.Name);
    //   for (Id taskId : this.eligibleTaskIdsByAccountId.get(accountId)) {
    //     System.debug(
    //       'Eligible Contact ' +
    //       contactById.get(taskById.get(taskId).WhoId).LastName
    //     );
    //     System.debug('Eligible Task ' + taskById.get(taskId).Subject);
    //   }
    // }
    // Database.executeBatch(
    //   new ActivateRetroactivelyBatch(this.eligibleTaskIdsByAccountId),
    //   25
    // );
  }
}