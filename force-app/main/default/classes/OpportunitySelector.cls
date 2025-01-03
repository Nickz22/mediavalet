public with sharing class OpportunitySelector {
  public OpportunitySelector() {
  }

  public List<Opportunity> selectOpportunitiesByAccountIds(Set<Id> accountIds) {
    return [
      SELECT AccountId, CreatedDate, Amount, IsClosed, OwnerId
      FROM Opportunity
      WHERE AccountId IN :accountIds
      WITH USER_MODE
    ];
  }

  public List<Opportunity> selectOpportunitiesWithForecastInfoByAccountIds(
    Set<Id> accountIds
  ) {
    return [
      SELECT
        Id,
        StageName,
        (
          SELECT Id, ForecastCategory, CreatedDate
          FROM OpportunityHistories
          ORDER BY CreatedDate
        )
      FROM Opportunity
      WHERE accountId IN :accountIds
      WITH USER_MODE
    ];
  }
}