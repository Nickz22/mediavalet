@IsTest
public class OBMetrixSettingsServiceTest {
  private static final String OPPORTUNITY = 'Opportunity';
  private static final String EVENT = 'Event';
  private static final String TASK = 'Task';

  static User ioAdmin {
    get {
      if (ioAdmin == null) {
        ioAdmin = TestFactory.ioAdmin;
      }
      return ioAdmin;
    }
    set;
  }

  @isTest
  static void given() {
    System.runAs(ioAdmin) {
      oneUserWithIoPermissions();
      oneNullInstalledSetting();
    }
  }

  @isTest
  static void oneUserWithIoPermissions() {
    Assert.areEqual(
      1,
      [
        SELECT COUNT()
        FROM PermissionSetAssignment
        WHERE AssigneeId = :ioAdmin.Id AND PermissionSet.Name = :C.OBMETRIX
      ]
    );
  }

  @isTest
  static void oneNullInstalledSetting() {
    Assert.isNull(OB_Metrix_Install_Settings__c.getOrgDefaults().Installed__c);
  }

  @IsTest
  static void testSetStandardObjectPermissions() {
    User adminUser = TestFactory.ioAdmin;

    System.runAs(adminUser) {
      Test.startTest();
      OBMetrixSettingsService.runPostInstall();
      Test.stopTest();

      // Fetch the permission set, ensure C.OBMETRIX contains the correct permission set name
      PermissionSet standardObjectPermissionSet = [
        SELECT Id
        FROM PermissionSet
        WHERE Label = :C.STANDARD_OBJECT_PERMISSION_SET_NAME
        LIMIT 1
      ];

      Assert.areEqual(
        1,
        [
          SELECT COUNT()
          FROM FieldPermissions
          WHERE
            SObjectType = 'Task'
            AND Field = 'Task.Type'
            AND ParentId = :standardObjectPermissionSet.Id
        ]
      );

      Assert.areEqual(
        1,
        [
          SELECT COUNT()
          FROM PermissionSetAssignment
          WHERE
            AssigneeId = :adminUser.Id
            AND PermissionSetId = :standardObjectPermissionSet.Id
        ]
      );

      Assert.isNotNull(
        OB_Metrix_Install_Settings__c.getOrgDefaults().Installed__c
      );
    }
  }

  @TestSetup
  static void setup() {
    System.runAs(ioAdmin) {
      OB_Metrix_Install_Settings__c setting = OB_Metrix_Install_Settings__c.getOrgDefaults();
      setting.Installed__c = null;
      upsert setting;
    }
  }
}