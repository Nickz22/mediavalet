public with sharing class PermissionsCache {
  private static Set<Id> cachedIoUserIds;
  public static Set<Id> ioUserIds {
    get {
      if (cachedIoUserIds == null) {
        cachedIoUserIds = Pluck.ids(
          new PermissionSetAssignmentSelector()
            .selectAssignmentsByPermissionSetNameOrderedByAssignee(
              new Set<String>{ C.OBMETRIX, C.OBMETRIX_PERFORMANCE }
            ),
          C.ASSIGNEE_ID
        );
      }
      return cachedIoUserIds;
    }
  }

  private static List<User> cachedIoUsers;
  public static List<User> ioUsers {
    get {
      if (cachedIoUsers == null) {
        cachedIoUsers = [SELECT Name FROM User WHERE Id IN :ioUserIds];
      }
      return cachedIoUsers;
    }
  }
}