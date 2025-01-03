/**
 * @description Test class for DeactivateAccountBtnController class
 */

 /**
 * TODO: rewrite test without custom account fields
 */
@IsTest
private with sharing class DeactivateAccountBtnControllerTest {
  // @TestSetup
  // private static void setupData() {
  //   TestFactory.generateMasterData();
  //   List<Account> testAccounts = [
  //     SELECT Activated_By__r.FirstName, Activated_By__r.LastName
  //     FROM Account
  //   ];
  //   TestFactory.activateAccount(testAccounts[0].Id);
  // }

  // @IsTest
  // private static void testAccountDeactivation() {
  //   List<Status__c> statuses = [
  //     SELECT
  //       Account__c,
  //       OwnerId,
  //       Deactivated_By__r.FirstName,
  //       Deactivated_By__r.LastName,
  //       Deactivated_Date__c
  //     FROM Status__c
  //   ];
  //   ApexPages.StandardController stdController = new ApexPages.StandardController(
  //     statuses[0]
  //   );
  //   DeactivateAccountBtnController deactivationController = new DeactivateAccountBtnController(
  //     stdController
  //   );
  //   deactivationController.init();
  //   statuses = [
  //     SELECT
  //       Deactivated_Date__c,
  //       Deactivated_By__r.FirstName,
  //       Deactivated_By__r.LastName
  //     FROM Status__c
  //     WHERE Account__c = :statuses[0].Account__c
  //   ];
  //   System.assertEquals(Date.today(), statuses[0].Deactivated_Date__c);
  //   stdController = new ApexPages.StandardController(statuses[0]);
  //   deactivationController = new DeactivateAccountBtnController(stdController);
  //   deactivationController.init();
  //   System.assertEquals(
  //     String.format(
  //       Label.Account_Already_Deactivated,
  //       new List<String>{ UserInfo.getName() }
  //     ),
  //     deactivationController.errorMessage
  //   );
  //   deactivationController.goBack();
  //   DeactivateAccountBtnController.isCurrentUserSysAdmin();
  // }
}