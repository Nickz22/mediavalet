public with sharing class UserSelector {
  public UserSelector() {
  }

  public List<User> selectActiveUsersOrderedByName() {
    return [
      SELECT Id, Name
      FROM User
      WHERE IsActive = TRUE
      WITH USER_MODE
      ORDER BY Name
    ];
  }

  public List<User> selectIoAdminByRunningUserId() {
    return [
      SELECT Id
      FROM User
      WHERE
        (OBMetrix_Admin__c = TRUE
        OR Profile.Name LIKE '%System Administrator%')
        AND Id = :UserInfo.getUserId()
      WITH USER_MODE
    ];
  }

  public List<User> selectActiveLicensedUsersOrderedByName() {
    return [
      SELECT Id, Name, OBMetrix_Admin__c, OBMetrix_Manager__c
      FROM User
      WHERE IsActive = TRUE AND Profile.UserLicenseId != NULL
      WITH USER_MODE
      ORDER BY Name
    ];
  }

  public List<User> selectUsersByIds(List<String> ids) {
    return [
      SELECT Id, OBMetrix_Admin__c
      FROM User
      WHERE Id IN :ids
      WITH USER_MODE
    ];
  }
}