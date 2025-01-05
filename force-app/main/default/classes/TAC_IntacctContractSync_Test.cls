@IsTest
private class TAC_IntacctContractSync_Test {
  // Mock class to simulate the callout response
  private class MockHttpResponseGenerator implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      // Create a fake response
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"success":true}'); // Adjust this based on expected response format
      res.setStatusCode(200);
      return res;
    }
  }

  @IsTest
  static void testInvocableSyncSingleContractToSageIntacct() {
    // Set the mock callout class
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

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

    // Call the invocable method
    Test.startTest();
    TAC_IntacctContractSync.invocableSyncSingleContractToSageIntacct(
      new List<Id>{ testContract.Id }
    );
    Test.stopTest();

    // Add assertions as necessary, for example:
    // Check if any Platform Events were published, or if any other side effects occurred.
  }
}
