@isTest
public with sharing class MultipeActivatedContactsRollupTest {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;

  @isTest
  static void given() {
    System.assertEquals(1, [SELECT COUNT() FROM Account]);
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      [SELECT COUNT() FROM Contact]
    );
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      [SELECT COUNT() FROM Outbound_Contact_Activation__c]
    );
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD *
      ACTIVITIES_FOR_CONTACT_ACTIVATION,
      [SELECT COUNT() FROM Task]
    );
    Status__c os = [SELECT Total_Inmails__c FROM Status__c LIMIT 1];
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD *
      ACTIVITIES_FOR_CONTACT_ACTIVATION,
      os.Total_Inmails__c
    );
  }

  @isTest
  static void whenANewContactIsActivatedUnderExistingStatus_thenPreviousMetricsAreMaintainedInTheRollup() {
    CustomMetadataCache.enableActivateAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Contact.SObjectType, Task.SObjectType }
      );
      Account account = [SELECT Id FROM Account LIMIT 1];
      Contact c = new Contact(LastName = 'another activated contact');
      uow.registerRelationship(c, Contact.AccountId, account);
      uow.registerNew(c);
      List<Task> tasks = new List<Task>();
      for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          CustomMetadataCache.setting.InMail_Advance1__c
        );
        uow.registerRelationship(t, Task.WhoId, c);
        tasks.add(t);
      }
      uow.registerNew(tasks);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.assertEquals(1, [SELECT COUNT() FROM Status__c]);
    Status__c os = [SELECT Total_Inmails__c FROM Status__c LIMIT 1];
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD + 1,
      [
        SELECT COUNT()
        FROM Outbound_Contact_Activation__c
        WHERE Outbound_Status__c = :os.Id
      ],
      JSON.serializePretty(
        [SELECT Contact__r.Name, Contact__c FROM Outbound_Contact_Activation__c]
      )
    );
    System.assertEquals(
      (CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD *
      ACTIVITIES_FOR_CONTACT_ACTIVATION) + ACTIVITIES_FOR_CONTACT_ACTIVATION,
      os.Total_Inmails__c
    );
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
      Account activatedAccount = new Account(Name = 'activated account');
      uow.registerNew(activatedAccount);

      List<Contact> activatedContacts = new List<Contact>();
      for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
        Contact activatedContact = new Contact(
          LastName = 'activated contact ' + i
        );
        activatedContacts.add(activatedContact);
        uow.registerRelationship(
          activatedContact,
          Contact.AccountId,
          activatedAccount
        );
      }
      uow.registerNew(activatedContacts);

      List<Task> outboundTasks = new List<Task>();
      for (Contact c : activatedContacts) {
        for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
          Task t = TestFactory.createEligibleActivityForFilter(
            CustomMetadataCache.setting.InMail_Advance1__c
          );
          uow.registerRelationship(t, Task.WhoId, c);
          outboundTasks.add(t);
        }
      }

      uow.registerNew(outboundTasks);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}