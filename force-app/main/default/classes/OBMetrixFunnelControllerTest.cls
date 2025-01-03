/*
 * Test class for below classes
 * 1. OBMetrixFunnelController
 * 2. OBMetrixFunnelMetrixHelper
 * Added On : 10th Feb 2020
 */
@IsTest
public class OBMetrixFunnelControllerTest {
  // @TestSetup
  // private static void setupData() {
  //   TestFactory.generateMasterData();
  //   List<Account> testAccounts = [
  //     SELECT Activated_By__r.FirstName, Activated_By__r.LastName
  //     FROM Account
  //   ];
  //   TestFactory.activateAccount(testAccounts[0].Id);
  //   Contact contact = [SELECT AccountId FROM Contact LIMIT 1];
  //   insert TestFactory.createTask(contact.Id, true, false, false, false);
  //   insert TestFactory.createOpportunity(contact.AccountId, false);
  //   insert TestFactory.createTestEvent(contact.Id);
  // }
  // @IsTest
  // public static void runTest() {
  //   OBMetrixFunnelController.UserConfig ucm = new OBMetrixFunnelController.UserConfig();
  //   ucm.rows = new List<OBMetrixFunnelController.UserConfigRow>();
  //   OBMetrixFunnelController.UserConfigRow uc = new OBMetrixFunnelController.UserConfigRow();
  //   uc.header = 'Outbound Funnel Metrics';
  //   uc.metrics = new List<OBMetrixFunnelController.UserConfigBox>();
  //   uc.metrics.add(
  //     new OBMetrixFunnelController.UserConfigBox(
  //       'NEW_ACCOUNT_ACTIVATIONS',
  //       true
  //     )
  //   );
  //   uc.metrics.add(
  //     new OBMetrixFunnelController.UserConfigBox('NEW_CONTACT_ACTIVATED')
  //   );
  //   uc.metrics.add(
  //     new OBMetrixFunnelController.UserConfigBox('OPPORTUNITY_CREATED')
  //   );
  //   uc.metrics.add(
  //     new OBMetrixFunnelController.UserConfigBox('MEETINGS_SET', true)
  //   );
  //   String userMetrixConfig = JSON.serialize(uc);
  //   Test.startTest();
  //   OBMetrixFunnelController.saveUserSettings(userMetrixConfig);
  //   Object data = (Object) OBMetrixFunnelController.getOBFunnelData(
  //     UserInfo.getUserId()
  //   );
  //   System.assert(data != null);
  //   // todo: GitLab#2: temporarily ignore the following line to accommodate SFDX push
  //   // todo: Gitlab#2: most of the following method have now changed their signatures
  //   // data = OBMetrixFunnelController.getFunnelMetrix('This Month', UserInfo.getUserId());
  //   // todo: GitLab#2: temporarily ignore the following line to accommodate SFDX push
  //   // OBMetrixFunnelController.getMetricChart('MEETINGS_SET', 'Last Month', UserInfo.getUserId());
  //   Test.stopTest();
  // }
  // @IsTest
  // public static void runTestWithoutSave() {
  //   // todo: GitLab#2: temporarily ignore the following line to accommodate SFDX push
  //   // todo: Gitlab#2: most of the following method have now changed their signatures
  //   // OBMetrixFunnelController.saveUserSettings('');
  //   // Object data = OBMetrixFunnelController.getOBFunnelData(null);
  //   // System.assert(data != null);
  //   // data = OBMetrixFunnelController.getFunnelMetrix('This Week', null);
  //   // data = OBMetrixFunnelController.getFunnelMetrix('This Quarter', null);
  //   // data = OBMetrixFunnelController.getFunnelMetrix('Last Month', null);
  //   // data = OBMetrixFunnelController.getFunnelMetrix('Last Quarter', null);
  //   // data = OBMetrixFunnelController.getFunnelMetrix('Last Week', null);
  //   // Test.startTest();
  //   // OBMetrixFunnelController.getMetricChart('NEW_ACCOUNT_ACTIVATIONS', 'This Week', null);
  //   // OBMetrixFunnelController.getMetricChart('NEW_ACCOUNT_ACTIVATIONS', 'This Quarter', null);
  //   // OBMetrixFunnelController.getMetricChart('NEW_ACCOUNT_ACTIVATIONS', 'This Month', null);
  //   // OBMetrixFunnelController.getMetricChart('NEW_ACCOUNT_ACTIVATIONS', 'Last Week', null);
  //   // OBMetrixFunnelController.getMetricChart('NEW_ACCOUNT_ACTIVATIONS', 'Last Quarter', null);
  //   // Test.stopTest();
  // }
}