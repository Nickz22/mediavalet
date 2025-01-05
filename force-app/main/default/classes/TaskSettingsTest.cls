@isTest
public class TaskSettingsTest {
  @isTest
  static void given() {
    oneCoolingOffIoOwnedAccount();
    oneIoOwnedAccountWithOpenOpportunity();
    oneCoolingOffIoOwnedContact();
    oneIoOwnedContactWithOpenOpportunity();
  }

  static void oneCoolingOffIoOwnedAccount() {
    Settings__mdt setting = CustomMetadataCache.setting;
    Date coolOffThreshold = Date.today()
      .addDays(-Integer.valueOf(setting.Wait_Period__c));
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'cooling off'
          AND Id IN (
            SELECT Account__c
            FROM Status__c
            WHERE Unresponsive_Date__c >= :coolOffThreshold
          )
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneIoOwnedAccountWithOpenOpportunity() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'open opportunity'
          AND Id IN (SELECT AccountId FROM Opportunity WHERE IsClosed = FALSE)
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneCoolingOffIoOwnedContact() {
    Settings__mdt setting = CustomMetadataCache.setting;
    Date coolOffThreshold = Date.today()
      .addDays(-Integer.valueOf(setting.Wait_Period__c));
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Account.Name = 'cooling off'
          AND AccountId IN (
            SELECT Account__c
            FROM Status__c
            WHERE Unresponsive_Date__c >= :coolOffThreshold
          )
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneIoOwnedContactWithOpenOpportunity() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Account.Name = 'open opportunity'
          AND AccountId IN (
            SELECT AccountId
            FROM Opportunity
            WHERE IsClosed = FALSE
          )
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  @isTest
  static void whenInboundEmailActivitiesAreCreatedOverThresholdUnderCoolingOffAccount_thenContactIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;

    Contact coolOffContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'cooling off' AND LastName = 'cooling off'
      LIMIT 1
    ];
    Contact positiveCaseContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'test' AND LastName = 'test'
      LIMIT 1
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      List<Task> tasks = new List<Task>();
      for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          settings.Inbound_Email_Advance__c
        );
        t.WhoId = coolOffContact.Id;
        tasks.add(t);
      }
      for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          settings.Inbound_Email_Advance__c
        );
        t.WhoId = positiveCaseContact.Id;
        tasks.add(t);
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(
          new Set<Id>{ coolOffContact.Id, positiveCaseContact.Id }
        );
      System.assertEquals(1, activations.size());
    }
  }

  @isTest
  static void whenInboundEmailActivitiesAreCreatedOverThresholdUnderOpenOpportunityAccount_thenContactIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;

    Contact openOpportunityContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'open opportunity' AND LastName = 'open opportunity'
      LIMIT 1
    ];
    Contact positiveCaseContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'test' AND LastName = 'test'
      LIMIT 1
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      List<Task> tasks = new List<Task>();
      for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          settings.Inbound_Email_Advance__c
        );
        t.WhoId = openOpportunityContact.Id;
        tasks.add(t);
      }
      for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          settings.Inbound_Email_Advance__c
        );
        t.WhoId = positiveCaseContact.Id;
        tasks.add(t);
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(
          new Set<Id>{ openOpportunityContact.Id, positiveCaseContact.Id }
        );
      System.assertEquals(1, activations.size());
    }
  }

  @isTest
  static void whenInboundEmailActivitiesAreCreatedOverThresholdWhileActivateAutomaticallyIsDisabled_thenContactIsNotActivated() {
    CustomMetadataCache.disableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;

    Contact positiveCaseContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'test' AND LastName = 'test'
      LIMIT 1
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      List<Task> tasks = new List<Task>();
      for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          settings.Inbound_Email_Advance__c
        );
        t.WhoId = positiveCaseContact.Id;
        tasks.add(t);
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(
          new Set<Id>{ positiveCaseContact.Id }
        );
      System.assertEquals(0, activations.size());
    }
  }

  @TestSetup
  static void makeData() {
    Settings__mdt setting = CustomMetadataCache.setting;
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Status__c.SObjectType,
          Opportunity.SObjectType
        }
      );

      // positive test case accounts
      Account testAccount = new Account(
        Name = 'test account',
        OwnerId = TestFactory.ioAgent.Id
      );
      uow.registerNew(testAccount);

      Contact testContact = new Contact(
        FirstName = 'test',
        LastName = 'test',
        OwnerId = TestFactory.ioAgent.Id
      );
      uow.registerRelationship(testContact, Contact.AccountId, testAccount);
      uow.registerNew(testContact);

      // make cooling off account
      Account coolOffAccount = new Account(
        Name = 'cooling off',
        Territory__c = 'United States'
      );
      uow.registerNew(coolOffAccount);

      Contact coolingOffContact = new Contact(
        FirstName = 'cooling off',
        LastName = 'cooling off'
      );
      uow.registerRelationship(
        coolingOffContact,
        Contact.AccountId,
        coolOffAccount
      );
      uow.registerNew(coolingOffContact);

      Integer oneLessThanCoolOff = Integer.valueOf(setting.Wait_Period__c) - 1;
      Status__c coolingOffStatus = new Status__c(
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE,
        Unresponsive_Date__c = Date.today().addDays(-oneLessThanCoolOff)
      );
      uow.registerRelationship(
        coolingOffStatus,
        Status__c.Account__c,
        coolOffAccount
      );
      uow.registerNew(coolingOffStatus);

      // make open opportunity account
      Account openOpportunityAccount = new Account(
        Name = 'open opportunity',
        Territory__c = 'United States'
      );

      uow.registerNew(openOpportunityAccount);

      Contact openOpportunityContact = new Contact(
        FirstName = 'open opportunity',
        LastName = 'open opportunity'
      );

      uow.registerRelationship(
        openOpportunityContact,
        Contact.AccountId,
        openOpportunityAccount
      );

      uow.registerNew(openOpportunityContact);

      Opportunity openOpportunity = new Opportunity(
        Name = 'open opportunity',
        CloseDate = Date.today().addDays(1),
        StageName = 'Prospecting',
        Amount = 1000
      );

      uow.registerRelationship(
        openOpportunity,
        Opportunity.AccountId,
        openOpportunityAccount
      );

      uow.registerNew(openOpportunity);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}
