public with sharing class ActivateAccountBtnController {
  private static Settings__mdt settings { get; set; }

  private Account currentAccount { get; set; }

  @TestVisible
  private static String staticErrorMessage = '';
  public String errorMessage { get; set; }

  public ActivateAccountBtnController(
    ApexPages.StandardController stdController
  ) {
    if (!Test.isRunningTest()) {
      stdController.addFields(
        new List<String>{
          'Activated_By__r.FirstName',
          'Activated_By__r.LastName'
        }
      );
    }
    currentAccount = (Account) stdController.getRecord();
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          Settings__mdt.sObjectType,
          new List<Schema.SObjectField>{
            Settings__mdt.fields.Wait_Period__c,
            Settings__mdt.fields.Limit_Number_of_Claims__c,
            Settings__mdt.Number_of_Simultaneous_Claims_per_Rep__c
          }
        )
    ) {
      settings = [
        SELECT
          Wait_Period__c,
          Limit_Number_of_Claims__c,
          Number_of_Simultaneous_Claims_per_Rep__c
        FROM Settings__mdt
        ORDER BY ID DESC
        LIMIT 1
      ];
    }
  }

  public Pagereference init() {
    Boolean isPermissionEnabled = PermissionsCache.ioUserIds.contains(
      UserInfo.getUserId()
    );
    if (!isPermissionEnabled) {
      errorMessage = String.format(
          Label.Non_OBMetrix_Logged_In_User,
          new List<String>{}
        )
        .escapeEcmaScript();
      staticErrorMessage = errorMessage;
      return null;
    }
    Boolean isOsFlsPermissionEnabled = ESAPI.accessController()
      .isAuthorizedToView(
        Status__c.sobjectType,
        new List<Schema.SObjectField>{
          Status__c.Unresponsive_Date__c,
          Status__c.Account__c
        }
      );

    if (!isOsFlsPermissionEnabled) {
      return null;
    }
    if (settings.Limit_Number_of_Claims__c == true) {
      String claimed = C.OUTBOUND_PROSPECTING_STATUS_CLAIMED;
      String userId = UserInfo.getUserId();
      String username = UserInfo.getUserName(); // for logging, remove
      String query =
        'SELECT COUNT() FROM Account WHERE Id IN (SELECT Account__c FROM Status__c WHERE Prospecting_Status__c = \'' +
        claimed +
        '\' AND Claimed_By__c = \'' +
        userId +
        '\')';
      Integer claimedAcc = Database.countQuery(query);
      if (claimedAcc >= settings.Number_of_Simultaneous_Claims_per_Rep__c) {
        errorMessage = String.format(
            Label.Number_of_Simultaneous_Claims_per_Rep_Error,
            new List<String>{
              String.valueOf(settings.Number_of_Simultaneous_Claims_per_Rep__c)
            }
          )
          .escapeEcmaScript();
        staticErrorMessage = errorMessage;
        return null;
      }
    }
    List<Status__c> outboundStatuses = [
      SELECT
        Unresponsive_Date__c,
        Follow_up_Date__c,
        opportunity_created_date__c,
        nurture_date__c,
        CreatedBy.Name
      FROM Status__c
      WHERE Account__c = :currentAccount.Id
      WITH USER_MODE
      ORDER BY Unresponsive_Date__c DESC NULLS FIRST
    ];
    if (
      !outboundStatuses.isEmpty() &&
      outboundStatuses[0].Unresponsive_Date__c == null &&
      outboundStatuses[0].Opportunity_Created_Date__c == null &&
      outboundStatuses[0].Nurture_Date__c == null
    ) {
      errorMessage = String.format(
          Label.Account_Already_Activated,
          new List<String>{ outboundStatuses[0].CreatedBy.Name }
        )
        .escapeEcmaScript();
      staticErrorMessage = errorMessage;
      return null;
    } else if (
      !outboundStatuses.isEmpty() &&
      outboundStatuses[0].Unresponsive_Date__c != null &&
      outboundStatuses[0]
        .Unresponsive_Date__c.daysBetween(Datetime.now().date()) <
      settings.Wait_Period__c
    ) {
      errorMessage = String.format(
          Label.Account_Activation_Wait_Period_Error,
          new List<String>{
            String.valueOf(
              settings.Wait_Period__c -
              outboundStatuses[0]
                .Unresponsive_Date__c.daysBetween(Datetime.now().date())
            )
          }
        )
        .escapeEcmaScript();
      staticErrorMessage = errorMessage;
      return null;
    } else if (
      !outboundStatuses.isEmpty() &&
      outboundStatuses[0].Nurture_Date__c != null &&
      outboundStatuses[0].Follow_up_Date__c != null &&
      outboundStatuses[0].Follow_up_Date__c > Date.today()
    ) {
      errorMessage = String.format(
          Label.Account_Currently_In_Nurture,
          new List<String>{
            String.valueOf(
              Date.today().daysBetween(outboundStatuses[0].Follow_up_date__c)
            )
          }
        )
        .escapeEcmaScript();
      staticErrorMessage = errorMessage;
      return null;
    } else {
      String claimed = C.OUTBOUND_PROSPECTING_STATUS_CLAIMED;
      Status__c newStatus = new Status__c(
        Account__c = currentAccount.Id,
        Times_Activated__c = outboundStatuses.size() + 1,
        Prospecting_Status__c = claimed,
        Claimed_By__c = UserInfo.getUserId(),
        OwnerId = UserInfo.getUserId(),
        Activated_Date__c = Date.today()
      );
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Status__c.SObjectType }
      );
      uow.registerNew(newStatus);
      uow.commitWork();
    }
    return null;
  }

  public PageReference goBack() {
    return (new ApexPages.StandardController(currentAccount)).view();
  }
}