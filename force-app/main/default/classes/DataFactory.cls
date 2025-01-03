public with sharing class DataFactory {
  public static Task createTask(
    Id contactId,
    Boolean isOutbound,
    Boolean isInbound,
    Boolean isCall,
    Boolean isEngagedCall,
    Settings__mdt settings
  ) {
    String subject = isOutbound ? settings.Outbound_Email_Subject__c : ' task ';
    subject = isInbound ? settings.Inbound_Email_Subject__c : subject;
    subject = isCall ? settings.Call_Subject__c : subject;
    subject = isEngagedCall ? settings.Engaged_Call_Subject__c : subject;
    Task testTask = new Task(
      WhoId = contactId,
      Subject = subject,
      ActivityDate = Date.today(),
      Status = 'Completed',
      OwnerId = UserInfo.getUserId()
    );

    return testTask;
  }

  public static Event createEvent(Id contactId, Settings__mdt settings) {
    String subject = settings.Outbound_Meeting_Subject__c;
    Event testEvent = new Event(
      WhoId = contactId,
      Subject = subject,
      ActivityDate = Date.today(),
      StartDateTime = DateTime.now(),
      EndDateTime = DateTime.now().addHours(1),
      OwnerId = UserInfo.getUserId()
    );
    return testEvent;
  }

  public static Opportunity createOpportunity(Id accountId, Boolean isWon) {
    Opportunity testOpportunity = new Opportunity(
      Name = 'Test Opportunity',
      AccountId = accountId,
      CloseDate = Date.today().addDays(1),
      Amount = 100
    );
    testOpportunity.StageName = isWon ? 'Closed Won' : 'Prospecting';
    return testOpportunity;
  }

  public static Map<String, List<SObject>> singleAccountWithContact(
    String accountName
  ) {
    Map<String, List<SObject>> result = new Map<String, List<SObject>>();

    List<Account> testAccounts;

    Account testAccount = new Account(Name = accountName);
    insert testAccount;

    testAccounts = new List<Account>{ testAccount };

    List<Contact> testContacts = new List<Contact>();
    for (Integer contactsNum = 0; contactsNum < 1; contactsNum++) {
      Integer contactRandom = (Integer) Math.floor(Math.random() * 10000);
      testContacts.add(
        new Contact(
          AccountId = testAccounts[0].Id,
          FirstName = 'John',
          LastName = 'Smith ' + contactRandom,
          Email = 'john.smith+' + contactRandom + '@contact.invalid'
        )
      );
    }
    insert testContacts;

    result.put('accounts', testAccounts);
    result.put('contacts', testContacts);

    return result;
  }
}