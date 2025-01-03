public with sharing class SettingsSelector {
  public SettingsSelector() {
  }

  public Settings__mdt selectSkinnySetting() {
    return [
      SELECT
        MasterLabel,
        DeveloperName,
        retroanalysis_isCompleted__c,
        retroanalysis_progressCounter__c
      FROM Settings__mdt
      WITH USER_MODE
      LIMIT 1
    ];
  }

  public Settings__mdt selectSetting() {
    return [
      SELECT
        Call_Subject__c,
        Inbound_Email_Subject__c,
        Outbound_Email_Subject__c,
        Activate_Automatically1__c,
        Engaged_Call_Subject__c,
        Outbound_Meeting_Subject__c,
        Inbound_Email_Subject_Filter__c,
        Wait_Period__c,
        Deactivate_After__c,
        Filter_Accounts_Criteria__c,
        Filter_Opportunity_Criteria__c,
        Call_Advance__c,
        Inbound_Email_Advance__c,
        Outbound_Email_Advance__c,
        Outbound_Meeting_Advance__c,
        Engaged_Call_Advance__c,
        Gift_Advance1__c,
        InMail_Advance1__c,
        Activities_Created_by_User1__c,
        Timeframe_Days_Contact1__c,
        Active_Contacts1__c,
        Timeframe_Days_Account1__c,
        Do_Not_Activate_if_Open_Opportunity1__c,
        Opportunity_Value_Field__c,
        Meeting_Object__c,
        Claim_Period__c,
        Limit_Number_of_Claims__c,
        Number_of_Simultaneous_Claims_per_Rep__c,
        User_Credit_Field__c,
        Disable_OBMetrix_App_Calculations__c,
        Email_Alert_A_C_Claimed_By_Another_User__c,
        Email_Alert_1_OBMetrix_Selected_Users__c,
        Email_Alert_1_Original_User__c,
        Email_Alert_1_Out_Of_Policy_User__c,
        Email_Alert_Activated_OR_Engaged_Status__c,
        Email_Alert_2_OBMetrix_Selected_Users__c,
        Email_Alert_2_Original_User__c,
        Email_Alert_2_Out_Of_Policy_User__c,
        Disable_OBMetrix_Tasks_Calculations__c,
        Set_Approaching_Outbound_Event_Automatic__c,
        Set_Approaching_Outbound_Opps_Automatic__c,
        retroanalysis_isCompleted__c
      FROM Settings__mdt
      WITH USER_MODE
      ORDER BY ID DESC
      LIMIT 1
    ];
  }
}