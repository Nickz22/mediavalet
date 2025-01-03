// TaskTrigger.apxt
trigger TaskTrigger on Task(after insert) {
  Boolean isIoUser = PermissionsCache.ioUserIds.contains(UserInfo.getUserId());
  if (!isIoUser) {
    return;
  }

  if (
    CustomMetadataCache.setting == null ||
    CustomMetadataCache.setting.Disable_OBMetrix_App_Calculations__c ||
    !CustomMetadataCache.setting.Activate_Automatically1__c
  ) {
    return;
  }

  try {
    fflib_SObjectDomain.triggerHandler(TaskTriggerHandler.class);
  } catch (Exception e) {
    ExceptionHandler.sendExceptionToUser(e);
  }
}