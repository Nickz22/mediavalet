public with sharing class PipelineHistorySelector {
  public List<Prospecting_Effort__c> selectHistoriesByStatusIds(
    Set<Id> statusIds
  ) {
    // Query to select the existing Pipeline History record by status ID
    return [
      SELECT
        Call_Connects__c,
        Outbound_Emails__c,
        Inbound_Emails__c,
        Activated_By__c,
        Meetings__c,
        Gifts__c,
        Inmails__c,
        Dials__c,
        Outbound_Status__c,
        Status__c,
        Task_Ids__c
      FROM Prospecting_Effort__c
      WHERE Outbound_Status__c IN :statusIds
      WITH USER_MODE
    ];
  }
}