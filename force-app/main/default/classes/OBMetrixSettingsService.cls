/*
 * OBMetring Setting component Controller
 * Provide facility to show setting and save it as deploy metadata
 * Implemented DeployCallback to save setting as metadata.
 * Added On : 6th Jan 2020
 */
public with sharing class OBMetrixSettingsService implements Metadata.DeployCallback {
  public static List<String> TASKS_FIELDS = new List<String>{
    'Subject',
    'Type',
    'Description',
    'CreatedById',
    'TaskSubtype',
    'OwnerId'
  };
  public static List<String> EVENTS_FIELDS = new List<String>{
    'Subject',
    'Type',
    'Description',
    'CreatedById',
    'OwnerId'
  };

  /*
   * Get Current Setting to show on component
   * Added on : 6th Jan 2020
   */
  @AuraEnabled
  public static Settings__mdt getLatestSettings() {
    return getSettings();
  }
  /*
   * Get Current Setting to show on component
   * Added on : 6th Jan 2020
   * Added on : 15th of April 2021
   */
  @AuraEnabled(cacheable=true)
  public static Settings__mdt getSettings() {
    Settings__mdt settings;
    String lableValue = Label.OBMetrix_Setting_Instruction;
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          Settings__mdt.sObjectType,
          new List<String>{
            'Call_Advance__c',
            'Inbound_Email_Advance__c',
            'Outbound_Email_Advance__c',
            'Outbound_Meeting_Advance__c',
            'Engaged_Call_Advance__c',
            'Inbound_Email_Subject_Filter__c',
            'Wait_Period__c',
            'Deactivate_After__c',
            'Gift_Advance1__c',
            'InMail_Advance1__c',
            'Activities_Created_by_User1__c',
            'Timeframe_Days_Contact1__c',
            'Active_Contacts1__c',
            'Timeframe_Days_Account1__c',
            'Do_Not_Activate_if_Open_Opportunity1__c',
            'Claim_Period__c',
            'Opportunity_Value_Field__c',
            'Meeting_Object__c',
            'Limit_Number_of_Claims__c',
            'Number_of_Simultaneous_Claims_per_Rep__c',
            'User_Credit_Field__c',
            'Email_Alert_A_C_Claimed_By_Another_User__c',
            'Email_Alert_1_OBMetrix_Selected_Users__c',
            'Email_Alert_1_Original_User__c',
            'Email_Alert_1_Out_Of_Policy_User__c',
            'Email_Alert_Activated_OR_Engaged_Status__c',
            'Email_Alert_2_OBMetrix_Selected_Users__c',
            'Email_Alert_2_Original_User__c',
            'Email_Alert_2_Out_Of_Policy_User__c',
            'Disable_OBMetrix_App_Calculations__c',
            'Disable_OBMetrix_Tasks_Calculations__c',
            'Set_Approaching_Outbound_Opps_Automatic__c',
            'Set_Approaching_Outbound_Event_Automatic__c',
            'retroanalysis_isCompleted__c'
          }
        )
    ) {
      settings = new SettingsSelector().selectSetting();
      if (Test.isRunningTest()) {
        // For testing we need to keep same value everytime otherwise test coverage will failed if setting changed by user
        settings.Inbound_Email_Subject__c = '[Outreach][Email][In]';
        settings.Outbound_Email_Subject__c = '[Outreach][Email][Out]';
        settings.Engaged_Call_Subject__c = '[Not Answered]';
        settings.Call_Subject__c = '[Answered]';
        settings.Outbound_Meeting_Subject__c = '[Meeting]';
        settings.Inbound_Email_Advance__c = '{"filters":[{"field":"Subject","operator":"contains","value":"[Outreach][Email][In]"}]}';
        settings.Outbound_Email_Advance__c = '{"filters":[{"field":"Subject","operator":"contains","value":"[Outreach][Email][Out]"}],"filterLogic":"","disabled":false}';
        settings.Call_Advance__c = '{"filters":[{"field":"Subject","operator":"contains","value":"Call"}]}';
        settings.Engaged_Call_Advance__c = '{"filters":[{"field":"Subject","operator":"contains","value":"Engaged"}],"disabled":false}';
        settings.Outbound_Meeting_Advance__c = '{"filters":[{"field":"Subject","operator":"contains","value":"Meeting"}]}';
        settings.Gift_Advance1__c = '{"filters":[{"field":"Subject","operator":"contains","value":"Gift"}]}';
        settings.InMail_Advance1__c = '{"filters":[{"field":"Subject","operator":"contains","value":"InMail"}]}';
        settings.Opportunity_Value_Field__c = 'Amount';
        settings.Meeting_Object__c = 'Event';
        settings.Claim_Period__c = 4;
        settings.Number_of_Simultaneous_Claims_per_Rep__c = 400;
        settings.Limit_Number_of_Claims__c = true;
        settings.User_Credit_Field__c = 'OwnerId';
        settings.Email_Alert_A_C_Claimed_By_Another_User__c = true;
        settings.Email_Alert_1_OBMetrix_Selected_Users__c = '';
        settings.Email_Alert_1_Original_User__c = true;
        settings.Email_Alert_1_Out_Of_Policy_User__c = true;
        settings.Email_Alert_Activated_OR_Engaged_Status__c = true;
        settings.Email_Alert_2_OBMetrix_Selected_Users__c = '';
        settings.Email_Alert_2_Original_User__c = true;
        settings.Email_Alert_2_Out_Of_Policy_User__c = true;
        settings.Disable_OBMetrix_App_Calculations__c = false;
        settings.Disable_OBMetrix_Tasks_Calculations__c = false;
        settings.Set_Approaching_Outbound_Event_Automatic__c = false;
        settings.Set_Approaching_Outbound_Opps_Automatic__c = false;
        settings.retroanalysis_isCompleted__c = true;
      }
    }
    return settings;
  }

  @AuraEnabled(cacheable=true)
  public static List<FieldWrapper> getActivityFields() {
    List<FieldWrapper> fields = new List<FieldWrapper>();
    List<SObjectField> fieldTokens = Task.getSObjectType()
      .getDescribe()
      .fields.getMap()
      .values();
    for (SObjectField fieldToken : fieldTokens) {
      if (TASKS_FIELDS.contains(fieldToken.getDescribe().getName())) {
        fields.add(new FieldWrapper(fieldToken.getDescribe()));
      }
    }
    return fields;
  }

  @AuraEnabled(cacheable=true)
  public static List<FieldWrapper> getEventFields() {
    List<FieldWrapper> fields = new List<FieldWrapper>();
    List<SObjectField> fieldTokens = Event.getSObjectType()
      .getDescribe()
      .fields.getMap()
      .values();
    for (SObjectField fieldToken : fieldTokens) {
      if (EVENTS_FIELDS.contains(fieldToken.getDescribe().getName())) {
        fields.add(new FieldWrapper(fieldToken.getDescribe()));
      }
    }
    return fields;
  }
  /*
   * Get all active User order by Name
   */
  @AuraEnabled
  public static Object getActivUsers() {
    Map<String, Object> result = new Map<String, Object>();
    List<OBNDSelectOption> activeUsers = new List<OBNDSelectOption>();

    List<String> obmUserList = OBMetrixUserSettingsService.getOBMetrixUser();
    System.debug('obmUserList :: ' + obmUserList);
    if (
      ESAPI.accessController()
        .isAuthorizedToView(User.sObjectType, new List<String>{ 'Id', 'Name' })
    ) {
      for (User u : new UserSelector().selectActiveUsersOrderedByName()) {
        if (obmUserList.contains(u.id)) {
          activeUsers.add(new OBNDSelectOption(u.Name, u.Id));
        }
      }
    }

    result.put('activeUsers', activeUsers);
    result.put('isAdmin', isAdminOrSystemAdmin());
    return result;
  }
  /*
   * Deploy a changeset to update settings
   * Added on : 7th Jan 2020
   *
   * Added on : 15th Aprial 2021
   */
  @AuraEnabled
  public static void saveOBSettings(Settings__mdt obSettings) {
    List<String> fieldList = new List<String>{
      'Activate_Automatically1__c',
      'Call_Advance__c',
      'Inbound_Email_Advance__c',
      'Outbound_Email_Advance__c',
      'Outbound_Meeting_Advance__c',
      'Engaged_Call_Advance__c',
      'Inbound_Email_Subject_Filter__c',
      'Wait_Period__c',
      'Deactivate_After__c',
      'Gift_Advance1__c',
      'InMail_Advance1__c',
      'Filter_Accounts_Criteria__c',
      'Filter_Opportunity_Criteria__c',
      'Activities_Created_by_User1__c',
      'Timeframe_Days_Contact1__c',
      'Active_Contacts1__c',
      'Timeframe_Days_Account1__c',
      'Do_Not_Activate_if_Open_Opportunity1__c',
      'Opportunity_Value_Field__c',
      'Meeting_Object__c',
      'Claim_Period__c',
      'Limit_Number_of_Claims__c',
      'Number_of_Simultaneous_Claims_per_Rep__c',
      'User_Credit_Field__c',
      'Email_Alert_A_C_Claimed_By_Another_User__c',
      'Email_Alert_1_OBMetrix_Selected_Users__c',
      'Email_Alert_1_Original_User__c',
      'Email_Alert_1_Out_Of_Policy_User__c',
      'Email_Alert_Activated_OR_Engaged_Status__c',
      'Email_Alert_2_OBMetrix_Selected_Users__c',
      'Email_Alert_2_Original_User__c',
      'Email_Alert_2_Out_Of_Policy_User__c',
      'Disable_OBMetrix_App_Calculations__c',
      'Disable_OBMetrix_Tasks_Calculations__c',
      'Set_Approaching_Outbound_Event_Automatic__c',
      'Set_Approaching_Outbound_Opps_Automatic__c'
    };

    System.debug('settings here again' + obSettings);

    Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
    customMetadata.fullName = 'Settings__mdt.Main';
    customMetadata.label = 'Activity Subject Filters';

    for (String key : fieldList) {
      Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
      customField.field = key;
      customField.value = obSettings.get(key);

      System.debug('key' + key);
      System.debug('value' + obSettings.get(key));

      customMetadata.values.add(customField);
    }

    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
    mdContainer.addMetadata(customMetadata);
    OBMetrixSettingsService callback = new OBMetrixSettingsService();
    if (!Test.isRunningTest()) {
      Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
      System.debug('Deployment Process Id :: ' + jobId);
    }
  }
  /*
   * Get Map of Task & Events which is satisfied by setting filters for preview
   * Added on : 7th Jan 2020
   */
  @AuraEnabled
  public static Map<String, List<SObject>> getFilteredActivities(
    Settings__mdt obSettings,
    String accountId
  ) {
    Map<String, List<SObject>> resultMap = new Map<String, List<SObject>>();
    resultMap.put('OutboundEmail', new List<SObject>());
    resultMap.put('InboundEmail', new List<SObject>());
    resultMap.put('Call', new List<SObject>());
    resultMap.put('EnagagedCall', new List<SObject>());
    resultMap.put('OutboundMeeting', new List<SObject>());
    resultMap.put('Gift', new List<SObject>());
    resultMap.put('InMail', new List<SObject>());
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          Contact.sObjectType,
          new List<String>{ 'Id', 'AccountId' }
        )
    ) {
      Map<String, Contact> contactsMap = new Map<String, Contact>(
        new ContactSelector().selectContactsByAccountId(accountId)
      );
      if (contactsMap.size() > 0) {
        List<String> contactIds = new List<String>(contactsMap.keySet());
        if (
          ESAPI.accessController()
            .isAuthorizedToView(Task.sObjectType, TASKS_FIELDS)
        ) {
          List<String> taskOpFields = new List<String>();
          for (
            OBNDSelectOption wrp : OBMetricFieldPickListController.getFieldList(
              'Task',
              'Text'
            )
          ) {
            taskOpFields.add(wrp.value);
          }
          String query =
            'SELECT Id,' +
            String.join(taskOpFields, ', ') +
            ', CreatedDate FROM TASK WHERE WhoId IN :contactIds WITH USER_MODE ORDER BY CreatedDate';
          System.debug('query 190 :: ' + query);
          List<Task> allTasks = Database.query(query);
          for (Task task : allTasks) {
            boolean isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Outbound_Email_Advance__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('OutboundEmail').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Inbound_Email_Advance__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('InboundEmail').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Call_Advance__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('Call').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Engaged_Call_Advance__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('EnagagedCall').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Outbound_Meeting_Advance__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('OutboundMeeting').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.Gift_Advance1__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('Gift').add(task);
            }
            isApplicable = OutboundCalculationService.isApplicable(
              task,
              obSettings.InMail_Advance1__c,
              null
            );
            if (isApplicable == true) {
              resultMap.get('InMail').add(task);
            }
          }
        }
        if (
          ESAPI.accessController()
            .isAuthorizedToView(Event.sObjectType, EVENTS_FIELDS)
        ) {
          List<String> eventOpFields = new List<String>();
          for (
            OBNDSelectOption wrp : OBMetricFieldPickListController.getFieldList(
              'Event',
              'Text'
            )
          ) {
            eventOpFields.add(wrp.value);
          }
          String query =
            'SELECT ' +
            String.join(eventOpFields, ', ') +
            ', CreatedDate FROM EVENT WHERE WhoId IN :contactIds WITH USER_MODE ORDER BY CreatedDate';
          System.debug('query :: ' + query);
          List<Event> allEvent = Database.query(query);
          for (Event event : allEvent) {
            if (
              OutboundCalculationService.isApplicable(
                event,
                obSettings.Outbound_Meeting_Advance__c,
                null
              )
            ) {
              resultMap.get('OutboundMeeting').add(event);
            }
          }
        }
      }
    }
    return resultMap;
  }

  public class FieldWrapper {
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String apiName { get; set; }

    public FieldWrapper(DescribeFieldResult fieldDescribe) {
      this.label = fieldDescribe.getLabel();
      this.label = this.label.contains('ID')
        ? this.label.substringBefore('ID')
        : this.label;
      this.apiName = fieldDescribe.getName();
      this.apiName = this.apiName.endsWithIgnoreCase('Id')
        ? this.apiName.substring(0, this.apiName.length() - 2) + '.Name'
        : this.apiName;
      for (Schema.SObjectType reference : fieldDescribe.getReferenceTo()) {
        this.apiName = fieldDescribe.getRelationshipName() + '.Name';
      }
    }
    public FieldWrapper(String label, String apiName) {
      this.label = label;
      this.apiName = apiName;
    }
  }

  public void handleResult(
    Metadata.DeployResult result,
    Metadata.DeployCallbackContext context
  ) {
    System.debug('Do Nothing..');
  }

  /*
   * Check whether logged In user is Admin or not
   */
  public static boolean isAdminOrSystemAdmin() {
    List<String> fields = new List<String>{ 'Id', 'ProfileId' };
    if (ESAPI.accessController().isAuthorizedToView(User.sObjectType, fields)) {
      String loggedInId = UserInfo.getUserId();
      List<User> res = new UserSelector().selectIoAdminByRunningUserId();
      return res.size() > 0 || Test.isRunningTest();
    }
    return false;
  }

  //Retroactive Analysis

  @AuraEnabled
  public static void runAnalysis(String daysBack) {
    // Settings__mdt setting = new SettingsSelector().selectSkinnySetting();

    // setting.retroanalysis_isCompleted__c = true;
    // String isCompleted = MetaDataUtility.upsertMetadata(
    //   new List<Settings__mdt>{ setting }
    // );

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
  public static void erasaIOData() {
    Settings__mdt setting = new SettingsSelector().selectSkinnySetting();

    setting.retroanalysis_isCompleted__c = false;
    String isCompleted = MetaDataUtility.upsertMetadata(
      new List<Settings__mdt>{ setting }
    );
  }

  private static ApiResponse createStandardObjectPermissionSet() {
    ApiResponse response = new ApiResponse();

    List<PermissionSet> standardObjectPermissionSets = new PermissionSetSelector()
      .selectPermissionSetByName(
        C.STANDARD_OBJECT_PERMISSION_SET_NAME.replace(' ', '_')
      );
    PermissionSet standardObjectPermissionSet = !standardObjectPermissionSets.isEmpty()
      ? standardObjectPermissionSets[0]
      : null;

    Boolean doesStandardObjectPermissionAlreadyExist =
      standardObjectPermissionSet != null;

    if (!doesStandardObjectPermissionAlreadyExist) {
      standardObjectPermissionSet = new PermissionSet(
        Name = C.STANDARD_OBJECT_PERMISSION_SET_NAME.replace(' ', '_'),
        Label = C.STANDARD_OBJECT_PERMISSION_SET_NAME
      );

      Database.SaveResult standardObjectPermissionSetResult = Database.insert(
        standardObjectPermissionSet,
        false
      );

      if (!standardObjectPermissionSetResult.isSuccess()) {
        response.isSuccess = false;
        response.message =
          'Failed to create standard object permission set ' +
          standardObjectPermissionSetResult.getErrors()[0].getMessage();
        return response;
      }
    }

    Boolean doesFieldPermissionExist =
      [
        SELECT COUNT()
        FROM FieldPermissions
        WHERE
          ParentId = :standardObjectPermissionSet.Id
          AND SObjectType = 'Task'
          AND Field = 'Task.Type'
      ] > 0;

    if (!doesFieldPermissionExist) {
      List<FieldPermissions> fieldPermissionsToAdd = new List<FieldPermissions>();

      // Add field permissions with the helper method
      fieldPermissionsToAdd.add(
        createFieldPermission(
          'Task',
          'Task.Type',
          standardObjectPermissionSet.Id
        )
      );

      List<Database.UpsertResult> upsertResult = Database.upsert(
        fieldPermissionsToAdd,
        true
      );

      if (!upsertResult[0].isSuccess()) {
        response.isSuccess = false;
        response.message =
          'Failed to create standard object field permissions ' +
          upsertResult[0].getErrors()[0].getMessage();
        return response;
      }
    }

    response.isSuccess = true;
    response.message = 'Standard object permission set created successfully';
    response.data = standardObjectPermissionSet;
    return response;
  }

  @TestVisible
  private static ApiResponse assignStandardObjectPermissions() {
    ApiResponse response = new ApiResponse();

    ApiResponse createPermissionSetResponse = createStandardObjectPermissionSet();
    if (!createPermissionSetResponse.isSuccess) {
      return createPermissionSetResponse;
    }

    // assign the permission set to all holders of the OBMetrix permission set
    List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
    for (
      PermissionSetAssignment assignee : new PermissionSetAssignmentSelector()
        .selectAssignmentsByPermissionSetNameOrderedByAssignee(
          new Set<String>{ C.OBMETRIX }
        )
    ) {
      permissionSetAssignments.add(
        new PermissionSetAssignment(
          AssigneeId = assignee.AssigneeId,
          PermissionSetId = ((PermissionSet) createPermissionSetResponse.data)
            .Id
        )
      );
    }

    Database.SaveResult[] permissionSetAssignmentResults = Database.insert(
      permissionSetAssignments,
      false
    );

    for (
      Database.SaveResult permissionSetAssignmentResult : permissionSetAssignmentResults
    ) {
      Boolean isDupeAssignmentError = permissionSetAssignmentResult.getErrors()
          .isEmpty()
        ? false
        : permissionSetAssignmentResult.getErrors()[0]
            .getMessage()
            .containsIgnoreCase('duplicate');
      if (permissionSetAssignmentResult.isSuccess() || isDupeAssignmentError) {
        continue;
      }
      response.isSuccess = false;
      response.message =
        'Failed to assign standard object permission set ' +
        permissionSetAssignmentResult.getErrors()[0].getMessage();
      return response;
    }

    response.isSuccess = true;
    response.message = 'Standard object permissions created successfully';
    return response;
  }

  // Helper method to create FieldPermissions instances
  private static FieldPermissions createFieldPermission(
    String sObjectType,
    String fieldName,
    Id parentId
  ) {
    return new FieldPermissions(
      SObjectType = sObjectType,
      Field = fieldName,
      ParentId = parentId,
      PermissionsRead = true
    );
  }

  // Custom exception class for error handling
  public class CustomException extends Exception {
  }

  @AuraEnabled
  public static List<ApiResponse> runPostInstall() {
    List<ApiResponse> apiResponses = new List<ApiResponse>();

    Database.UpsertResult installDateResult = new PostInstallServices()
      .updateInstallDateIfNecessary();
    Boolean isInstallDateAlreadySet = installDateResult == null;

    ApiResponse permissionsResult = assignStandardObjectPermissions();
    apiResponses.add(permissionsResult);

    if (!isInstallDateAlreadySet) {
      ApiResponse installDateResponse = new ApiResponse();
      installDateResponse.isSuccess = installDateResult.isSuccess();
      installDateResponse.message = installDateResponse.isSuccess
        ? 'Install date updated successfully'
        : 'Failed to update install date ' +
          installDateResult.getErrors()[0].getMessage();
      apiResponses.add(installDateResponse);
    }

    return apiResponses;
  }
}