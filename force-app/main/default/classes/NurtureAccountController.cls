public with sharing class NurtureAccountController {
  @AuraEnabled
  public static Status__c getActiveStatus(String recordId) {
    List<Schema.SObjectField> fields = new List<Schema.SObjectField>{
      Status__c.Prospecting_Status__c,
      Status__c.Account__c,
      Status__c.Unresponsive_Date__c
    };
    if (
      !ESAPI.accessController()
        .isAuthorizedToView(Status__c.sobjectType, fields)
    ) {
      return null;
    }
    List<Status__c> outboundStatuses = [
      SELECT
        Id,
        Prospecting_Status__c,
        Account__c,
        Activated_By__c,
        Activated_Date__c,
        Times_Activated__c,
        Follow_up_Date__c,
        Nurture_Notes__c
      FROM Status__c
      WHERE Account__c = :recordId AND Unresponsive_Date__c = NULL
      WITH USER_MODE
    ];
    return outboundStatuses.size() > 0 ? outboundStatuses.get(0) : null;
  }

  private static Status__c buildNurtureStatus(
    Status__c status,
    Date followUp,
    String notes
  ) {
    status.Prospecting_Status__c = C.OUTBOUND_PROSPECTING_STATUS_NURTURE;
    status.Follow_up_Date__c = followUp;
    status.Nurture_Notes__c = notes;
    status.Nurture_Date__c = Date.today();

    return status;
  }

  // public static Map<String, Map<Id, SObject>> nurtureInBatch(Database.BatchableContext context, List<sObject> scope) {
  //     outboundSettings = [SELECT Deactivate_After__c, Wait_Period__c
  //                         FROM Settings__mdt ORDER BY ID DESC
  //                         LIMIT 1];

  //     Map<Id, Status__c> nurtureStatusForUpdate = new Map<Id, Status__c>();
  //     Map<Id, Account> accountsForUpdate = new Map<Id, Account>();

  //     for ( Status__c outboundStatus : (List<Status__c>)scope ){

  //         if (outboundStatus.Account__c != null) {

  //             /**
  //              * Figure out followup dates
  //              */
  //             Date followUp = Date.today();

  //             if (outboundSettings.Wait_Period__c != null) {
  //                 followUp = Date.today().addDays(Integer.valueOf(outboundSettings.Wait_Period__c));
  //             }

  //             /**
  //              * Build the new statuses
  //              */
  //             Status__c outboundStatus = buildNurtureStatus(
  //                 outboundStatus,
  //                 followUp,
  //                 Label.Automated_Nurture_Account_Notes
  //             );

  //             nurtureStatusForUpdate.put(outboundStatus.Id, outboundStatus);

  //             // Todo: below code might not be needed as this now ensured
  //             // by an afterUpdate trigger
  //             //
  //             // /**
  //             //  * Update Account objects in batch as well.
  //             //  *
  //             //  * This needs to be done explicitly here as there will be
  //             //  * no afterUpdate trigger when updating Status__c in
  //             //  * batch
  //             //  */
  //             // accountsForUpdate.put(
  //             //     outboundStatus.Account__c,
  //             //     new Account(
  //             //         Id = outboundStatus.Account__c,
  //             //         Status__c = outboundStatus.Prospecting_Status__c
  //             //         )
  //             // );
  //         }

  //     }

  //     Map<String, Map<Id, SObject>> result = new Map<String, Map<Id, SObject>>();

  //     result.put('Status__c', nurtureStatusForUpdate);
  //     result.put('Account', accountsForUpdate);

  //     return result;
  // }
}