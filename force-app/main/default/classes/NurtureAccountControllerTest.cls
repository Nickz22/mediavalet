/**
 * TODO: rewrite test without custom account fields
 */
@IsTest
public class NurtureAccountControllerTest {
  // @TestSetup
  // private static void setupData() {
  //   TestFactory.generateMasterData();
  //   List<Account> testAccounts = [
  //     SELECT Activated_By__r.FirstName, Activated_By__r.LastName
  //     FROM Account
  //   ];
  //   TestFactory.activateAccount(testAccounts[0].Id);
  // }

  // private static List<Account> getTestAccounts() {
  //   List<Account> testAccounts = [
  //     SELECT Id, Follow_up_Date__c, Status__c
  //     FROM Account
  //   ];
  //   return testAccounts;
  // }

  // @IsTest
  // public static void nurtureTest() {
  //   /**
  //    * Prepare data
  //    */
  //   List<Account> testAccounts = NurtureAccountControllerTest.getTestAccounts();
  //   Account accountUnderTest = testAccounts[0];

  //   Status__c previousStatus = NurtureAccountController.getActiveStatus(
  //     accountUnderTest.Id
  //   );

  //   Date expectedDate = Date.today().addDays(1);
  //   String expectedNote = 'Test note';

  //   /**
  //    * Logic under test
  //    */
  //   NurtureAccountController.nurture(
  //     previousStatus,
  //     expectedDate,
  //     expectedNote
  //   );

  //   /**
  //    * Assertions
  //    */
  //   testAccounts = NurtureAccountControllerTest.getTestAccounts();
  //   accountUnderTest = testAccounts[0];

  //   Status__c statusUnderTest = NurtureAccountController.getActiveStatus(
  //     accountUnderTest.Id
  //   );

  //   assertAccountNurture(
  //     previousStatus,
  //     statusUnderTest,
  //     accountUnderTest,
  //     expectedDate,
  //     expectedNote
  //   );
  // }

  // public static void assertAccountNurture(
  //   Status__c newStatus,
  //   Status__c previousStatus,
  //   Account acc,
  //   Date expectedDate,
  //   String expectedNote
  // ) {
  //   System.assertEquals(
  //     previousStatus.Id,
  //     newStatus.Id,
  //     'Excessive Outbound Status created by the deactivator batch'
  //   );

  //   System.assertEquals(
  //     C.OUTBOUND_PROSPECTING_STATUS_NURTURE,
  //     newStatus.Prospecting_Status__c,
  //     'The prospecting status of the outbound status has not been changed to Nurture'
  //   );

  //   System.assertEquals(
  //     expectedDate,
  //     newStatus.Follow_up_Date__c,
  //     'The follow up date of the outbound status has not been set'
  //   );

  //   System.assertEquals(
  //     expectedNote,
  //     newStatus.Nurture_Notes__c,
  //     'The nurture notes of the outbound status has not been changed to Nurture'
  //   );
  // }
}