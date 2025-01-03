public with sharing class PermissionSetAssignmentSelector {
  public PermissionSetAssignmentSelector() {
  }

  public List<PermissionSetAssignment> selectAssignmentsByPermissionSetNameOrderedByAssignee(
    Set<String> permissionSetNames
  ) {
    return [
      SELECT AssigneeId
      FROM PermissionSetAssignment
      WHERE PermissionSet.Name IN :permissionSetNames
      ORDER BY Assignee.Name
    ];
  }
}