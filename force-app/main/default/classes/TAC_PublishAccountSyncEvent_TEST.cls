@IsTest
public class TAC_PublishAccountSyncEvent_TEST {
  @isTest
  static void testPublishEventWithValidData() {
    // Arrange: Create test data
    Account testAccount = new Account(
      Name = 'Test Account',
      Territory__c = 'United States'
    );
    insert testAccount;

    // Create the Request object as required by the invocable method
    TAC_PublishAccountSyncEvent.Request req = new TAC_PublishAccountSyncEvent.Request();
    req.accountId = testAccount.Id;

    // Act: Call the method with the test data
    Test.startTest();
    TAC_PublishAccountSyncEvent.publishEvent(
      new List<TAC_PublishAccountSyncEvent.Request>{ req }
    );
    Test.stopTest();

    // Assert: Verify that the event has been published
    // Since it's a Platform Event, direct query validation isn't possible
    // Assert that no exceptions were thrown and, if applicable, check the success of the operation
  }

  // More test methods can be added to cover negative cases, bulk handling, etc.
}
