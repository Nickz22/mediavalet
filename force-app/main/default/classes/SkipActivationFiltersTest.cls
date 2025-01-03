@isTest
public class SkipActivationFiltersTest {
  static final String ACCOUNT_SUPPRESSION_CRITERIA_AND = JSON.serialize(
    new FieldFilter(
      '1 AND 2',
      new List<FieldFilterRow>{
        new FieldFilterRow('Name', '=', 'Skip This Account'),
        new FieldFilterRow('AccountNumber', '=', 'Skip This Number')
      }
    )
  );

  static final String ACCOUNT_SUPPRESSION_CRITERIA_OR = JSON.serialize(
    new FieldFilter(
      '1 OR 2',
      new List<FieldFilterRow>{
        new FieldFilterRow('Name', '=', 'Skip This Account'),
        new FieldFilterRow('AccountNumber', '=', 'Skip This Number')
      }
    )
  );

  static final String ACCOUNT_SUPPRESSION_CRITERIA_AND_OR = JSON.serialize(
    new FieldFilter(
      '(1 OR (2 AND 3))',
      new List<FieldFilterRow>{
        new FieldFilterRow('Name', '=', 'Skip This Account'),
        new FieldFilterRow('AccountNumber', '=', 'Skip This Number'),
        new FieldFilterRow(
          'Sic',
          C.FilterLogicOperator.STARTS.toString(),
          'hello'
        )
      }
    )
  );

  static final String OPPORTUNITY_SUPPRESSION_CRITERIA_AND = JSON.serialize(
    new FieldFilter(
      '1 AND 2',
      new List<FieldFilterRow>{
        new FieldFilterRow('Name', '=', 'Skip This Opportunity'),
        new FieldFilterRow(
          'StageName',
          '=',
          TestFactory.openOpportunityStages[0]
        )
      }
    )
  );

