public with sharing class ContactSelector {
  public ContactSelector() {
  }

  /**
   * No User Mode because we need to be absolutely sure that the trigger which executes
   * this query does not run when a Contact is inactive, by way of any Unresponsive Status,
   * or any open opportunity
   */
  public List<Contact> selectEligibleContactsByContactIds(Set<Id> contactIds) {
    Integer coolOffPeriod = Integer.valueOf(
      CustomMetadataCache.setting.Wait_Period__c
    );
    Date coolOffThreshold = Date.today().addDays(-coolOffPeriod);
    Set<Id> accountIdsWithOpenOpportunity = Pluck.ids(
      this.selectContactsByIdsFromAccountsWithOpenOpportunities(contactIds),
      C.ACCOUNT_ID_FIELD
    );
    return [
      SELECT Owner.Name, AccountId, Account.Name, Name
      FROM Contact
      WHERE
        Id IN :contactIds
        AND AccountId NOT IN (
          SELECT Account__c
          FROM Status__c
          WHERE Unresponsive_Date__c >= :coolOffThreshold
        )
        AND AccountId NOT IN :accountIdsWithOpenOpportunity
      WITH USER_MODE
    ];
  }

  /**
   * No User Mode because we need to be absolutely sure that the trigger which executes
   * this query does not run when a Contact is inactive, by way of any Unresponsive Status,
   * or any open opportunity
   */
  public List<Contact> selectContactsByIdsFromAccountsWithOpenOpportunities(
    Set<Id> contactIds
  ) {
    return [
      SELECT AccountId
      FROM Contact
      WHERE
        Id IN :contactIds
        AND AccountId IN (
          SELECT AccountId
          FROM Opportunity
          WHERE IsClosed = FALSE
        )
      WITH USER_MODE
    ];
  }

  public List<Contact> selectContactsByAccountId(Id accountId) {
    return [SELECT Id FROM Contact WHERE AccountId = :accountId WITH USER_MODE];
  }

  public List<Contact> selectContactsByAccountIds(Set<Id> accountIds) {
    return [
      SELECT Account.Name, AccountId
      FROM Contact
      WHERE AccountId IN :accountIds
      WITH USER_MODE
    ];
  }

  public List<Contact> selectContactsByIds(Set<Id> ids) {
    return [
      SELECT Name, AccountId, Account.Name, OwnerId, Owner.Name
      FROM Contact
      WHERE Id IN :ids
      WITH USER_MODE
    ];
  }

  public List<Contact> selectContactsWithAllAccountFields(Set<Id> ids) {
    List<String> contactFields = new List<String>();
    for (
      Schema.SObjectField field : Contact.SObjectType.getDescribe()
        .fields.getMap()
        .values()
    ) {
      if (field.getDescribe().isAccessible()) {
        contactFields.add(field.getDescribe().getName());
      }
    }
    List<String> accountFields = new List<String>();
    for (
      Schema.SObjectField field : Account.SObjectType.getDescribe()
        .fields.getMap()
        .values()
    ) {
      if (field.getDescribe().isAccessible()) {
        accountFields.add('Account.' + field.getDescribe().getName());
      }
    }
    String query =
      'SELECT ' +
      String.join(contactFields, ', ') +
      ', ' +
      String.join(accountFields, ', ') +
      ' FROM Contact WHERE Id IN :ids WITH USER_MODE';
    return Database.query(query);
  }

  public List<Contact> selectByIdsAndAccountId(Set<Id> ids, Id accountId) {
    return [
      SELECT Id
      FROM Contact
      WHERE Id IN :ids AND AccountId = :accountId
      WITH USER_MODE
    ];
  }

  public List<Contact> selectSiblingContactsByContactIds(Set<Id> contactIds) {
    Set<Id> accountIds = Pluck.ids(
      this.selectContactsByIds(contactIds),
      C.ACCOUNT_ID_FIELD
    );
    return [
      SELECT AccountId, Account.Name, Name
      FROM Contact
      WHERE AccountId IN :accountIds AND Id NOT IN :contactIds
      WITH USER_MODE
    ];
  }
}
