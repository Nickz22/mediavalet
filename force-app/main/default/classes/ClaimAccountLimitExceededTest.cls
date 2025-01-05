@isTest
public class ClaimAccountLimitExceededTest {
  static final String ACCOUNT_NAME_PREFIX = 'Test Account';
  static final Integer SIMULTANEOUS_CLAIM_LIMIT = 8;

  @isTest
  static void given() {
    simultaneousClaimsPerRepIsEight();
    eightClaimedAccounts();
    oneUnclaimedAccount();
  }

  @isTest
  static void whenClaimingExceedsLimit_verifyErrorMessageIsShown() {
    System.runAs(TestFactory.ioAgent) {
      // Get the unclaimed Account record
      Account unclaimedAccount = [
        SELECT Id
        FROM Account
        WHERE Id NOT IN (SELECT Account__c FROM Status__c)
        LIMIT 1
      ];

      // Create a new instance of ActivateAccountBtnController
      ApexPages.StandardController stdController = new ApexPages.StandardController(
        unclaimedAccount
      );
      ActivateAccountBtnController controller = new ActivateAccountBtnController(
        stdController
      );

      Test.startTest();
      controller.init();
      Test.stopTest();

      // Expect error message to be displayed
      System.assertEquals(
        true,
        String.isNotBlank(controller.errorMessage),
        'expecting member errorMessage to be set'
      );

      System.assertEquals(
        String.format(
            Label.Number_of_Simultaneous_Claims_per_Rep_Error,
            new List<String>{
              String.valueOf(
                new SettingsSelector()
                  .selectSetting()
                  .Number_of_Simultaneous_Claims_per_Rep__c
              )
            }
          )
          .escapeEcmaScript(),
        controller.errorMessage
      );
    }
  }

  static void simultaneousClaimsPerRepIsEight() {
    Settings__mdt setting = new SettingsSelector().selectSetting();
    System.assertEquals(
      SIMULTANEOUS_CLAIM_LIMIT,
      setting.Number_of_Simultaneous_Claims_per_Rep__c
    );

    System.assertEquals(true, setting.Limit_Number_of_Claims__c);
  }

  static void eightClaimedAccounts() {
    System.assertEquals(
      SIMULTANEOUS_CLAIM_LIMIT,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE Account__c != NULL AND Claimed_By__c = :TestFactory.ioAgent.Id
      ]
    );
  }

  static void oneUnclaimedAccount() {
    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Account
        WHERE Id NOT IN (SELECT Account__c FROM Status__c)
      ]
    );
  }

  @TestSetup
  static void setup() {
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Account.SObjectType, Status__c.SObjectType }
      );

      // Create five claimed accounts and one unclaimed account
      for (Integer i = 0; i <= SIMULTANEOUS_CLAIM_LIMIT; i++) {
        // Create a new Account
        Account a = new Account();
        a.Name = ACCOUNT_NAME_PREFIX + i;
        a.Territory__c = 'United States';

        uow.registerNew(a);

        // Create a new Status record associated with the Account
        if (i < SIMULTANEOUS_CLAIM_LIMIT) {
          Status__c s = new Status__c();
          s.Account__c = a.Id;
          s.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_CLAIMED;
          // First 8 Accounts are claimed
          s.Claimed_By__c = TestFactory.ioAgent.Id;
          uow.registerRelationship(s, Status__c.Account__c, a);
          uow.registerNew(s);
        } // The last Account is unclaimed
      }

      // Commit the Unit of Work
      uow.commitWork();
    }
  }
}
