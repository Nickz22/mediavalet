public with sharing class C {
  public static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD {
    get {
      return (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
    }
  }
  public static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION {
    get {
      return (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;
    }
  }

  public enum ACCOUNT_ACTIVATION_ELIGIBLE {
    MEETING_SET,
    OPPORTUNITY_CREATED,
    CONTACTS_PER_ACCOUNT
  }

  public static final String DELIMITER {
    get {
      return ';';
    }
  }

  // standard object names
  public static final String EVENT_NAME {
    get {
      return 'Event';
    }
  }
  public static final String TASK_NAME {
    get {
      return 'Task';
    }
  }

  public static final String SETTING_NAME {
    get {
      return 'Main';
    }
  }

  public static final String OBMETRIX {
    get {
      return 'OBMetrix';
    }
  }

  public static final String OBMETRIX_PERFORMANCE {
    get {
      return 'OBMetrix_Performance';
    }
  }

  public static final String STANDARD_OBJECT_PERMISSION_SET_NAME {
    get {
      return 'InsideOutbound Standard Object Permissions';
    }
  }

  public static final String ASSIGNEE_ID {
    get {
      return 'AssigneeId';
    }
  }

  public static final String OPPORTUNITY {
    get {
      return 'Opportunity';
    }
  }

  public static final String EVENT {
    get {
      return 'Event';
    }
  }

  public static final String TASK {
    get {
      return 'Task';
    }
  }

  // standard field names
  public static final String ID_FIELD {
    get {
      return 'Id';
    }
  }

  public static final String OWNER_ID_FIELD {
    get {
      return 'OwnerId';
    }
  }

  public static final String ACTIVITY_SUBJECT_FIELD {
    get {
      return 'Subject';
    }
  }

  // Activity field names
  public static final String ACTIVITY_WHO_ID_FIELD {
    get {
      return 'WhoId';
    }
  }

  public static final String ACTIVITY_WHAT_ID_FIELD {
    get {
      return 'WhatId';
    }
  }

  // Opportunity field names
  public static final String OPPORTUNITY_AMOUNT_FIELD {
    get {
      return 'Amount';
    }
  }

  public static final String ACCOUNT_ID_FIELD {
    get {
      return 'AccountId';
    }
  }

  // Status field names
  public static final String STATUS_ACCOUNT_FIELD {
    get {
      return 'Account__c';
    }
  }

  public static final String STATUS_OPPORTUNITY_FIELD {
    get {
      return 'Opportunity__c';
    }
  }

  public static final String STATUS_PROSPECTING_STATUS_FIELD {
    get {
      return 'Prospecting_Status__c';
    }
  }

  public static final Map<String, String> PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME {
    get {
      if (PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME == null) {
        PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Status__c.Prospecting_Status__c.getDescribe();

        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
          PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME.put(
            f.getValue(),
            f.getLabel()
          );
        }
      }
      return PROSPECTING_STATUS_PICKLIST_LABEL_BY_API_NAME;
    }
    set;
  }

  // Prospecting Effort field names
  public static final String PROSPECTING_EFFORT_OS_FIELD {
    get {
      return 'Outbound_Status__c';
    }
  }

  public static final String PROSPECTING_EFFORT_STATUS_FIELD {
    get {
      return 'Status__c';
    }
  }

  // Outbound Contact Activation field names
  public static final String OUTBOUND_CONTACT_ACTIVATION_CONTACT_FIELD {
    get {
      return 'Contact__c';
    }
  }

  public static final String OUTBOUND_CONTACT_ACTIVATION_CONTACT_TO_ACCOUNT_ID_PATH {
    get {
      return 'Contact__r.AccountId';
    }
  }

  public static final String OUTBOUND_CONTACT_ACTIVATION_STATUS_FIELD {
    get {
      return 'Outbound_Status__c';
    }
  }

  // Claim Status Names
  public static final String OUTBOUND_PROSPECTING_STATUS_ACTIVATED {
    get {
      return 'Activated';
    }
  }
  public static final String OUTBOUND_PROSPECTING_STATUS_CLAIM_EXPIRED {
    get {
      return 'Claim Expired';
    }
  }
  public static final String OUTBOUND_PROSPECTING_STATUS_CLAIMED {
    get {
      return 'Claimed';
    }
  }

  public static final String OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE {
    get {
      return 'Unresponsive';
    }
  }

  public static final String OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED {
    get {
      return 'Opportunity Created';
    }
  }

  public static final String OUTBOUND_PROSPECTING_STATUS_NURTURE {
    get {
      return 'Nurture';
    }
  }

  public static final String OUTBOUND_PROSPECTING_STATUS_ENGAGED {
    get {
      return 'Engaged';
    }
  }

  public static final String OUTBOUND_PROSPECTING_STATUS_MEETING_SET {
    get {
      return 'Meeting_Set';
    }
  }

  public static final Set<String> ACTIVE_OUTBOUND_PROSPECTING_STATUSES {
    get {
      return new Set<String>{
        OUTBOUND_PROSPECTING_STATUS_CLAIMED,
        OUTBOUND_PROSPECTING_STATUS_NURTURE,
        OUTBOUND_PROSPECTING_STATUS_ENGAGED,
        OUTBOUND_PROSPECTING_STATUS_MEETING_SET,
        OUTBOUND_PROSPECTING_STATUS_ACTIVATED
      };
    }
  }

  public static final Set<String> INACTIVE_OUTBOUND_PROSPECTING_STATUSES {
    get {
      return new Set<String>{
        OUTBOUND_PROSPECTING_STATUS_CLAIM_EXPIRED,
        OUTBOUND_PROSPECTING_STATUS_UNRESPONSIVE,
        OUTBOUND_PROSPECTING_STATUS_OPPORTUNITY_CREATED
      };
    }
  }

  public static final String OUTBOUND_CONTACT_ACTIVATION_STATUS_RELATIONSHIP {
    get {
      return 'Outbound_Status__r';
    }
  }

  // filter constants
  public enum FilterLogicOperator {
    CONTAINS,
    NOTCONTAINS,
    EQUALS,
    STARTS,
    ENDS
  }
}