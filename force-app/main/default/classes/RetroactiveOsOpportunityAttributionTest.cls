@isTest
public class RetroactiveOsOpportunityAttributionTest {
  // private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  // private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;
  // private static final Integer TRACKING_PERIOD = Integer.valueOf(
  //   CustomMetadataCache.setting.Timeframe_Days_Contact1__c
  // );
  // @isTest
  // static void given() {
  //   System.assertEquals(
  //     ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //     CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [SELECT COUNT() FROM Task]
  //   );
  //   System.assertEquals(1, [SELECT COUNT() FROM Account]);
  //   System.assertEquals(
  //     CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [SELECT COUNT() FROM Contact]
  //   );
  //   System.assertEquals(0, [SELECT COUNT() FROM Status__c]);
  //   System.assertEquals(
  //     0,
  //     [SELECT COUNT() FROM Outbound_Contact_Activation__c]
  //   );
  // }

  // @isTest
  // static void whenOpportunityCreatedOutsideTrackingPeriod_thenNoOppAttributedToStatus() {
  //   // Creating an opportunity outside the tracking period
  //   System.runAs(TestFactory.ioAgent) {
  //     Account account = [SELECT Id FROM Account];
  //     // create opportunity
  //     Opportunity opp = new Opportunity(
  //       Name = 'do not attribute this opp',
  //       StageName = TestFactory.openOpportunityStages[0],
  //       Amount = 1000,
  //       CloseDate = Date.today(),
  //       AccountId = account.Id
  //     );
  //     insert opp;

  //     // Set opp created date outside the window of TRACKING_PERIOD
  //     Test.setCreatedDate(opp.Id, Date.today().addDays(TRACKING_PERIOD + 1));
  //   }

  //   System.runAs(TestFactory.ioAdmin) {
  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(2);
  //     Test.startTest();
  //     Database.executeBatch(batch);
  //     Test.stopTest();
  //   }

  //   // Check Status__c record to see if Opportunity is not set
  //   Status__c os = [SELECT Opportunity__c FROM Status__c LIMIT 1];
  //   // System.assertEquals(
  //   //   null,
  //   //   os.Opportunity__c,
  //   //   'Status should not have an Opportunity set for records created outside the tracking period'
  //   // );
  // }

  // @isTest
  // static void whenRetroactiveStatusCreated_andOpportunityCreatedWithinTrackingPeriodAfterLastProspectinActivity_thenOppAttributedToStatus() {
  //   CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
  //   System.runAs(TestFactory.ioAgent) {
  //     Account account = [SELECT Id FROM Account];
  //     // create opportunity
  //     Opportunity opp = new Opportunity(
  //       Name = 'attribute this opp',
  //       StageName = TestFactory.openOpportunityStages[0],
  //       Amount = 1000,
  //       CloseDate = Date.today(),
  //       AccountId = account.Id
  //     );
  //     insert opp;
  //     //   keep opp created date just inside window
  //     Test.setCreatedDate(opp.Id, Date.today().addDays((TRACKING_PERIOD - 1)));
  //   }

  //   System.runAs(TestFactory.ioAdmin) {
  //     // RetroactiveActivationBatch batch = new RetroactiveActivationBatch(2);
  //     Test.startTest();
  //     // Database.executeBatch(batch);
  //     // uncomment in test scenarios where you need easier debugging
  //     Account acc = [SELECT Id FROM Account LIMIT 1];
  //     List<Task> tasks = [SELECT Id FROM Task ORDER BY CreatedDate ASC];
  //     fflib_SObjectUnitOfWork uow = new ActivateRetroactivelyBatch(
  //         new Map<Id, Set<Id>>{ acc.Id => Pluck.ids(tasks) }
  //       )
  //       .activateEligibleAccountsAndContacts(
  //         new List<Account>{ acc },
  //         new fflib_SObjectUnitOfWork(
  //           new List<SObjectType>{
  //             Status__c.SObjectType,
  //             Outbound_Contact_Activation__c.SObjectType
  //           }
  //         )
  //       );
  //     uow.commitWork();
  //     Test.stopTest();
  //   }

  //   List<Status__c> os = [
  //     SELECT Opportunity__r.Name, Prospecting_Status__c, Total_Meetings__c
  //     FROM Status__c
  //   ];
  //   System.debug(JSON.serialize(os));
  //   // System.assertEquals('attribute this opp', os[0].Opportunity__r.Name);
  // }

  // @TestSetup
  // static void setup() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   System.runAs(TestFactory.ioAgent) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );
  //     uow = TestFactory.initActivatedContactData(
  //       CustomMetadataCache.setting.Inbound_Email_Advance__c,
  //       uow
  //     );

  //     // insert records without triggers enabled
  //     Test.startTest();
  //     uow.commitWork();
  //     Test.stopTest();
  //   }
  // }
}