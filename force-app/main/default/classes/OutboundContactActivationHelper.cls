public with sharing class OutboundContactActivationHelper {
  public static Outbound_Contact_Activation__c getOca(SObject c) {
    return new Outbound_Contact_Activation__c(
      Contact__c = c.Id,
      Name = c.get('Name') + ' [Activated]'
    );
  }

  public static Outbound_Contact_Activation__c addStatToActivation(
    Outbound_Contact_Activation__c oca,
    ActivityStats stat
  ) {
    oca.Inbound_Emails__c =
      (oca.Inbound_Emails__c != null ? oca.Inbound_Emails__c : 0) +
      (stat.inboundEmails != null ? stat.inboundEmails : 0);

    oca.Outbound_Emails__c =
      (oca.Outbound_Emails__c != null ? oca.Outbound_Emails__c : 0) +
      (stat.outboundEmails != null ? stat.outboundEmails : 0);

    oca.Dials__c =
      (oca.Dials__c != null ? oca.Dials__c : 0) +
      (stat.dials != null ? stat.dials : 0);

    oca.Meetings__c =
      (oca.Meetings__c != null ? oca.Meetings__c : 0) +
      (stat.meetings != null ? stat.meetings : 0);

    if (
      oca.First_Outbound_Activity__c == null ||
      oca.First_Outbound_Activity__c > stat.firstOutboundActivityDate
    ) {
      oca.First_Outbound_Activity__c = stat.firstOutboundActivityDate;
    }

    if (
      oca.Last_Outbound_Activity__c == null ||
      oca.Last_Outbound_Activity__c < stat.lastOutboundActivityDate
    ) {
      oca.Last_Outbound_Activity__c = stat.lastOutboundActivityDate;
    }

    if (oca.First_Meeting_Date__c == null && oca.Meetings__c > 0) {
      oca.First_Meeting_Date__c = stat.firstMeetingDate;
    }

    if (oca.Last_Meeting_Date__c == null && oca.Meetings__c > 0) {
      oca.Last_Meeting_Date__c = stat.lastMeetingDate;
    } else if (
      stat.lastMeetingDate != null &&
      oca.Last_Meeting_Date__c != null &&
      stat.lastMeetingDate > oca.Last_Meeting_Date__c
    ) {
      oca.Last_Meeting_Date__c = stat.lastMeetingDate;
    }

    if (
      oca.Last_Prospecting_Activity__c == null ||
      oca.Last_Prospecting_Activity__c < stat.lastProspectingActivityDate
    ) {
      oca.Last_Prospecting_Activity__c = stat.lastProspectingActivityDate;
    }

    if (
      oca.First_Prospecting_Activity__c == null ||
      oca.First_Prospecting_Activity__c > stat.firstProspectingActivityDate
    ) {
      oca.First_Prospecting_Activity__c = stat.firstProspectingActivityDate;
    }

    if (oca.Engaged_Date__c == null && stat.isEngagedActivity()) {
      oca.Engaged_Date__c = Date.today();
      oca.First_Outbound_Engagement__c = Date.today();
      // TODO: should we add Engaged_By_Retro__c here?
    }

    oca.Gifts__c = oca.Gifts__c != null
      ? oca.Gifts__c + stat.gifts
      : stat.gifts;
    oca.Inmails__c = oca.Inmails__c != null
      ? oca.Inmails__c + stat.inmails
      : stat.inmails;
    oca.Call_Connects__c = oca.Call_Connects__c != null
      ? oca.Call_Connects__c + stat.engagedDials
      : stat.engagedDials;
    oca.Engagements__c = oca.Engagements__c != null
      ? oca.Engagements__c + stat.inboundEmails + stat.engagedDials
      : stat.inboundEmails + stat.engagedDials;
    return oca;
  }
}