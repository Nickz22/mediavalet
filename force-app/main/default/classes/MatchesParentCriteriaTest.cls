@isTest
private class MatchesParentCriteriaTest {
  @isTest
  static void testParentCriteriaWithTaskFilter() {
    System.runAs(TestFactory.ioAgent) {
      // Build a sample filter referencing parent fields
      FieldFilter filter = new FieldFilter();
      filter.disabled = false;
      filter.filterLogic = '1 AND 2';
      filter.filters = new List<FieldFilterRow>{
        new FieldFilterRow('Who.Account.Name', '=', 'ParentCriteriaTest'),
        new FieldFilterRow('Subject', 'contains', 'Hello')
      };
      String filterString = JSON.serialize(filter);

      // Create an Account, Contact, and Task to satisfy the filter
      Account acc = new Account(Name = 'ParentCriteriaTest', Territory__c = 'United States');
      insert acc;
      Contact con = new Contact(
        FirstName = 'ParentTest',
        LastName = 'Contact',
        AccountId = acc.Id
      );
      insert con;
      Task t = new Task(
        Subject = 'Hello from Parent Criteria Test',
        WhoId = con.Id
      );
      insert t;

      // Confirm TaskHelper.isApplicable picks up on parent's field
      Test.startTest();
      ActivityContactWrapper criteriaWrapper = new ActivityContactWrapper(t, con);
      Boolean applicable = TaskHelper.isApplicable(criteriaWrapper, filterString, null);
      Test.stopTest();

      System.assert(
        applicable,
        'Filter should match on parent Account name and Task subject'
      );
    }
  }
}
