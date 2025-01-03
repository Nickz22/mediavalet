@isTest
public class RetroactiveActivationTest {
  // private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  // private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;

  // @isTest
  // static void testRetroactiveActivation() {
  //   OpportunityHistorySelector2.returnMockDataForRetroactiveActivation = true;
  //   OpportunityHistorySelector2.mockStages = new List<String>{ 'Prospecting' };
  //   OpportunityHistorySelector2.mockCreatedDate = System.now().addDays(-10);
  //   System.runAs(TestFactory.ioAdmin) {
  //     // set old task to createddate 8 days ago
  //     Datetime eightDaysAgo = System.now().addDays(-8);
  //     List<Task> oldTasks = [SELECT Id FROM Task WHERE Subject = 'Old Task'];
  //     for (Task t : oldTasks) {
  //       Test.setCreatedDate(t.Id, eightDaysAgo);
  //     }

  //     List<Task> thirdTasks = [SELECT Id FROM Task WHERE Subject LIKE '%2'];
  //     Datetime fourDaysAgo = System.now().addDays(-4);
  //     for (Task t : thirdTasks) {
  //       Test.setCreatedDate(t.Id, fourDaysAgo);
  //     }

  //     List<Opportunity> opp = [
  //       SELECT Id, AccountId
  //       FROM Opportunity
  //       WHERE Name = 'Single Prospecting Activity Account Opp'
  //     ];
  //     for (Opportunity o : opp) {
  //       Test.setCreatedDate(o.Id, System.now().addDays(-10));
  //     }

  //     System.assertEquals(
  //       1,
  //       new OpportunityHistorySelector2()
  //         .selectByOpportunityIds(new Set<Id>{ opp[0].Id })
  //         .size()
  //     );

  //     System.assertEquals(
  //       0,
  //       [
  //         SELECT COUNT()
  //         FROM Status__c
  //         WHERE Account__r.Name = 'Single Prospecting Activity Account'
  //       ]
  //     );

  //     // RetroactiveActivationBatch batch = new RetroactiveActivationBatch(5);
  //     Test.startTest();
  //     // Database.executeBatch(batch);
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

  //     System.assertEquals(
  //       0,
  //       [
  //         SELECT COUNT()
  //         FROM Status__c
  //         WHERE Account__r.Name = 'Single Prospecting Activity Account'
  //       ]
  //     );
  //     System.assertEquals(
  //       1,
  //       [
  //         SELECT COUNT()
  //         FROM Outbound_Contact_Activation__c
  //         WHERE Contact__r.LastName = 'Contact with single OCA'
  //       ]
  //     );
  //   }
  // }

  // @isTest
  // static void testRetroactiveActivation2() {
  //   OpportunityHistorySelector2.returnMockDataForRetroactiveActivation = true;
  //   OpportunityHistorySelector2.mockStages = new List<String>{ 'Prospecting' };
  //   OpportunityHistorySelector2.mockCreatedDate = System.now().addDays(-2);

  //   // set all Tasks to createddate 4 days ago
  //   Datetime fourDaysAgo = System.now().addDays(-4);
  //   for (Task t : [SELECT Id FROM Task]) {
  //     Test.setCreatedDate(t.Id, fourDaysAgo);
  //   }
  //   System.runAs(TestFactory.ioAdmin) {
  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(5);
  //     Test.startTest();
  //     Database.executeBatch(batch);
  //     Test.stopTest();

  //     System.assertEquals(
  //       1,
  //       [
  //         SELECT COUNT()
  //         FROM Status__c
  //         WHERE
  //           Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
  //       ]
  //     );
  //     System.assertEquals(
  //       1,
  //       [
  //         SELECT COUNT()
  //         FROM Status__C
  //         WHERE Prospecting_Status__c = 'Activated'
  //       ]
  //     );

  //     System.assertEquals(
  //       4,
  //       [
  //         SELECT COUNT()
  //         FROM Outbound_Contact_Activation__c
  //         WHERE Contact__r.Name LIKE 'Activated%'
  //       ]
  //     );

  //     System.assertEquals(
  //       1,
  //       [
  //         SELECT COUNT()
  //         FROM Outbound_Contact_Activation__c
  //         WHERE Contact__r.Name = 'Contact with Single Oca'
  //       ]
  //     );
  //   }
  // }

  // @isTest
  // static void testRetroactiveActivation3() {
  //   CustomMetadataCache.withEventMeetingObject = true;
  //   // set all Tasks to createddate 4 days ago
  //   Datetime fourDaysAgo = System.now().addDays(-4);
  //   for (Task t : [SELECT Id FROM Task]) {
  //     Test.setCreatedDate(t.Id, fourDaysAgo);
  //   }

  //   // set Events createddate 2 days ago
  //   Datetime twoDaysAgo = System.now().addDays(-2);
  //   for (Event e : [SELECT Id FROM Event]) {
  //     Test.setCreatedDate(e.Id, twoDaysAgo);
  //   }

