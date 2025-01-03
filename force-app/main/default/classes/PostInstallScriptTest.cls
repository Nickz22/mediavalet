/**
 * Test class for PostInstallScript with custom setting OB_Metrix_Install_Settings__c.
 */
@IsTest
private class PostInstallScriptTest {
  /**
   * Tests that the Installed__c field is updated when initially null.
   */
  @IsTest
  static void testInstallDateUpdatedWhenNull() {
    System.runAs(TestFactory.ioAdmin) {
      // Setup - ensure no existing settings to interfere with test
      delete [SELECT Id FROM OB_Metrix_Install_Settings__c];

      // Insert a new custom setting record with Installed__c set to null
      OB_Metrix_Install_Settings__c setting = new OB_Metrix_Install_Settings__c();
      // Note: Depending on how your custom setting is defined, you might need to set specific fields here.
      insert setting;

      // Simulate package installation
      new PostInstallServices().updateInstallDateIfNecessary();

      // Verify Installed__c is now set
      OB_Metrix_Install_Settings__c updatedSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
      System.assertNotEquals(
        null,
        updatedSetting.Installed__c,
        'Installed__c should be updated with the current date/time.'
      );
    }
  }

  /**
   * Tests that the Installed__c field is not updated when it already has a value.
   */
  @IsTest
  static void testInstallDateNotUpdatedWhenSet() {
    System.runAs(TestFactory.ioAdmin) {
      // Setup - ensure no existing settings to interfere with test
      delete [SELECT Id FROM OB_Metrix_Install_Settings__c];

      // Insert a new custom setting record with Installed__c set to a specific date/time
      OB_Metrix_Install_Settings__c setting = new OB_Metrix_Install_Settings__c();
      Date initialDate = Date.today();
      setting.Installed__c = initialDate;
      insert setting;

      // Simulate package installation
      new PostInstallServices().updateInstallDateIfNecessary();

      // Verify Installed__c has not been updated
      OB_Metrix_Install_Settings__c updatedSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
      System.assertEquals(
        initialDate,
        updatedSetting.Installed__c,
        'Installed__c should not be updated if it already has a value.'
      );
    }
  }
}