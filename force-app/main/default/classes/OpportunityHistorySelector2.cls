public with sharing class OpportunityHistorySelector2 {
  @TestVisible
  static Boolean returnMockDataForRetroactiveActivation = false;
  @TestVisible
  static Datetime mockCreatedDate;
  public List<OpportunityHistory> selectByOpportunityIds(
    Set<Id> opportunityIds
  ) {
    List<OpportunityHistory> histories = new List<OpportunityHistory>();
    if (returnMockDataForRetroactiveActivation) {
      for (Id opportunityId : opportunityIds) {
        Map<String, Object> history = new Map<String, Object>{
          'OpportunityId' => opportunityId,
          'StageName' => TestFactory.openOpportunityStages[0],
          'CreatedDate' => mockCreatedDate == null
            ? System.now()
            : mockCreatedDate
        };
        histories.add(
          (OpportunityHistory) JSON.deserialize(
            JSON.serialize(history),
            OpportunityHistory.class
          )
        );
      }
    } else {
      histories = [
        SELECT OpportunityId, StageName, CreatedDate
        FROM OpportunityHistory
        WHERE OpportunityId IN :opportunityIds
        WITH USER_MODE
      ];
    }

    return histories;
  }

  class MockOpportunityHistoryException extends Exception {
  }
}