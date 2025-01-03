@isTest
public class OutboundStatusExpirationTest {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;
  private static final Integer ACCOUNTS_COUNT = 10;

  @isTest
  static void given() {
    oneIoOwnedActivatedAccount();
    ioOwnedActivatedContactsUnderActivatedAccount();
    bulkIoOwnedAccounts();
    bulkIoOwnedActivatedContactsUnderActivatedAccount();
  }

  static void oneIoOwnedActivatedAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'Activated Account'
          AND Id IN (
            SELECT Account__c
            FROM Status__c
            WHERE
              Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
          )
          AND OwnerId IN :PermissionsCache.ioUserIds
      ]
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE Account__r.Name = 'Activated Account'
      ]
    );
  }

  static void ioOwnedActivatedContactsUnderActivatedAccount() {
    List<Contact> contacts = [
      SELECT Id
      FROM Contact
      WHERE
        AccountId IN (
          SELECT Account__c
          FROM Status__c
          WHERE Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
        )
        AND LastName LIKE 'Activated Contact%'
        AND OwnerId IN :PermissionsCache.ioUserIds
    ];
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      contacts.size()
    );
    System.assertEquals(
      contacts.size(),
      [
        SELECT COUNT()
        FROM Outbound_Contact_Activation__c
        WHERE Outbound_Status__c != NULL AND Contact__c IN :contacts
      ]
    );
  }

  static void bulkIoOwnedAccounts() {
    System.assertEquals(
      ACCOUNTS_COUNT,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name LIKE 'Bulk%'
          AND Id IN (
            SELECT Account__c
            FROM Status__c
            WHERE
              Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
          )
          AND OwnerId IN :PermissionsCache.ioUserIds
      ]
    );
    System.assertEquals(
      ACCOUNTS_COUNT,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE Account__r.Name LIKE 'Bulk Activated Account%'
      ]
    );
  }

  static void bulkIoOwnedActivatedContactsUnderActivatedAccount() {
    List<Contact> contacts = [
      SELECT Id
      FROM Contact
      WHERE
        AccountId IN (
          SELECT Account__c
          FROM Status__c
          WHERE Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
        )
        AND LastName LIKE 'Bulk Activated Contact%'
        AND OwnerId IN :PermissionsCache.ioUserIds
    ];
    System.assertEquals(
      ACCOUNTS_COUNT * CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
      contacts.size()
    );
    System.assertEquals(
      contacts.size(),
      [
        SELECT COUNT()
        FROM Outbound_Contact_Activation__c
        WHERE Outbound_Status__c != NULL AND Contact__c IN :contacts
      ]
    );
  }

  @isTest
  static void whenActivatedAccountsLastOutboundActivityExceedsTrackingPeriod_thenOsAndOcasAreExpired() {
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Status__c.SObjectType }
      );
      Status__c os = [
        SELECT Id, Account__c
        FROM Status__c
        WHERE Account__r.Name = 'Activated Account'
      ];
      Date deactivationThreshold = Date.today()
        .addDays(
          -Integer.valueOf(CustomMetadataCache.setting.Deactivate_After__c + 1)
        );
      os.Last_Outbound_Activity__c = deactivationThreshold;
      uow.registerDirty(os);
      uow.commitWork();

      Test.startTest();
      Database.executeBatch(new AccountsDeactivatorBatch());
      Test.stopTest();

      os = [
        SELECT
          Prospecting_Status__c,
          Unresponsive_Date__c,
          (
            SELECT Expired_Date__c, Is_Current__c
            FROM Outbound_Contact_Activations__r
          )
        FROM Status__c
        WHERE Account__r.Name = 'Activated Account'
      ];

      System.assertEquals(os.Unresponsive_Date__c, Date.today());
      System.assertEquals(
        os.Prospecting_Status__c,
        C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
      );
      System.assertEquals(
        CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
        os.Outbound_Contact_Activations__r.size()
      );
      for (
        Outbound_Contact_Activation__c oca : os.Outbound_Contact_Activations__r
      ) {
        System.assertEquals(Date.today(), oca.Expired_Date__c);
        System.assertEquals(false, oca.Is_Current__c);
      }
    }
  }

  @isTest
  static void whenActivatedAccountsLastOutboundActivityExceedsTrackingPeriodBulk_thenOsAndOcasAreExpired() {
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Status__c.SObjectType }
      );

      List<Status__c> statuses = [
        SELECT Id, Account__c
        FROM Status__c
        WHERE Account__r.Name LIKE 'Bulk Activated Account%'
      ];
      Date deactivationThreshold = Date.today()
        .addDays(
          -Integer.valueOf(CustomMetadataCache.setting.Deactivate_After__c + 1)
        );

      for (Status__c os : statuses) {
        os.Last_Outbound_Activity__c = deactivationThreshold;
        uow.registerDirty(os);
      }
      uow.commitWork();

      Test.startTest();
      Database.executeBatch(new AccountsDeactivatorBatch(), ACCOUNTS_COUNT);
      Test.stopTest();

      statuses = [
        SELECT
          Prospecting_Status__c,
          Unresponsive_Date__c,
          (
            SELECT Expired_Date__c, Is_Current__c
            FROM Outbound_Contact_Activations__r
          )
        FROM Status__c
        WHERE Account__r.Name LIKE 'Bulk Activated Account%'
      ];

      for (Status__c os : statuses) {
        System.assertEquals(os.Unresponsive_Date__c, Date.today());
        System.assertEquals(
          os.Prospecting_Status__c,
          C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
        );
        System.assertEquals(
          CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD,
          os.Outbound_Contact_Activations__r.size()
        );
        for (
          Outbound_Contact_Activation__c oca : os.Outbound_Contact_Activations__r
        ) {
          System.assertEquals(Date.today(), oca.Expired_Date__c);
          System.assertEquals(false, oca.Is_Current__c);
        }
      }
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
      // create and activate Account
      Account activatedAccount = new Account(Name = 'Activated Account');

      uow.registerNew(activatedAccount);

      for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
        Contact activatedContact = new Contact(
          LastName = 'Activated Contact ' + i,
          AccountId = activatedAccount.Id
        );
        uow.registerRelationship(
          activatedContact,
          Contact.AccountId,
          activatedAccount
        );
        uow.registerNew(activatedContact);

        for (Integer j = 0; j < ACTIVITIES_FOR_CONTACT_ACTIVATION; j++) {
          Task outboundEmailTask = TestFactory.createEligibleActivityForFilter(
            CustomMetadataCache.setting.Outbound_Email_Advance__c
          );
          uow.registerRelationship(
            outboundEmailTask,
            Task.WhoId,
            activatedContact
          );
          uow.registerNew(outboundEmailTask);
        }
      }

      // Create multiple accounts
      for (Integer i = 0; i < ACCOUNTS_COUNT; i++) {
        // create and activate Account
        Account bulkActivatedAccount = new Account(
          Name = 'Bulk Activated Account ' + i
        );

        uow.registerNew(bulkActivatedAccount);

        for (Integer j = 0; j < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; j++) {
          Contact activatedContact = new Contact(
            LastName = 'Bulk Activated Contact ' + j,
            AccountId = bulkActivatedAccount.Id
          );
          uow.registerRelationship(
            activatedContact,
            Contact.AccountId,
            bulkActivatedAccount
          );
          uow.registerNew(activatedContact);

          for (Integer k = 0; k < ACTIVITIES_FOR_CONTACT_ACTIVATION; k++) {
            Task outboundEmailTask = TestFactory.createEligibleActivityForFilter(
              CustomMetadataCache.setting.Outbound_Email_Advance__c
            );
            uow.registerRelationship(
              outboundEmailTask,
              Task.WhoId,
              activatedContact
            );
            uow.registerNew(outboundEmailTask);
          }
        }
      }

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}