@isTest
public class CreatesPipelineHistoryForNewOs {
  @isTest
  static void shouldCreatePipelineHistoriesForEachNewOs() {
    System.runAs(TestFactory.ioAdmin) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      for (Integer i = 0; i < 2; i++) {
        uow = TestFactory.initActivatedContactData(
          CustomMetadataCache.setting.Call_Advance__c,
          uow
        );
      }

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      Assert.areEqual(2, [SELECT COUNT() FROM Status__c WITH USER_MODE]);

      List<Prospecting_Effort__c> pipelineHistories = new PipelineHistorySelector()
        .selectHistoriesByStatusIds(Pluck.ids([SELECT Id FROM Status__c]));
      Assert.areEqual(
        2,
        pipelineHistories.size(),
        'Pipeline History records should be created for each new OS'
      );
      Assert.areEqual(
        'Approaching',
        pipelineHistories[0].Status__c,
        'Pipeline history should be activated since corresponding OS is activated'
      );
      Assert.areEqual(
        'Approaching',
        pipelineHistories[1].Status__c,
        'Pipeline history should be activated since corresponding OS is activated'
      );
      Assert.isNotNull(
        pipelineHistories[0].Activated_By__c,
        'Pipeline history should have its Activated By lookup set'
      );

      Assert.isNotNull(
        pipelineHistories[1].Activated_By__c,
        'Pipeline history should have its Activated By lookup set'
      );

      Set<Id> taskIds = new Set<Id>();
      for (Prospecting_Effort__c ph : pipelineHistories) {
        for (String taskId : ph.Task_Ids__c.split(',')) {
          Assert.isFalse(
            taskIds.contains(taskId),
            'Task Ids should be unique in Pipeline History Task Ids field'
          );
          Assert.areEqual(
            Task.SObjectType,
            Id.valueOf(taskId).getSobjectType(),
            'Pipeline History Task Ids field should be comprised of Task Ids'
          );
          taskIds.add(Id.valueOf(taskId));
        }
      }
    }
  }
}