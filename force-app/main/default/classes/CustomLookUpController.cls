public with sharing class CustomLookUpController {
  @AuraEnabled
  public static List<sObject> fetchLookUpValues(
    String searchKeyWord,
    String ObjectName,
    String whereclause,
    integer LimitValue,
    string orderfield,
    string searchField,
    string orderBy,
    string selectedRecordId,
    List<String> idList,
    boolean idFilter
  ) {
    searchKeyWord = String.isBlank(searchKeyWord)
      ? ''
      : String.escapeSingleQuotes(searchKeyWord);
    ObjectName = String.isBlank(ObjectName)
      ? ''
      : String.escapeSingleQuotes(ObjectName);
    whereclause = String.isBlank(whereclause)
      ? ''
      : String.escapeSingleQuotes(whereclause);
    orderfield = String.isBlank(orderfield)
      ? ''
      : String.escapeSingleQuotes(orderfield);
    searchField = String.isBlank(searchField)
      ? ''
      : String.escapeSingleQuotes(searchField);
    orderBy = String.isBlank(orderBy) ? '' : String.escapeSingleQuotes(orderBy);
    selectedRecordId = String.isBlank(selectedRecordId)
      ? ''
      : String.escapeSingleQuotes(selectedRecordId);

    String searchKey = '%' + searchKeyWord + '%';
    if (LimitValue == null) {
      LimitValue = 5;
    }
    if (orderfield == null || orderfield == '') {
      orderfield = 'createdDate';
    }
    if (orderBy == null || orderBy == '') {
      orderBy = 'DESC';
    }
    List<sObject> returnList = new List<sObject>();

    // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
    String sQuery = 'select id, ';

    if (String.isNotBlank(searchField)) {
      squery += searchField;
    } else {
      squery += 'Name ';
    }

    sQuery += ' from ' + ObjectName + ' where ';

    if (String.isNotBlank(selectedRecordId)) {
      squery += 'Id = :selectedRecordId ';
    } else {
      if (String.isNotBlank(searchField)) {
        squery += searchField;
      } else {
        squery += 'Name ';
      }

      squery += ' LIKE: searchKey';

      if (String.isNotBlank(whereclause)) {
        sQuery += ' AND ' + whereclause;
      }

      if (idFilter == true && idList != null && !idList.isEmpty()) {
        sQuery += ' AND Id IN :idList ';
      }

      sQuery +=
        ' with user_mode ' +
        ' order by ' +
        orderfield +
        ' ' +
        orderBy +
        ' limit ' +
        LimitValue;
    }
    system.debug(searchKey + '--sQuery--' + sQuery);

    List<sObject> lstOfRecords = Database.query(sQuery);

    for (sObject obj : lstOfRecords) {
      returnList.add(obj);
    }
    return returnList;
  }
}