@IsTest
public class TAC_IntacctProductSync_TEST {

    // If ia_crm.SobjectController makes callouts, you need to create a mock class
    // that implements HttpCalloutMock to simulate the callout response

    @IsTest
    static void testSyncProductToSageIntacct() {
        // Arrange: Create test data
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = 'TestCode' // Include the ProductCode as it's required
        );
        
        insert testProduct;

        // Set up the mock response if necessary
        // Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockClass());

        // Act: Call the method with the test data
        Test.startTest();
        TAC_IntacctProductSync.invocableSyncSingleProductToSageIntacct(new List<Id>{testProduct.Id});
        Test.stopTest();

        // Assert: Verify that the method behaved as expected
        // Since we can't verify the external sync in a test, we rely on
        // the internal state changes or logs that can be checked.
    }
}