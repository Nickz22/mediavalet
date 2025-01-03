@isTest
class ActivatesViaTaskAndSingleActivity {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;

  @isTest
  static void given() {
    twoContacts();
    oneAccount();
    oneProspectingActivity();
  }

  static void twoContacts() {
    Assert.areEqual(2, [SELECT COUNT() FROM Contact]);
  }

  static void oneAccount() {
    Assert.areEqual(1, [SELECT COUNT() FROM Account]);
  }

  static void oneProspectingActivity() {
    Assert.areEqual(1, [SELECT COUNT() FROM Task]);
  }

  @isTest
  static void shouldCreateStatusWithRollupsWhenTaskMeetingIsCreatedUnderSameContactAsProspectingActivity() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withTaskMeetingObject = true;

    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      Contact contact = [
        SELECT AccountId
        FROM Contact
        WHERE Name = 'Single Prospecting Activity Contact'
        LIMIT 1
      ];

      Task task = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      task.WhoId = contact.Id;

      uow.registerNew(task);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      Status__c activeStatus = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ contact.AccountId }
        )[0];
    }
  }

  @isTest
  static void shouldCreateStatusWithRollupsWhenTaskMeetingIsCreatedUnderDifferentContactFromSameAccount() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withTaskMeetingObject = true;

    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      Contact contact = [
        SELECT AccountId
        FROM Contact
        WHERE Name = 'Contact without Activity'
        LIMIT 1
      ];

      Task task = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      task.WhoId = contact.Id;

      uow.registerNew(task);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      Status__c activeStatus = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ contact.AccountId }
        )[0];

      Assert.areEqual(1, activeStatus.Total_Inbound_Emails__c);
    }
  }

  @TestSetup
  static void makeData() {
    CustomMetadataCache.enableActivateAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      // create Account and Contact
      Account acc = new Account(Name = 'Single Prospecting Activity Account');
      uow.registerNew(acc);

      Contact con = new Contact(
        LastName = 'Single Prospecting Activity Contact',
        AccountId = acc.Id
      );

      Contact con2 = new Contact(
        LastName = 'Contact without Activity',
        AccountId = acc.Id
      );
      uow.registerRelationship(con, Contact.AccountId, acc);
      uow.registerRelationship(con2, Contact.AccountId, acc);
      uow.registerNew(con);
      uow.registerNew(con2);

      Task inboundEmailTask = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Inbound_Email_Advance__c
      );
      uow.registerRelationship(inboundEmailTask, Task.WhoId, con);
      uow.registerNew(inboundEmailTask);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}