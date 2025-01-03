/**
 * TODO: revisit tests once retro batch becomes a priority again
 */
@isTest
public class MultipleOsSingleAccountRetroactivelyTest {
  // private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  // private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;
  // private static final Integer TRACKING_PERIOD = Integer.valueOf(
  //   CustomMetadataCache.setting.Timeframe_Days_Contact1__c
  // );
  // private static final Integer WAIT_PERIOD = Integer.valueOf(
  //   CustomMetadataCache.setting.Wait_Period__c
  // );

  // private static Date latestActivationDate = Date.today()
  //   .addDays(-TRACKING_PERIOD + 1);
  // private static Date middleActivationDate = Date.today()
  //   .addDays((WAIT_PERIOD * 2) * -1);
  // private static Date oldestActivationDate = Date.today()
  //   .addDays((WAIT_PERIOD * 3) * -1);

  // @isTest
  // static void testActivationBatchResultsInThreeOsRecords() {
  //   // these are setting static state so need to be set for every relevant context
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.withEventMeetingObject = true;
  //   CustomMetadataCache.disableActivationViaMeetingSet = true;
  //   CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
  //   // Execute the batch
  //   System.runAs(TestFactory.ioAdmin) {
  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(
  //       WAIT_PERIOD * 5
  //     );
  //     Test.startTest();
  //     Database.executeBatch(batch);
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

  //   // Assert the presence of two distinct Status__c records related to the Account
  //   List<Status__c> statuses = [
  //     SELECT
  //       Total_Gifts__c,
  //       Last_Prospecting_Activity__c,
  //       Activated_Date__c,
  //       Total_Meetings__c,
  //       Prospecting_Status__c,
  //       First_Meeting_Date__c,
  //       Last_Meeting_Date__c,
  //       Opportunity__c,
  //       Opportunity_Amount__c,
  //       Opportunity_Created_Date__c
  //     FROM Status__c
  //     ORDER BY Last_Prospecting_Activity__c ASC
  //   ];
  //   System.assertEquals(2, statuses.size(), JSON.serialize(statuses));

  //   Status__c oldestOs = statuses[0];
  //   // System.assertEquals(
  //   //   ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //   //   CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //   //   oldestOs.Total_Gifts__c
  //   // );
  //   // System.assertEquals(2, oldestOs.Total_Meetings__c);

  //   // // sometimes the datetime to date conversion when mocking createddate is off by a day
  //   // System.assert(
  //   //   oldestActivationDate.addDays(1)
  //   //     .daysBetween(oldestOs.First_Meeting_Date__c) <= 1
  //   // );
  //   // System.assert(
  //   //   oldestActivationDate.addDays(2)
  //   //     .daysBetween(oldestOs.Last_Meeting_Date__c) <= 1
  //   // );
  //   // System.assertEquals(
  //   //   C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET,
  //   //   oldestOs.Prospecting_Status__c
  //   // );

  //   Status__c newestOs = statuses[1];
  //   // System.assertEquals(
  //   //   ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //   //   CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //   //   newestOs.Total_Gifts__c
  //   // );
  //   // System.assertEquals(
  //   //   C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
  //   //   newestOs.Prospecting_Status__c
  //   // );

  //   Opportunity opp = [
  //     SELECT CreatedDate
  //     FROM Opportunity
  //     WHERE Id = :newestOs.Opportunity__c
  //   ];
  //   // System.assertEquals(opp.CreatedDate.date(), newestOs.Activated_Date__c);

  //   // System.assertEquals(
  //   //   CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD * 2,
  //   //   [
  //   //     SELECT COUNT()
  //   //     FROM Outbound_Contact_Activation__c
  //   //     WHERE Outbound_Status__c IN :statuses
  //   //   ]
  //   // );
  // }

  // @isTest
  // static void testActivationBatchResultsInThreeOsRecordsWithMeetingSetDisabled() {
  //   // these are setting static state so need to be set for every relevant context
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.withEventMeetingObject = true;

  //   // Execute the batch
  //   System.runAs(TestFactory.ioAdmin) {
  //     // for each contact, delete all but 1 task
  //     Map<Id, List<Task>> tasksByContactId = Mapper.byId(
  //       [SELECT WhoId, CreatedDate FROM Task],
  //       C.ACTIVITY_WHO_ID_FIELD
  //     );
  //     List<Task> tasksToDelete = new List<Task>();
  //     for (Contact c : [SELECT id FROM contact]) {
  //       List<Task> tasks = tasksByContactId.get(c.Id);
  //       Map<Date, Task> tasksByCreatedDate = new Map<Date, Task>();
  //       for (Task t : tasks) {
  //         if (tasksByCreatedDate.containsKey(t.CreatedDate.date())) {
  //           tasksToDelete.add(t);
  //         } else {
  //           tasksByCreatedDate.put(t.CreatedDate.date(), t);
  //         }
  //       }
  //     }
  //     delete tasksToDelete;
  //     delete [SELECT id FROM event LIMIT 1];

  //     RetroactiveActivationBatch batch = new RetroactiveActivationBatch(
  //       WAIT_PERIOD * 5
  //     );
  //     Test.startTest();
  //     CustomMetadataCache.disableActivationViaMeetingSet = true;
  //     CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
  //     System.debug(CustomMetadataCache.setting);
  //     Database.executeBatch(batch);
  //     // uncomment in test scenarios where you need easier debugging
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

  //   // Assert the presence of two distinct Status__c records related to the Account
  //   List<Status__c> statuses = [
  //     SELECT
  //       Total_Gifts__c,
  //       Last_Prospecting_Activity__c,
  //       Total_Meetings__c,
  //       Prospecting_Status__c,
  //       Opportunity__c,
  //       Opportunity_Amount__c,
  //       Opportunity_Created_Date__c
  //     FROM Status__c
  //     ORDER BY Last_Prospecting_Activity__c ASC
  //   ];
  //   // System.assertEquals(1, statuses.size(), JSON.serialize(statuses));

  //   Status__c onlyOs = statuses[0];
  //   // System.assertEquals(0, onlyOs.Total_Gifts__c);
  //   // System.assertEquals(0, onlyOs.Total_Meetings__c);
  //   // System.assertEquals(
  //   //   C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
  //   //   onlyOs.Prospecting_Status__c
  //   // );
  // }

  // @TestSetup
  // static void setupTestData() {
  //   // order matters
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   CustomMetadataCache.withEventMeetingObject = true;
  //   CustomMetadataCache.disableActivationViaMeetingSet = true;

  //   System.runAs(TestFactory.ioAgent) {
  //     // Create an account
  //     Account account = new Account(Name = 'Test Account');
  //     insert account;

  //     for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
  //       // Create a contact associated with the account
  //       Contact associatedContact = new Contact(
  //         FirstName = 'Test',
  //         LastName = 'Contact',
  //         AccountId = account.Id
  //       );
  //       associatedContact.AccountId = account.Id;
  //       insert associatedContact;

  //       // Create 1st group of tasks (activation 1) and associate them with the contact
  //       List<Task> firstActivationTasks = new List<Task>();
  //       for (Integer j = 0; j < ACTIVITIES_FOR_CONTACT_ACTIVATION; j++) {
  //         Task t = TestFactory.createEligibleActivityForFilter(
  //           CustomMetadataCache.setting.Gift_Advance1__c
  //         );
  //         t.WhoId = associatedContact.Id;
  //         firstActivationTasks.add(t);
  //       }
  //       insert firstActivationTasks;

  //       // Create 2nd group of tasks (activation 2) after the wait period and associate them with the contact
  //       List<Task> thirdActivationTasks = new List<Task>();
  //       for (Integer j = 0; j < ACTIVITIES_FOR_CONTACT_ACTIVATION; j++) {
  //         Task t = TestFactory.createEligibleActivityForFilter(
  //           CustomMetadataCache.setting.Gift_Advance1__c
  //         );
  //         t.WhoId = associatedContact.Id;
  //         thirdActivationTasks.add(t);
  //       }
  //       insert thirdActivationTasks;

  //       // Adjust their creation date to some days back but within TRACKING_PERIOD
  //       for (Task t : firstActivationTasks) {
  //         Test.setCreatedDate(t.Id, latestActivationDate);
  //       }

  //       // Adjust their creation date to fall after the wait period from the first activation date
  //       for (Task t : thirdActivationTasks) {
  //         Test.setCreatedDate(t.Id, oldestActivationDate);
  //       }
  //     }

  //     Opportunity opp = new Opportunity(
  //       Name = 'second activation tasks opp',
  //       AccountId = account.Id,
  //       CloseDate = latestActivationDate,
  //       StageName = 'Closed Won',
  //       Amount = 2000
  //     );
  //     insert opp;
  //     Test.setCreatedDate(opp.Id, latestActivationDate.addDays(1));

  //     Event e = TestFactory.createEligibleEventForFilter(
  //       CustomMetadataCache.setting.Outbound_Meeting_Advance__c
  //     );
  //     Event e2 = TestFactory.createEligibleEventForFilter(
  //       CustomMetadataCache.setting.Outbound_Meeting_Advance__c
  //     );
  //     Id whoId = [SELECT Id FROM Contact LIMIT 1].Id;
  //     e.WhoId = whoId;
  //     e2.WhoId = whoId;
  //     insert e;
  //     insert e2;
  //     Test.setCreatedDate(e.Id, oldestActivationDate.addDays(2));
  //     Test.setCreatedDate(e2.Id, oldestActivationDate.addDays(1));
  //   }
  // }
}