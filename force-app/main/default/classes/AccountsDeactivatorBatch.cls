/**
 * @description Batch Job that deactivate Accounts after N days of inactivity (set in Settings__c.Deactivate_After__c)
 */
public with sharing class AccountsDeactivatorBatch implements Database.Batchable<sObject>, Database.Stateful {
  private Settings__mdt outboundSettings { get; set; }
  private Set<String> ACTIVE_OS_PROSPECTING_STATUSES = C.ACTIVE_OUTBOUND_PROSPECTING_STATUSES;

  fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new List<SObjectType>{
      Status__c.sObjectType,
      Outbound_Contact_Activation__c.SObjectType
    }
  );

  public AccountsDeactivatorBatch() {
    outboundSettings = [
      SELECT Deactivate_After__c, Wait_Period__c
      FROM Settings__mdt
      ORDER BY ID DESC
      LIMIT 1
    ];
  }

  /**
   * @description Prepares the query to retrieve Accounts for deactivation
   */
  public Database.QueryLocator start(Database.BatchableContext context) {
    Date deactivateAfter = Date.today()
      .addDays(-1 * Integer.valueOf(outboundSettings.Deactivate_After__c));
    String query =
      'SELECT Account__c,Activated_By__c,Activated_Date__c,Times_Activated__c ' +
      'FROM Status__c ' +
      'WHERE Last_Outbound_Activity__c < :deactivateAfter ' +
      'AND Prospecting_Status__c IN: ACTIVE_OS_PROSPECTING_STATUSES ' +
      'AND Account__c != null ' +
      'WITH USER_MODE';
    return Database.getQueryLocator(query);
  }

  /**
   * @description Deactivates accounts
   */
  public void execute(Database.BatchableContext context, List<sObject> scope) {
    List<Status__c> unresponsiveStatuses = new List<Status__c>();
    for (Status__c os : (List<Status__c>) scope) {
      /**
       * Update statuses
       */
      os.Unresponsive_Date__c = Date.today();
      os.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE;
      unresponsiveStatuses.add(os);
    }
    List<Outbound_Contact_Activation__c> unresponsiveOcas = new OutboundContactActivationSelector()
      .selectOcasByStatusIds(Pluck.ids(unresponsiveStatuses));
    for (Outbound_Contact_Activation__c oca : unresponsiveOcas) {
      oca.Expired_Date__c = Date.today();
    }

    this.uow.registerDirty(unresponsiveStatuses);
    this.uow.registerDirty(unresponsiveOcas);
    this.uow.commitWork();
  }

  public void finish(Database.BatchableContext context) {
    //Do nothing
  }

  /**
   * @description Helper method to run the job
   */
  public static void runBatch() {
    Database.executeBatch(new AccountsDeactivatorBatch(), 1000);
  }
}