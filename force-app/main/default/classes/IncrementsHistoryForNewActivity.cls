@isTest
public class IncrementsHistoryForNewActivity {
  @isTest
  static void given() {
    System.runAs(TestFactory.ioAdmin) {
      twoAccounts();
      twoContacts();
      twoStatuses();
      onePipelineHistoryPerStatusWithCallConnectsSet();
    }
  }

  @isTest
  static void shouldIncrementExistingPipelineHistoryOnNewActivityUnderSameOsAndSameProspectingStatus() {
    System.runAs(TestFactory.ioAdmin) {
      Contact activatedContact = [
        SELECT AccountId
        FROM Contact
        WITH USER_MODE
        LIMIT 1
      ];
      Task connectedCall = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Call_Advance__c
      );

      connectedCall.WhoId = activatedContact.Id;

      Prospecting_Effort__c oldPipelineHistory = new PipelineHistorySelector()
        .selectHistoriesByStatusIds(
          Pluck.ids(
            [
              SELECT Id
              FROM Status__c
              WHERE Account__c = :activatedContact.AccountId
              WITH USER_MODE
            ]
          )
        )[0];

      Test.startTest();
      Database.insert(connectedCall, AccessLevel.USER_MODE);
      Test.stopTest();
      Prospecting_Effort__c newPipelineHistory = [
        SELECT Dials__c
        FROM Prospecting_Effort__c
        WHERE Id = :oldPipelineHistory.Id
        WITH USER_MODE
      ];
      Assert.areEqual(
        oldPipelineHistory.Dials__c + 1,
        newPipelineHistory.Dials__c,
        'Pipeline History should have incremented Call Connects by number of new activities, which in this case is 1'
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

      for (Integer i = 0; i < 2; i++) {
        uow = TestFactory.initActivatedContactData(
          CustomMetadataCache.setting.Call_Advance__c,
          uow
        );
      }

      Test.startTest();
      uow.commitWork();
      Test.stopTest();

      List<Prospecting_Effort__c> pipelineHistories = new PipelineHistorySelector()
        .selectHistoriesByStatusIds(Pluck.ids([SELECT Id FROM Status__c]));
      Assert.areEqual(
        2,
        pipelineHistories.size(),
        'Pipeline History records should be created for each new OS'
      );
    }
  }

  static void twoAccounts() {
    Assert.areEqual(2, [SELECT COUNT() FROM Account]);
  }

  static void twoContacts() {
    Integer expectedActivatedContactsPerAccount = Integer.valueOf(
      CustomMetadataCache.setting.Active_Contacts1__c
    );
    Assert.areEqual(
      2 * expectedActivatedContactsPerAccount,
      [SELECT COUNT() FROM Contact]
    );
  }

  static void twoStatuses() {
    Assert.areEqual(2, [SELECT COUNT() FROM Status__c]);
  }

  static void onePipelineHistoryPerStatusWithCallConnectsSet() {
    Integer expectedCallConnects = Integer.valueOf(
      CustomMetadataCache.setting.Activities_Created_by_User1__c
    );

    Integer expectedActivatedContactsPerAccount = Integer.valueOf(
      CustomMetadataCache.setting.Active_Contacts1__c
    );

    List<Prospecting_Effort__c> histories = new PipelineHistorySelector()
      .selectHistoriesByStatusIds(Pluck.ids([SELECT Id FROM Status__c]));

    List<Id> statusIds = new List<Id>(
      Pluck.ids(histories, C.PROSPECTING_EFFORT_OS_FIELD)
    );

    Assert.areEqual(
      2,
      statusIds.size(),
      'expected 2 unique statuses for 2 histories'
    );

    for (Prospecting_Effort__c history : histories) {
      Assert.areEqual(
        expectedCallConnects * expectedActivatedContactsPerAccount,
        history.Dials__c,
        'expected Call Connects to be set to ' + expectedCallConnects
      );
    }
  }
}