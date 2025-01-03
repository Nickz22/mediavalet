/*
 * Test Class for OBMetrixUserSettingsService.
 * Added On : 7th Feb 2020
 */
@IsTest
public class OBMetrixUserSettingsServiceTest {
  @IsTest
  public static void runTest() {
    String userName = 'test' + System.currentTimeMillis() + '@Test.com';
    String userName1 = 'test1' + System.currentTimeMillis() + '@Test.com';
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User u = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = userName
    );
    insert u;

    User u1 = new User(
      Alias = 'stand1',
      Email = 'standarduser1@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = userName1,
      OBMetrix_Admin__c = true,
      OBMetrix_Manager__c = u.Id
    );
    insert u1;

    OBMetrixUserSettingsService.saveUserSettings(
      new List<String>{ u.Id },
      new List<String>{ u.Id },
      new List<User>{ u1 }
    );
    OBMetrixUserSettingsService.saveUserSettings(
      new List<String>{ u1.Id },
      new List<String>{ u1.Id },
      new List<User>{ u1 }
    );
    OBMetrixUserSettingsService.saveUserSettings(
      new List<String>{ u1.Id },
      new List<String>{ u1.Id },
      new List<User>{ u1 }
    );
    Map<String, Object> result = (Map<String, Object>) OBMetrixUserSettingsService.getActivUsers();
    System.assert(result != null && result.get('selectedUsers') != null);
  }
}