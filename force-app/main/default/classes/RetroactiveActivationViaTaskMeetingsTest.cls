/**
 * TODO: revisit tests once retro batch becomes a priority again
 */
@isTest
public with sharing class RetroactiveActivationViaTaskMeetingsTest {
  // @isTest
  // static void given() {
  //   oneInactivatedAccount();
  //   oneOpportunity();
  //   oneInactivatedContact();
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

  // static void oneOpportunity() {
  //   System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);
  // }

  // /**
  //  * fix the date rollups
  //  */
  // @isTest
  // static void whenRetroActivationRuns_thenDialTasksShouldActivateAccount() {
  //   CustomMetadataCache.withTaskMeetingObject = true;
  //   CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;

  //   System.runAs(TestFactory.ioAdmin) {
  //     Test.startTest();
  //     Database.executeBatch(new RetroactiveActivationBatch(20));
  //     //   uncomment in test scenarios where you need easier debugging
  //     // Account acc = [SELECT Id FROM Account LIMIT 1];
  //     // List<Task> tasks = [SELECT Id FROM Task ORDER BY CreatedDate ASC];
  //     // fflib_SObjectUnitOfWork uow = new ActivateRetroactivelyBatch(
  //     //     new Map<Id, Set<Id>>{ acc.Id => Pluck.ids(tasks) }
  //     //   )
  //     //   .activateEligibleAccountsAndContacts(
  //     //     new List<Account>{ acc },
  //     //     new fflib_SObjectUnitOfWork(
  //     //       new List<SObjectType>{
  //     //         Status__c.SObjectType,
  //     //         Outbound_Contact_Activation__c.SObjectType
  //     //       }
  //     //     )
  //     //   );
  //     // uow.commitWork();
  //     Test.stopTest();
  //   }

  //   List<Status__c> oss = [
  //     SELECT
  //       First_Meeting_Date__c,
  //       Last_Meeting_Date__c,
  //       Total_Meetings__c,
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

  //   // giving a day of cushion in our assertions because very often datetimes
  //   // are parsed into dates that are 1 day before the datetime
  //   // System.assert(
  //   //   Math.abs(Date.today().daysBetween(os.Last_Meeting_Date__c)) <= 3
  //   // );
  //   // System.assert(
  //   //   Math.abs(Date.today().daysBetween(os.First_Meeting_Date__c)) <= 6
  //   // );
  // }

  // @TestSetup
  // static void makeData() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.disableActivationViaOpportunityCreationAutomatically = true;
  //   CustomMetadataCache.withTaskMeetingObject = true;

  //   System.runAs(TestFactory.ioAgent) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Opportunity.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );

  //     Account acc = new Account(Name = 'Test');
  //     uow.registerNew(acc);
  //     List<Contact> testContacts = new List<Contact>();
  //     for (Integer i = 0; i < C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
  //       Contact testContact1 = new Contact(LastName = 'Test1');
  //       uow.registerRelationship(testContact1, Contact.AccountId, acc);
  //       uow.registerNew(testContact1);
  //       testContacts.add(testContact1);
  //     }

  //     List<Task> taskMeetings = new List<Task>();
  //     List<Task> outboundCalls = new List<Task>();
  //     for (Contact c : testContacts) {
  //       Task meeting = TestFactory.createEligibleActivityForFilter(
  //         CustomMetadataCache.setting.Outbound_Meeting_Advance__c
  //       );
  //       meeting.WhoId = c.Id;
  //       uow.registerRelationship(meeting, Task.WhoId, c);
  //       taskMeetings.add(meeting);

  //       Task call = TestFactory.createEligibleActivityForFilter(
  //         CustomMetadataCache.setting.Call_Advance__c
  //       );
  //       call.WhoId = c.Id;
  //       uow.registerRelationship(call, Task.WhoId, c);
  //       outboundCalls.add(call);
  //     }
  //     uow.registerNew(taskMeetings);
  //     uow.registerNew(outboundCalls);
  //     // create opportunity, set created date to 2 days in the future
  //     Opportunity opp = new Opportunity(
  //       Name = 'Test Opp',
  //       CloseDate = Date.today(),
  //       StageName = 'Prospecting',
  //       Amount = 1000
  //     );
  //     uow.registerRelationship(opp, Opportunity.AccountId, acc);
  //     uow.registerNew(opp);
  //     uow.commitWork();
  //     Test.setCreatedDate(opp.Id, Date.today());
  //     for (Integer i = 0; i < taskMeetings.size(); i++) {
  //       // if divisible by 1, set 5 days ago
  //       // if divisible by 2, set 10 days ago
  //       if (Math.mod(i, 2) == 0) {
  //         Test.setCreatedDate(taskMeetings[i].Id, Date.today().addDays(-5));
  //       } else if (Math.mod(i, 1) == 0) {
  //         Test.setCreatedDate(taskMeetings[i].Id, Date.today().addDays(-2));
  //       }
  //     }
  //   }
  // }
}