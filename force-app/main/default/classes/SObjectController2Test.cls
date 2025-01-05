@isTest
public with sharing class SObjectController2Test {
  static testMethod void test() {
    Account a1 = new Account(
      Name = 'Test1',
      AccountNumber = '1',
      Website = 'https://trailblazer.me/id/ericsmith',
      Type = 'Type1',
      Description = 'D1',
      Territory__c = 'United States'
    );
    insert a1;
    Account a2 = new Account(
      Name = 'Test2',
      AccountNumber = '2',
      Website = 'https://ericsplayground.wordpress.com/blog/',
      Type = 'Type2',
      Description = 'D2',
      Territory__c = 'United States'
    );
    insert a2;

    Account[] accts = [SELECT Id, Name, OwnerId FROM Account];
    String fieldnames = 'Name,Id,OwnerId,AccountNumber,Website,Type,Description,IsDeleted,CreatedDate,AnnualRevenue,Fax,LastActivityDate';
    String testResponse = SObjectController2.getReturnResults(
      accts,
      fieldnames
    );
    System.assert(testResponse.contains('"noEditFieldList":['));
    System.assert(testResponse.contains('"lookupFieldList":["OwnerId"]'));

    Account[] empty = [
      SELECT Id, Name, OwnerId
      FROM Account
      WHERE Name = 'NotInAccounts'
    ];
    String testEmpty = SObjectController2.getReturnResults(empty, fieldnames);
    System.assert(testEmpty.contains('"objectName":"EmptyCollection"'));
  }
}
