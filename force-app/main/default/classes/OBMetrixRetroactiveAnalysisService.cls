public inherited sharing class OBMetrixRetroactiveAnalysisService {
  @AuraEnabled
  public static Object getActivUsers() {
    return OBMetrixUserSettingsService.getActivUsers();
  }

  @AuraEnabled
  public static void runAnalysis(String daysBack) {
    Database.executeBatch(
      new RetroactiveActivationBatch(Integer.valueOf(daysBack.trim())),
      25
    );
    // Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
    // customMetadata.fullName = 'Settings__mdt.Main';
    // customMetadata.label = 'Activity Subject Filters';

    // Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
    // customField.field = 'retroanalysis_isCompleted__c';
    // customField.value = 'running';
    // customMetadata.values.add(customField);

    // RetroactiveAnalysisBatchSequenceTask.runBatch(
    //   Date.today(),
    //   Integer.valueof(daysBack.trim()),
    //   null,
    //   null,
    //   null,
    //   null
    // );
  }

  @AuraEnabled
  public static Boolean getAnalysisProgress() {
    Settings__mdt setting = new SettingsSelector().selectSkinnySetting();
    return setting.retroanalysis_isCompleted__c;
  }
}