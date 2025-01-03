@isTest
public class MultipleOsWithinCoolOffPeriodTest {
  //   @isTest
  //   static void given() {
  //     oneInactivatedAccount();
  //     oneInactivatedContact();
  //     enoughOutboundEmailsToActivateTwiceWithinCoolOffPeriod();
  //   }

  //   static void oneInactivatedAccount() {
  //     System.assertEquals(0, [SELECT COUNT() FROM Status__c]);
  //     System.assertEquals(
  //       1,
  //       [
  //         SELECT COUNT()
  //         FROM Account
  //         WHERE Id NOT IN (SELECT Account__c FROM Status__c)
  //       ]
  //     );
  //   }

  //   static void oneInactivatedContact() {
  //     System.assertEquals(
  //       C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //       [
  //         SELECT COUNT()
  //         FROM Contact
  //         WHERE Id NOT IN (SELECT Contact__c FROM Outbound_Contact_Activation__c)
  //       ]
  //     );
  //   }

  //   static void enoughOutboundEmailsToActivateTwiceWithinCoolOffPeriod() {
  //     List<Task> tasks = [SELECT CreatedDate FROM Task];
  //     System.assertEquals(
  //       C.ACTIVITIES_FOR_CONTACT_ACTIVATION *
  //       C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
  //         tasks.size()
  //     );

  //     Map<Date, List<Task>> tasksByDate = new Map<Date, List<Task>>();
  //     for (Task t : tasks) {
  //       Date d = t.CreatedDate.date();
  //       if (!tasksByDate.containsKey(d)) {
  //         tasksByDate.put(d, new List<Task>());
  //       }
  //       tasksByDate.get(d).add(t);
  //     }

  //     Date lastDate;
  //     for(Date taskCreatedDate : tasksByDate.keySet()) {
  //       if (lastDate != null) {
  //         System.assertEquals(
  //           C.ACTIVITIES_FOR_CONTACT_ACTIVATION,
  //           lastDate.daysBetween(taskCreatedDate)
  //         );
  //       }
  //       lastDate = taskCreatedDate;
  //     }
  //   }

  // @isTest
  // static void whenRetroBatchExecutes_andAccountHasMultipleOsWithinWaitPeriod_thenAccountIsActivatedWithSingleOsOnly() {
  //   System.runAs(TestFactory.ioAdmin) {
  //     Test.startTest();
  //     Database.executeBatch(new RetroactiveActivationBatch(30));
  //     Test.stopTest();
  //   }

  //   // System.assertEquals(1, [SELECT COUNT() FROM Status__c]);
  // }

  // @TestSetup
  // static void makeData() {
  //   CustomMetadataCache.disableActivateAutomatically = true;
  //   System.runAs(TestFactory.ioAdmin) {
  //     fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );

  //     TestFactory.initActivatedContactData(
  //       CustomMetadataCache.setting.Outbound_Email_Advance__c,
  //       uow
  //     );

  //     uow.commitWork();

  //     // construct query string with all task fields
  //     String taskFields = String.join(
  //       new List<String>(
  //         Task.SObjectType.getDescribe().fields.getMap().keySet()
  //       ),
  //       ','
  //     );
  //     List<Task> tasks = Database.query('SELECT ' + taskFields + ' FROM Task');
  //     // clone tasks without id
  //     uow = new fflib_SObjectUnitOfWork(
  //       new List<SObjectType>{
  //         Account.SObjectType,
  //         Contact.SObjectType,
  //         Task.SObjectType
  //       }
  //     );
  //     List<Task> earlierTasks = new List<Task>();
  //     for (Task t : tasks) {
  //       Task tClone = t.clone(false, true, false, false);
  //       earlierTasks.add(tClone);
  //     }

  //     uow.registerNew(earlierTasks);

  //     uow.commitWork();

  //     Integer trackingPeriod = Integer.valueOf(
  //       CustomMetadataCache.setting.Timeframe_Days_Contact1__c
  //     );
  //     Integer coolOffPeriod = Integer.valueOf(
  //       CustomMetadataCache.setting.Wait_Period__c
  //     );

  //     // set earlierTasks created date via Test.setCreatedDate() outside of trackingPeriod, but within coolOffPeriod (trackingPeriod will always be smaller)
  //     for (Task t : earlierTasks) {
  //       Test.setCreatedDate(t.Id, DateTime.now().addDays(-(coolOffPeriod - 1)));
  //     }
  //   }
  // }
}