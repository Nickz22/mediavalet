public with sharing class StatusSelector {
  public StatusSelector() {
  }

  public List<Status__c> selectActivatedStatusByIds(Set<Id> ids) {
    return [
      SELECT
        Account__c,
        Prospecting_Status__c,
        OwnerId,
        Activated_By__c,
        Claimed_By__c,
        Total_Meetings__c,
        First_Meeting_Date__c,
        Last_Meeting_Date__c,
        Total_Outbound_Emails__c,
        Unresponsive_Date__c,
        CreatedBy.Name,
        Total_Opportunities_Amount__c
      FROM Status__c
      WHERE
        Id IN :ids
        AND Prospecting_Status__c IN :C.ACTIVE_OUTBOUND_PROSPECTING_STATUSES
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
    Set<Id> accountIds
  ) {
    return [
      SELECT
        Account__c,
        Opportunity_Created_Date__c,
        Last_Meeting_Date__c,
        First_Meeting_Date__c,
        Total_Meetings__c,
        Total_Inbound_Emails__c,
        Total_Outbound_Emails__c,
        Opportunity__c,
        Opportunity_Amount__c,
        Prospecting_Status__c,
        Unresponsive_Date__c,
        Activated_Date__c,
        Activated_By__c,
        CreatedBy.Name,
        Total_Opportunities_Amount__c
      FROM Status__c
      WHERE Account__c IN :accountIds
      WITH USER_MODE
      ORDER BY Unresponsive_Date__c DESC NULLS FIRST
    ];
  }

  public List<Status__c> selectActiveUnclaimedStatusByAccountIds(
    Set<Id> accountIds
  ) {
    return [
      SELECT
        Activated_Date__c,
        Engaged_Date__c,
        First_Outbound_Activity__c,
        First_Outbound_Engagement__c,
        Last_Outbound_Activity__c,
        Last_Outbound_Engagement__c,
        Total_Outbound_Calls__c,
        Total_Outbound_Emails__c,
        Total_Outbound_Engagements__c,
        Total_Call_Connects__c,
        Activated_Contact_Ids__c,
        Engaged_Contact_Ids__c,
        Total_Activated_Contacts__c,
        Total_Engaged_Contacts__c,
        CreatedById,
        Activated_By__c,
        Total_Meetings__c,
        First_Meeting_Date__c,
        Last_Meeting_Date__c,
        Times_Activated__c,
        Prospecting_Status__c,
        OwnerId,
        Total_Gifts__c,
        Total_InMails__c,
        Claimed_By__c,
        First_Opportunity_Created__c,
        Activated_By_Retro__c
      FROM Status__c
      WHERE
        Account__c IN :accountIds
        AND Unresponsive_Date__c = NULL
        AND Account__c != NULL
        AND Prospecting_Status__c != :C.OUTBOUND_PROSPECTING_STATUS_CLAIMED
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectActiveStatusByOpportunityIds(
    Set<Id> opportunityIds
  ) {
    return [
      SELECT
        Total_Opportunities_Created__c,
        First_Opportunity_Created__c,
        CreatedById,
        Activated_By__c,
        Prospecting_Status__c,
        OwnerId,
        Activated_By_Retro__c
      FROM Status__c
      WHERE
        Opportunity__c IN :opportunityIds
        AND Nurture_Date__c = NULL
        AND Opportunity_Created_Date__c = NULL
        AND Unresponsive_Date__c = NULL
        AND Activated_Date__c != NULL
        AND Account__c != NULL
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectOpportunityCreatedStatusByAccountIds(
    Set<Id> accountIds
  ) {
    return [
      SELECT
        Account__c,
        Total_Opportunities_Created__c,
        First_Opportunity_Created__c,
        First_Meeting_Date__c,
        Last_Meeting_Date__c,
        First_Outbound_Activity__c,
        Last_Outbound_Activity__c,
        Engaged_Date__c,
        First_Outbound_Engagement__c,
        CreatedById,
        Total_Meetings__c,
        Activated_By__c,
        Prospecting_Status__c,
        OwnerId,
        Activated_By_Retro__c
      FROM Status__c
      WHERE Account__c IN :accountIds AND Opportunity_Created_Date__c != NULL
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectActiveStatusByAccountIds(Set<Id> accountIds) {
    return [
      SELECT
        Account__c,
        Total_Opportunities_Created__c,
        First_Opportunity_Created__c,
        First_Meeting_Date__c,
        Last_Meeting_Date__c,
        First_Outbound_Activity__c,
        Last_Outbound_Activity__c,
        Engaged_Date__c,
        First_Outbound_Engagement__c,
        CreatedById,
        Total_Meetings__c,
        Activated_By__c,
        Prospecting_Status__c,
        OwnerId,
        Activated_By_Retro__c
      FROM Status__c
      WHERE
        Account__c IN :accountIds
        AND Nurture_Date__c = NULL
        AND Opportunity_Created_Date__c = NULL
        AND Unresponsive_Date__c = NULL
        AND Activated_Date__c != NULL
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectRetroActivatedStatusesByAccountId(
    Set<Id> accountIds
  ) {
    return [
      SELECT Id, Activated_By_Retro__c
      FROM Status__c
      WHERE Account__c IN :accountIds AND Activated_By_Retro__c = TRUE
      WITH USER_MODE
    ];
  }

  public List<Status__c> selectByIds(Set<Id> ids) {
    return [
      SELECT
        Account__c,
        Prospecting_Status__c,
        OwnerId,
        Claimed_By__c,
        First_Meeting_Date__c,
        Last_Meeting_Date__c,
        Activated_By__c,
        Unresponsive_Date__c,
        CreatedBy.Name,
        Total_Call_Connects__c,
        Total_Inmails__c,
        Total_Gifts__c,
        Total_Opportunities_Amount__c,
        Total_Outbound_Calls__c,
        Total_Meetings__c,
        Total_Inbound_Emails__c,
        Total_Outbound_Emails__c
      FROM Status__c
      WHERE Id IN :ids
      WITH USER_MODE
    ];
  }
}