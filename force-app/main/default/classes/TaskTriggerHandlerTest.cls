@isTest
public with sharing class TaskTriggerHandlerTest {
  private static Settings__mdt setting = CustomMetadataCache.setting;
  private static User ioAdminUser = TestFactory.ioAdmin;

  @isTest
  static void given() {
    System.runAs(ioAdminUser) {
      oneAccount();
      oneContact();
      oneProspectingActivity();
      installedToday();
    }
  }

  static void oneAccount() {
    Assert.areEqual([SELECT COUNT() FROM Account], 1);
  }

  static void oneContact() {
    Assert.areEqual([SELECT COUNT() FROM Contact], 1);
  }

  static void oneProspectingActivity() {
    Map<Id, ActivityStats> statsByWhoId = TaskHelper.getActivityStatsByWhoId(
      [
        SELECT
          Id,
          WhoId,
          WhatId,
          Subject,
          ActivityDate,
          Status,
          Priority,
          OwnerId,
          Type,
          CreatedDate
        FROM Task
      ]
    );
    Assert.isTrue(statsByWhoId.values()[0].hasProspectingActivity());
  }

  static void installedToday() {
    Assert.areEqual(
      [
        SELECT COUNT()
        FROM OB_Metrix_Install_Settings__c
        WHERE Installed__c = TODAY
      ],
      1
    );
  }

  @isTest
  static void whenProspectingActivityCreated_andCoolOffHasNotElapsedSinceLastProspectingActivity_thenContactShouldNotBeActivated() {
    CustomMetadataCache.withXActivitiesPerContact = 2;
    CustomMetadataCache.withWaitPeriod = 8;
    CustomMetadataCache.withContactTrackingPeriod = 12;
    CustomMetadataCache.enableActivateAutomatically = true;

    OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
    installSetting.Installed__c = Date.today().addDays(-2);
    upsert installSetting;

    Task t = [SELECT Id FROM Task];
    Test.setCreatedDate(t.Id, Date.today().addDays(-2));
    update t;

    /**
     * GIVEN app was installed 4 days ago
     *  AND a prospecting activity was created 2 days ago
     *  AND the cool off period is 8 days
     *  AND the contact tracking period is 12 days
     * WHEN a prospecting activity is created
     * THEN Date.today().addDays(-4 + 8) is within 8 days of the previous prospecting activity (2 days ago)
     *  AND the contact should not be activated
     */
    System.runAs(ioAdminUser) {
      Test.startTest();
      Contact c = [SELECT AccountId FROM Contact];
      Task task = TestFactory.createEligibleActivityForFilter(
        setting.Engaged_Call_Advance__c
      );
      task.WhatId = c.AccountId;
      task.WhoId = c.Id;
      insert task;
      Test.stopTest();
    }

    System.assertEquals(
      0,
      [SELECT COUNT() FROM Outbound_Contact_Activation__c]
    );
  }

  @isTest
  static void whenProspectingActivityCreated_andExactCoolOffHasElapsedSinceLastProspectingActivity_thenContactShouldNotBeActivated() {
    CustomMetadataCache.withXActivitiesPerContact = 2;
    CustomMetadataCache.withWaitPeriod = 4;
    CustomMetadataCache.withContactTrackingPeriod = 7;
    CustomMetadataCache.enableActivateAutomatically = true;

    OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
    installSetting.Installed__c = Date.today().addDays(-2);
    upsert installSetting;

    Task t = [SELECT Id FROM Task];
    Test.setCreatedDate(t.Id, Date.today().addDays(-4));
    update t;

    /**
     * GIVEN app was installed 2 days ago
     *  AND a prospecting activity was created 2 days ago
     *  AND the cool off period is 4 days
     *  AND the contact tracking period is 7 days
     * WHEN a prospecting activity is created
     * THEN Date.today().addDays(-2 + 4) is exactly 4 days of the previous prospecting activity (2 days ago)
     *  AND the contact should not be activated
     */

    System.runAs(ioAdminUser) {
      Test.startTest();
      Contact c = [SELECT AccountId FROM Contact];
      Task task = TestFactory.createEligibleActivityForFilter(
        setting.Engaged_Call_Advance__c
      );
      task.WhatId = c.AccountId;
      task.WhoId = c.Id;
      insert task;
      Test.stopTest();
    }

    System.assertEquals(
      0,
      [SELECT COUNT() FROM Outbound_Contact_Activation__c]
    );
  }

  @isTest
  static void whenProspectingActivityCreated_andCoolOffHasElapsedSinceLastProspectingActivity_thenContactShouldBeActivated() {
    CustomMetadataCache.withXActivitiesPerContact = 2;
    CustomMetadataCache.withWaitPeriod = 4;
    CustomMetadataCache.withContactTrackingPeriod = 7;
    CustomMetadataCache.enableActivateAutomatically = true;

    OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
    installSetting.Installed__c = Date.today().addDays(-2);
    upsert installSetting;

    Task t = [SELECT Id FROM Task];
    Test.setCreatedDate(t.Id, Date.today().addDays(-5));
    update t;

    /**
     * GIVEN app was installed 2 days ago
     *  AND a prospecting activity was created 5 days ago
     *  AND the cool off period is 4 days
     *  AND the contact tracking period is 7 days
     * WHEN a prospecting activity is created
     * THEN Date.today().addDays(-2 + 4) is > 2 days away from the previous prospecting activity (5 days ago)
     *  AND the contact should be activated
     */
    System.runAs(ioAdminUser) {
      Test.startTest();
      Contact c = [SELECT AccountId FROM Contact];
      Task task = TestFactory.createEligibleActivityForFilter(
        setting.Engaged_Call_Advance__c
      );
      task.WhatId = c.AccountId;
      task.WhoId = c.Id;
      insert task;
      Test.stopTest();
    }

    System.assertEquals(
      1,
      [SELECT COUNT() FROM Outbound_Contact_Activation__c]
    );
  }

  @TestSetup
  public static void setupData() {
    CustomMetadataCache.withXActivitiesPerContact = 2;

    System.runAs(ioAdminUser) {
      OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
      installSetting.Installed__c = Date.today();
      upsert installSetting;
      Account a = new Account(
        Name = 'Test Account',
        Territory__c = 'United States'
      );
      insert a;
      Contact c = new Contact(LastName = 'Test Contact', AccountId = a.Id);
      insert c;
      Task t = TestFactory.createEligibleActivityForFilter(
        setting.Engaged_Call_Advance__c
      );
      t.WhoId = c.Id;
      t.WhatId = a.Id;
      insert t;
    }
  }
}
