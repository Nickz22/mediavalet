public with sharing class Pluck {
  public static Set<Id> ids(List<SObject> records) {
    Set<Id> ids = new Set<Id>();
    for (SObject record : records) {
      ids.add(record.Id);
    }
    return ids;
  }

  public static Set<Id> ids(List<SObject> records, String idField) {
    Set<Id> ids = new Set<Id>();
    for (SObject record : records) {
      ids.add((Id) record.get(idField));
    }
    return ids;
  }

  public static Set<String> strings(List<SObject> records, String path) {
    Set<String> strings = new Set<String>();
    for (SObject record : records) {
      strings.add((String) Util.getValueByPath(record, path));
    }
    return strings;
  }

  public static Set<Id> idsAtPath(List<SObject> records, String path) {
    Set<Id> ids = new Set<Id>();
    for (SObject record : records) {
      ids.add((Id) Util.getValueByPath(record, path));
    }
    return ids;
  }

  public static List<SObject> parentSObjects(
    List<SObject> records,
    String relationshipPath
  ) {
    Map<Id, SObject> sObjectById = new Map<Id, SObject>();

    for (SObject r : records) {
      SObject sobj = r.getSObject(relationshipPath);
      sObjectById.put(sobj.Id, sobj);
    }

    return sObjectById.values();
  }
}