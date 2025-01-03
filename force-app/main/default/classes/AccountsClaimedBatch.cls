/*
 * Batch class to delete Status record for Claimed account but no activity done in claim periods
 * Find all status who are still in Claimed Status and not activated and created date is in falls after claim period in past
 * Added on : 10th Feb 2020
 * Test Class :: AccountsClaimedBatchTest
 */
public with sharing class AccountsClaimedBatch implements Database.Batchable<sObject>, Database.Stateful {
  private Settings__mdt outboundSettings { get; set; }
  fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new List<SObjectType>{ Status__c.SObjectType }
  );
  public AccountsClaimedBatch() {
    outboundSettings = [
      SELECT Claim_Period__c
      FROM Settings__mdt
      ORDER BY ID DESC
      LIMIT 1
    ];
  }

  /**
   * @description Prepares the query to retrieve Accounts for claimed but not activated
   */
  public Database.QueryLocator start(Database.BatchableContext context) {
    if (outboundSettings.Claim_Period__c == null) {
      outboundSettings.Claim_Period__c = 100000; // almost no possible data for this steps
    }
    Date deleteAfter = Date.today()
      .addDays(-1 * Integer.valueOf(outboundSettings.Claim_Period__c));
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          Status__c.sobjectType,
          new List<Schema.SObjectField>{
            Status__c.Account__c,
            Status__c.Activated_Date__c,
            Status__c.Prospecting_Status__c,
            Status__c.CreatedDate
          }
        )
    ) {
      String claimed = C.OUTBOUND_PROSPECTING_STATUS_CLAIMED;
      String query = 'SELECT Id, Account__c FROM Status__c WHERE CreatedDate <: deleteAfter AND Prospecting_Status__c =:claimed';
      return Database.getQueryLocator(query);
    }
    return null;
  }

  /**
   * @description delete status and update account status to 'Available'.
   */
  public void execute(Database.BatchableContext context, List<sObject> scope) {
    try {
      for (Status__c status : (List<Status__c>) scope) {
        status.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_CLAIM_EXPIRED;
        status.Claim_Expired__c = Date.today();
        this.uow.registerDirty(status);
      }

      this.uow.commitWork();
    } catch (Exception e) {
      throw e;
      // do something (not sure how to implement Brett's error handling)
    }
  }

  public void finish(Database.BatchableContext context) {
    //Do nothing
  }

  /**
   * @description Helper method to run the job
   */
  public static void runBatch() {
    Database.executeBatch(new AccountsClaimedBatch(), 1000);
  }
}