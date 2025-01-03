/*
 * OBMetring User Setting component Controller
 * Provide facility to get user list having 'OBMatrix' permission set and update it
 * Added On : 7th Feb 2020
 */
public with sharing class OBMetrixUserSettingsService {
  public static String OBMetrix_PermissionSet_Name = 'OBMetrix';
  public static String Edit_OBMetrix_Settings_PermissionSet_Name = 'Edit_OBMetrix_Settings';
  public static String OBMetrix_Performance_PermissionSet_Name = 'OBMetrix_Performance';

  @AuraEnabled
  public static Object getActivUsers() {
    Map<String, Object> result = new Map<String, Object>();
    List<OBNDSelectOption> activeUsers = new List<OBNDSelectOption>();
    List<User> activeUsersObj = new List<User>();
    boolean obMetrix = false;
    boolean obMetrixPerf = false;
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          PermissionSet.sObjectType,
          new List<String>{ 'Id', 'Name' }
        )
    ) {
      List<PermissionSet> pset = new PermissionSetSelector()
        .selectIoPermissions();
      for (PermissionSet p : pset) {
        obMetrix = obMetrix || p.Name == OBMetrix_PermissionSet_Name;
        obMetrixPerf =
          obMetrixPerf || p.Name == OBMetrix_Performance_PermissionSet_Name;
      }
    }

    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          User.sObjectType,
          new List<String>{
            'Id',
            'Name',
            'OBMetrix_Admin__c',
            'OBMetrix_Manager__c'
          }
        )
    ) {
      activeUsersObj = new UserSelector()
        .selectActiveLicensedUsersOrderedByName();
      for (User u : activeUsersObj) {
        activeUsers.add(new OBNDSelectOption(u.Name, u.Id));
      }
    }

    List<String> obmUserList = getOBMetrixUser();
    List<User> obmUsers = new List<User>();
    System.debug('obmUserList :: ' + obmUserList);
    for (User u : activeUsersObj) {
      if (obmUserList.contains(u.Id)) {
        obmUsers.add(u);
      }
    }

    result.put('activeUsers', activeUsers);
    result.put('activeUsersObj', obmUsers);
    result.put('selectedUsers', obmUserList);
    result.put(
      'selectedUsersPerf',
      getSelectedUser(OBMetrix_Performance_PermissionSet_Name)
    );
    result.put('obMetrix', obMetrix);
    result.put('obMetrixPerf', obMetrixPerf);
    return result;
  }

  public static List<String> getOBMetrixUser() {
    return getSelectedUser(OBMetrix_PermissionSet_Name);
  }
  /*
   * Get list of Users for given permission set name
   */
  public static List<String> getSelectedUser(String pSetName) {
    List<String> selectedUsersPerf = new List<String>();
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          PermissionSetAssignment.sObjectType,
          new List<String>{ 'Id', 'PermissionSetId', 'AssigneeId' }
        )
    ) {
      for (
        PermissionSetAssignment psa : new PermissionSetAssignmentSelector()
          .selectAssignmentsByPermissionSetNameOrderedByAssignee(
            new Set<String>{ pSetName }
          )
      ) {
        selectedUsersPerf.add(psa.AssigneeId);
      }
    }
    return selectedUsersPerf;
  }

  /*
   * Update permission set assignment to given users only. delete if any users removed from selection
   * Added on : 7th Feb 2020
   */
  @AuraEnabled
  public static void saveUserSettings(
    List<String> selectedUsers,
    List<String> selectedUsersPerf,
    List<User> activeUsersObj
  ) {
    saveUserSettings(selectedUsers, OBMetrix_PermissionSet_Name);
    // saveUserSettings(
    //   selectedUsersPerf,
    //   OBMetrix_Performance_PermissionSet_Name
    // );

    if (
      activeUsersObj != null &&
      activeUsersObj.size() > 0 &&
      ESAPI.accessController()
        .isAuthorizedToUpdate(
          User.sObjectType,
          new List<String>{ 'OBMetrix_Admin__c', 'OBMetrix_Manager__c' }
        )
    ) {
      ESAPI.accessController()
        .updateAsUser(
          new Map<Id, User>(activeUsersObj),
          new List<String>{ 'OBMetrix_Admin__c', 'OBMetrix_Manager__c' }
        );
    }

    //update 5/21/2020 - add/remove "Edit OBMetrix Settings" permission set based on "OBMetrix Admin" checkbox
    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          User.sObjectType,
          new List<String>{ 'Id', 'OBMetrix_Admin__c' }
        )
    ) {
      List<String> adminUserIds = new List<String>();
      List<User> selectedUserList = new UserSelector()
        .selectUsersByIds(selectedUsers);
      for (User u : selectedUserList) {
        if (u.OBMetrix_Admin__c) {
          adminUserIds.add(u.Id);
        }
      }

      if (!adminUserIds.isEmpty()) {
        saveUserSettings(
          adminUserIds,
          Edit_OBMetrix_Settings_PermissionSet_Name
        );
      }
    }
  }

  /*
   * Save / Delete Permission set assignment as per list given.
   */
  public static void saveUserSettings(
    List<String> selectedUsers,
    String pName
  ) {
    selectedUsers = selectedUsers == null ? new List<String>() : selectedUsers;
    Set<String> selectedUsersSet = new Set<String>(selectedUsers);
    List<PermissionSetAssignment> deleteAssigment = new List<PermissionSetAssignment>();

    if (
      ESAPI.accessController()
        .isAuthorizedToView(
          PermissionSetAssignment.sObjectType,
          new List<String>{ 'Id', 'PermissionSetId', 'AssigneeId' }
        )
    ) {
      for (
        PermissionSetAssignment psa : new PermissionSetAssignmentSelector()
          .selectAssignmentsByPermissionSetNameOrderedByAssignee(
            new Set<String>{ pName }
          )
      ) {
        if (!selectedUsers.contains(psa.AssigneeId)) {
          deleteAssigment.add(psa);
        } else {
          selectedUsersSet.remove(psa.AssigneeId);
        }
      }
      if (
        deleteAssigment.size() > 0 &&
        ESAPI.accessController()
          .isAuthorizedToDelete(PermissionSetAssignment.sObjectType)
      ) {
        ESAPI.accessController().deleteAsUser(deleteAssigment);
      }
    }
    if (
      selectedUsersSet.size() > 0 &&
      ESAPI.accessController()
        .isAuthorizedToView(
          PermissionSet.sObjectType,
          new List<String>{ 'Id', 'Name' }
        )
    ) {
      PermissionSet oBMetrixPermSet = new PermissionSetSelector()
        .selectPermissionSetByName(pName)[0];
      List<PermissionSetAssignment> newAssignment = new List<PermissionSetAssignment>();
      for (String newId : selectedUsersSet) {
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.PermissionSetId = oBMetrixPermSet.Id;
        psa.AssigneeId = newId;
        newAssignment.add(psa);
      }
      if (
        newAssignment.size() > 0 &&
        ESAPI.accessController()
          .isAuthorizedToCreate(
            PermissionSetAssignment.sObjectType,
            new List<String>{ 'PermissionSetId', 'AssigneeId' }
          )
      ) {
        ESAPI.accessController()
          .insertAsUser(
            newAssignment,
            new List<String>{ 'PermissionSetId', 'AssigneeId' }
          );
      }
    }
  }
}