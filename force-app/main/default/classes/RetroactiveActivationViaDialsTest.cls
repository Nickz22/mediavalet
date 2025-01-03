@isTest
public with sharing class RetroactiveActivationViaDialsTest {
  // @isTest
  // static void given() {
  //   oneInactivatedAccount();
  //   oneOpportunity();
  //   oneInactivatedContact();
  //   enoughDialTasksToActivate();
  // }

  // static void oneInactivatedAccount() {
  //   System.assertEquals(0, [SELECT COUNT() FROM Status__c]);
  //   System.assertEquals(
  //     1,
  //     [
  //       SELECT COUNT()
  //       FROM Account
  //       WHERE Id NOT IN (SELECT Account__c FROM Status__c)
  //     ]
  //   );
  // }

  // static void oneInactivatedContact() {
  //   System.assertEquals(
  //     C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [
  //       SELECT COUNT()
  //       FROM Contact
  //       WHERE Id NOT IN (SELECT Contact__c FROM Outbound_Contact_Activation__c)
  //     ]
  //   );
  // }

  // static void enoughDialTasksToActivate() {
  //   System.assertEquals(
  //     (C.ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //     C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD) +
  //     C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //     [SELECT COUNT() FROM Task]
  //   );
  // }

  // static void oneOpportunity() {
  //   System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);
  // }

  // @isTest
  // static void whenRetroActivationRuns_thenDialTasksShouldActivateAccount() {
  //   CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
  //   System.runAs(TestFactory.ioAdmin) {
  //     Test.startTest();
  //     Database.executeBatch(new RetroactiveActivationBatch(20));
  //     Test.stopTest();
  //   }

  //   List<Status__c> oss = [
  //     SELECT
  //       Total_Outbound_Calls__c,
  //       Total_Call_Connects__c,
  //       Prospecting_Status__c,
  //       Opportunity__c,
  //       Opportunity_Amount__c
  //     FROM Status__c
  //   ];
  //   // System.assertEquals(1, oss.size());

  //   Status__c os = oss[0];

  //   // System.assertEquals(
  //   //   C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
  //   //   os.Prospecting_Status__c
  //   // );

  //   // System.assertEquals(
  //   //   C.ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //   //   C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //   //   os.Total_Outbound_Calls__c
  //   // );

  //   // System.assertEquals(
  //   //   C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //   //   os.Total_Call_Connects__c
  //   // );

  //   List<Outbound_Contact_Activation__c> ocas = [
  //     SELECT Contact__c, Dials__c, Call_Connects__c
  //     FROM Outbound_Contact_Activation__c
  //   ];
  //   // System.assertEquals(
  //   //   C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //   //   ocas.size()
  //   // );
  //   for (Outbound_Contact_Activation__c oca : ocas) {
  //     System.assertEquals(C.ACTIVITIES_FOR_CONTACT_ACTIVATION, oca.Dials__c);
  //     System.assertEquals(1, oca.Call_Connects__c);
  //   }
  // }

  // @TestSetup
  // static void makeData() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.disableActivationViaOpportunityCreationAutomatically = true;
  //   System.runAs(TestFactory.ioAgent) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );
  //     uow = TestFactory.initActivatedContactData(
  //       CustomMetadataCache.setting.Call_Advance__c,
  //       uow
  //     );

  //     Test.startTest();
  //     uow.commitWork();
  //     Test.stopTest();

  //     List<Task> callConnectTasks = new List<Task>();
  //     for (Contact c : [SELECT Id FROM Contact]) {
  //       Task t = TestFactory.createEligibleActivityForFilter(
  //         CustomMetadataCache.setting.Engaged_Call_Advance__c
  //       );
  //       t.WhoId = c.Id;
  //       callConnectTasks.add(t);
  //     }
  //     insert callConnectTasks;

  //     // create opportunity, set created date to 2 days in the future
  //     Account acc = [SELECT Id FROM Account];
  //     Opportunity opp = new Opportunity(
  //       AccountId = acc.Id,
  //       Name = 'Test Opp',
  //       CloseDate = Date.today().addDays(2),
  //       StageName = 'Prospecting',
  //       Amount = 1000
  //     );
  //     insert opp;
  //     Test.setCreatedDate(opp.Id, Date.today().addDays(2));
  //   }
  // }
}