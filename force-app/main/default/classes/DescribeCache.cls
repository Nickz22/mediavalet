global with sharing class DescribeCache {
  // get global describe
  static Map<String, SObjectType> cachedGlobalDescribe = new Map<String, SObjectType>();
  static final Map<SObjectType, Map<String, ChildRelationship>> relationships = new Map<SObjectType, Map<String, ChildRelationship>>();
  static final Map<SObjectType, Map<String, SObjectField>> fields = new Map<SObjectType, Map<String, SObjectField>>();

  global static Map<String, SObjectField> getFieldMapFor(
    String sObjectTypeName
  ) {
    if (!cachedGlobalDescribe.containsKey(sObjectTypeName)) {
      cachedGlobalDescribe.put(
        sObjectTypeName,
        Schema.getGlobalDescribe().get(sObjectTypeName)
      );
    }
    return cachedGlobalDescribe.get(sObjectTypeName)
      .getDescribe()
      .fields.getMap();
  }

  global static ChildRelationship getChildRelationship(
    SObjectType sObjectType,
    String name
  ) {
    if (relationships.containsKey(sObjectType))
      return relationships.get(sObjectType).get(name);
    Map<String, ChildRelationship> children = new Map<String, ChildRelationship>();
    for (
      ChildRelationship relation : sObjectType.getDescribe()
        .getChildRelationships()
    )
      children.put(relation.getRelationshipName(), relation);
    relationships.put(sObjectType, children);
    return children.get(name);
  }

  global static SObjectField getField(
    SObjectType sObjectType,
    String fieldPath
  ) {
    if (sObjectType == null || fieldPath == null)
      return null;
    if (!fields.containsKey(sObjectType))
      fields.put(sObjectType, sObjectType.getDescribe().fields.getMap());
    if (!fieldPath.contains('.'))
      return fields.get(sObjectType).get(fieldPath);

    Relationship relation = new Relationship(fieldPath.substringBefore('.'));
    SObjectField field = fields.get(sObjectType).get(relation.getFieldPath());
    if (field == null)
      return null;

    SObjectType parentType = field.getDescribe().getReferenceTo()[0];
    return getField(parentType, fieldPath.substringAfter('.'));
  }
  class Relationship {
    final String name;
    public Relationship(String name) {
      this.name = name;
    }
    public String getFieldPath() {
      if (name == null)
        return null;
      return name.endsWith('__r') ? name.replace('__r', '__c') : name + 'Id';
    }
  }
}