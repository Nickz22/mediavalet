/**
 * need to reinstate this job so that it works for Status__c and OCA
 */
public with sharing class RetroactiveAnalysisRollbackBatch /*implements Database.Batchable<sObject>, Database.Stateful */ {
  public RetroactiveAnalysisRollbackBatch() {
  }
  /*
  public Database.QueryLocator start(Database.BatchableContext context) {
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          Task.sObjectType,
          new List<String>{
            'Id',
            'AccountId',
            'WhoId',
            'WhatId',
            'ActivityDate'
          }
        )
    ) {
      return Database.getQueryLocator(
        RetroactiveAnalysisEngine.rollbackDatasetQuery()
      );
    }
    return null;
  }

  public void execute(
    Database.BatchableContext context,
    List<sObject> accounts
  ) {
    RetroactiveAnalysisEngine.rollback((List<Account>) accounts);
  }

  public void finish(Database.BatchableContext context) {
    //Do nothing
  }
*/
  /**
   * @description Helper method to run the job

  public static void runBatch() {
    Database.executeBatch(new RetroactiveAnalysisRollbackBatch(), 1000);
  }
  */
}