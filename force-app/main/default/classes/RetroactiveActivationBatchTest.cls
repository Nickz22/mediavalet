@isTest
public class RetroactiveActivationBatchTest {
  // @isTest
  // static void given() {
  //   oneInactiveAccount();
  //   inactiveContacts();
  //   enoughTasksToActivate();
  //   oneOpenOpportunityCreatedSixtyDaysAgo();
  // }

  // static void oneInactiveAccount() {
  //   System.assertEquals(
  //     1,
  //     [
  //       SELECT COUNT()
  //       FROM Account
  //       WHERE Id NOT IN (SELECT Account__c FROM Status__c)
  //     ]
  //   );
  // }

  // static void inactiveContacts() {
  //   System.assertEquals(
  //     C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [
  //       SELECT COUNT()
  //       FROM Contact
  //       WHERE Id NOT IN (SELECT Contact__c FROM Outbound_Contact_Activation__c)
  //     ]
  //   );
  // }

  // static void enoughTasksToActivate() {
  //   System.assertEquals(
  //     C.ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //     C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [SELECT COUNT() FROM Task]
  //   );
  // }

  // static void oneOpenOpportunityCreatedSixtyDaysAgo() {
  //   System.assertEquals(
  //     1,
  //     [
  //       SELECT COUNT()
  //       FROM Opportunity
  //       WHERE IsClosed = FALSE AND CreatedDate = N_DAYS_AGO:60
  //     ]
  //   );
  // }

  // @isTest
  // static void whenRetroactiveBatchExecutes_andOpenOpportunityExists_andTheOppWasCreatedOutsideWaitingPeriod_thenAccountIsNotActivatable() {
  //   OpportunityHistorySelector2.returnMockDataForRetroactiveActivation = true;
  //   OpportunityHistorySelector2.mockCreatedDate = System.now().addDays(-60);
  //   System.runAs(TestFactory.ioAdmin) {
  //     // number in constructor doesn't matter
  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(10);
  //     batch.getEligibleTaskIdsByAccountId(
  //       [SELECT Id, WhoId, CreatedDate, Subject FROM Task]
  //     );
  //     // System.assert(batch.eligibleTaskIdsByAccountId.isEmpty());
  //   }
  // }

  // @TestSetup
  // static void makeData() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.disableActivationViaOpportunityCreationAutomatically = true;
  //   System.runAs(TestFactory.ioAdmin) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );
  //     uow = TestFactory.initActivatedContactData(
  //       CustomMetadataCache.setting.Outbound_Email_Advance__c,
  //       uow
  //     );
  //     uow.commitWork();
  //     uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{ Opportunity.SObjectType }
  //     );
  //     // create opportunity
  //     Opportunity opportunity = new Opportunity();
  //     opportunity.Name = 'Test Opportunity';
  //     opportunity.Amount = 1000;
  //     opportunity.CloseDate = Date.today();
  //     opportunity.StageName = TestFactory.openOpportunityStages[0];
  //     opportunity.AccountId = [SELECT Id FROM Account LIMIT 1].Id;

  //     uow.registerNew(opportunity);
  //     uow.commitWork();

  //     Test.setCreatedDate(opportunity.Id, System.now().addDays(-60));
  //   }
  // }
}