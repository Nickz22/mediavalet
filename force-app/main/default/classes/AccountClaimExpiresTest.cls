@isTest
public class AccountClaimExpiresTest {
  @isTest
  static void given() {
    ioLicensedUser();
    claimedAccount();
    claimPeriodOfFourDays();
  }

  static void ioLicensedUser() {
    List<PermissionSetAssignment> ioAssignments = new PermissionSetAssignmentSelector()
      .selectAssignmentsByPermissionSetNameOrderedByAssignee(
        new Set<String>{ C.OBMETRIX, C.OBMETRIX_PERFORMANCE }
      );
    Set<Id> ioAssigneeIds = Pluck.ids(ioAssignments, C.ASSIGNEE_ID);
    System.assertEquals(
      true,
      ioAssigneeIds.contains(TestFactory.ioAgent.Id),
      'IO Agent is not an IO licensed user'
    );
  }

  @isTest
  static void whenClaimPeriodPasses_verifyOutboundStatusProspectingStatusIsSetToClaimExpired() {
    Status__c claimedStatus = [SELECT Account__c FROM Status__c LIMIT 1];
    Test.setCreatedDate(claimedStatus.Id, System.now().addDays(-9));
    claimedStatus = [SELECT Account__c, CreatedDate FROM Status__c LIMIT 1];
    System.assertEquals(
      claimedStatus.CreatedDate.date(),
      System.now().addDays(-9).date()
    );
    System.runAs(TestFactory.ioAgent) {
      Test.startTest();
      AccountsClaimedBatch.runBatch();
      Test.stopTest();
    }

    System.assertEquals(
      true,
      [
        SELECT COUNT()
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'AccountsClaimedBatch' AND TotalJobItems > 0
      ] > 0,
      'expected a single asyncapexjob item with "AccountsClaimedBatch" apex class and > 1 totaljobitems'
    );

    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE
          Account__c = :claimedStatus.Account__c
          AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_CLAIM_EXPIRED
          AND Claim_Expired__c = TODAY
      ],
      'expected an expired claimed at end of test \n\n ' +
      JSON.serialize([SELECT Prospecting_Status__c FROM Status__c])
    );
  }

  @isTest
  static void whenClaimPeriodDoesNotPass_verifyOutboundStatusProspectingStatusIsNotSetToClaimExpired() {
    Status__c claimedStatus = [SELECT Account__c FROM Status__c LIMIT 1];
    Test.setCreatedDate(claimedStatus.Id, System.now().addDays(-2));
    claimedStatus = [SELECT Account__c, CreatedDate FROM Status__c LIMIT 1];
    System.assertEquals(
      claimedStatus.CreatedDate.date(),
      System.now().addDays(-2).date()
    );
    System.runAs(TestFactory.ioAgent) {
      Test.startTest();
      AccountsClaimedBatch.runBatch();
      Test.stopTest();
    }

    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'AccountsClaimedBatch' AND TotalJobItems = 0
      ],
      'expected no asyncapexjob item with "AccountsClaimedBatch" apex class'
    );

    System.assertEquals(
      0,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE
          Account__c = :claimedStatus.Account__c
          AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_CLAIM_EXPIRED
          AND Claim_Expired__c = TODAY
      ],
      'expected an expired claimed at end of test \n\n ' +
      JSON.serialize([SELECT Prospecting_Status__c FROM Status__c])
    );
  }

  static void claimedAccount() {
    List<Account> testAccount = [
      SELECT Id
      FROM Account
      WHERE Name = 'Test Account'
    ];
    System.assertEquals(
      1,
      testAccount.size(),
      'expected a single account at start of test'
    );

    System.assertEquals(
      1,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE
          Account__c = :testAccount[0].Id
          AND Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_CLAIMED
      ],
      'expected a single claimed status at start of test'
    );
  }

  static void claimPeriodOfFourDays() {
    Settings__mdt setting = new SettingsSelector().selectSetting();
    System.assertEquals(
      4,
      setting.Claim_Period__c,
      'expected a claim period of 4 at start of test'
    );
  }

  @TestSetup
  static void makeData() {
    System.runAs(TestFactory.ioAgent) {
      Account testAccount = new Account(Name = 'Test Account');
      insert testAccount;
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
      Settings__mdt setting = new SettingsSelector().selectSetting();
      setting.Claim_Period__c = 3;
    }
  }
}