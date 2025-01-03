@isTest
public with sharing class UpdatedOpportunityValueRollupTest {
  @isTest
  static void given() {
    System.runAs(TestFactory.ioAgent) {
      ioLicensedUser();
      oneAccount();
      oneOpportunity();
      oneOutboundStatus();
      totalOpportunityValueSettingSetToAmount();
    }
  }

  @isTest
  static void whenIUpdateNewOpportunity_thenStatusOpportunityValueIncreasesByOpportunityValue() {
    System.runAs(TestFactory.ioAgent) {
      Set<Id> accountIds = Pluck.ids([SELECT Id FROM Account], C.ID_FIELD);
      Account testAccount = new AccountSelector()
        .selectAccountsByIds(accountIds)[0];
      Opportunity testOpportunity = new OpportunitySelector()
        .selectOpportunitiesByAccountIds(accountIds)[0];
      testOpportunity.Amount = 2000;
      update testOpportunity;
      Status__c testStatus = new StatusSelector()
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
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
        )
    ];
    System.assertEquals(
      1,
      account.size(),
      JSON.serializePretty(
        [SELECT Account__r.Name, Prospecting_Status__c FROM Status__c]
      )
    );
  }

  static void oneOpportunity() {
    List<Opportunity> opportunity = [SELECT Id FROM Opportunity];
    System.assertEquals(
      1,
      opportunity.size(),
      'expected a single opportunity at start of test'
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

  @TestSetup
  static void makeData() {
    CustomMetadataCache.enableActivateAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      Account testAccount = new Account(Name = 'test account');
      insert testAccount;
      TestFactory.activateAccount(testAccount.Id);
      Opportunity testOpportunity = new Opportunity(
        Name = 'test opportunity',
        AccountId = testAccount.Id,
        Amount = 1000,
        StageName = TestFactory.getOpenOpportunityStageName(),
        CloseDate = Date.today().addDays(10)
      );
      insert testOpportunity;
    }
  }
}