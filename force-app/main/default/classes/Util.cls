public with sharing class Util {
  public static Boolean hasCoolingOffPeriodElapsedSinceLastUpgrade() {
    OB_Metrix_Install_Settings__c installSetting = OB_Metrix_Install_Settings__c.getOrgDefaults();
    if (installSetting?.Installed__c == null) {
      // this should always be set, but if its not we'll let the transaction continue
      return true;
    }
    return Date.today() >=
      installSetting
        .Installed__c.addDays(
          Integer.valueOf(CustomMetadataCache.setting.Wait_Period__c)
        );
  }
  public static Object getValueByPath(SObject record, String path) {
    // Split the path by '.'
    List<String> pathParts = path.split('\\.');

    // Start with the current record
    SObject currentObject = record;
    Object value;
    // Loop through the path parts
    for (String pathPart : pathParts) {
      if (pathParts.indexOf(pathPart) == pathParts.size() - 1) {
        value = currentObject.get(pathPart);
        break;
      }
      // Dereference the current object
      currentObject = (SObject) currentObject.getSObject(pathPart);
    }

    // Return the value at the end of the path
    return value;
  }
}