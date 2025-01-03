@isTest
public class BlockAccountClaimWithinCoolOffPeriodTest {
  static final String COOLED_OFF_UNRESPONSIVE_ACCOUNT_NAME = 'Cool Unresponsive Account';
  static final String UNRESPONSIVE_ACCOUNT_NAME = 'Unresponsive Account';
  static final String NURTURE_ACCOUNT_NAME = 'Nurture Account';
  static final String OPPORTUNITY_CREATED_ACCOUNT_NAME = 'Opportunity Created Account';

  @isTest
  static void given() {
    coolingOffPeriodIsThirtyDays();
    oneAccountWithOpportunityCreatedOutboundStatusFiftyDaysAgo();
    oneAccountWithUnresponsiveOutboundStatusTwoDaysAgo();
    oneAccountWithCooledOffUnresponsiveStatusSetThirtyOneDaysAgo();
    oneAccountWithNurtureStatusSeventeenDaysAgoAndFollowupDateInTwentyNineDays();
  }

  @isTest
  static void whenCoolingOffPeriodHasNotYetPassed_verifyUnresponsiveAccountClaimIsBlocked() {
    System.runAs(TestFactory.ioAgent) {
      // Get the Account record
      Account testAccount = [
        SELECT Id
        FROM Account
        WHERE Name = :UNRESPONSIVE_ACCOUNT_NAME
        LIMIT 1
      ];

      // Create a new instance of ActivateAccountBtnController
      ApexPages.StandardController stdController = new ApexPages.StandardController(
        testAccount
      );
      ActivateAccountBtnController controller = new ActivateAccountBtnController(
        stdController
      );

      Test.startTest();
      controller.init();
      Test.stopTest();
      System.assertNotEquals(
        '',
        controller.errorMessage,
        'expecting member errorMessage to be set'
      );
      // get status__c related to account
      Status__c status = [
        SELECT Unresponsive_Date__c
        FROM Status__c
        WHERE Account__c = :testAccount.Id
        LIMIT 1
      ];
      System.assertEquals(
        String.format(
            Label.Account_Activation_Wait_Period_Error,
            new List<String>{
              String.valueOf(
                new SettingsSelector().selectSetting().Wait_Period__c -
                (status.Unresponsive_Date__c.daysBetween(Date.today()))
              )
            }
          )
          .escapeEcmaScript(),
        controller.errorMessage
      );
    }
  }

  @isTest
  static void whenFollowupDateHasNotYetPassed_verifyNurturingAccountClaimIsBlocked() {
    System.runAs(TestFactory.ioAgent) {
      // Get the Account record
      Account testAccount = [
        SELECT Id
        FROM Account
        WHERE Name = :NURTURE_ACCOUNT_NAME
        LIMIT 1
      ];

      // Create a new instance of ActivateAccountBtnController
      ApexPages.StandardController stdController = new ApexPages.StandardController(
        testAccount
      );
      ActivateAccountBtnController controller = new ActivateAccountBtnController(
        stdController
      );

      Test.startTest();
      controller.init();
      Test.stopTest();
      System.assertNotEquals(
        '',
        controller.errorMessage,
        'expecting member errorMessage to be set'
      );
      // get status__c related to account
      Status__c status = [
        SELECT Follow_up_date__c
        FROM Status__c
        WHERE Account__c = :testAccount.Id
        LIMIT 1
      ];
      System.assertEquals(
        String.format(
            Label.Account_Currently_In_Nurture,
            new List<String>{
              String.valueOf(Date.today().daysBetween(status.Follow_up_Date__c))
            }
          )
          .escapeEcmaScript(),
        controller.errorMessage
      );
    }
  }

