public with sharing class CustomMetadataCache {
  @TestVisible
  private static Boolean disableOutboundEmailForTest = false;
  @TestVisible
  private static Boolean disableInmailForTest = false;
  @TestVisible
  private static Boolean disableGiftForTest = false;
  @TestVisible
  private static Boolean disableCallConnectForTest = false;
  @TestVisible
  private static Boolean disableDialForTest = false;
  @TestVisible
  private static Boolean disableInboundEmailForTest = false;
  @TestVisible
  private static Boolean disableActivateAutomatically = false;
  @TestVisible
  private static Boolean enableActivateAutomatically = false;
  @TestVisible
  private static Boolean enableActivationViaOpportunityCreationAutomatically = false;
  @TestVisible
  private static Boolean disableActivationViaOpportunityCreationAutomatically = false;
  @TestVisible
  private static Boolean disableActivationViaMeetingSet = false;
  @TestVisible
  private static Boolean withTaskMeetingObject = false;
  @TestVisible
  private static Boolean withEventMeetingObject = false;
  @TestVisible
  private static Integer withXActivitiesPerContact = 0;
  @TestVisible
  private static Integer withWaitPeriod = 0;
  @TestVisible
  private static Integer withContactTrackingPeriod = 0;
  @TestVisible
  private static String withOutboundEmailAdvance = '';
  @TestVisible
  private static String withAccountSuppressionCriteria = '';
  @TestVisible
  private static Boolean disableAccountSuppression = false;
  @TestVisible
  private static String withOpportunitySuppressionCriteria = '';

  private static Settings__mdt cachedSetting;
  public static Settings__mdt setting {
    get {
      if (disableOutboundEmailForTest) {
        cachedSetting = disabledOutboundEmailActivitySetting;
      }
      if (disableInmailForTest) {
        cachedSetting = disabledInMailSetting;
      }
      if (disableGiftForTest) {
        cachedSetting = disabledGiftSetting;
      }
      if (disableCallConnectForTest) {
        cachedSetting = disabledCallConnectSetting;
      }
      if (disableDialForTest) {
        cachedSetting = disabledDialSetting;
      }
      if (disableInboundEmailForTest) {
        cachedSetting = disabledInboundEmailSetting;
      }
      if (disableActivateAutomatically) {
        cachedSetting = activateAutomaticallyDisabledSetting;
      }
      if (enableActivateAutomatically) {
        cachedSetting = activateAutomaticallyEnabledSetting;
      }
      if (enableActivationViaOpportunityCreationAutomatically) {
        cachedSetting = activationViaOpportunityCreationAutomaticallyEnabledSetting;
      }
      if (disableActivationViaOpportunityCreationAutomatically) {
        cachedSetting = disableActivationViaOpportunityCreationAutomaticallySetting;
      }
      if (disableActivationViaMeetingSet) {
        cachedSetting = disableActivationViaMeetingSetSetting;
      }
      if (withTaskMeetingObject) {
        cachedSetting = withTaskMeetingObjectSetting;
      }
      if (withEventMeetingObject) {
        cachedSetting = withEventMeetingObjectSetting;
      }

      if (withXActivitiesPerContact > 0) {
        cachedSetting = withXActivitiesPerContactSetting;
      }
      if (withWaitPeriod > 0) {
        cachedSetting = withWaitPeriodSetting;
      }

      if (withContactTrackingPeriod > 0) {
        cachedSetting = withContactTrackingPeriodSetting;
      }

      if (String.isNotBlank(withOutboundEmailAdvance)) {
        cachedSetting = withOutboundEmailAdvanceSetting;
      }

      if (String.isNotBlank(withAccountSuppressionCriteria)) {
        cachedSetting = withAccountSuppressionCriteriaSetting;
      }

      if (disableAccountSuppression) {
        cachedSetting = withAccountSuppressionCriteriaSetting;
      }

      if (String.isNotBlank(withOpportunitySuppressionCriteria)) {
        cachedSetting = withOpportunitySuppressionCriteriaSetting;
      }

      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      return cachedSetting;
    }
  }

  /**
   * returns a setting with outbound email activity disabled for testing only
   */

  @TestVisible
  private static Settings__mdt cachedDisabledOutboundEmailActivitySetting;
  @TestVisible
  public static Settings__mdt disabledOutboundEmailActivitySetting {
    get {
      if (cachedDisabledOutboundEmailActivitySetting == null) {
        cachedDisabledOutboundEmailActivitySetting = new SettingsSelector()
          .selectSetting();
      }
      FieldFilter outboundEmailConfiguration = (FieldFilter) JSON.deserialize(
        cachedDisabledOutboundEmailActivitySetting.Outbound_Email_Advance__c,
        FieldFilter.class
      );
      outboundEmailConfiguration.disabled = true;
      cachedDisabledOutboundEmailActivitySetting.Outbound_Email_Advance__c = JSON.serialize(
        outboundEmailConfiguration
      );
      return cachedDisabledOutboundEmailActivitySetting;
    }
  }

  /**
   * returns a setting with inbound email disabled for testing only
   */

  @TestVisible
  private static Settings__mdt cachedDisabledInMailSetting;
  @TestVisible
  public static Settings__mdt disabledInMailSetting {
    get {
      if (cachedDisabledInMailSetting == null) {
        cachedDisabledInMailSetting = new SettingsSelector().selectSetting();
      }
      FieldFilter InMailConfiguration = (FieldFilter) JSON.deserialize(
        cachedDisabledInMailSetting.InMail_Advance1__c,
        FieldFilter.class
      );
      InMailConfiguration.disabled = true;
      cachedDisabledInMailSetting.InMail_Advance1__c = JSON.serialize(
        InMailConfiguration
      );
      return cachedDisabledInMailSetting;
    }
  }

  /**
   * returns a setting with gift disabled for testing only
   */

  @TestVisible
  public static Settings__mdt disabledGiftSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      FieldFilter giftConfiguration = (FieldFilter) JSON.deserialize(
        cachedSetting.Gift_Advance1__c,
        FieldFilter.class
      );
      giftConfiguration.disabled = true;
      cachedSetting.Gift_Advance1__c = JSON.serialize(giftConfiguration);
      return cachedSetting;
    }
  }

  /**
   * returns a setting with call connect disabled for testing only
   */

  @TestVisible
  public static Settings__mdt disabledCallConnectSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      FieldFilter callConnectConfiguration = (FieldFilter) JSON.deserialize(
        cachedSetting.Engaged_Call_Advance__c,
        FieldFilter.class
      );
      callConnectConfiguration.disabled = true;
      cachedSetting.Engaged_Call_Advance__c = JSON.serialize(
        callConnectConfiguration
      );
      return cachedSetting;
    }
  }

  /**
   * returns a setting with dial disabled for testing only
   */

  @TestVisible
  public static Settings__mdt disabledDialSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      FieldFilter dialConfiguration = (FieldFilter) JSON.deserialize(
        cachedSetting.Call_Advance__c,
        FieldFilter.class
      );
      dialConfiguration.disabled = true;
      cachedSetting.Call_Advance__c = JSON.serialize(dialConfiguration);
      return cachedSetting;
    }
  }

  /**
   * returns a setting with inbound email disabled for testing only
   */

  @TestVisible
  private static Settings__mdt cachedDisabledInboundEmailSetting;
  @TestVisible
  public static Settings__mdt disabledInboundEmailSetting {
    get {
      if (cachedDisabledInboundEmailSetting == null) {
        cachedDisabledInboundEmailSetting = new SettingsSelector()
          .selectSetting();
      }
      FieldFilter inboundEmailConfiguration = (FieldFilter) JSON.deserialize(
        cachedDisabledInboundEmailSetting.Inbound_Email_Advance__c,
        FieldFilter.class
      );
      inboundEmailConfiguration.disabled = true;
      cachedDisabledInboundEmailSetting.Inbound_Email_Advance__c = JSON.serialize(
        inboundEmailConfiguration
      );
      return cachedDisabledInboundEmailSetting;
    }
  }

  /**
   * returns a setting with activate automatically disabled for testing only
   */

  @TestVisible
  private static Settings__mdt cachedActivateAutomaticallyDisabledSetting;
  @TestVisible
  public static Settings__mdt activateAutomaticallyDisabledSetting {
    get {
      if (cachedActivateAutomaticallyDisabledSetting == null) {
        cachedActivateAutomaticallyDisabledSetting = new SettingsSelector()
          .selectSetting();
      }
      cachedActivateAutomaticallyDisabledSetting.Activate_Automatically1__c = false;
      return cachedActivateAutomaticallyDisabledSetting;
    }
  }

  /**
   * returns a setting with activate automatically enabled for testing only
   */
  @TestVisible
  public static Settings__mdt activateAutomaticallyEnabledSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Activate_Automatically1__c = true;
      return cachedSetting;
    }
  }

  /**
   * returns a setting with activation via opportunity creation automatically enabled for testing only
   */
  @TestVisible
  public static Settings__mdt activationViaOpportunityCreationAutomaticallyEnabledSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Set_Approaching_Outbound_Opps_Automatic__c = true;
      return cachedSetting;
    }
  }

  /**
   * returns a setting with task meeting object enabled for testing only
   */
  @TestVisible
  public static Settings__mdt withTaskMeetingObjectSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Meeting_Object__c = C.TASK_NAME;
      cachedSetting.Set_Approaching_Outbound_Event_Automatic__c = true;
      cachedSetting.Outbound_Meeting_Advance__c = '{"filters":[{"field":"Type","operator":"=","value":"Meeting"}],"disabled":false}';
      return cachedSetting;
    }
  }

  /**
   * returns a setting with event meeting object enabled for testing only
   */
  @TestVisible
  public static Settings__mdt withEventMeetingObjectSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Meeting_Object__c = C.EVENT_NAME;
      cachedSetting.Set_Approaching_Outbound_Event_Automatic__c = true;
      cachedSetting.Outbound_Meeting_Advance__c = '{"filters":[{"field":"Type","operator":"=","value":"Meeting"}],"disabled":false}';
      return cachedSetting;
    }
  }

  /**
   * returns a setting with activation via meeting set automatically disabled for testing only
   */
  @TestVisible
  public static Settings__mdt disableActivationViaMeetingSetSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Set_Approaching_Outbound_Event_Automatic__c = false;
      return cachedSetting;
    }
  }

  /**
   * returns a setting with activation via opportunity creation automatically disabled for testing only
   */
  @TestVisible
  public static Settings__mdt disableActivationViaOpportunityCreationAutomaticallySetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Set_Approaching_Outbound_Opps_Automatic__c = false;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withXActivitiesPerContactSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Activities_Created_by_User1__c = withXActivitiesPerContact;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withWaitPeriodSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Wait_Period__c = withWaitPeriod;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withContactTrackingPeriodSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Timeframe_Days_Contact1__c = withContactTrackingPeriod;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withOutboundEmailAdvanceSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Outbound_Email_Advance__c = withOutboundEmailAdvance;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withAccountSuppressionCriteriaSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Filter_Accounts_Criteria__c = disableAccountSuppression
        ? ''
        : withAccountSuppressionCriteria;
      return cachedSetting;
    }
  }

  @TestVisible
  public static Settings__mdt withOpportunitySuppressionCriteriaSetting {
    get {
      if (cachedSetting == null) {
        cachedSetting = new SettingsSelector().selectSetting();
      }
      cachedSetting.Filter_Opportunity_Criteria__c = withOpportunitySuppressionCriteria;
      return cachedSetting;
    }
  }
}