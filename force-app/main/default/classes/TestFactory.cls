@IsTest
public with sharing class TestFactory {
  private static final Integer CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD = (Integer) CustomMetadataCache.setting.Active_Contacts1__c;
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;
  private static Settings__mdt settings { get; set; }

  private static List<String> cachedOpenOpportunityStages;
  public static List<String> openOpportunityStages {
    get {
      if (cachedOpenOpportunityStages == null) {
        cachedOpenOpportunityStages = getOpenOpportunityStages();
      }
      return cachedOpenOpportunityStages;
    }
  }

  public static List<String> getOpenOpportunityStages() {
    // Create a list to store the stage values
    List<String> openStages = new List<String>();

    // Query the OpportunityStage object to get all open stages
    for (OpportunityStage stage : [
      SELECT MasterLabel
      FROM OpportunityStage
      WHERE IsClosed = FALSE
      ORDER BY MasterLabel
    ]) {
      openStages.add(stage.MasterLabel);
    }

    return openStages;
  }

  static User cachedIoAgent;
  public static User ioAgent {
    get {
      if (cachedIoAgent == null) {
        List<User> u = [
          SELECT Id
          FROM User
          WHERE Username = 'ioAgent@InsideOutboundtest.com'
        ];
        if (u.isEmpty()) {
          cachedIoAgent = createIoTestUser();
        } else {
          cachedIoAgent = u[0];
        }
      }
      return cachedIoAgent;
    }
  }

  static User cachedIoAdmin;
  public static User ioAdmin {
    get {
      if (cachedIoAdmin == null) {
        List<User> u = [
          SELECT Id
          FROM User
          WHERE Username = 'ioAdmin@InsideOutboundtest.com'
        ];
        if (u.isEmpty()) {
          cachedIoAdmin = createIoAdminUser();
        } else {
          cachedIoAdmin = u[0];
        }
      }
      return cachedIoAdmin;
    }
  }

  // create test user with assignments to permission sets with names new Set<String>{ C.OBMetrix, C.OBMetrix_Performance }
  public static User createIoTestUser() {
    User testUser = new User(
      Alias = 'testuser',
      Email = 'ioAgent@InsideOutboundtest.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Test Io Agent',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
      .Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'ioAgent@InsideOutboundtest.com',
      IsActive = true
    );
    insert testUser;

    List<PermissionSet> permissionSets = [
      SELECT Id
      FROM PermissionSet
      WHERE Name IN (:C.OBMETRIX, :C.OBMETRIX_PERFORMANCE)
    ];
    List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
    for (PermissionSet permissionSet : permissionSets) {
      assignments.add(
        new PermissionSetAssignment(
          AssigneeId = testUser.Id,
          PermissionSetId = permissionSet.Id
        )
      );
    }
    insert assignments;

    return testUser;
  }

  public static User createIoAdminUser() {
    User testUser = new User(
      Alias = 'testuser',
      Email = 'ioAdmin@InsideOutboundtest.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Test Io Admin',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
      .Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'ioAdmin@InsideOutboundtest.com',
      IsActive = true
    );
    insert testUser;

    List<PermissionSet> permissionSets = [
      SELECT Id
      FROM PermissionSet
      WHERE Name IN (:C.OBMETRIX, :C.OBMETRIX_PERFORMANCE)
    ];

    List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
    for (PermissionSet permissionSet : permissionSets) {
      assignments.add(
        new PermissionSetAssignment(
          AssigneeId = testUser.Id,
          PermissionSetId = permissionSet.Id
        )
      );
    }
    insert assignments;

    return testUser;
  }

  static {
    settings = [
      SELECT
        Call_Subject__c,
        Inbound_Email_Subject__c,
        Outbound_Email_Subject__c,
        Engaged_Call_Subject__c,
        Outbound_Meeting_Subject__c
      FROM Settings__mdt
      LIMIT 1
    ];
  }

  public static void generateMasterData() {
    List<Account> testAccounts = new List<Account>{
      new Account(Name = 'Test Account 1'),
      new Account(Name = 'Test Account 2'),
      new Account(Name = 'Test Account 3'),
      new Account(Name = 'Test Account 4')
    };
    insert testAccounts;

    List<Contact> testContacts = new List<Contact>{
      new Contact(
        AccountId = testAccounts[0].Id,
        FirstName = 'Test',
        LastName = 'Contact 1',
        Email = 'test1@contact.invalid'
      ),
      new Contact(
        AccountId = testAccounts[1].Id,
        FirstName = 'Test',
        LastName = 'Contact 2',
        Email = 'test2@contact.invalid'
      ),
      new Contact(
        AccountId = testAccounts[2].Id,
        FirstName = 'Test',
        LastName = 'Contact 3',
        Email = 'test3@contact.invalid'
      ),
      new Contact(
        AccountId = testAccounts[1].Id,
        FirstName = 'Test',
        LastName = 'Contact 4',
        Email = 'test4@contact.invalid'
      )
    };
    insert testContacts;
  }

  /** TODO: replace activation flow with OS object */
  public static void activateAccount(Id testAccountId) {
    Account testAccount = [SELECT Id FROM Account WHERE Id = :testAccountId];
    ApexPages.StandardController stdController = new ApexPages.StandardController(
      testAccount
    );
    ActivateAccountBtnController activationController = new ActivateAccountBtnController(
      stdController
    );
    activationController.init();
  }

  public static Task createTask(
    Id contactId,
    Boolean isOutbound,
    Boolean isInbound,
    Boolean isCall,
    Boolean isEngagedCall
  ) {
    return DataFactory.createTask(
      contactId,
      isOutbound,
      isInbound,
      isCall,
      isEngagedCall,
      settings
    );
  }

  public static Opportunity createOpportunity(Id accountId, Boolean isWon) {
    return DataFactory.createOpportunity(accountId, isWon);
  }

  public static Event createTestEvent(Id contactId) {
    return DataFactory.createEvent(contactId, settings);
  }

  public static String getOpenOpportunityStageName() {
    return [
      SELECT MasterLabel
      FROM OpportunityStage
      WHERE IsClosed = FALSE
      LIMIT 1
    ]
    .MasterLabel;
  }

  /**
   * @param taskCriteria - JSON string representing the criteria for the task
   * @param uow - Unit of Work to register the created objects
   * @return uow registered Account.SObjectType, Contact.SobjectType and Task.SObjectType sufficient to activate the account
   */
  public static fflib_SObjectUnitOfWork initActivatedContactData(
    String taskCriteria,
    fflib_SObjectUnitOfWork uow
  ) {
    Account activatedAccount = new Account(Name = 'activated account ');
    uow.registerNew(activatedAccount);

    List<Contact> activatedContacts = new List<Contact>();
    for (Integer i = 0; i < CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD; i++) {
      Contact activatedContact = new Contact(
        LastName = 'activated contact ' + i
      );
      activatedContacts.add(activatedContact);
      uow.registerRelationship(
        activatedContact,
        Contact.AccountId,
        activatedAccount
      );
    }
    uow.registerNew(activatedContacts);

    List<Task> outboundTasks = new List<Task>();
    for (Contact c : activatedContacts) {
      for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(taskCriteria);
        uow.registerRelationship(t, Task.WhoId, c);
        outboundTasks.add(t);
      }
    }

    uow.registerNew(outboundTasks);
    return uow;
  }

  public static Task createEligibleActivityForFilter(String jsonString) {
    // Deserializing JSON to FieldFilter object
    FieldFilter filterObject = (FieldFilter) JSON.deserialize(
      jsonString,
      FieldFilter.class
    );

    // Create a new Task object
    Task task = new Task();

    // Populate required fields - Adjust these as needed for your org
    task.Status = 'Open';
    task.Priority = 'Normal';
    task.Subject = 'Testing';

    // Iterate through the filters
    for (FieldFilterRow filter : filterObject.filters) {
      String field = filter.field;
      String operator = filter.operator;
      String value = filter.value;

      // Populate fields based on operator
      switch on operator {
        when '=' {
          task.put(field, value);
        }
        when '!=' {
          task.put(field, 'Not Equal Dummy Data');
        }
        when 'contains' {
          task.put(field, value + ' Dummy Data');
        }
        when 'notcontains' {
          task.put(field, 'Dummy Data Not Containing');
        }
        when 'starts' {
          task.put(field, value + ' Dummy Data');
        }
        when 'ends' {
          task.put(field, 'Dummy Data ' + value);
        }
      }
    }

    return task;
  }

  public static Event createEligibleEventForFilter(String jsonString) {
    // Deserializing JSON to FieldFilter object
    FieldFilter filterObject = (FieldFilter) JSON.deserialize(
      jsonString,
      FieldFilter.class
    );

    // Create a new Event object
    Event event = new Event(
      DurationInMinutes = 30,
      ActivityDateTime = Datetime.now(),
      Subject = 'test'
    );

    // Iterate through the filters
    for (FieldFilterRow filter : filterObject.filters) {
      String field = filter.field;
      String operator = filter.operator;
      String value = filter.value;

      // Populate fields based on operator
      switch on operator {
        when '=' {
          event.put(field, value);
        }
        when '!=' {
          event.put(field, 'Not Equal Dummy Data');
        }
        when 'contains' {
          event.put(field, value + ' Dummy Data');
        }
        when 'notcontains' {
          event.put(field, 'Dummy Data Not Containing');
        }
        when 'starts' {
          event.put(field, value + ' Dummy Data');
        }
        when 'ends' {
          event.put(field, 'Dummy Data ' + value);
        }
      }
    }

    return event;
  }
}