  @isTest
  static void whenCoolingOffPeriodHasPassed_verifyUnresponsiveAccountClaimIsAllowed() {
    System.runAs(TestFactory.ioAgent) {
      // Get the Account record
      Account testAccount = [
        SELECT Id
        FROM Account
        WHERE Name = :COOLED_OFF_UNRESPONSIVE_ACCOUNT_NAME
        LIMIT 1
      ];

      Status__c cooledOffStatus = [
        SELECT Id
        FROM Status__c
        WHERE Account__c = :testAccount.Id
        LIMIT 1
      ];

      // Create a new instance of ActivateAccountBtnController
      ApexPages.StandardController stdController = new ApexPages.StandardController(
        testAccount
      );
      ActivateAccountBtnController controller = new ActivateAccountBtnController(
        stdController
      );

      Test.startTest();
      controller.init();
      Test.stopTest();
      System.assertEquals(
        true,
        String.isBlank(controller.errorMessage),
        'expecting member errorMessage to be blank'
      );

      // assert the presence of a new Status__c related to the account
      Status__c status = [
        SELECT Prospecting_Status__c, Claimed_By__c
        FROM Status__c
        WHERE Account__c = :testAccount.Id AND Id != :cooledOffStatus.Id
        LIMIT 1
      ];
      System.assertEquals(
        C.OUTBOUND_PROSPECTING_STATUS_CLAIMED,
        status.Prospecting_Status__c,
        'expected new status to have a prospecting status of Claimed'
      );
      System.assertEquals(
        UserInfo.getUserId(),
        Id.valueOf(status.Claimed_By__c),
        'expected new status to have a Claimed_By__c of the current user'
      );
    }
  }

  static void coolingOffPeriodIsThirtyDays() {
    System.assertEquals(
      30.0,
      new SettingsSelector().selectSetting().Wait_Period__c
    );
  }

  static void oneAccountWithOpportunityCreatedOutboundStatusFiftyDaysAgo() {
    // assert details
    Account opportunityCreatedAccount = [
      SELECT Id
      FROM Account
      WHERE Name = :OPPORTUNITY_CREATED_ACCOUNT_NAME
      LIMIT 1
    ];

    Opportunity testOpportunity = [
      SELECT Id
      FROM Opportunity
      WHERE AccountId = :opportunityCreatedAccount.Id
      LIMIT 1
    ];

    List<Status__c> opportunityCreatedStatus = [
      SELECT Opportunity_Created_Date__c
      FROM Status__c
      WHERE
        Account__c = :opportunityCreatedAccount.Id
        AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
    ];
    System.assertEquals(
      1,
      opportunityCreatedStatus.size(),
      'Should be one opportunity created status\n' +
      JSON.serialize(
        [
          SELECT Account__c, Opportunity__c, Prospecting_Status__c
          FROM Status__c
          WHERE Opportunity_Created_Date__c != NULL
        ]
      )
    );

    System.assertEquals(
      Date.today().addDays(-50),
      opportunityCreatedStatus[0].Opportunity_Created_Date__c
    );
  }

  static void oneAccountWithUnresponsiveOutboundStatusTwoDaysAgo() {
    // assert details
    Account unresponsiveAccount = [
      SELECT Id
      FROM Account
      WHERE Name = :UNRESPONSIVE_ACCOUNT_NAME
      LIMIT 1
    ];

    Status__c unresponsiveStatus = [
      SELECT Unresponsive_Date__c
      FROM Status__c
      WHERE
        Account__c = :unresponsiveAccount.Id
        AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
      LIMIT 1
    ];

    System.assertEquals(
      Date.today().addDays(-2),
      unresponsiveStatus.Unresponsive_Date__c
    );
  }

  static void oneAccountWithCooledOffUnresponsiveStatusSetThirtyOneDaysAgo() {
    Account cooledOffUnresponsiveAccount = [
      SELECT Id
      FROM Account
      WHERE Name = :COOLED_OFF_UNRESPONSIVE_ACCOUNT_NAME
      LIMIT 1
    ];

    Status__c cooledOffUnresponsiveStatus = [
      SELECT Unresponsive_Date__c
      FROM Status__c
      WHERE
        Account__c = :cooledOffUnresponsiveAccount.Id
        AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE
      LIMIT 1
    ];

    System.assertEquals(
      Date.today().addDays(-31),
      cooledOffUnresponsiveStatus.Unresponsive_Date__c
    );
  }

