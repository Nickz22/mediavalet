public with sharing class DeactivateAccountBtnController {
  private Status__c currentStatus { get; set; }

  public String errorMessage { get; set; }

  public DeactivateAccountBtnController(
    ApexPages.StandardController stdController
  ) {
    if (!Test.isRunningTest()) {
      stdController.addFields(
        new List<String>{
          'OwnerId',
          'Deactivated_By__r.FirstName',
          'Deactivated_By__r.LastName',
          'Unresponsive_Date__c',
          'Account__c'
        }
      );
    }
    currentStatus = (Status__c) stdController.getRecord();
  }

  public Pagereference init() {
    if (currentStatus.Unresponsive_Date__c != null) {
      String deactivatedBy =
        currentStatus.Deactivated_By__r.FirstName +
        ' ' +
        currentStatus.Deactivated_By__r.LastName;
      errorMessage = String.format(
          Label.Account_Already_Deactivated,
          new List<String>{ deactivatedBy }
        )
        .escapeEcmaScript();
      return null;
    }
    if (
      currentStatus.OwnerId == UserInfo.getUserId() || isCurrentUserSysAdmin()
    ) {
      currentStatus.Deactivated_By__c = UserInfo.getUserId();
      currentStatus.Unresponsive_Date__c = Date.today();
      currentStatus.Prospecting_Status__c = 'Deactivated';
      ESAPI.accessController()
        .updateAsUser(
          currentStatus,
          new List<String>{
            'Deactivated_By__c',
            'Unresponsive_Date__c',
            'Prospecting_Status__c'
          }
        );
    } else {
      errorMessage = Label.Account_Deactivation_Error;
    }
    return null;
  }

  public PageReference goBack() {
    return (new ApexPages.StandardController(currentStatus)).view();
  }

  @TestVisible
  private static Boolean isCurrentUserSysAdmin() {
    if (
      !ESAPI.accessController()
        .isAuthorizedToView(
          Profile.sObjectType,
          new List<String>{
            'Id',
            'PermissionsModifyAllData',
            'PermissionsViewSetup',
            'PermissionsAuthorApex'
          }
        )
    ) {
      return false;
    }
    Map<Id, Profile> sysAdminProfilesMap = new Map<Id, Profile>(
      [
        SELECT Id
        FROM Profile
        WHERE
          PermissionsModifyAllData = TRUE
          AND PermissionsViewSetup = TRUE
          AND PermissionsAuthorApex = TRUE
      ]
    );
    return sysAdminProfilesMap.containsKey(UserInfo.getProfileId());
  }
}