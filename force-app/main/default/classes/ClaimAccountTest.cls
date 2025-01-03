@isTest
public class ClaimAccountTest {
  private static final Integer ACTIVITIES_FOR_CONTACT_ACTIVATION = (Integer) CustomMetadataCache.setting.Activities_Created_by_User1__c;

  @isTest
  static void given() {
    ioLicensedUser();
    oneAccount();
  }

  @isTest
  static void whenIClickClaimAccount_thenClaimedStatusIsCreated_andSubsequentActivatedContactsRollupCorrectly() {
    CustomMetadataCache.enableActivateAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      // Get the Account record
      Account testAccount = [SELECT Id FROM Account LIMIT 1];

      // Create a new instance of ActivateAccountBtnController
      ApexPages.StandardController stdController = new ApexPages.StandardController(
        testAccount
      );
      ActivateAccountBtnController controller = new ActivateAccountBtnController(
        stdController
      );

      Test.startTest();
      controller.init();
      Test.stopTest();

      Status__c outboundStatus = [
        SELECT Prospecting_Status__c, Claimed_By__c
        FROM Status__c
        WHERE Account__c = :testAccount.Id
        ORDER BY CreatedDate DESC
        LIMIT 1
      ];
      System.assertEquals(
        C.OUTBOUND_PROSPECTING_STATUS_CLAIMED,
        outboundStatus.Prospecting_Status__c,
        'Status should be claimed'
      );
      System.assertEquals(
        TestFactory.ioAgent.Id,
        outboundStatus.Claimed_By__c,
        'Claimed By should be the test user'
      );

      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Contact.SObjectType, Task.SObjectType }
      );
      Contact newContact = new Contact(LastName = 'New Contact');
      uow.registerRelationship(newContact, Contact.AccountId, testAccount);
      uow.registerNew(newContact);
      List<Task> tasks = new List<Task>();
      for (Integer i = 0; i < ACTIVITIES_FOR_CONTACT_ACTIVATION; i++) {
        Task t = TestFactory.createEligibleActivityForFilter(
          CustomMetadataCache.setting.Inbound_Email_Advance__c
        );
        uow.registerRelationship(t, Task.WhoId, newContact);
        tasks.add(t);
      }
      uow.registerNew(tasks);

      uow.commitWork();

      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Outbound_Contact_Activation__c
          WHERE Contact__r.Name = :'New Contact'
        ]
      );

      outboundStatus = [
        SELECT Prospecting_Status__c, Claimed_By__c, Total_Inbound_Emails__c
        FROM Status__c
        WHERE Account__c = :testAccount.Id AND Id = :outboundStatus.Id
        ORDER BY CreatedDate DESC
        LIMIT 1
      ];
      System.assertEquals(
        ACTIVITIES_FOR_CONTACT_ACTIVATION,
        outboundStatus.Total_Inbound_Emails__c
      );
      System.assertEquals(
        C.OUTBOUND_PROSPECTING_STATUS_ENGAGED,
        outboundStatus.Prospecting_Status__c
      );
    }
  }

  static void ioLicensedUser() {
    List<PermissionSetAssignment> ioAssignments = new PermissionSetAssignmentSelector()
      .selectAssignmentsByPermissionSetNameOrderedByAssignee(
        new Set<String>{ C.OBMETRIX, C.OBMETRIX_PERFORMANCE }
      );
    Set<Id> ioAssigneeIds = Pluck.ids(ioAssignments, C.ASSIGNEE_ID);
    System.assertEquals(
      true,
      ioAssigneeIds.contains(TestFactory.ioAgent.Id),
      'IO Agent is not an IO licensed user'
    );
  }

  static void oneAccount() {
    System.assertEquals(
      1,
      [SELECT COUNT() FROM Account],
      'expected a single account at start of test'
    );
  }

  @TestSetup
  static void makeData() {
    System.runAs(TestFactory.ioAgent) {
      insert new Account(Name = 'Test Account');
    }
  }
}