  static void oneAccountWithNurtureStatusSeventeenDaysAgoAndFollowupDateInTwentyNineDays() {
    Account nurtureAccount = [
      SELECT Id
      FROM Account
      WHERE Name = :NURTURE_ACCOUNT_NAME
      LIMIT 1
    ];
    Status__c nurtureStatus = [
      SELECT Nurture_Date__c, Follow_up_date__c
      FROM Status__c
      WHERE
        Account__c = :nurtureAccount.Id
        AND Prospecting_Status__c = 'Nurture'
      LIMIT 1
    ];

    System.assertEquals(
      Date.today().addDays(-17),
      nurtureStatus.Nurture_Date__c
    );

    System.assertEquals(
      Date.today().addDays(29),
      nurtureStatus.Follow_up_date__c
    );
  }

  @TestSetup
  static void setup() {
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Opportunity.SObjectType,
          Status__c.SObjectType
        }
      );
      // create nurture account
      Account nurtureAccount = new Account(Name = NURTURE_ACCOUNT_NAME);

      uow.registerNew(nurtureAccount);

      Status__c nurtureStatus = new Status__c(
        Account__c = nurtureAccount.Id,
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_NURTURE,
        Nurture_Date__c = Date.today().addDays(-17),
        Follow_up_Date__c = Date.today().addDays(29)
      );
      uow.registerRelationship(
        nurtureStatus,
        Status__c.Account__c,
        nurtureAccount
      );
      uow.registerNew(nurtureStatus);

      // create unresponsive account
      Account unresponsiveAccount = new Account(
        Name = UNRESPONSIVE_ACCOUNT_NAME
      );
      uow.registerNew(unresponsiveAccount);

      Status__c unresponsiveStatus = new Status__c(
        Account__c = unresponsiveAccount.Id,
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE,
        Unresponsive_Date__c = Date.today().addDays(-2)
      );
      uow.registerRelationship(
        unresponsiveStatus,
        Status__c.Account__c,
        unresponsiveAccount
      );
      uow.registerNew(unresponsiveStatus);

      // create cooled off unresponsive account
      Account cooledOffUnresponsiveAccount = new Account(
        Name = COOLED_OFF_UNRESPONSIVE_ACCOUNT_NAME
      );
      uow.registerNew(cooledOffUnresponsiveAccount);

      Status__c cooledOffUnresponsiveStatus = new Status__c(
        Account__c = cooledOffUnresponsiveAccount.Id,
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE,
        Unresponsive_Date__c = Date.today().addDays(-31)
      );
      uow.registerRelationship(
        cooledOffUnresponsiveStatus,
        Status__c.Account__c,
        cooledOffUnresponsiveAccount
      );
      uow.registerNew(cooledOffUnresponsiveStatus);

      // create opportunity created account
      Account opportunityCreatedAccount = new Account(
        Name = OPPORTUNITY_CREATED_ACCOUNT_NAME
      );
      uow.registerNew(opportunityCreatedAccount);

      Opportunity testOpportunity = new Opportunity(
        Name = 'Test Opportunity',
        StageName = 'Closed Won',
        CloseDate = Date.today().addDays(-5)
      );
      uow.registerRelationship(
        testOpportunity,
        Opportunity.AccountId,
        opportunityCreatedAccount
      );
      uow.registerNew(testOpportunity);

      Status__c opportunityCreatedStatus = new Status__c(
        Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED,
        Opportunity_Created_Date__c = Date.today().addDays(-50)
      );
      uow.registerRelationship(
        opportunityCreatedStatus,
        Status__c.Opportunity__c,
        testOpportunity
      );
      uow.registerRelationship(
        opportunityCreatedStatus,
        Status__c.Account__c,
        opportunityCreatedAccount
      );
      uow.registerNew(opportunityCreatedStatus);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}