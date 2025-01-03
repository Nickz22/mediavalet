@isTest
public class OpportunityCreationActivationTest {
  @isTest
  static void given() {
    System.runAs(TestFactory.ioAgent) {
      oneIoOwnedAccountWithTask();
      oneIoOwnedContactWithTask();
      oneIoOwnedAccountWithoutTask();
      oneIoOwnedContactWithoutTask();
      oneCoolingOffAccountWithTask();
      oneCooledOffStatusUnderCoolingOffAccountWithTask();
      oneActivatedAccount();
    }
  }

  static void oneCoolingOffAccountWithTask() {
    Set<Id> whoIds = Pluck.ids(
      [
        SELECT WhoId
        FROM Task
        WHERE Who.FirstName = 'cooling off contact with task'
      ],
      C.ACTIVITY_WHO_ID_FIELD
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND Name = 'cooling off account with task'
          AND Id IN (SELECT AccountId FROM Contact WHERE Id IN :whoIds)
      ]
    );
  }

  static void oneCooledOffStatusUnderCoolingOffAccountWithTask() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE
          Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
          AND Unresponsive_Date__c != NULL
          AND Account__r.Name = 'cooling off account with task'
      ]
    );
  }

  static void oneActivatedAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND Name = 'active account'
          AND Id IN (
            SELECT Account__c
            FROM Status__c
            WHERE
              Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
          )
      ]
    );
  }

  static void oneIoOwnedAccountWithTask() {
    Set<Id> whoIds = Pluck.ids(
      [SELECT WhoId FROM Task],
      C.ACTIVITY_WHO_ID_FIELD
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND Name = 'account with task'
          AND Id IN (SELECT AccountId FROM Contact WHERE Id IN :whoIds)
      ]
    );
  }

  static void oneIoOwnedContactWithTask() {
    Set<Id> whoIds = Pluck.ids(
      [SELECT WhoId FROM Task],
      C.ACTIVITY_WHO_ID_FIELD
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND FirstName = 'contact with task'
          AND LastName = 'contact with task'
          AND Id IN :whoIds
      ]
    );
  }

  static void oneIoOwnedAccountWithoutTask() {
    Set<Id> whoIds = Pluck.ids(
      [SELECT WhoId FROM Task],
      C.ACTIVITY_WHO_ID_FIELD
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND Name = 'account without task'
          AND Id NOT IN (SELECT AccountId FROM Contact WHERE Id IN :whoIds)
      ]
    );
  }

  static void oneIoOwnedContactWithoutTask() {
    Set<Id> whoIds = Pluck.ids(
      [SELECT WhoId FROM Task],
      C.ACTIVITY_WHO_ID_FIELD
    );
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          OwnerId = :TestFactory.ioAgent.Id
          AND FirstName = 'contact without task'
          AND LastName = 'contact without task'
          AND Id NOT IN :whoIds
      ]
    );
  }

  @isTest
  static void whenOpportunityIsCreatedAndProspectingActivityExists_thenAccountIsActivated() {
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    CustomMetadataCache.enableActivateAutomatically = true;

    Account accountWithTask = [
      SELECT Id
      FROM Account
      WHERE Name = 'account with task'
      LIMIT 1
    ];
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Opportunity.SObjectType }
      );
      Opportunity o = new Opportunity(
        Name = 'opportunity with task',
        AccountId = accountWithTask.Id,
        CloseDate = Date.today(),
        StageName = 'Prospecting',
        Amount = 100
      );
      uow.registerRelationship(o, Opportunity.AccountId, accountWithTask);
      uow.registerNew(o);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
    System.runAs(TestFactory.ioAdmin) {
      Status__c status = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ accountWithTask.Id }
        )[0];
      System.assertEquals(
        C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
        status.Prospecting_Status__c
      );
    }
  }

  @isTest
  static void whenOpportunityIsCreatedAndNoProspectingActivityExists_thenAccountIsNotActivated() {
    System.runAs(TestFactory.ioAgent) {
      CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
      CustomMetadataCache.enableActivateAutomatically = true;

      Account accountWithoutTask = [
        SELECT Id
        FROM Account
        WHERE Name = 'account without task'
        LIMIT 1
      ];
      System.runAs(TestFactory.ioAgent) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
          new List<SObjectType>{ Opportunity.SObjectType }
        );
        Opportunity o = new Opportunity(
          Name = 'opportunity without task',
          AccountId = accountWithoutTask.Id,
          CloseDate = Date.today(),
          StageName = 'Prospecting',
          Amount = 100
        );
        uow.registerRelationship(o, Opportunity.AccountId, accountWithoutTask);
        uow.registerNew(o);

        Test.startTest();
        uow.commitWork();
        Test.stopTest();
      }
      List<Status__c> status = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ accountWithoutTask.Id }
        );
      System.assertEquals(0, status.size());
    }
  }

  @isTest
  private static void whenOpportunityIsCreatedWhileAccountIsAlreadyActive_thenStatusSetToOpportunityCreated() {
    Account activatedAccount;
    System.runAs(TestFactory.ioAgent) {
      CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
      CustomMetadataCache.enableActivateAutomatically = true;

      activatedAccount = [
        SELECT Id
        FROM Account
        WHERE Name = 'active account'
        LIMIT 1
      ];

      List<Status__c> statuses = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ activatedAccount.Id }
        );
      System.assertEquals(1, statuses.size());
      System.assertEquals(
        statuses[0].Prospecting_Status__c,
        C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED
      );
      System.assertEquals(statuses[0].Activated_Date__c, Date.today());
      System.assertEquals(null, statuses[0].Opportunity_Created_Date__c);
      System.assertEquals(null, statuses[0].Opportunity__c);

      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Opportunity.SObjectType }
      );
      Opportunity o = new Opportunity(
        Name = 'opportunity with task',
        CloseDate = Date.today(),
        StageName = 'Prospecting',
        Amount = 100
      );
      uow.registerRelationship(o, Opportunity.AccountId, activatedAccount);
      uow.registerNew(o);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
    System.runAs(TestFactory.ioAdmin) {
      List<Status__c> statuses = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ activatedAccount.Id }
        );
      System.assertEquals(1, statuses.size());
      System.assertEquals(
        statuses[0].Prospecting_Status__c,
        C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
      );
      System.assertEquals(
        statuses[0].Opportunity_Created_Date__c,
        Date.today()
      );
      System.assert(statuses[0].Opportunity__c != null);
      System.assertEquals(100, statuses[0].Opportunity_Amount__c);
    }
  }

  @isTest
  static void whenOpportunityIsCreatedUnderCoolingOffAccount_thenAccountIsNotActivated() {
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    CustomMetadataCache.enableActivateAutomatically = true;

    Account coolingOffAccountWithTask = [
      SELECT Id
      FROM Account
      WHERE Name = 'cooling off account with task'
      LIMIT 1
    ];
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Opportunity.SObjectType }
      );
      Opportunity o = new Opportunity(
        Name = 'opportunity with task',
        CloseDate = Date.today(),
        StageName = 'Prospecting',
        Amount = 100
      );
      uow.registerRelationship(
        o,
        Opportunity.AccountId,
        coolingOffAccountWithTask
      );
      uow.registerNew(o);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
    // filter out unresponsive status from setup
    List<Status__c> status = [
      SELECT Id
      FROM Status__c
      WHERE
        Account__c = :coolingOffAccountWithTask.Id
        AND (Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
        OR Prospecting_Status__c IN :C.ACTIVE_OUTBOUND_PROSPECTING_STATUSES)
    ];
    System.assertEquals(0, status.size());
  }

  @TestSetup
  static void makeData() {
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType,
          Status__c.SObjectType
        }
      );
      //   create account/contact with one prospecting activity
      Account accountWithTask = new Account(Name = 'account with task');
      uow.registerNew(accountWithTask);

      Contact contactWithTask = new Contact(
        FirstName = 'contact with task',
        LastName = 'contact with task'
      );
      uow.registerRelationship(
        contactWithTask,
        Contact.AccountId,
        accountWithTask
      );
      uow.registerNew(contactWithTask);

      Task t = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Inbound_Email_Advance__c
      );
      uow.registerRelationship(t, Task.WhoId, contactWithTask);
      uow.registerNew(t);

      // create account/contact with no prospecting activity
      Account accountWithoutTask = new Account(Name = 'account without task');
      uow.registerNew(accountWithoutTask);

      Contact contactWithoutTask = new Contact(
        FirstName = 'contact without task',
        LastName = 'contact without task'
      );
      uow.registerRelationship(
        contactWithoutTask,
        Contact.AccountId,
        accountWithoutTask
      );
      uow.registerNew(contactWithoutTask);

      // create cooling off account/contact with prospecting activity
      Account coolingOffAccountWithTask = new Account(
        Name = 'cooling off account with task'
      );

      uow.registerNew(coolingOffAccountWithTask);

      Contact coolingOffContactWithTask = new Contact(
        FirstName = 'cooling off contact with task',
        LastName = 'cooling off contact with task'
      );

      uow.registerRelationship(
        coolingOffContactWithTask,
        Contact.AccountId,
        coolingOffAccountWithTask
      );

      uow.registerNew(coolingOffContactWithTask);

      Task coolingOffTask = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Inbound_Email_Advance__c
      );

      uow.registerRelationship(
        coolingOffTask,
        Task.WhoId,
        coolingOffContactWithTask
      );
      uow.registerNew(coolingOffTask);

      Date coolOffThreshold = Date.today()
        .addDays(
          -(Integer.valueOf(CustomMetadataCache.setting.Wait_Period__c))
        );
      Status__c coolOffStatus = new Status__c(
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE,
        Unresponsive_Date__c = coolOffThreshold
      );
      uow.registerRelationship(
        coolOffStatus,
        Status__c.Account__c,
        coolingOffAccountWithTask
      );
      uow.registerNew(coolOffStatus);

      // create account/contact with active status
      Account activatedAccount = new Account(Name = 'active account');
      uow.registerNew(activatedAccount);

      Contact activeContactWithTask = new Contact(
        FirstName = 'active contact',
        LastName = 'active contact'
      );

      uow.registerRelationship(
        activeContactWithTask,
        Contact.AccountId,
        activatedAccount
      );
      uow.registerNew(activeContactWithTask);

      Status__c activeStatus = new Status__c(
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_ACTIVATED,
        Activated_Date__c = Date.today()
      );
      uow.registerRelationship(
        activeStatus,
        Status__c.Account__c,
        activatedAccount
      );
      uow.registerNew(activeStatus);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}