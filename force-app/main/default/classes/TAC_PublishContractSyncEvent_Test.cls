@IsTest
private class TAC_PublishContractSyncEvent_Test {
  @IsTest
  static void testPublishEvent() {
    // Create a test Account
    Account testAccount = new Account(
      Name = 'Test Account',
      Territory__c = 'United States'
    );
    insert testAccount;

    // Create a test Contract associated with the Account
    Contract testContract = new Contract(
      Name = 'Test Contract',
      AccountId = testAccount.Id
    );
    insert testContract;

    // Prepare the request
    TAC_PublishContractSyncEvent.Request req = new TAC_PublishContractSyncEvent.Request();
    req.contractId = testContract.Id;

    Exception ex;
    // Call the method
    Test.startTest();
    try {
      TAC_PublishContractSyncEvent.publishEvent(
        new List<TAC_PublishContractSyncEvent.Request>{ req }
      );
    } catch (Exception e) {
      ex = e;
    }
    Test.stopTest();

    // Assert that no exceptions were thrown
    System.assert(ex == null, 'An exception occurred: ' + ex);
  }
}
