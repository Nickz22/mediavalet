public without sharing class PermissionSetSelector {
  public static String OBMETRIX_PERMISSIONSET_NAME = 'OBMetrix';
  static final String OBMETRIX_PERFORMANCE_PERMISSIONSET_NAME = 'OBMetrix_Performance';

  public PermissionSetSelector() {
  }

  public List<PermissionSet> selectIoPermissions() {
    return [
      SELECT Id, Name
      FROM PermissionSet
      WHERE
        Name = :OBMETRIX_PERMISSIONSET_NAME
        OR Name = :OBMETRIX_PERFORMANCE_PERMISSIONSET_NAME
    ];
  }

  public List<PermissionSet> selectPermissionSetByName(String pName) {
    return [SELECT Id FROM PermissionSet WHERE Name = :pName];
  }
}