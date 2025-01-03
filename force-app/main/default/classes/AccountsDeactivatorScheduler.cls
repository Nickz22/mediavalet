/**
 * @description Scheduled job that runs AccountsDeactivatorBatch for account deactivate, nurture account and claimed account checking
 */
global with sharing class AccountsDeactivatorScheduler implements Schedulable {
  global void execute(SchedulableContext context) {
    AccountsDeactivatorBatch.runBatch();
    AccountsClaimedBatch.runBatch();
  }
}