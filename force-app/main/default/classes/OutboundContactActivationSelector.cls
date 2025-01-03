public with sharing class OutboundContactActivationSelector {
  public OutboundContactActivationSelector() {
  }

  static final String OUTBOUND_CONTACT_ACTIVATION_FIELDS = String.join(
    new List<String>(
      Schema.SObjectType.Outbound_Contact_Activation__c.fields.getMap().keySet()
    ),
    ','
  );

  static final String OUTBOUND_CONTACT_ACTIVATION_STATUS_FIELDS =
    'Outbound_Status__r.' +
    String.join(
      new List<String>(Schema.SObjectType.Status__c.fields.getMap().keySet()),
      ',Outbound_Status__r.'
    );

  static final String OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELDS = 'Contact__r.AccountId';

  static final String OUTBOUND_CONTACT_ACTIVATION_ACTIVATED_BY_FIELDS = 'Activated_By__r.Name';

  public List<Outbound_Contact_Activation__c> selectCurrentActivationsByContactIds(
    Set<Id> contactIds
  ) {
    List<Outbound_Contact_Activation__c> activations;
    String q =
      'SELECT ' +
      OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_ACTIVATED_BY_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_STATUS_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_FIELDS +
      ' ' +
      'FROM Outbound_Contact_Activation__c ' +
      'WHERE Contact__c IN :contactIds ' +
      ' AND Is_Current__c = true ' +
      'WITH USER_MODE';
    try {
      activations = Database.query(q);
    } catch (Exception e) {
      throw new OutboundContactActivationSelectorException(
        e.getMessage() +
        '\n\n' +
        q
      );
    }
    return activations;
  }

  private class OutboundContactActivationSelectorException extends Exception {
  }

  public List<Outbound_Contact_Activation__c> selectCurrentActivationsByAccountIdsNotInIds(
    Set<Id> accountIds,
    Set<Id> notInIds
  ) {
    return Database.query(
      'SELECT ' +
      OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_ACTIVATED_BY_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_FIELDS +
      ' ' +
      'FROM Outbound_Contact_Activation__c ' +
      'WHERE Contact__r.AccountId IN :accountIds ' +
      ' AND Is_Current__c = true ' +
      ' AND Id NOT IN :notInIds ' +
      'WITH USER_MODE'
    );
  }

  public List<Outbound_Contact_Activation__c> selectCurrentActivationsByAccountIds(
    Set<Id> accountIds
  ) {
    String q =
      'SELECT ' +
      OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_ACTIVATED_BY_FIELDS +
      ',' +
      OUTBOUND_CONTACT_ACTIVATION_FIELDS +
      ' ' +
      'FROM Outbound_Contact_Activation__c ' +
      'WHERE Contact__r.AccountId IN :accountIds ' +
      ' AND Is_Current__c = true ' +
      'WITH USER_MODE';
    System.debug(q);
    return Database.query(q);
  }

  public List<Outbound_Contact_Activation__c> selectOcasByStatusIds(
    Set<Id> statusIds
  ) {
    return [
      SELECT Id
      FROM Outbound_Contact_Activation__c
      WHERE Outbound_Status__c IN :statusIds
      WITH USER_MODE
    ];
  }
}