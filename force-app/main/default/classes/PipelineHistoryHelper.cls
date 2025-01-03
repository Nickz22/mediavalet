public with sharing class PipelineHistoryHelper {
  public PipelineHistoryHelper() {
  }

  public static Prospecting_Effort__c incrementPipelineHistory(
    Prospecting_Effort__c pipelineHistory,
    Outbound_Contact_Activation__c oca
  ) {
    if (pipelineHistory.Call_Connects__c == null) {
      pipelineHistory.Call_Connects__c = 0;
    }
    if (oca.Call_Connects__c != null) {
      pipelineHistory.Call_Connects__c += oca.Call_Connects__c;
    }

    if (pipelineHistory.Outbound_Emails__c == null) {
      pipelineHistory.Outbound_Emails__c = 0;
    }
    if (oca.Outbound_Emails__c != null) {
      pipelineHistory.Outbound_Emails__c += oca.Outbound_Emails__c;
    }

    if (pipelineHistory.Inbound_Emails__c == null) {
      pipelineHistory.Inbound_Emails__c = 0;
    }
    if (oca.Inbound_Emails__c != null) {
      pipelineHistory.Inbound_Emails__c += oca.Inbound_Emails__c;
    }

    if (pipelineHistory.Meetings__c == null) {
      pipelineHistory.Meetings__c = 0;
    }
    if (oca.Meetings__c != null) {
      pipelineHistory.Meetings__c += oca.Meetings__c;
    }

    if (pipelineHistory.Gifts__c == null) {
      pipelineHistory.Gifts__c = 0;
    }
    if (oca.Gifts__c != null) {
      pipelineHistory.Gifts__c += oca.Gifts__c;
    }

    if (pipelineHistory.Inmails__c == null) {
      pipelineHistory.Inmails__c = 0;
    }
    if (oca.Inmails__c != null) {
      pipelineHistory.Inmails__c += oca.Inmails__c;
    }

    if (pipelineHistory.Dials__c == null) {
      pipelineHistory.Dials__c = 0;
    }
    if (oca.Dials__c != null) {
      pipelineHistory.Dials__c += oca.Dials__c;
    }

    return pipelineHistory;
  }

  public static Prospecting_Effort__c createNew(Status__c os) {
    return new Prospecting_Effort__c(
      Outbound_Status__c = os.Id,
      Status__c = C.PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME.get(
        os.Prospecting_Status__c
      ),
      Activated_By__c = os.Activated_By__c,
      Status_Entered__c = Date.today(),
      Call_Connects__c = 0,
      Outbound_Emails__c = 0,
      Inbound_Emails__c = 0,
      Meetings__c = 0,
      Gifts__c = 0,
      Inmails__c = 0,
      Dials__c = 0,
      Task_Ids__c = ''
    );
  }
}