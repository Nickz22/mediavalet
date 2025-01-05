@isTest
private class MatchesParentCriteriaTest {
  @isTest
  static void testParentCriteriaWithTaskFilterInDb() {
    FieldFilter filter = new FieldFilter();
    filter.disabled = false;
    filter.filterLogic = '1 AND 2';
    filter.filters = new List<FieldFilterRow>{
      new FieldFilterRow('Who.Account.Name', '=', 'ParentCriteriaTest'),
      new FieldFilterRow('Subject', 'contains', 'Hello')
    };

    CustomMetadataCache.withOutboundEmailAdvance = JSON.serialize(filter);
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;

    System.runAs(TestFactory.ioAgent) {
      Account testAccount = new Account(
        Name = 'ParentCriteriaTest',
        Territory__c = 'United States'
      );
      insert testAccount;

      List<Contact> testContacts = new List<Contact>();
      for (Integer i = 0; i < 3; i++) {
        testContacts.add(
          new Contact(
            FirstName = 'ParentTest' + i,
            LastName = 'Contact' + i,
            AccountId = testAccount.Id
          )
        );
      }
      insert testContacts;

      Integer threshold = Integer.valueOf(
        settings.Activities_Created_by_User1__c
      );
      List<Task> tasks = new List<Task>();
      for (Contact c : testContacts) {
        for (Integer i = 0; i < threshold; i++) {
          tasks.add(
            new Task(
              Subject = 'Hello from Parent Criteria Test ' + i,
              WhoId = c.Id
            )
          );
        }
      }
      insert tasks;

      Test.startTest();
      testContacts[0] = new ContactSelector()
        .selectContactsWithAllAccountFields(
          new Set<Id>{ testContacts[0].Id }
        )[0];
      ActivityContactWrapper criteriaWrapper = new ActivityContactWrapper(
        tasks[0],
        testContacts[0]
      );
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Account__c IN (
              SELECT Id
              FROM Account
              WHERE Name = 'ParentCriteriaTest'
            )
        ],
        'Expected the account to have a Status__c record if threshold is met'
      );
    }
  }

  @isTest
  static void testContactFieldUsage() {
    FieldFilter filter = new FieldFilter();
    filter.disabled = false;
    filter.filterLogic = '1 AND 2';
    filter.filters = new List<FieldFilterRow>{
      new FieldFilterRow('Who.Name', '=', '_ ContactFieldTest'),
      new FieldFilterRow('Subject', 'contains', 'HelloFromContactTest')
    };

    CustomMetadataCache.withOutboundEmailAdvance = JSON.serialize(filter);
    CustomMetadataCache.enableActivateAutomatically = true;
    Settings__mdt settings = CustomMetadataCache.setting;
    Account acc;
    System.runAs(TestFactory.ioAgent) {
      acc = new Account(
        Name = 'ContactFieldTestAccount',
        Territory__c = 'United States'
      );
      insert acc;

      List<Contact> testContacts = new List<Contact>();
      for (Integer i = 0; i < 3; i++) {
        testContacts.add(
          new Contact(
            FirstName = '_',
            LastName = 'ContactFieldTest',
            AccountId = acc.Id
          )
        );
      }
      insert testContacts;

      Integer threshold = Integer.valueOf(
        settings.Activities_Created_by_User1__c
      );
      List<Task> tasks = new List<Task>();
      for (Contact c : testContacts) {
        for (Integer i = 0; i < threshold; i++) {
          tasks.add(
            new Task(Subject = 'HelloFromContactTest subject', WhoId = c.Id)
          );
        }
      }

      Test.startTest();
      insert tasks;
      Test.stopTest();
    }

    System.runAs(TestFactory.ioAdmin) {
      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE Account__c = :acc.Id
        ],
        'Expected the account to have a Status__c record if threshold is met'
      );
    }
  }
}
