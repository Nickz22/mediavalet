@isTest
public with sharing class NewOpportunityValueRollupTest {
  @isTest
  static void given() {
    System.runAs(TestFactory.ioAdmin) {
      ioLicensedUser();
      oneAccount();
      oneOutboundStatus();
      totalOpportunityValueSettingSetToAmount();
    }
  }

  @isTest
  static void whenICreateNewOpportunity_thenStatusOpportunityValueIncreasesByOpportunityValue() {
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      Account testAccount = new AccountSelector()
        .selectAccountsByIds(
          Pluck.ids([SELECT Id FROM Account], C.ID_FIELD)
        )[0];
      Opportunity testOpportunity = new Opportunity(
        Name = 'test opportunity',
        AccountId = testAccount.Id,
        Amount = 1000,
        StageName = TestFactory.getOpenOpportunityStageName(),
        CloseDate = Date.today().addDays(10)
      );

      Test.startTest();
      insert testOpportunity;
      Test.stopTest();

      Status__c testStatus = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ testAccount.Id }
        )[0];
      System.assertEquals(
        1000,
        testStatus.Opportunity_Amount__c,
        'Opportunity Amount field on Status record should be 1000'
      );
      testOpportunity.Amount = 2000;
      update testOpportunity;
      testStatus = new StatusSelector()
        .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
          new Set<Id>{ testAccount.Id }
        )[0];
      System.assertEquals(
        2000,
        testStatus.Opportunity_Amount__c,
        'Total Opportunities Amount field on Status record should be 2000'
      );
    }
  }

  @TestSetup
  static void makeData() {
    System.runAs(TestFactory.ioAgent) {
      Account testAccount = new Account(Name = 'test account');
      insert testAccount;
      TestFactory.activateAccount(testAccount.Id);
    }
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

  static void oneAccount() {
    List<Account> account = [
      SELECT Id
      FROM Account
      WHERE
        Id IN (
          SELECT Account__c
          FROM Status__c
          WHERE Prospecting_Status__c = 'Claimed'
        )
    ];
    System.assertEquals(
      1,
      account.size(),
      'expected a single account at start of test'
    );
  }

  static void oneOutboundStatus() {
    List<Status__c> outboundStatuses = new StatusSelector()
      .selectStatusByAccountOrderedByExpiredAndDeactivatedDate(
        new Set<Id>{ [SELECT Id FROM Account][0].Id }
      );
    System.assertEquals(
      1,
      outboundStatuses.size(),
      'expected a single outbound status at start of test'
    );
  }

  static void totalOpportunityValueSettingSetToAmount() {
    Settings__mdt setting = new SettingsSelector().selectSetting();
    System.assertEquals(
      setting.Opportunity_Value_Field__c,
      C.OPPORTUNITY_AMOUNT_FIELD
    );
  }
}