  //   System.runAs(TestFactory.ioAdmin) {
  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(5);
  //     Test.startTest();
  //     Database.executeBatch(batch);
  //     Test.stopTest();

  //     System.debug(
  //       'Statuses\n\n' +
  //       JSON.serialize(
  //         [
  //           SELECT
  //             Name,
  //             Account__r.Name,
  //             Prospecting_Status__c,
  //             Opportunity_Amount__c,
  //             Opportunity_Created_Date__c
  //           FROM Status__c
  //         ]
  //       )
  //     );
  //     System.debug(
  //       'Outbound Contact Activations\n\n' +
  //       JSON.serialize(
  //         [
  //           SELECT Contact__r.Name, Name, Outbound_Status__r.Name
  //           FROM Outbound_Contact_Activation__c
  //         ]
  //       )
  //     );
  //   }
  // }

  // @TestSetup
  // static void makeData() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   System.runAs(TestFactory.ioAgent) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Opportunity.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType,
  //         Event.SObjectType
  //       }
  //     );
  //     // create Account and Contact
  //     Account acc = new Account(Name = 'Single Prospecting Activity Account');
  //     uow.registerNew(acc);

  //     Opportunity opp = new Opportunity(
  //       Name = 'Single Prospecting Activity Account Opp',
  //       Amount = 1000,
  //       CloseDate = date.today(),
  //       StageName = 'Prospecting'
  //     );
  //     uow.registerRelationship(opp, Opportunity.AccountId, acc);
  //     uow.registerNew(opp);

  //     Contact con = new Contact(
  //       LastName = 'Single Prospecting Activity Contact',
  //       AccountId = acc.Id
  //     );
  //     uow.registerRelationship(con, Contact.AccountId, acc);
  //     uow.registerNew(con);

  //     Task inboundEmailTask = TestFactory.createEligibleActivityForFilter(
  //       CustomMetadataCache.setting.Inbound_Email_Advance__c
  //     );
  //     uow.registerRelationship(inboundEmailTask, Task.WhoId, con);
  //     uow.registerNew(inboundEmailTask);

  //     // create Account/Contact/Tasks to create OCA
  //     Account ocaAccount = new Account(Name = 'Account with single OCA');
  //     uow.registerNew(ocaAccount);

  //     Contact ocaContact = new Contact(
  //       LastName = 'Contact with single OCA',
  //       AccountId = ocaAccount.Id
  //     );
  //     uow.registerRelationship(ocaContact, Contact.AccountId, ocaAccount);
  //     uow.registerNew(ocaContact);

  //     Event meetingEvent = TestFactory.createEligibleEventForFilter(
  //       CustomMetadataCache.setting.Outbound_Meeting_Advance__c
  //     );
  //     meetingEvent.Subject = 'Test Meeting Set';
  //     uow.registerRelationship(meetingEvent, Event.WhoId, ocaContact);
  //     uow.registerNew(meetingEvent);

  //     for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
  //       Task inboundEmailTask2 = TestFactory.createEligibleActivityForFilter(
  //         CustomMetadataCache.setting.Inbound_Email_Advance__c
  //       );
  //       uow.registerRelationship(inboundEmailTask2, Task.WhoId, ocaContact);
  //       uow.registerNew(inboundEmailTask2);
  //     }

  //     // create and activate Account
  //     Account activatedAccount = new Account(Name = 'Activated Account');

  //     uow.registerNew(activatedAccount);

  //     for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
  //       Contact activatedContact = new Contact(
  //         LastName = 'Activated Contact ' + i,
  //         AccountId = activatedAccount.Id
  //       );
  //       uow.registerRelationship(
  //         activatedContact,
  //         Contact.AccountId,
  //         activatedAccount
  //       );
  //       uow.registerNew(activatedContact);

  //       for (Integer j = 0; j < ACTIVITIES_FOR_CONTACT_ACTIVATION; j++) {
  //         Task outboundEmailTask = TestFactory.createEligibleActivityForFilter(
  //           CustomMetadataCache.setting.Outbound_Email_Advance__c
  //         );
  //         outboundEmailTask.Subject += ' ' + j;
  //         uow.registerRelationship(
  //           outboundEmailTask,
  //           Task.WhoId,
  //           activatedContact
  //         );
  //         uow.registerNew(outboundEmailTask);
  //       }

  //       Task oldTask = new Task(
  //         WhoId = activatedContact.Id,
  //         Subject = 'Old Task'
  //       );

  //       uow.registerRelationship(oldTask, Task.WhoId, activatedContact);
  //       uow.registerNew(oldTask);
  //     }

  //     Test.startTest();
  //     uow.commitWork();
  //     Test.stopTest();
  //   }

  // }
}