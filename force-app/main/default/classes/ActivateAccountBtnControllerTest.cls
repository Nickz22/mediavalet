/**
 * @description Test class for ActivateAccountBtnController class
 */

 /**
 * TODO: rewrite test without custom account fields
 */
@IsTest
private with sharing class ActivateAccountBtnControllerTest {
  @TestSetup
  private static void setupData() {
    TestFactory.generateMasterData();
  }

  // @IsTest
  // private static void activateAccountTest() {
  //   System.runAs(TestFactory.ioAgent) {
  //     List<Account> testAccounts = [
  //       SELECT Activated_By__r.FirstName, Activated_By__r.LastName
  //       FROM Account
  //     ];
  //     ApexPages.StandardController stdController = new ApexPages.StandardController(
  //       testAccounts[0]
  //     );
  //     ActivateAccountBtnController activationController = new ActivateAccountBtnController(
  //       stdController
  //     );

  //     Test.startTest();
  //     activationController.init();
  //     Test.stopTest();

  //     activationController.goBack();
  //     List<Status__c> statuses = [
  //       SELECT
  //         Account__c,
  //         OwnerId,
  //         Deactivated_By__r.FirstName,
  //         Deactivated_By__r.LastName,
  //         Deactivated_Date__c
  //       FROM Status__c
  //       WHERE Account__c = :testAccounts[0].Id
  //     ];
  //     System.assertEquals(statuses.size(), 1);
  //     activationController.init();
  //     System.assertEquals(
  //       String.format(
  //         Label.Account_Already_Activated,
  //         new List<String>{ UserInfo.getName() }
  //       ),
  //       activationController.errorMessage
  //     );

  //     ApexPages.StandardController stdController1 = new ApexPages.StandardController(
  //       statuses[0]
  //     );
  //     DeactivateAccountBtnController deactivationController = new DeactivateAccountBtnController(
  //       stdController1
  //     );
  //     deactivationController.init();
  //     statuses = [
  //       SELECT
  //         Deactivated_Date__c,
  //         Deactivated_By__r.FirstName,
  //         Deactivated_By__r.LastName
  //       FROM Status__c
  //       WHERE Account__c = :statuses[0].Account__c
  //     ];
  //     System.assertEquals(Date.today(), statuses[0].Deactivated_Date__c);
  //     activationController.init();
  //   }
  // }
}