  @isTest
  static void whenAccountMeetsANDSkipCriteria_andNewProspectingActivityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Inbound_Email_Advance__c,
        uow
      );

      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    Assert.areEqual(0, [SELECT COUNT() FROM Status__c]);
  }

  @isTest
  static void whenAccountMeetsORSkipCriteria_andNewProspectingActivityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_OR;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Inbound_Email_Advance__c,
        uow
      );

      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Valid Account Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    Assert.areEqual(0, [SELECT COUNT() FROM Status__c]);
  }

  @isTest
  static void whenAccountMeetsANDORSkipCriteria_andNewProspectingActivityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND_OR;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );

      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Skip This Number';
      acc.Sic = 'hello world';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    Assert.areEqual(0, [SELECT COUNT() FROM Status__c]);
  }

  @isTest
  static void whenAccountDoesNotMeetANDORSkipCriteria_andNewProspectingActivityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.enableActivateAutomatically = true;
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );

      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Skip This Number';
      acc.Sic = 'hi world';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }

    Assert.areEqual(1, [SELECT COUNT() FROM Status__c]);
  }

  @isTest
  static void whenAccountMeetsSkipCriteria_andNewMeetingIsSetViaEvent_thenAccountIsNotActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withEventMeetingObject = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.enableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because account meets skip criteria'
      );

      Event event = TestFactory.createEligibleEventForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      event.WhoId = [SELECT Id FROM Contact LIMIT 1][0].Id;
      event.WhatId = [SELECT Id FROM Account LIMIT 1][0].Id;
      Test.startTest();
      insert event;
      Test.stopTest();
    }

    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Status__c],
      'event should not have activated the account since the account met skip criteria'
    );
  }

  @isTest
  static void whenAccountDoesNotMeetSkipCriteria_andNewMeetingIsSetViaEvent_thenAccountIsActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withEventMeetingObject = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Event event = TestFactory.createEligibleEventForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      event.WhoId = [SELECT Id FROM Contact LIMIT 1][0].Id;
      event.WhatId = [SELECT Id FROM Account LIMIT 1][0].Id;

      CustomMetadataCache.enableActivateAutomatically = true;
      Test.startTest();
      insert event;
      Test.stopTest();
    }

    Assert.areEqual(
      1,
      [SELECT COUNT() FROM Status__c],
      'event should have activated the account since the account did not meet skip criteria'
    );
  }

  @isTest
  static void whenAccountMeetsSkipCriteria_andNewMeetingIsSetViaTask_thenAccountIsNotActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withTaskMeetingObject = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.enableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because account meets skip criteria'
      );

      Task task = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      task.WhoId = [SELECT Id FROM Contact LIMIT 1][0].Id;
      task.WhatId = [SELECT Id FROM Account LIMIT 1][0].Id;
      Test.startTest();
      insert task;
      Test.stopTest();
    }

    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Status__c],
      'task should not have activated the account since the account met skip criteria'
    );
  }

  @isTest
  static void whenAccountDoesNotMeetSkipCriteria_andNewMeetingIsSetViaTask_thenAccountIsActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withTaskMeetingObject = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );

      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Task task = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Outbound_Meeting_Advance__c
      );
      task.WhoId = [SELECT Id FROM Contact LIMIT 1][0].Id;
      task.WhatId = [SELECT Id FROM Account LIMIT 1][0].Id;

      CustomMetadataCache.enableActivateAutomatically = true;
      Test.startTest();
      insert task;
      Test.stopTest();
    }

    Assert.areEqual(
      1,
      [SELECT COUNT() FROM Status__c],
      'task should have activated the account since the account did not meet skip criteria'
    );
  }

  @isTest
  static void whenAccountMeetsSkipCriteria_andNewOpportunityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.enableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because account meets skip criteria'
      );

      Opportunity opp = TestFactory.createOpportunity(
        [SELECT Id FROM Account LIMIT 1]
        .Id,
        false
      );
      Test.startTest();
      insert opp;
      Test.stopTest();
    }

    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Status__c],
      'opportunity should not have activated the account since the account met the skip criteria'
    );
  }

  @isTest
  static void whenAccountDoesNotMeetSkipCriteria_andNewOpportunityIsCreated_thenAccountIsActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      // set skip details
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Skip This Number';
      uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0] = acc;

      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Opportunity opp = TestFactory.createOpportunity(
        [SELECT Id FROM Account LIMIT 1]
        .Id,
        false
      );

      CustomMetadataCache.enableActivateAutomatically = true;
      Test.startTest();
      insert opp;
      Test.stopTest();
    }

    Assert.areEqual(
      1,
      [SELECT COUNT() FROM Status__c],
      'opportunity should have activated the account since the account did not meet the skip criteria'
    );
  }

  @isTest
  static void whenOpportunityMeetsSkipCriteria_andNewOpportunityIsCreated_thenAccountIsNotActivated() {
    CustomMetadataCache.withOpportunitySuppressionCriteria = OPPORTUNITY_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Opportunity opp = TestFactory.createOpportunity(
        [SELECT Id FROM Account LIMIT 1]
        .Id,
        true
      );
      opp.Name = 'Skip This Opportunity';
      opp.StageName = TestFactory.openOpportunityStages[0];
      Test.startTest();
      insert opp;
      Test.stopTest();
    }

    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Status__c],
      'opportunity should not have activated the account since the opportunity met the skip criteria'
    );
  }

  @isTest
  static void whenOpportunityDoesNotMeetSkipCriteria_andAccountMeetsSkipCriteria_thenAccountIsNotActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withOpportunitySuppressionCriteria = OPPORTUNITY_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Skip This Account';
      acc.AccountNumber = 'Skip This Number';
      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Opportunity opp = TestFactory.createOpportunity(
        [SELECT Id FROM Account LIMIT 1]
        .Id,
        true
      );
      opp.Name = 'Valid Opportunity';
      opp.StageName = TestFactory.openOpportunityStages[0];
      Test.startTest();
      insert opp;
      Test.stopTest();
    }

    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Status__c],
      'opportunity should not have activated the account since the account met the skip criteria'
    );
  }

  @isTest
  static void whenOpportunityDoesNotMeetSkipCriteria_andAccountDoesNotMeetsSkipCriteria_thenAccountIsActivated() {
    CustomMetadataCache.withAccountSuppressionCriteria = ACCOUNT_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.withOpportunitySuppressionCriteria = OPPORTUNITY_SUPPRESSION_CRITERIA_AND;
    CustomMetadataCache.enableActivationViaOpportunityCreationAutomatically = true;
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      CustomMetadataCache.disableActivateAutomatically = true;
      TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Gift_Advance1__c,
        uow
      );
      Account acc = (Account) uow.m_newListByType.get(
        Account.SObjectType.getDescribe().getName()
      )[0];
      acc.Name = 'Valid Account';
      acc.AccountNumber = 'Valid Account Number';
      uow.commitWork();

      Assert.areEqual(
        0,
        [SELECT COUNT() FROM Status__c],
        'Status should not have been created because automatic activation is disabled'
      );

      Opportunity opp = TestFactory.createOpportunity(
        [SELECT Id FROM Account LIMIT 1]
        .Id,
        true
      );
      opp.Name = 'Valid Opportunity';
      opp.StageName = TestFactory.openOpportunityStages[0];
      Test.startTest();
      insert opp;
      Test.stopTest();
    }

    Assert.areEqual(
      1,
      [SELECT COUNT() FROM Status__c],
      'opportunity should have activated the account since the account did not meet the skip criteria'
    );
  }
}