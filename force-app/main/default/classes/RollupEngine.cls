public with sharing class RollupEngine {
  public RollupEngine() {
  }

  /**
   * @description - expects net-new Tasks
   * @return - List<Outbound_Contact_Activation__c> - new/updated Outbound Contact Activations in addition to any current Outbound Contact Activations that already exist under the related Accounts
   */
  public List<Outbound_Contact_Activation__c> createAndUpdateOcasViaActivityPerContact(
    List<Task> newTasks
  ) {
    Map<Id, List<SObject>> newTasksByWhoId = Mapper.byPath(
      newTasks,
      C.ACTIVITY_WHO_ID_FIELD
    );
    for (
      Account account : new AccountSelector()
        .selectAccountsWithContactIdsByContactIds(
          Pluck.ids(newTasks, C.ACTIVITY_WHO_ID_FIELD)
        )
    ) {
      if (
        TaskHelper.isApplicable(
          account,
          CustomMetadataCache.setting.Filter_Accounts_Criteria__c,
          null
        )
      ) {
        for (Contact c : account.Contacts) {
          newTasksByWhoId.remove(c.Id);
        }
      }
    }

    newTasks = new List<Task>();
    for (List<SObject> tasks : newTasksByWhoId.values()) {
      for (Task task : (List<Task>) tasks) {
        newTasks.add((Task) task);
      }
    }

    if (!Util.hasCoolingOffPeriodElapsedSinceLastUpgrade()) {
      // since cool off period hasn't elapsed since upgrade
      // we're going to look back wait_period # days to ensure we
      // don't activate something that is already in-flight
      Set<Id> accountIds = Pluck.ids(newTasks, C.ACTIVITY_WHAT_ID_FIELD);
      List<Task> previousActivitiesWithinCoolOff = new TaskSelector()
        .selectTasksByAccountIdsCreatedAfterDateBeforeTodayAndNotInIds(
          accountIds,
          Pluck.ids(newTasks),
          Date.today()
            .addDays(
              -Integer.valueOf(CustomMetadataCache.setting.Wait_Period__c)
            )
        );
      if (!previousActivitiesWithinCoolOff.isEmpty()) {
        newTasks = TaskHelper.filterActivitiesFromAccountsWithOtherProspectingActivities(
          newTasks,
          previousActivitiesWithinCoolOff
        );
      }
    }

    Set<Id> whoIds = Pluck.ids(newTasks, C.ACTIVITY_WHO_ID_FIELD);
    Map<Id, Contact> whoById = new Map<Id, Contact>(
      new ContactSelector().selectContactsByIds(whoIds)
    );
    Set<Id> accountIds = Pluck.ids(whoById.values(), C.ACCOUNT_ID_FIELD);

    Map<Id, ActivityStats> newActivityStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      newTasks
    );
    Map<Id, ActivityStats> nonNewActivityStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      new TaskSelector()
        .selectIoOwnedTasksWithinTrackingPeriodByWhoIdsNotInIds(
          whoIds,
          Pluck.ids(newTasks, C.ID_FIELD)
        )
    );

    Map<Id, SObject> osByAccountId = Mapper.singleById(
      new StatusSelector().selectActiveStatusByAccountIds(accountIds),
      C.STATUS_ACCOUNT_FIELD
    );
    Map<Id, SObject> currentOcaByContactId = Mapper.singleById(
      new OutboundContactActivationSelector()
        .selectCurrentActivationsByAccountIds(accountIds),
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
    );

    System.debug(JSON.serializePretty(currentOcaByContactId.values()));

    Map<Id, User> ioUserById = new Map<Id, User>(PermissionsCache.ioUsers);
    List<Outbound_Contact_Activation__c> newOcas = new List<Outbound_Contact_Activation__c>();
    for (ActivityStats stat : newActivityStatByWhoId.values()) {
      Outbound_Contact_Activation__c oca;
      if (!stat.hasProspectingActivity()) {
        continue;
      }
      if (currentOcaByContactId.containsKey(stat.contactId)) {
        oca = (Outbound_Contact_Activation__c) currentOcaByContactId.get(
          stat.contactId
        );
      } else {
        oca = OutboundContactActivationHelper.getOca(
          whoById.get(stat.contactId)
        );
        oca.Activated_By__c = stat.ownerId;
        oca.Activated_By__r = ioUserById.get(stat.ownerId);
        oca.Activated_Date__c = stat.lastProspectingActivityDate;
        oca.Contact__r = whoById.get(stat.contactId);
        // start with stats from non-new activities
        if (nonNewActivityStatByWhoId.containsKey(stat.contactId)) {
          oca = OutboundContactActivationHelper.addStatToActivation(
            oca,
            nonNewActivityStatByWhoId.get(stat.contactId)
          );
        }
      }

      oca.Outbound_Status__r = (Status__c) osByAccountId.get(
        oca.Contact__r.AccountId
      );

      Status__c os = (Status__c) oca.getSObject(
        C.OUTBOUND_CONTACT_ACTIVATION_STATUS_RELATIONSHIP
      );
      Boolean isStatusClaimantDifferentThanActivityOwner =
        os != null &&
        os.OwnerId != stat.ownerId &&
        os.Claimed_By__c != stat.ownerId;
      if (isStatusClaimantDifferentThanActivityOwner) {
        continue;
      }

      oca = OutboundContactActivationHelper.addStatToActivation(oca, stat);
      // Issue fixed - https://app.asana.com/0/0/1201667469061740/f
      Integer activityCount = Integer.valueOf(
        (oca.Inbound_Emails__c != null ? oca.Inbound_Emails__c : 0) +
        (oca.Outbound_Emails__c != null ? oca.Outbound_Emails__c : 0) +
        (oca.Dials__c != null ? oca.Dials__c : 0) +
        (oca.Inmails__c != null ? oca.Inmails__c : 0) +
        (oca.Gifts__c != null ? oca.Gifts__c : 0) +
        (oca.Call_Connects__c != null ? oca.Call_Connects__c : 0)
      );
      Boolean isEligibleForActivitiesPerContactActivation =
        (activityCount + oca.Meetings__c) >=
        CustomMetadataCache.setting.Activities_Created_by_User1__c;

      if (isEligibleForActivitiesPerContactActivation) {
        newOcas.add(oca);
      }
    }

    return newOcas;
  }

  public List<Outbound_Contact_Activation__c> createAndUpdateOcasViaMeetingSet(
    List<Task> newTasks,
    List<Contact> contacts
  ) {
    Map<Id, ActivityStats> newTaskStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      newTasks
    );

    return this.createAndUpdateOcasViaMeetingSet(newTaskStatByWhoId, contacts);
  }

  public List<Outbound_Contact_Activation__c> createAndUpdateOcasViaMeetingSet(
    List<Event> newEvents,
    List<Contact> contacts
  ) {
    Map<Id, ActivityStats> newEventStatByWhoId = EventHelper.getMeetingStatsByWhoId(
      newEvents
    );

    return this.createAndUpdateOcasViaMeetingSet(newEventStatByWhoId, contacts);
  }

  public List<Outbound_Contact_Activation__c> createAndUpdateOcasViaMeetingSet(
    Map<Id, ActivityStats> newActivityStatByWhoId,
    List<Contact> contacts
  ) {
    Set<Id> newTaskIds = new Set<Id>();
    Boolean isTaskActivityStat =
      new List<Id>(newActivityStatByWhoId.values()[0].activityIds)[0]
        .getSobjectType() == Task.getSObjectType();
    if (isTaskActivityStat) {
      for (ActivityStats stat : newActivityStatByWhoId.values()) {
        for (Id activityId : stat.activityIds) {
          newTaskIds.add(activityId);
        }
      }
    }

    contacts.addAll(
      new ContactSelector()
        .selectSiblingContactsByContactIds(Pluck.ids(contacts))
    );

    List<Task> activitiesWithinTrackingPeriod = new TaskSelector()
      .selectIoOwnedTasksWithinTrackingPeriodByWhoIdsNotInIds(
        Pluck.ids(contacts),
        newTaskIds
      );

    System.debug(JSON.serializePretty(activitiesWithinTrackingPeriod));

    if (activitiesWithinTrackingPeriod.isEmpty()) {
      return new List<Outbound_Contact_Activation__c>();
    }

    if (!Util.hasCoolingOffPeriodElapsedSinceLastUpgrade()) {
      // since cool off period hasn't elapsed since upgrade
      // we're going to look back wait_period # days to ensure we
      // don't activate something that is already in-flight
      Set<Id> accountIds = Pluck.ids(
        activitiesWithinTrackingPeriod,
        C.ACTIVITY_WHAT_ID_FIELD
      );
      List<Task> previousActivitiesWithinCoolOff = new TaskSelector()
        .selectTasksByAccountIdsCreatedAfterDateBeforeTodayAndNotInIds(
          accountIds,
          CustomMetadataCache.setting.Meeting_Object__c == C.EVENT_NAME // if the meeting object is an event we want to query all // activities under the account, including the ones we've already retrieved
            ? new Set<Id>()
            : Pluck.ids(activitiesWithinTrackingPeriod),
          Date.today()
            .addDays(
              -Integer.valueOf(CustomMetadataCache.setting.Wait_Period__c)
            )
        );
      if (!previousActivitiesWithinCoolOff.isEmpty()) {
        activitiesWithinTrackingPeriod = TaskHelper.filterActivitiesFromAccountsWithOtherProspectingActivities(
          activitiesWithinTrackingPeriod,
          previousActivitiesWithinCoolOff
        );
      }
    }

    Map<Id, List<SObject>> activitiesWithinTrackingPeriodByWhoId = Mapper.byPath(
      activitiesWithinTrackingPeriod,
      C.ACTIVITY_WHO_ID_FIELD
    );
    for (
      Account account : new AccountSelector()
        .selectAccountsWithContactIdsByContactIds(
          Pluck.ids(activitiesWithinTrackingPeriod, C.ACTIVITY_WHO_ID_FIELD)
        )
    ) {
      if (
        TaskHelper.isApplicable(
          account,
          CustomMetadataCache.setting.Filter_Accounts_Criteria__c,
          null
        )
      ) {
        for (Contact c : account.Contacts) {
          activitiesWithinTrackingPeriodByWhoId.remove(c.Id);
        }
      }
    }

    activitiesWithinTrackingPeriod = new List<Task>();
    for (List<SObject> tasks : activitiesWithinTrackingPeriodByWhoId.values()) {
      for (Task task : (List<Task>) tasks) {
        activitiesWithinTrackingPeriod.add((Task) task);
      }
    }

    Map<Id, ActivityStats> prospectingActivityStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      activitiesWithinTrackingPeriod
    );

    Map<Id, Contact> contactById = new Map<Id, Contact>(contacts);
    Map<Id, ActivityStats> prospectingActivityStatByAccountId = new Map<Id, ActivityStats>();
    for (Id whoId : prospectingActivityStatByWhoId.keyset()) {
      Id accountId = contactById.get(whoId).AccountId;
      if (!prospectingActivityStatByAccountId.containsKey(accountId)) {
        prospectingActivityStatByAccountId.put(
          accountId,
          new ActivityStats(null, null, null)
        );
      }
      prospectingActivityStatByAccountId.put(
        accountId,
        ActivityStats.consolidateStats(
          new List<ActivityStats>{
            prospectingActivityStatByAccountId.get(accountId),
            prospectingActivityStatByWhoId.get(whoId)
          }
        )
      );
    }

    List<Outbound_Contact_Activation__c> meetingSetOcas = new List<Outbound_Contact_Activation__c>();
    Map<Id, SObject> currentOcaByContactId = Mapper.singleById(
      new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(Pluck.ids(contacts)),
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
    );
    for (Id contactId : newActivityStatByWhoId.keyset()) {
      ActivityStats stat = newActivityStatByWhoId.get(contactId);
      ActivityStats existingStat = prospectingActivityStatByAccountId.get(
        contactById.get(contactId).AccountId
      );
      Boolean isNewMeetingActivity = stat.meetings > 0;
      Boolean hasPreexistingProspectingActivity =
        existingStat != null && existingStat.hasProspectingActivity();
      if (isNewMeetingActivity && hasPreexistingProspectingActivity) {
        // check for existing Status, and roll up if it exists
        // or create if it doesn't
        Outbound_Contact_Activation__c oca;
        if (currentOcaByContactId.containsKey(contactId)) {
          oca = (Outbound_Contact_Activation__c) currentOcaByContactId.get(
            contactId
          );
          oca.First_Meeting_Date__c = oca.First_Meeting_Date__c == null
            ? Date.today()
            : oca.First_Meeting_Date__c;
          oca.Last_Meeting_Date__c = Date.today();
          oca.Meetings__c += 1;
        } else {
          oca = new Outbound_Contact_Activation__c(
            Name = contactById.get(contactId).Name + ' [Activated]',
            Activated_Date__c = stat.lastMeetingDate,
            Activated_By__c = stat.ownerId,
            First_Meeting_Date__c = Date.today(),
            Last_Meeting_Date__c = Date.today(),
            Meetings__c = 1,
            Call_Connects__c = existingStat.engagedDials,
            Dials__c = existingStat.dials,
            Gifts__c = existingStat.gifts,
            Inbound_Emails__c = existingStat.inboundEmails,
            Outbound_Emails__c = existingStat.outboundEmails,
            Inmails__c = existingStat.inMails,
            Contact__r = contactById.get(contactId),
            Contact__c = contactById.get(contactId).Id
          );
        }
        meetingSetOcas.add(oca);
      }
    }
    return meetingSetOcas;
  }

  public List<Status__c> createAndUpdateMeetingSetStatuses(
    List<Outbound_Contact_Activation__c> meetingSetOcas,
    List<Contact> contacts
  ) {
    Set<Id> ocaAccountIds = Pluck.idsAtPath(
      meetingSetOcas,
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_TO_ACCOUNT_ID_PATH
    );
    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      new StatusSelector().selectActiveStatusByAccountIds(ocaAccountIds),
      C.STATUS_ACCOUNT_FIELD
    );
    Map<Id, Status__c> meetingSetOsByAccountId = new Map<Id, Status__c>();
    Map<Id, Contact> contactById = new Map<Id, Contact>(contacts);
    for (Outbound_Contact_Activation__c oca : meetingSetOcas) {
      if (meetingSetOsByAccountId.containsKey(oca.Contact__r.AccountId)) {
        continue;
      }
      Status__c os;
      if (statusByAccountId.containsKey(oca.Contact__r.AccountId)) {
        os = (Status__c) statusByAccountId.get(oca.Contact__r.AccountId);
        os.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET;
      } else {
        os = new Status__c(
          Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET,
          Account__c = contactById.get(oca.Contact__c).AccountId,
          Activated_Date__c = oca.Activated_Date__c,
          Activated_By__c = oca.Activated_By__c
        );
      }
      meetingSetOsByAccountId.put(os.Account__c, os);
    }
    return meetingSetOsByAccountId.values();
  }

  /**
   * @description - returns a new Status__c if contact activations meets threshold
   *              or returns an updated Status__c if active one already exists
   */
  public List<Status__c> createContactsPerAccountStatuses(
    List<Outbound_Contact_Activation__c> newAndUpdatedOcas
  ) {
    Map<Id, List<Outbound_Contact_Activation__c>> ocasByAccountId = Mapper.byPath(
      newAndUpdatedOcas,
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_TO_ACCOUNT_ID_PATH
    );

    Set<Id> accountIds = ocasByAccountId.keySet();
    for (
      Outbound_Contact_Activation__c dbActivation : new OutboundContactActivationSelector()
        .selectCurrentActivationsByAccountIdsNotInIds(
          accountIds,
          Pluck.ids(newAndUpdatedOcas, C.ID_FIELD)
        )
    ) {
      ocasByAccountId.get(dbActivation.Contact__r.AccountId).add(dbActivation);
    }

    List<Status__c> currentStatuses = new List<Status__c>();
    for (Outbound_Contact_Activation__c oca : newAndUpdatedOcas) {
      Status__c currentOs = (Status__c) oca.getSObject(
        C.OUTBOUND_CONTACT_ACTIVATION_STATUS_RELATIONSHIP
      );
      if (currentOs != null) {
        currentStatuses.add(currentOs);
      }
    }
    Map<Id, SObject> existingOsByAccountId = Mapper.singleById(
      currentStatuses,
      C.STATUS_ACCOUNT_FIELD
    );

    // create new statuses
    for (Id accountId : accountIds) {
      if (
        !existingOsByAccountId.containsKey(accountId) &&
        ocasByAccountId.get(accountId).size() >=
        CustomMetadataCache.setting.Active_Contacts1__c
      ) {
        // create new status
        // needs rollup fields
        Outbound_Contact_Activation__c oca = ocasByAccountId.get(accountId)[0];
        oca.Outbound_Status__r = new Status__c( // it's helpful to have the OS attached to the OCA like this, looks confusing though
          Activated_Date__c = Date.today(),
          Activated_By__c = oca.Activated_By__c,
          Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED,
          Account__c = accountId
        );
        existingOsByAccountId.put(accountId, oca.Outbound_Status__r);
      }
    }

    return existingOsByAccountId.values();
  }

  public List<Status__c> activateAccountsViaOpportunityCreation(
    List<Opportunity> opportunities
  ) {
    List<Opportunity> unskippedOpportunities = new List<Opportunity>();
    for (Opportunity opportunity : opportunities) {
      if (
        !TaskHelper.isApplicable(
          opportunity,
          CustomMetadataCache.setting.Filter_Opportunity_Criteria__c,
          null
        )
      ) {
        unskippedOpportunities.add(opportunity);
      }
    }

    List<Account> accountsEligibleForOpportunityActivation = new AccountSelector()
      .selectAccountsEligibleForOpportunityActivationByIds(
        Pluck.ids(unskippedOpportunities, C.ACCOUNT_ID_FIELD),
        Pluck.ids(unskippedOpportunities)
      );

    if (accountsEligibleForOpportunityActivation.isEmpty()) {
      return new List<Status__c>();
    }

    List<Account> eligibleUnskippedAccounts = new List<Account>();
    for (Account account : accountsEligibleForOpportunityActivation) {
      if (
        !TaskHelper.isApplicable(
          account,
          CustomMetadataCache.setting.Filter_Accounts_Criteria__c,
          null
        )
      ) {
        eligibleUnskippedAccounts.add(account);
      }
    }

    Map<Id, Contact> eligibleContactById = new Map<Id, Contact>(
      new ContactSelector()
        .selectContactsByAccountIds(Pluck.ids(eligibleUnskippedAccounts))
    );

    List<Task> ioTasksInTrackingPeriod = new TaskSelector()
      .selectIoOwnedTasksWithinTrackingPeriodByWhoIdsNotInIds(
        eligibleContactById.keyset(),
        new Set<Id>()
      );

    if (ioTasksInTrackingPeriod.isEmpty()) {
      return new List<Status__c>();
    }

    if (!Util.hasCoolingOffPeriodElapsedSinceLastUpgrade()) {
      // since cool off period hasn't elapsed since upgrade
      // we're going to look back wait_period # days to ensure we
      // don't activate something that is already in-flight
      Set<Id> accountIds = Pluck.ids(
        ioTasksInTrackingPeriod,
        C.ACTIVITY_WHAT_ID_FIELD
      );
      List<Task> previousActivitiesWithinCoolOff = new TaskSelector()
        .selectTasksByAccountIdsCreatedAfterDateBeforeTodayAndNotInIds(
          accountIds,
          new Set<Id>(),
          Date.today()
            .addDays(
              -Integer.valueOf(CustomMetadataCache.setting.Wait_Period__c)
            )
        );
      if (!previousActivitiesWithinCoolOff.isEmpty()) {
        ioTasksInTrackingPeriod = TaskHelper.filterActivitiesFromAccountsWithOtherProspectingActivities(
          ioTasksInTrackingPeriod,
          previousActivitiesWithinCoolOff
        );
      }
    }

    if (ioTasksInTrackingPeriod.isEmpty()) {
      return new List<Status__c>();
    }

    Map<Id, ActivityStats> prospectingActivityStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      ioTasksInTrackingPeriod
    );

    Map<Id, SObject> opportunityByAccountId = Mapper.singleById(
      unskippedOpportunities,
      C.ACCOUNT_ID_FIELD
    );
    Map<Id, Status__c> newActivationByAccountId = new Map<Id, Status__c>();
    Map<Id, User> ioUserById = new Map<Id, User>(PermissionsCache.ioUsers);
    for (Id contactId : prospectingActivityStatByWhoId.keyset()) {
      ActivityStats stat = prospectingActivityStatByWhoId.get(contactId);
      Contact contact = eligibleContactById.get(contactId);
      Id accountId = contact.AccountId;
      if (!stat.hasProspectingActivity()) {
        continue;
      }

      Opportunity opportunity = (Opportunity) opportunityByAccountId.get(
        accountId
      );

      Status__c os = newActivationByAccountId.containsKey(accountId)
        ? (Status__c) newActivationByAccountId.get(accountId)
        : new Status__c(
            Activated_Date__c = Date.today(),
            Activated_By__c = stat.ownerId,
            Account__c = accountId,
            Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
            Opportunity__c = opportunity.Id,
            Opportunity_Created_Date__c = opportunity.CreatedDate.date(),
            Opportunity_Amount__c = opportunity.Amount,
            Total_Outbound_Emails__c = 0,
            Total_Inbound_Emails__c = 0,
            Total_Outbound_Calls__c = 0,
            Total_Inmails__c = 0,
            Total_Gifts__c = 0,
            Total_Call_Connects__c = 0
          );

      os.Total_Outbound_Emails__c += stat.outboundEmails;
      os.Total_Inbound_Emails__c += stat.inboundEmails;
      os.Total_Outbound_Calls__c += stat.dials;
      os.Total_Inmails__c += stat.inMails;
      os.Total_Gifts__c += stat.gifts;
      os.Total_Call_Connects__c += stat.engagedDials;

      newActivationByAccountId.put(accountId, os);
    }
    return newActivationByAccountId.values();
  }

  /**
   * will overwrite whatever Opportunity details exist on Status prior to its invocation
   * because we assume a Status will always only have a single Opportunity associated with it
   */
  public List<Status__c> rollupOpportunityToStatus(
    List<Opportunity> opportunities,
    List<Status__c> statuses
  ) {
    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      statuses,
      C.STATUS_ACCOUNT_FIELD
    );

    List<Status__c> updatedStatuses = new List<Status__c>();
    for (Opportunity opportunity : opportunities) {
      if (!statusByAccountId.containsKey(opportunity.AccountId)) {
        continue;
      }
      Status__c status = StatusHelper.rollupOpportunityToStatus(
        (Status__c) statusByAccountId.get(opportunity.AccountId),
        opportunity
      );
      updatedStatuses.add(status);
    }

    return updatedStatuses;
  }
}