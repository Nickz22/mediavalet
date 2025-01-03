public with sharing class Mapper {
  public static Map<Id, List<SObject>> byId(
    List<SObject> records,
    String idField
  ) {
    Map<Id, List<SObject>> result = new Map<Id, List<SObject>>();
    for (SObject record : records) {
      Id id = (Id) record.get(idField);
      if (!result.containsKey(id)) {
        result.put(id, new List<SObject>());
      }
      result.get(id).add(record);
    }
    return result;
  }

  public static Map<Id, SObject> singleById(List<SObject> records) {
    Map<Id, SObject> result = new Map<Id, SObject>();
    for (SObject record : records) {
      Id id = (Id) record.get(C.ID_FIELD);
      result.put(id, record);
    }
    return result;
  }

  public static Map<Id, SObject> singleById(
    List<SObject> records,
    String idField
  ) {
    Map<Id, SObject> result = new Map<Id, SObject>();
    for (SObject record : records) {
      Id id = (Id) record.get(idField);
      result.put(id, record);
    }
    return result;
  }

  public static Map<Id, List<SObject>> byPath(
    List<SObject> records,
    String path
  ) {
    Map<Id, List<SObject>> resultMap = new Map<Id, List<SObject>>();

    // Loop through the list of records
    for (SObject record : records) {
      // Use getValueByPath to get the id at the end of the path
      Object value = Util.getValueByPath(record, path);

      // If the value is an Id
      if (value instanceof Id) {
        Id id = (Id) value;

        // If the map already contains this id, append to its list
        if (resultMap.containsKey(id)) {
          resultMap.get(id).add(record);
        } else {
          // Else, create a new list with the current record
          resultMap.put(id, new List<SObject>{ record });
        }
      } else {
        throw new MapperException('Path does not resolve to an Id');
      }
    }

    return resultMap;
  }

  public class MapperException extends Exception {
  }
}