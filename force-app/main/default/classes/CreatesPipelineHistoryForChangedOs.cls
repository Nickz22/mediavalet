@isTest
public with sharing class CreatesPipelineHistoryForChangedOs {
  @isTest
  static void given() {
    System.runAs(TestFactory.ioAdmin) {
      Assert.areEqual(1, [SELECT COUNT() FROM Status__c]);

      Assert.areEqual(
        1,
        new PipelineHistorySelector()
          .selectHistoriesByStatusIds(Pluck.ids([SELECT Id FROM Status__c]))
          .size()
      );
    }
  }

  @isTest
  static void shouldCreatePipelineHistoryWhenProspectingStatusChanged() {
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType }
      );

      Task connectedCall = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Engaged_Call_Advance__c
      );
      connectedCall.WhoId = [SELECT Id FROM Contact WITH USER_MODE LIMIT 1].Id;
      uow.registerNew(connectedCall);

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      List<Prospecting_Effort__c> pipelineHistories = new PipelineHistorySelector()
        .selectHistoriesByStatusIds(
          Pluck.ids([SELECT Id FROM Status__c WITH USER_MODE])
        );
      Assert.areEqual(
        2,
        pipelineHistories.size(),
        'Expected 2 Pipeline Histories since the Status was created and then had its Prospecting Status changed via a connection with the prospect'
      );

      Assert.isTrue(
        pipelineHistories[0].Status__c == 'Approaching' &&
        pipelineHistories[1].Status__c == 'In Contact',
        'Pipeline Histories should have "Activated" and "Engaged" statuses, instead got ' +
        pipelineHistories[0].Status__c +
        ' and ' +
        pipelineHistories[1].Status__c
      );

      Assert.areEqual(
        0,
        pipelineHistories[1].Dials__c,
        'Engaged Pipeline History should have 0 Dials since those Dials have already been attributed to the Activated Pipeline History'
      );

      Assert.areEqual(
        1,
        pipelineHistories[1].Call_Connects__c,
        'Engaged Pipeline History should have 1 Connected Call since the Call connection was what prompted the creation of the second Pipeline History \n'
      );
    }
  }

  @TestSetup
  static void setup() {
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      uow = TestFactory.initActivatedContactData(
        CustomMetadataCache.setting.Call_Advance__c,
        uow
      );

      Test.startTest();
      uow.commitWork();
      Test.stopTest();
    }
  }
}