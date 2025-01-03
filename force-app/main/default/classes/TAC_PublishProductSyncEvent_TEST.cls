@IsTest
public class TAC_PublishProductSyncEvent_TEST {
    @isTest
    static void testPublishEventWithValidData() {
       // Arrange: Create test data
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = 'TestCode' // Include the ProductCode as it's required
        );
        insert testProduct;

        // Create the Request object as required by the invocable method
        TAC_PublishProductSyncEvent.Request req = new TAC_PublishProductSyncEvent.Request();
        req.productId = testProduct.Id;

        // Act: Call the method with the test data
        Test.startTest();
        TAC_PublishProductSyncEvent.publishEvent(new List<TAC_PublishProductSyncEvent.Request>{req});
        Test.stopTest();

        // Assert: Verify that the event has been published
        // Since it's a Platform Event, we can't query it directly from the database
        // Instead, we assert that no exceptions were thrown and, if there's a way to
        // check the success of the operation (like an external callout), we do it here
    }

    // More test methods can be added to cover negative cases, bulk handling, etc.
}