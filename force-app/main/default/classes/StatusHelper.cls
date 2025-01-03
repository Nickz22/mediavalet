public with sharing class StatusHelper {
  public static Status__c rollupOpportunityToStatus(
    Status__c os,
    Opportunity opportunity
  ) {
    os.Opportunity_Created_Date__c = opportunity.CreatedDate.date();
    os.Opportunity__c = opportunity.Id;
    os.Opportunity_Amount__c = opportunity.Amount;
    os.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED;
    return os;
  }

  /**
   * @description resets Status rollup values, and resets in accordance with OCAs
   */
  public static List<Status__c> rollupOcasToStatuses(
    List<Status__c> statuses,
    List<Outbound_Contact_Activation__c> ocas
  ) {
    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      statuses,
      C.STATUS_ACCOUNT_FIELD
    );

    for (Status__c os : (List<Status__c>) statusByAccountId.values()) {
      os.Total_Meetings__c = 0;
      os.Total_Outbound_Emails__c = 0;
      os.Total_Inbound_Emails__c = 0;
      os.Total_Outbound_Calls__c = 0;
      os.Total_Outbound_Engagements__c = 0;
      os.Total_Call_Connects__c = 0;
      os.Total_Gifts__c = 0;
      os.Total_Inmails__c = 0;
      os.Total_Activated_Contacts__c = 0;
      os.First_Meeting_Date__c = null;
      os.Last_Meeting_Date__c = null;
      os.First_Outbound_Activity__c = null;
      os.Last_Outbound_Activity__c = null;
      os.First_Prospecting_Activity__c = null;
      os.Last_Prospecting_Activity__c = null;
      os.Engaged_Date__c = null;
      os.First_Outbound_Engagement__c = null;
    }

    for (Outbound_Contact_Activation__c oca : ocas) {
      if (!statusByAccountId.containsKey(oca.Contact__r.AccountId)) {
        continue;
      }
      Status__c os = (Status__c) statusByAccountId.get(
        oca.Contact__r.AccountId
      );
      os.Total_Activated_Contacts__c += 1;
      os.Total_Meetings__c += (oca.Meetings__c == null ? 0 : oca.Meetings__c);
      os.Total_Outbound_Emails__c += (oca.Outbound_Emails__c == null
        ? 0
        : oca.Outbound_Emails__c);
      os.Total_Inbound_Emails__c += (oca.Inbound_Emails__c == null
        ? 0
        : oca.Inbound_Emails__c);
      os.Total_Outbound_Engagements__c += (oca.Engagements__c == null
        ? 0
        : oca.Engagements__c);
      System.debug(os.Total_Outbound_Calls__c);
      os.Total_Outbound_Calls__c += (oca.Dials__c == null ? 0 : oca.Dials__c);
      os.Total_Call_Connects__c += (oca.Call_Connects__c == null
        ? 0
        : oca.Call_Connects__c);
      os.Total_Gifts__c += (oca.Gifts__c == null ? 0 : oca.Gifts__c);
      os.Total_Inmails__c += (oca.Inmails__c == null ? 0 : oca.Inmails__c);

      if (
        oca.First_Meeting_Date__c != null &&
        (os.First_Meeting_Date__c == null ||
        oca.First_Meeting_Date__c < os.First_Meeting_Date__c)
      ) {
        os.First_Meeting_Date__c = oca.First_Meeting_Date__c;
      }

      if (
        oca.Last_Meeting_Date__c != null &&
        (os.Last_Meeting_Date__c == null ||
        oca.Last_Meeting_Date__c > os.Last_Meeting_Date__c)
      ) {
        os.Last_Meeting_Date__c = oca.Last_Meeting_Date__c;
      }

      if (
        oca.First_Outbound_Activity__c != null &&
        (os.First_Outbound_Activity__c == null ||
        oca.First_Outbound_Activity__c < os.First_Outbound_Activity__c)
      ) {
        os.First_Outbound_Activity__c = oca.First_Outbound_Activity__c;
      }

      if (
        oca.Last_Outbound_Activity__c != null &&
        (os.Last_Outbound_Activity__c == null ||
        oca.Last_Outbound_Activity__c > os.Last_Outbound_Activity__c)
      ) {
        os.Last_Outbound_Activity__c = oca.Last_Outbound_Activity__c;
      }

      if (
        oca.Last_Prospecting_Activity__c != null &&
        (os.Last_Prospecting_Activity__c == null ||
        oca.Last_Prospecting_Activity__c > os.Last_Prospecting_Activity__c)
      ) {
        os.Last_Prospecting_Activity__c = oca.Last_Prospecting_Activity__c;
      }

      if (
        oca.First_Prospecting_Activity__c != null &&
        (os.First_Prospecting_Activity__c == null ||
        oca.First_Prospecting_Activity__c < os.First_Prospecting_Activity__c)
      ) {
        os.First_Prospecting_Activity__c = oca.First_Prospecting_Activity__c;
      }

      if (os.Engaged_Date__c == null) {
        os.Engaged_Date__c = oca.Engaged_Date__c;
      }

      if (
        oca.First_Outbound_Engagement__c != null &&
        (os.First_Outbound_Engagement__c == null ||
        oca.First_Outbound_Engagement__c < os.First_Outbound_Engagement__c)
      ) {
        os.First_Outbound_Engagement__c = oca.First_Outbound_Engagement__c;
      }
    }

    for (Status__c os : (List<Status__c>) statusByAccountId.values()) {
      String newProspectingStatus = os.Prospecting_Status__c;

      if (
        os.Id == null &&
        os.First_Meeting_Date__c == null &&
        os.Engaged_Date__c == null
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED;
      } else if (os.Id == null && os.First_Meeting_Date__c != null) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET;
      } else if (os.Id == null && os.Engaged_Date__c != null) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ENGAGED;
      } else if (
        os.Id != null &&
        (os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ENGAGED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_CLAIMED) &&
        os.First_Meeting_Date__c != null
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET;
      } else if (
        os.Id != null &&
        os.Engaged_Date__c != null &&
        (os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_CLAIMED)
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ENGAGED;
      }
      os.Prospecting_Status__c = newProspectingStatus;
    }
    return statusByAccountId.values();
  }

  // rollup without resetting Status values
  public static List<Status__c> incrementOcasIntoStatuses(
    List<Status__c> statuses,
    List<Outbound_Contact_Activation__c> ocas
  ) {
    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      statuses,
      C.STATUS_ACCOUNT_FIELD
    );

    for (Outbound_Contact_Activation__c oca : ocas) {
      if (!statusByAccountId.containsKey(oca.Contact__r.AccountId)) {
        continue;
      }
      Status__c os = (Status__c) statusByAccountId.get(
        oca.Contact__r.AccountId
      );
      os.Total_Activated_Contacts__c += 1;
      os.Total_Meetings__c += (oca.Meetings__c == null ? 0 : oca.Meetings__c);
      os.Total_Outbound_Emails__c += (oca.Outbound_Emails__c == null
        ? 0
        : oca.Outbound_Emails__c);
      os.Total_Inbound_Emails__c += (oca.Inbound_Emails__c == null
        ? 0
        : oca.Inbound_Emails__c);
      os.Total_Outbound_Engagements__c += (oca.Engagements__c == null
        ? 0
        : oca.Engagements__c);
      os.Total_Outbound_Calls__c += (oca.Dials__c == null ? 0 : oca.Dials__c);
      os.Total_Call_Connects__c += (oca.Call_Connects__c == null
        ? 0
        : oca.Call_Connects__c);
      os.Total_Gifts__c += (oca.Gifts__c == null ? 0 : oca.Gifts__c);
      os.Total_Inmails__c += (oca.Inmails__c == null ? 0 : oca.Inmails__c);

      if (
        oca.First_Meeting_Date__c != null &&
        (os.First_Meeting_Date__c == null ||
        oca.First_Meeting_Date__c < os.First_Meeting_Date__c)
      ) {
        os.First_Meeting_Date__c = oca.First_Meeting_Date__c;
      }

      if (
        oca.Last_Meeting_Date__c != null &&
        (os.Last_Meeting_Date__c == null ||
        oca.Last_Meeting_Date__c > os.Last_Meeting_Date__c)
      ) {
        os.Last_Meeting_Date__c = oca.Last_Meeting_Date__c;
      }

      if (
        oca.First_Outbound_Activity__c != null &&
        (os.First_Outbound_Activity__c == null ||
        oca.First_Outbound_Activity__c < os.First_Outbound_Activity__c)
      ) {
        os.First_Outbound_Activity__c = oca.First_Outbound_Activity__c;
      }

      if (
        oca.Last_Outbound_Activity__c != null &&
        (os.Last_Outbound_Activity__c == null ||
        oca.Last_Outbound_Activity__c > os.Last_Outbound_Activity__c)
      ) {
        os.Last_Outbound_Activity__c = oca.Last_Outbound_Activity__c;
      }

      if (
        oca.Last_Prospecting_Activity__c != null &&
        (os.Last_Prospecting_Activity__c == null ||
        oca.Last_Prospecting_Activity__c > os.Last_Prospecting_Activity__c)
      ) {
        os.Last_Prospecting_Activity__c = oca.Last_Prospecting_Activity__c;
      }

      if (
        oca.First_Prospecting_Activity__c != null &&
        (os.First_Prospecting_Activity__c == null ||
        oca.First_Prospecting_Activity__c < os.First_Prospecting_Activity__c)
      ) {
        os.First_Prospecting_Activity__c = oca.First_Prospecting_Activity__c;
      }

      if (os.Engaged_Date__c == null) {
        os.Engaged_Date__c = oca.Engaged_Date__c;
      }

      if (
        oca.First_Outbound_Engagement__c != null &&
        (os.First_Outbound_Engagement__c == null ||
        oca.First_Outbound_Engagement__c < os.First_Outbound_Engagement__c)
      ) {
        os.First_Outbound_Engagement__c = oca.First_Outbound_Engagement__c;
      }

      String newProspectingStatus = os.Prospecting_Status__c;

      if (
        os.Id == null &&
        os.First_Meeting_Date__c == null &&
        os.Engaged_Date__c == null
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED;
      } else if (os.Id == null && os.First_Meeting_Date__c != null) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET;
      } else if (os.Id == null && os.Engaged_Date__c != null) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ENGAGED;
      } else if (
        os.Id != null &&
        (os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ENGAGED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_CLAIMED) &&
        os.First_Meeting_Date__c != null
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET;
      } else if (
        os.Id != null &&
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED ||
        os.Prospecting_Status__c == C.OUTBOUND_PROSPECTING_STATUS_CLAIMED &&
        os.Engaged_Date__c != null
      ) {
        newProspectingStatus = C.OUTBOUND_PROSPECTING_STATUS_ENGAGED;
      }

      os.Prospecting_Status__c = newProspectingStatus;

      statusByAccountId.put(os.Id, os);
    }
    return statusByAccountId.values();
  }
}