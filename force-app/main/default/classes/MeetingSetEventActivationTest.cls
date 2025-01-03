@isTest
public class MeetingSetEventActivationTest {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;

  @isTest
  static void given() {
    oneIoOwnedAccount();
    oneIoOwnedContact();
    oneIoOwnedAccountWithSingleOca();
    oneIoOwnedContactWithSingleOca();
    oneIoOwnedActivatedAccount();
    ioOwnedActivatedContactsUnderActivatedAccount();
  }

  @isTest
  static void oneIoOwnedAccount() {
    System.debug(PermissionsCache.ioUserIds);
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Name = 'Single Prospecting Activity Account'
          AND OwnerId IN :PermissionsCache.ioUserIds
      ],
      [SELECT Name FROM Account]
    );
  }

  @isTest
  static void oneIoOwnedContact() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Name = 'Single Prospecting Activity Contact'
          AND OwnerId IN :PermissionsCache.ioUserIds
      ]
    );
  }

  static void oneIoOwnedAccountWithSingleOca() {
    Set<Id> ocaAccountIds = Pluck.idsAtPath(
      [
        SELECT Contact__r.AccountId
        FROM Outbound_Contact_Activation__c
        WHERE Contact__r.Account.Name = 'Account with single OCA'
      ],
      C.OUTBOUND_CONTACT_ACTIVATION_CONTACT_TO_ACCOUNT_ID_PATH
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE Id IN :ocaAccountIds AND OwnerId IN :PermissionsCache.ioUserIds
      ]
    );
  }

  static void oneIoOwnedContactWithSingleOca() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          Id IN (
            SELECT Contact__c
            FROM Outbound_Contact_Activation__c
            WHERE Contact__r.LastName = 'Contact with single OCA'
          )
          AND OwnerId IN :PermissionsCache.ioUserIds
      ]
    );
  }

  static void oneIoOwnedActivatedAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          Id IN (
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

  @isTest
  static void whenMeetingSetWhileOneProspectingActivityExists_thenAccountIsActivated() {
    CustomMetadataCache.withEventMeetingObject = true;
    CustomMetadataCache.enableActivateAutomatically = true;

    Account accountWithTask = [
      SELECT Id
      FROM Account
      WHERE Name = 'Single Prospecting Activity Account'
      LIMIT 1
    ];
    Contact contactWithTask = [
      SELECT Id
      FROM Contact
      WHERE LastName = 'Single Prospecting Activity Contact'
      LIMIT 1
    ];
    Status__c status;
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Event.SObjectType }
      );
      Event meetingEvent = TestFactory.createEligibleEventForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      meetingEvent.Subject = 'Test Meeting Set';
      uow.registerRelationship(meetingEvent, Event.WhoId, contactWithTask);
      uow.registerNew(meetingEvent);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      status = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ accountWithTask.Id }
        )[0];
    }
    System.assertEquals(
      status.Prospecting_Status__c,
      C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET
    );
  }

  @isTest
  static void whenMeetingSetWhileSingleOcaExists_thenNewStatusIsAssociatedToExistingOca() {
    CustomMetadataCache.withEventMeetingObject = true;
    CustomMetadataCache.enableActivateAutomatically = true;

    Account accountWithOca = [
      SELECT Id
      FROM Account
      WHERE Name = 'Account with single OCA'
      LIMIT 1
    ];
    Contact contactWithOca = [
      SELECT Id
      FROM Contact
      WHERE LastName = 'Contact with single OCA'
      LIMIT 1
    ];

    Status__c status;
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Event.SObjectType }
      );
      Event meetingEvent = TestFactory.createEligibleEventForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      meetingEvent.Subject = 'Test Meeting Set';
      uow.registerRelationship(meetingEvent, Event.WhoId, contactWithOca);
      uow.registerNew(meetingEvent);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      status = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ accountWithOca.Id }
        )[0];
    }
    System.assertEquals(
      status.Prospecting_Status__c,
      C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Outbound_Contact_Activation__c
        WHERE Outbound_Status__c = :status.Id
      ],
      'expected opportunity contact activation to be associated to meeting set status'
    );
    System.assertEquals(1, status.Total_Meetings__c);
    System.assertEquals(Date.today(), status.Last_Meeting_Date__c);
    System.assertEquals(Date.today(), status.First_Meeting_Date__c);
    System.assertEquals(
      ACTIVITIES_FOR_CONTACT_ACTIVATION,
      status.Total_Inbound_Emails__c
    );
  }

  @isTest
  static void whenMeetingIsCreatedWhileStatusAlreadyExists_thenMeetingRollsUpToStatus() {
    CustomMetadataCache.withEventMeetingObject = true;
    CustomMetadataCache.enableActivateAutomatically = true;

    Account activatedAccount = [
      SELECT Id
      FROM Account
      WHERE Name = 'Activated Account'
      LIMIT 1
    ];
    List<Contact> activatedContacts = [
      SELECT Id
      FROM Contact
      WHERE LastName LIKE 'Activated Contact%'
    ];
    Status__c activeStatus;
    System.runAs(TestFactory.ioAgent) {
      activeStatus = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ activatedAccount.Id }
        )[0];
      System.assertEquals(0, activeStatus.Total_Meetings__c);
      System.assertEquals(null, activeStatus.Last_Meeting_Date__c);
      System.assertEquals(null, activeStatus.First_Meeting_Date__c);
      System.assertEquals(
        CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD *
        ACTIVITIES_FOR_CONTACT_ACTIVATION,
        activeStatus.Total_Outbound_Emails__c
      );

      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Event.SObjectType }
      );

      for (Contact c : activatedContacts) {
        Event meetingEvent = TestFactory.createEligibleEventForFilter(
          CustomMetadataCache.setting.Outbound_Meeting_Advance__c
        );
        meetingEvent.Subject = 'Test Meeting Set';
        uow.registerRelationship(meetingEvent, Event.WhoId, c);
        uow.registerNew(meetingEvent);
      }

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      activeStatus = new StatusSelector()
        .selectActivatedStatusByIds(new Set<Id>{ activeStatus.Id })[0];
    }

    System.assertEquals(
      C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET,
      activeStatus.Prospecting_Status__c,
      JSON.serialize(
        [SELECT Prospecting_Status__c, Account__r.Name FROM Status__c]
      )
    );
    System.assertEquals(
      activatedContacts.size(),
      activeStatus.Total_Meetings__c
    );
    System.assertNotEquals(null, activeStatus.Last_Meeting_Date__c);
    System.assertNotEquals(null, activeStatus.First_Meeting_Date__c);
    System.assertEquals(
      CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD *
      ACTIVITIES_FOR_CONTACT_ACTIVATION,
      activeStatus.Total_Outbound_Emails__c
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
      // create Account and Contact
      Account acc = new Account(Name = 'Single Prospecting Activity Account');
      uow.registerNew(acc);

      Contact con = new Contact(
        LastName = 'Single Prospecting Activity Contact',
        AccountId = acc.Id
      );
      uow.registerRelationship(con, Contact.AccountId, acc);
      uow.registerNew(con);

      Task inboundEmailTask = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Inbound_Email_Advance__c
      );
      uow.registerRelationship(inboundEmailTask, Task.WhoId, con);
      uow.registerNew(inboundEmailTask);

      // create Account/Contact/Tasks to create OCA
      Account ocaAccount = new Account(Name = 'Account with single OCA');
      uow.registerNew(ocaAccount);

      Contact ocaContact = new Contact(
        LastName = 'Contact with single OCA',
        AccountId = ocaAccount.Id
      );
      uow.registerRelationship(ocaContact, Contact.AccountId, ocaAccount);
      uow.registerNew(ocaContact);

      for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
        Task inboundEmailTask2 = TestFactory.createEligibleActivityForFilter(
          CustomMetadataCache.setting.Inbound_Email_Advance__c
        );
        uow.registerRelationship(inboundEmailTask2, Task.WhoId, ocaContact);
        uow.registerNew(inboundEmailTask2);
      }

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

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

  }
}