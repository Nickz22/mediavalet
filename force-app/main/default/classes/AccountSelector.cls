public with sharing class AccountSelector {
  static final String ALL_ACCOUNT_FIELDS {
    get {
      if (String.isBlank(ALL_ACCOUNT_FIELDS)) {
        List<String> accessibleFields = new List<String>();
        Map<String, SObjectField> fieldByName = Account.SObjectType.getDescribe()
          .fields.getMap();
        for (String accountFieldName : fieldByName.keyset()) {
          Schema.DescribeFieldResult fieldDescribe = fieldByName
            .get(accountFieldName)
            .getDescribe();
          if (fieldDescribe.isAccessible()) {
            accessibleFields.add(accountFieldName);
          }
        }
        ALL_ACCOUNT_FIELDS = String.join(accessibleFields, ',');
      }
      return ALL_ACCOUNT_FIELDS;
    }
    private set;
  }

  public AccountSelector() {
  }

  public List<Account> selectAccountsEligibleForOpportunityActivationByIds(
    Set<Id> accountIds,
    Set<Id> newOpportunityIds
  ) {
    List<Account> accountsWithPreexistingOpenOpportunities = [
      SELECT Id
      FROM Account
      WHERE
        Id IN :accountIds
        AND Id IN (
          SELECT AccountId
          FROM Opportunity
          WHERE IsClosed = FALSE AND Id NOT IN :newOpportunityIds
        )
      WITH USER_MODE
    ];
    Integer coolOffPeriod = Integer.valueOf(
      CustomMetadataCache.setting.Wait_Period__c
    );
    Date coolOffThreshold = Date.today().addDays(-coolOffPeriod);
    String outboundProspectingStatusUnresponsive = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE;
    String outboundProspectingStatusOpportunityCreated = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED;
    Set<String> activeOutboundProspectingStatuses = C.ACTIVE_OUTBOUND_PROSPECTING_STATUSES;
    return Database.query(
      'SELECT ' +
      ALL_ACCOUNT_FIELDS +
      ' ' +
      'FROM Account ' +
      'WHERE ' +
      'Id IN :accountIds ' +
      'AND Id NOT IN (' +
      'SELECT Account__c ' +
      'FROM Status__c ' +
      'WHERE ' +
      '(Prospecting_Status__c = :outboundProspectingStatusUnresponsive ' +
      'AND Unresponsive_Date__c >= :coolOffThreshold) ' +
      'OR Prospecting_Status__c IN :activeOutboundProspectingStatuses ' +
      'OR Prospecting_Status__c = :outboundProspectingStatusOpportunityCreated ' +
      ') ' +
      'AND Id NOT IN :accountsWithPreexistingOpenOpportunities ' +
      'WITH USER_MODE'
    );
  }

  public List<Account> selectAccountsByIds(Set<Id> accountIds) {
    return Database.query(
      'SELECT ' +
      ALL_ACCOUNT_FIELDS +
      ' ' +
      'FROM Account ' +
      'WHERE Id IN :accountIds ' +
      'WITH USER_MODE'
    );
  }

  public List<Account> selectAccountsWithContactIdsByContactIds(
    Set<Id> contactIds
  ) {
    return Database.query(
      'SELECT ' +
      ALL_ACCOUNT_FIELDS +
      ', (SELECT Id FROM Contacts) ' +
      'FROM Account ' +
      'WHERE Id IN (SELECT AccountId FROM Contact WHERE Id IN :contactIds) ' +
      'WITH USER_MODE'
    );
  }
}