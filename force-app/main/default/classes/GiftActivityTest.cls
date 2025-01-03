/**
 * needs to adjust to whatever activation threshold is setup in the org
 */
@isTest
public class GiftActivityTest {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;

  @isTest
  static void given() {
    oneIoOwnedAccount();
    oneIoOwnedBulkAccount();
    oneIoOwnedContact();
    ioOwnedBulkContacts(CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD);
    oneStaleActivatedIoOwnedAccount();
    twoStaleActivatedIoOwnedContacts();
    oneAccountWithContactWithPreexistingTaskInTrackingPeriod();
    oneContactWithPreexistingTaskInTrackingPeriod();
    onePreexistingTaskWithinTrackingPeriod();
  }

  static void oneIoOwnedAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE Name = 'test' AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneIoOwnedBulkAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE Name = 'bulk test account' AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneIoOwnedContact() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE Account.Name = 'test' AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void ioOwnedBulkContacts(
    Integer contactPerAccountActivationThreshold
  ) {
    System.assertEquals(
      contactPerAccountActivationThreshold,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Account.Name = 'bulk test account'
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneStaleActivatedIoOwnedAccount() {
    Status__c staleStatus = [
      SELECT Account__c
      FROM Status__c
      WHERE Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
      LIMIT 1
    ];
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'stale account test'
          AND OwnerId = :TestFactory.ioAgent.Id
          AND Id = :staleStatus.Account__c
      ]
    );
  }

