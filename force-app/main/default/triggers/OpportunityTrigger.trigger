trigger OpportunityTrigger on Opportunity(after insert, after update) {
  Boolean isIoUser = PermissionsCache.ioUserIds.contains(UserInfo.getUserId());
  if (!isIoUser) {
    return;
  }
  // extract boolean variables
  Boolean disableOBMetrixAppCalculations =
    CustomMetadataCache.setting == null ||
    CustomMetadataCache.setting.Disable_OBMetrix_App_Calculations__c;
  if (disableOBMetrixAppCalculations) {
    return;
  }

  try {
    fflib_SObjectDomain.triggerHandler(OpportunityTriggerHandler.class);
  } catch (Exception e) {
    ExceptionHandler.sendExceptionToUser(e);
  }
}