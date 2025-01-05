@isTest(SeeAllData=true)
public class RHX_TEST_Asset {
  static testMethod void RHX_Testmethod() {
    // Query the specific Product2 record
    Product2 testProduct = [
      SELECT Id
      FROM Product2
      WHERE Id = '01tJR0000005S5JYAU'
      LIMIT 1
    ];

    // Create an Account record
    Account testAccount = new Account(
      Name = 'Test Account',
      Territory__c = 'United States'
    );
    insert testAccount;

    // Optionally, create a Contact record associated with the Account
    Contact testContact = new Contact(
      LastName = 'Test Contact',
      AccountId = testAccount.Id
    );
    insert testContact;

    // Create an Asset record linked to the queried Product2, Account, and Contact
    Asset testAsset = new Asset(
      Name = 'Test Asset',
      AccountId = testAccount.Id,
      ContactId = testContact.Id,
      Product2Id = testProduct.Id
      // Include any other fields required for Asset
    );

    // Prepare the list of sObjects for the upsert operation
    List<sObject> sourceList = new List<sObject>{ testAsset };

    // Perform the upsert operation using rh2.ParentUtil.UpsertRollupTestRecords
    Test.startTest();
    rh2.ParentUtil.UpsertRollupTestRecords(sourceList);
    Test.stopTest();
  }
}