  static void twoStaleActivatedIoOwnedContacts() {
    List<Outbound_Contact_Activation__c> staleActivations = [
      SELECT Contact__c
      FROM Outbound_Contact_Activation__c
      WHERE Is_Current__c = FALSE
    ];
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      staleActivations.size()
    );
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Account.Name = 'stale account test'
          AND OwnerId = :TestFactory.ioAgent.Id
          AND Id IN :Pluck.ids(
            staleActivations,
            C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD
          )
      ]
    );
  }

  static void oneAccountWithContactWithPreexistingTaskInTrackingPeriod() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'preexisting task account'
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneContactWithPreexistingTaskInTrackingPeriod() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Account.Name = 'preexisting task account'
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void onePreexistingTaskWithinTrackingPeriod() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Task
        WHERE
          Who.FirstName = 'preexisting task contact'
          AND OwnerId = :TestFactory.ioAgent.Id
      ]
    );
  }

  @isTest
  static void whenGiftActivityIsCreatedWhileUnderThreshold_thenContactIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    Contact testContact = [
      SELECT Id
      FROM Contact
      WHERE FirstName = 'test' AND LastName = 'test'
      LIMIT 1
    ];
    Task gift = TestFactory.createEligibleActivityForFilter(
      settings.Gift_Advance1__c
    );
    gift.WhoId = testContact.Id;

    System.runAs(TestFactory.ioAgent) {
      insert gift;
    }

    Boolean isContactActivated =
      [
        SELECT COUNT()
        FROM Outbound_Contact_Activation__c
        WHERE Is_Current__c = TRUE AND Contact__c = :testContact.Id
      ] > 0;
    System.assertEquals(
      false,
      isContactActivated,
      'expected Contact not to be activated since single activity creation did not exceed activation threshold'
    );
  }

  @isTest
  static void whenGiftActivityIsCreatedOverThresholdAndFilterIsDisabled_thenContactIsNotActivated() {
    CustomMetadataCache.disableAccountSuppression = true;
    CustomMetadatacache.disableGiftForTest = true;
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    Contact testContact = [
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
          settings.Gift_Advance1__c
        );
        t.WhoId = testContact.Id;
        tasks.add(t);
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(new Set<Id>{ testContact.Id });
      System.assertEquals(0, activations.size());
    }
  }

  @isTest
  static void whenGiftActivityIsCreatedOverThreshold_thenContactIsActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.disableAccountSuppression = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    Contact testContact = [
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
          settings.Gift_Advance1__c
        );
        t.WhoId = testContact.Id;
        tasks.add(t);
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      Outbound_Contact_Activation__c activation = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(new Set<Id>{ testContact.Id })[0];
      System.assertEquals(activation.Gifts__c, minActivitiesToActivateContact);
      System.assertEquals(activation.Activated_By__c, TestFactory.ioAgent.Id);
      System.assertEquals(activation.Activated_Date__c, Date.today());
    }
  }

  @isTest
  static void whenInMailActivitiesAreCreatedOverThreshold_verifyContactIsActivatedBulk() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    Account bulkTestAccount = [
      SELECT Id
      FROM Account
      WHERE Name = 'bulk test account'
      LIMIT 1
    ];
    List<Contact> bulkContacts = [
      SELECT Id
      FROM Contact
      WHERE AccountId = :bulkTestAccount.Id
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      List<Task> tasks = new List<Task>();
      for (Contact c : bulkContacts) {
        for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
          Task t = TestFactory.createEligibleActivityForFilter(
            settings.Gift_Advance1__c
          );
          t.WhoId = c.Id;
          tasks.add(t);
        }
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      // assertions
      System.runAs(TestFactory.ioAdmin) {
        List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
          .selectCurrentActivationsByContactIds(
            Pluck.ids(bulkContacts, C.ID_FIELD)
          );

        System.assertEquals(bulkContacts.size(), activations.size());
        List<String> uniqueProspectIds = new List<Id>(
          Pluck.ids(activations, C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD)
        );
        System.assertEquals(
          CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
          uniqueProspectIds.size()
        );
        System.assertEquals(
          CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
          activations.size()
        );
        for (Outbound_Contact_Activation__c activation : activations) {
          System.assertEquals(
            minActivitiesToActivateContact,
            activation.Gifts__c
          );
          System.assertEquals(
            activation.Activated_By__c,
            TestFactory.ioAgent.Id
          );
          System.assertEquals(activation.Activated_Date__c, Date.today());
          System.assertEquals(
            activation.Gifts__c,
            minActivitiesToActivateContact
          );
        }

        System.assertEquals(
          1,
          [
            SELECT COUNT()
            FROM Status__c
            WHERE
              Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
          ]
        );
      }
    }
  }

  @isTest
  static void whenGiftActivityIsCreatedUnderStaleActivatedContactOverThreshold_thenContactIsReactivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    List<Contact> testContacts = [
      SELECT Id
      FROM Contact
      WHERE Account.Name = 'stale account test'
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );
      List<Task> tasks = new List<Task>();
      for (Contact c : testContacts) {
        for (Integer i = 0; i < minActivitiesToActivateContact; i++) {
          Task t = TestFactory.createEligibleActivityForFilter(
            settings.Gift_Advance1__c
          );
          t.WhoId = c.Id;
          tasks.add(t);
        }
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    // assertions
    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(
          Pluck.ids(testContacts, C.ID_FIELD)
        );

      System.assertEquals(activations.size(), testContacts.size());
      List<String> uniqueProspectIds = new List<Id>(
        Pluck.ids(activations, C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD)
      );
      System.assertEquals(
        CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
        uniqueProspectIds.size()
      );
      System.assertEquals(
        CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
        activations.size()
      );
      for (Outbound_Contact_Activation__c activation : activations) {
        System.assertEquals(
          activation.Gifts__c,
          minActivitiesToActivateContact
        );
        System.assertEquals(activation.Activated_By__c, TestFactory.ioAgent.Id);
        System.assertEquals(activation.Activated_Date__c, Date.today());
        System.assertEquals(
          activation.Gifts__c,
          minActivitiesToActivateContact
        );
      }

      // new status is not unresponsive
      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c != :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
        ]
      );

      // old status is still unresponsive
      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
        ]
      );
    }
  }

  @isTest
  static void whenNewActivityIsOverThresholdAndPreexistingActivityIsWithinTrackingPeriod_thenContactIsActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    List<Contact> testContacts = [
      SELECT Id
      FROM Contact
      WHERE Account.Name = 'preexisting task account'
    ];
    Integer minActivitiesToActivateContact = Integer.valueOf(
      settings.Activities_Created_by_User1__c
    );
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );
      List<Task> tasks = new List<Task>();
      for (Contact c : testContacts) {
        for (Integer i = 0; i < (minActivitiesToActivateContact - 1); i++) {
          Task t = TestFactory.createEligibleActivityForFilter(
            settings.Gift_Advance1__c
          );
          t.WhoId = c.Id;
          tasks.add(t);
        }
      }
      uow.registerNew(tasks);
      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    // assertions
    System.runAs(TestFactory.ioAdmin) {
      List<Outbound_Contact_Activation__c> activations = new OutboundContactActivationSelector()
        .selectCurrentActivationsByContactIds(
          Pluck.ids(testContacts, C.ID_FIELD)
        );

      System.assertEquals(activations.size(), testContacts.size());
    }
  }

  @TestSetup
  static void makeData() {
    Settings__mdt setting = CustomMetadataCache.setting;
    System.runAs(TestFactory.ioAdmin) {
      OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
      installSetting.Installed__c = null;
      upsert installSetting;
    }
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Status__c.SObjectType,
          Outbound_Contact_Activation__c.SObjectType,
          Task.SObjectType
        }
      );
      // make regular test account/contact
      Account testAccount = new Account(Name = 'test');
      uow.registerNew(testAccount);

      Contact testContact = new Contact(
        FirstName = 'test',
        LastName = 'test',
        AccountId = testAccount.Id
      );
      uow.registerRelationship(testContact, Contact.AccountId, testAccount);
      uow.registerNew(testContact);

      // make bulk test account/contacts
      Account bulkTestAccount = new Account(Name = 'bulk test account');
      uow.registerNew(bulkTestAccount);
      List<Contact> bulkContacts = new List<Contact>();
      Integer contactPerAccountActivationThreshold = CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD;
      for (Integer i = 0; i < contactPerAccountActivationThreshold; i++) {
        Contact c = new Contact(
          FirstName = 'bulk test',
          LastName = 'bulk test',
          AccountId = bulkTestAccount.Id
        );
        bulkContacts.add(c);
        uow.registerRelationship(c, Contact.AccountId, bulkTestAccount);
        uow.registerNew(c);
      }

      // make stale activated account/contacts
      Account staleActivatedAccount = new Account(Name = 'stale account test');
      uow.registerNew(staleActivatedAccount);
      Status__c staleStatus = new Status__c(
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
      );
      uow.registerNew(staleStatus);
      uow.registerRelationship(
        staleStatus,
        Status__c.Account__c,
        staleActivatedAccount
      );
      for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
        Contact staleActivatedContact = new Contact(
          FirstName = 'stale test ' + i,
          LastName = 'stale test ' + i
        );
        uow.registerRelationship(
          staleActivatedContact,
          Contact.AccountId,
          staleActivatedAccount
        );
        uow.registerNew(staleActivatedContact);
        Outbound_Contact_Activation__c staleActivation = new Outbound_Contact_Activation__c(
          Outbound_Status__c = staleStatus.Id,
          Activated_By__c = TestFactory.ioAgent.Id,
          Activated_Date__c = Date.today()
        );
        uow.registerRelationship(
          staleActivation,
          Outbound_Contact_Activation__c.Contact__c,
          staleActivatedContact
        );
        uow.registerRelationship(
          staleActivation,
          Outbound_Contact_Activation__c.Outbound_Status__c,
          staleStatus
        );
        uow.registerNew(staleActivation);
      }

      // make preexisting task/contact/account data
      Account preexistingAccount = new Account(
        Name = 'preexisting task account'
      );
      uow.registerNew(preexistingAccount);
      Contact preexistingContact = new Contact(
        FirstName = 'preexisting task contact',
        LastName = 'preexisting task contact',
        AccountId = preexistingAccount.Id
      );
      uow.registerRelationship(
        preexistingContact,
        Contact.AccountId,
        preexistingAccount
      );
      uow.registerNew(preexistingContact);
      Task preexistingTask = TestFactory.createEligibleActivityForFilter(
        setting.Gift_Advance1__c
      );
      uow.registerRelationship(preexistingTask, Task.WhoId, preexistingContact);
      uow.registerNew(preexistingTask);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}