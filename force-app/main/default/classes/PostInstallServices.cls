public with sharing class PostInstallServices {
  public PostInstallServices() {
  }

  /**
   * Updates the Installed__c field of the OB_Metrix_Install_Settings__c
   * custom setting with the current date/time,
   * but only if the Installed__c field is currently null.
   * @return ApiResponse
   */
  public Database.UpsertResult updateInstallDateIfNecessary() {
    OB_Metrix_Install_Settings__c settings = OB_Metrix_Install_Settings__c.getOrgDefaults();

    if (settings?.Installed__c != null) {
      return null;
    }

    if (settings == null) {
      settings = new OB_Metrix_Install_Settings__c();
    }

    settings.Installed__c = settings.Installed__c == null
      ? Date.today()
      : settings.Installed__c;
    Database.UpsertResult result = Database.upsert(
      new OB_Metrix_Install_Settings__c(
        Id = settings.Id,
        Installed__c = settings.Installed__c
      ),
      false,
      AccessLevel.USER_MODE
    );

    return result;
  }
}