public with sharing class ActivateRetroactivelyBatch implements Database.Batchable<sObject> {
  // @TestVisible
  // Map<Id, Set<Id>> eligibleTaskIdsByAccountId;
  // static Settings__mdt setting = CustomMetadataCache.setting;
  // static final Integer TRACKING_PERIOD = Integer.valueOf(
  //   setting.Timeframe_Days_Contact1__c
  // );
  // public ActivateRetroactivelyBatch(
  //   Map<Id, Set<Id>> eligibleTaskIdsByAccountId
  // ) {
  //   this.eligibleTaskIdsByAccountId = eligibleTaskIdsByAccountId;
  // }

  // class TrackingPeriod {
  //   // non opportunity OCAs
  //   List<Outbound_Contact_Activation__c> nonOpportunityOcas { get; set; }
  //   // tracked Event Ids
  //   Set<Id> eventIds { get; set; }
  //   // first opportunity in the tracking period
  //   Opportunity opportunity { get; set; }

  //   public TrackingPeriod() {
  //     this.nonOpportunityOcas = new List<Outbound_Contact_Activation__c>();
  //     this.eventIds = new Set<Id>();
  //   }
  // }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    // Set<Id> accountIds = this.eligibleTaskIdsByAccountId.keySet();
    // return Database.getQueryLocator(this.getQuery());
    return Database.getQueryLocator('');
  }

  // private String getQuery() {
  //   return 'SELECT Id,Name FROM Account WHERE Id IN: accountIds';
  // }

  public void execute(Database.BatchableContext bc, List<Account> accounts) {
    // fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    //   new List<SObjectType>{
    //     Status__c.SObjectType,
    //     Outbound_Contact_Activation__c.SObjectType
    //   }
    // );
    // uow = this.activateEligibleAccountsAndContacts(accounts, uow);

    // uow.commitWork();
  }

  public void finish(Database.BatchableContext bc) {
    // do something
  }

  // @TestVisible
  // private fflib_SObjectUnitOfWork activateEligibleAccountsAndContacts(
  //   List<Account> accounts,
  //   fflib_SObjectUnitOfWork uow
  // ) {
  //   Set<Id> taskIds = new Set<Id>();
  //   for (Account account : accounts) {
  //     taskIds.addAll(this.eligibleTaskIdsByAccountId.get(account.Id));
  //   }

  //   Map<Id, Task> taskById = new Map<Id, Task>(
  //     [
  //       SELECT
  //         WhoId,
  //         Who.Name,
  //         OwnerId,
  //         Subject,
  //         Type,
  //         CreatedDate,
  //         CreatedById,
  //         CreatedBy.Name
  //       FROM Task
  //       WHERE Id IN :taskIds
  //       ORDER BY CreatedDate ASC
  //     ]
  //   );

  //   Map<Id, List<Opportunity>> opportunitiesByAccountId = Mapper.byId(
  //     new OpportunitySelector()
  //       .selectOpportunitiesByAccountIds(Pluck.ids(accounts)),
  //     C.ACCOUNT_ID_FIELD
  //   );

  //   // get Event field map
  //   Map<String, SObjectField> tokenByFieldName = DescribeCache.getFieldMapFor(
  //     'Event'
  //   );
  //   String allEventFields = String.join(
  //     new List<String>(tokenByFieldName.keySet()),
  //     ','
  //   );
  //   // 'id,id,id,id'
  //   String accountIds =
  //     '\'' +
  //     String.join(new List<String>(Pluck.strings(accounts, 'Id')), '\',\'') +
  //     '\'';
  //   String query =
  //     'SELECT ' +
  //     allEventFields +
  //     ' FROM Event ' +
  //     'WHERE ' +
  //     'WhoId IN ( ' +
  //     'SELECT Id ' +
  //     'FROM Contact ' +
  //     'WHERE AccountId IN (' +
  //     accountIds +
  //     ')' +
  //     ') ' +
  //     'ORDER BY CreatedDate ASC';
  //   System.debug(query);
  //   Map<Id, List<Event>> eventsByAccountId = new Map<Id, List<Event>>();
  //   List<Event> accountEvents = (List<Event>) Database.query(query);
  //   Set<Id> whoIds = new Set<Id>();
  //   whoIds.addAll(Pluck.ids(taskById.values(), C.ACTIVITY_WHO_ID_FIELD));
  //   whoIds.addAll(Pluck.ids(accountEvents, C.ACTIVITY_WHO_ID_FIELD));
  //   Map<Id, Contact> contactById = new Map<Id, Contact>(
  //     new ContactSelector().selectContactsByIds(whoIds)
  //   );

  //   for (Event event : accountEvents) {
  //     Id accountId = contactById.get(event.WhoId).AccountId;
  //     if (!eventsByAccountId.containsKey(accountId)) {
  //       eventsByAccountId.put(accountId, new List<Event>());
  //     }
  //     eventsByAccountId.get(accountId).add(event);
  //   }

  //   List<Status__c> newStatuses = new List<Status__c>();
  //   for (Account account : accounts) {
  //     List<Task> tasks = new List<Task>();
  //     List<Task> meetingTasks = new List<Task>();
  //     Set<Id> eligibleTaskIds = eligibleTaskIdsByAccountId.get(account.Id);
  //     Map<Id, Outbound_Contact_Activation__c> ocaByContactId = new Map<Id, Outbound_Contact_Activation__c>();
  //     for (Task t : taskById.values()) {
  //       if (eligibleTaskIds.contains(t.Id)) {
  //         tasks.add(t);
  //         Boolean isMeeting = TaskHelper.isApplicable(
  //           t,
  //           CustomMetadataCache.setting.Outbound_Meeting_Advance__c,
  //           TaskHelper.getPattern(
  //             CustomMetadataCache.setting.Outbound_Meeting_Subject__c
  //           )
  //         );
  //         if (isMeeting) {
  //           meetingTasks.add(t);
  //         }
  //       }
  //     }
  //     Logger.log('LOGGING TASKS: ' + JSON.serialize(tasks));
  //     Date trackingDate;
  //     List<Task> tasksWithinTrackingPeriod = new List<Task>();
  //     Map<Id, List<Task>> tasksByContactId = Mapper.byId(
  //       tasks,
  //       C.ACTIVITY_WHO_ID_FIELD
  //     );

  //     Map<Id, ActivityStats> statsByContactId = new Map<Id, ActivityStats>();
  //     Map<Id, Contact> processedContactById = new Map<Id, Contact>();
  //     /**
  //      * need to continuously maintain a single OCA for the same contact in a single tracking period inside of this map
  //      */
  //     Map<Date, TrackingPeriod> trackingPeriodByUpperBoundDate = new Map<Date, TrackingPeriod>();
  //     Integer activityCountForAccount = 0;
  //     for (Task t : tasks) {
  //       Id contactId = t.WhoId;
  //       Contact contact = contactById.get(contactId);
  //       processedContactById.put(contactId, contact);
  //       ActivityStats stat = TaskHelper.getActivityStatsByWhoId(
  //           new List<Task>{ t }
  //         )
  //         .get(contactId);
  //       Date taskCreatedDate = t.CreatedDate.date();
  //       Boolean isWithinCurrentTrackingPeriod =
  //         trackingDate == null ||
  //         Math.abs(taskCreatedDate.daysBetween(trackingDate)) <=
  //         TRACKING_PERIOD;
  //       if (stat.hasProspectingActivity() || stat.meetings > 0) {
  //         if (isWithinCurrentTrackingPeriod) {
  //           tasksWithinTrackingPeriod.add(t);
  //           statsByContactId.putAll(
  //             TaskHelper.getActivityStatsByWhoId(tasksWithinTrackingPeriod)
  //           );
  //           if (trackingDate == null) {
  //             trackingDate = t.CreatedDate.date();
  //           }
  //         } else if (!isWithinCurrentTrackingPeriod) {
  //           tasksWithinTrackingPeriod.clear();
  //           ocaByContactId.clear();
  //           tasksWithinTrackingPeriod.add(t);
  //           trackingDate = t.CreatedDate.date();
  //           statsByContactId.putAll(
  //             TaskHelper.getActivityStatsByWhoId(tasksWithinTrackingPeriod)
  //           );
  //         }

  //         // find an OCA for same contact in trackingPeriodByUpperBoundDate

  //         Outbound_Contact_Activation__c oca;

  //         if (ocaByContactId.containsKey(contactId)) {
  //           oca = ocaByContactId.get(contactId);
  //         }

  //         // we haven't seen this contact yet
  //         if (oca == null) {
  //           oca = OutboundContactActivationHelper.getOca(contact);
  //         }
  //         ocaByContactId.put(contactId, oca);
  //         oca.Activated_By__c = t.CreatedById;
  //         oca.Activated_By__r = (User) t.getSObject('CreatedBy');
  //         /**
  //          * need to set contact with acccount id here
  //          */
  //         oca.Contact__r = contact;
  //         oca = OutboundContactActivationHelper.addStatToActivation(oca, stat);

  //         // find tasks in tracking period in meetingTasks
  //         System.debug(JSON.serialize(meetingTasks));
  //         List<Task> taskMeetingsWithinTrackingPeriod = new List<Task>();
  //         for (Task meetingTask : meetingTasks) {
  //           if (
  //             meetingTask.CreatedDate.date() >= trackingDate &&
  //             Math.abs(
  //               meetingTask.CreatedDate.date().daysBetween(trackingDate)
  //             ) < TRACKING_PERIOD
  //           ) {
  //             taskMeetingsWithinTrackingPeriod.add(meetingTask);
  //           }
  //         }

  //         List<Event> eventsWithinTrackingPeriod = new List<Event>();
  //         TrackingPeriod tp = trackingPeriodByUpperBoundDate.get(trackingDate);
  //         Set<Id> alreadyProcessedEventIds = tp?.eventIds == null
  //           ? new Set<Id>()
  //           : tp.eventIds;
  //         if (eventsByAccountId.containsKey(account.Id)) {
  //           for (Event e : eventsByAccountId.get(account.Id)) {
  //             if (
  //               e.CreatedDate.date() > trackingDate &&
  //               Math.abs(e.CreatedDate.date().daysBetween(trackingDate)) <
  //               TRACKING_PERIOD &&
  //               !alreadyProcessedEventIds.contains(e.Id)
  //             ) {
  //               eventsWithinTrackingPeriod.add(e);
  //             }
  //           }
  //         }

  //         ActivityStats eventStats = EventHelper.getMeetingStatsByWhoId(
  //             eventsWithinTrackingPeriod
  //           )
  //           .get(contactId);
  //         if (eventStats != null) {
  //           oca = OutboundContactActivationHelper.addStatToActivation(
  //             oca,
  //             eventStats
  //           );
  //         }
  //         oca.Meetings__c = eventStats?.meetings != null &&
  //           eventStats.meetings > 0
  //           ? eventStats.meetings
  //           : oca.Meetings__c;

  //         Integer activityCount = Integer.valueOf(
  //           (oca.Inbound_Emails__c != null ? oca.Inbound_Emails__c : 0) +
  //           (oca.Outbound_Emails__c != null ? oca.Outbound_Emails__c : 0) +
  //           (oca.Dials__c != null ? oca.Dials__c : 0) +
  //           (oca.Inmails__c != null ? oca.Inmails__c : 0) +
  //           (oca.Gifts__c != null ? oca.Gifts__c : 0) +
  //           (oca.Call_Connects__c != null ? oca.Call_Connects__c : 0) +
  //           (oca.Dials__c != null ? oca.Dials__c : 0)
  //         );
  //         activityCountForAccount += activityCount;
  //         Boolean isEligibleForActivitiesPerContactActivation =
  //           (activityCount + oca.Meetings__c) >=
  //           setting.Activities_Created_by_User1__c;

  //         Boolean isEligibleForOpportunityActivation = false;
  //         Opportunity activatableOpportunity;
  //         if (opportunitiesByAccountId.containsKey(account.Id)) {
  //           for (Opportunity opp : opportunitiesByAccountId.get(account.Id)) {
  //             Integer daysBetweenOpportunityCreatedAndTrackingDate = Math.abs(
  //               opp.CreatedDate.date().daysBetween(trackingDate)
  //             );
  //             if (
  //               opp.CreatedDate.date() > trackingDate &&
  //               daysBetweenOpportunityCreatedAndTrackingDate <
  //               TRACKING_PERIOD &&
  //               activityCountForAccount > 0
  //             ) {
  //               isEligibleForOpportunityActivation = true;
  //               activatableOpportunity = opp;
  //               break;
  //             }
  //           }
  //         }

  //         Boolean isEligibleForMeetingSetActivation =
  //           activityCountForAccount > 0 &&
  //           (taskMeetingsWithinTrackingPeriod.size() > 0 ||
  //           (eventStats != null &&
  //           eventStats.meetings > 0));

  //         if (
  //           isEligibleForActivitiesPerContactActivation ||
  //           isEligibleForMeetingSetActivation ||
  //           isEligibleForOpportunityActivation
  //         ) {
  //           tp = trackingPeriodByUpperBoundDate.get(trackingDate);
  //           if (tp == null) {
  //             tp = new TrackingPeriod();
  //             trackingPeriodByUpperBoundDate.put(trackingDate, tp);
  //           }
  //           if (eventStats != null) {
  //             tp.eventIds.addAll(eventStats.activityIds);
  //           }
  //         }

  //         if (isEligibleForActivitiesPerContactActivation) {
  //           oca.Activated_by_Retro__c = true;
  //           List<Outbound_Contact_Activation__c> nonOppOcas = trackingPeriodByUpperBoundDate.get(
  //               trackingDate
  //             )
  //             ?.nonOpportunityOcas;
  //           if (nonOppOcas == null) {
  //             trackingPeriodByUpperBoundDate.get(trackingDate)
  //               .nonOpportunityOcas.add(oca);
  //           } else {
  //             Map<Id, SObject> nonOppOcaByContactId = Mapper.singleById(
  //               nonOppOcas,
  //               C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
  //             );
  //             if (!nonOppOcaByContactId.containsKey(contact.Id)) {
  //               trackingPeriodByUpperBoundDate.get(trackingDate)
  //                 .nonOpportunityOcas.add(oca);
  //               uow.registerNew(oca); // this needs to go into the db as a legit contact activation
  //             }
  //           }
  //         }
  //         if (isEligibleForOpportunityActivation) {
  //           trackingPeriodByUpperBoundDate.get(trackingDate)
  //             .opportunity = activatableOpportunity;
  //         }
  //       }
  //     }

  //     System.debug(JSON.serialize(trackingPeriodByUpperBoundDate));

  //     if (trackingPeriodByUpperBoundDate.isEmpty()) {
  //       continue;
  //     }

  //     /**
  //      * need to ensure we are not creating two meeting_set/opportunity_created statuses unless
  //      * wait period has elapsed between both statuses last/first prospecting activity date
  //      **/
  //     List<Status__c> accountOs = new List<Status__c>();
  //     for (Date upperBoundDate : trackingPeriodByUpperBoundDate.keySet()) {
  //       TrackingPeriod tp = trackingPeriodByUpperBoundDate.get(upperBoundDate);
  //       Status__c os;

  //       // we don't activate Contacts under Accounts activated via Opportunity activation
  //       // effectively they are just markers by which we create Opportunity Created statuses

  //       if (!tp.nonOpportunityOcas.isEmpty()) {
  //         os = StatusHelper.rollupOcasToStatuses(
  //           new List<Status__c>{
  //             new Status__c(
  //               Account__c = tp.nonOpportunityOcas[0].Contact__r.AccountId // this needs to be here
  //             )
  //           },
  //           tp.nonOpportunityOcas
  //         )[0];
  //         Integer numberOfContactsNeededToActivate = Integer.valueOf(
  //           CustomMetadataCache.setting.Active_Contacts1__c
  //         );
  //         if (
  //           tp.nonOpportunityOcas.size() >= numberOfContactsNeededToActivate
  //         ) {
  //           os.Activated_By__c = tp.nonOpportunityOcas[0].Activated_By__c;
  //           os.Activated_Date__c = os.First_Prospecting_Activity__c == null
  //             ? os.First_Meeting_Date__c
  //             : os.First_Prospecting_Activity__c;
  //           os.Account__c = account.Id;
  //         } else if (
  //           os.First_Meeting_Date__c != null &&
  //           os.First_Prospecting_Activity__c != null &&
  //           CustomMetadataCache.setting.Set_Approaching_Outbound_Event_Automatic__c
  //         ) {
  //           os.Activated_By__c = tp.nonOpportunityOcas[0].Activated_By__c;
  //           os.Activated_Date__c = os.First_Prospecting_Activity__c <
  //             os.First_Meeting_Date__c
  //             ? os.First_Prospecting_Activity__c
  //             : os.First_Meeting_Date__c;
  //           os.Account__c = account.Id;
  //         }

  //         // if os wasn't activated, null it out so we don't register it for insert
  //         if (os.Activated_Date__c == null) {
  //           os = null;
  //         }
  //       }

  //       if (
  //         tp.opportunity != null &&
  //         setting.Set_Approaching_Outbound_Opps_Automatic__c
  //       ) {
  //         Opportunity opportunity = tp.opportunity;
  //         if (os != null) {
  //           os.Opportunity_Created_Date__c = opportunity.CreatedDate.date();
  //           os.Opportunity_Amount__c = opportunity.Amount;
  //           os.Opportunity__c = opportunity.Id;
  //           os.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED;
  //           os.Activated_Date__c = opportunity.CreatedDate.date();
  //           os.Activated_By__c = opportunity.OwnerId;
  //         } else {
  //           os = new Status__c(
  //             Activated_Date__c = opportunity.CreatedDate.date(),
  //             Activated_By__c = opportunity.OwnerId,
  //             Account__c = account.Id,
  //             Opportunity__c = opportunity.Id,
  //             Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
  //             Opportunity_Created_Date__c = opportunity.CreatedDate.date(),
  //             Opportunity_Amount__c = opportunity.Amount
  //           );
  //         }
  //       }

  //       if (os != null) {
  //         Integer coolOffPeriod = Integer.valueOf(
  //           CustomMetadataCache.setting.Wait_Period__c
  //         );
  //         // ensure our last os is not within cool off period
  //         if (
  //           accountOs.isEmpty() ||
  //           Math.abs(
  //             accountOs[accountOs.size() - 1]
  //               .Activated_Date__c.daysBetween(os.Activated_Date__c)
  //           ) > coolOffPeriod
  //         ) {
  //           os.Activated_By_Retro__c = true;
  //           accountOs.add(os);
  //           newStatuses.add(os);
  //         }
  //       }
  //     }
  //   }
  //   uow.registerNew(newStatuses);
  //   return uow;
  // }

  // // helpers
  // private Opportunity getFirstOpportunityInTrackingPeriod(
  //   List<Outbound_Contact_Activation__c> ocas,
  //   List<Opportunity> opportunities,
  //   Integer trackingPeriod
  // ) {
  //   Date lastProspectingActivityDate;
  //   for (Outbound_Contact_Activation__c oca : ocas) {
  //     if (
  //       lastProspectingActivityDate == null ||
  //       oca.Last_Prospecting_Activity__c > lastProspectingActivityDate
  //     ) {
  //       lastProspectingActivityDate = oca.Last_Prospecting_Activity__c;
  //     }
  //   }
  //   Opportunity firstOpportunityInTrackingPeriod;
  //   for (Opportunity opp : opportunities) {
  //     if (
  //       opp.CreatedDate.date() > lastProspectingActivityDate &&
  //       Math.abs(
  //         opp.CreatedDate.date().daysBetween(lastProspectingActivityDate)
  //       ) < trackingPeriod
  //     ) {
  //       firstOpportunityInTrackingPeriod = opp;
  //     }
  //   }
  //   return firstOpportunityInTrackingPeriod;
  // }
}