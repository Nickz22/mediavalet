/**
 * @description Service class that contains functionality to calculate all Outbound Metrix
 */
public with sharing class OutboundCalculationService {
  /**
   * Check if Task or Event is applicable for given filter.
   * return true if its match to all filters given string.
   * Add on :: 6th Jan 2020
   **/
  public static boolean isApplicable(
    SObject taskOrEvent,
    String filterString,
    Pattern filterPattern
  ) {
    System.debug(filterString + ' ' + filterPattern);
    if (String.isBlank(filterString)) {
      System.debug('isApplicable filterString is blank');
      String subject = taskOrEvent.get('Subject') != null
        ? String.valueOf(taskOrEvent.get('Subject'))
        : null;
      // Maintain backword functionality if filter string is blank
      System.debug('isApplicable filterPattern:' + filterPattern);
      boolean returnResponse =
        filterPattern == null || filterPattern.matcher(subject).find();
      System.debug('isApplicable returnResponse:' + returnResponse);
      return returnResponse;
    }
    System.debug('isApplicable filterString is not blank');
    Map<Integer, String> criteriaRes = new Map<Integer, String>();
    try {
      FieldFilter fieldFilter = (FieldFilter) JSON.deserialize(
        filterString,
        FieldFilter.class
      );
      if (
        fieldFilter.filters == null ||
        fieldFilter.filters.isEmpty() ||
        fieldFilter.disabled == true
      ) {
        // Filter is disabled than return false;
        return fieldFilter.disabled != true;
      }
      integer count = 1;
      String filterLogic = fieldFilter.filterLogic;
      for (FieldFilterRow rowFilter : fieldFilter.filters) {
        Object fieldValue = null;
        String[] keyPath = rowFilter.field.split('\\.');
        SObject tempObj = taskOrEvent;
        for (integer i = 0; i < keyPath.size(); i++) {
          if (tempObj == null) {
            break;
          }
          if (i + 1 == keyPath.size()) {
            fieldValue = tempObj.get(keyPath.get(i));
          } else {
            tempObj = tempObj.getSObject(keyPath.get(i));
          }
        }
        String taskValue = fieldValue == null ? '' : String.valueOf(fieldValue);
        System.debug('fieldValue :: ' + taskValue);
        String operator = rowFilter.operator;
        String filterVal = rowFilter.value == null ? '' : rowFilter.value;
        Boolean matchFilter = false;
        switch on operator {
          when '=' {
            // compare equals
            matchFilter = taskValue == filterVal;
          }
          when '!=' {
            // compare not equals
            matchFilter = taskValue != filterVal;
          }
          when 'starts' {
            // compare starts with
            matchFilter = taskValue.startsWithIgnoreCase(filterVal);
          }
          when 'ends' {
            // compare ends with
            matchFilter = taskValue.endsWithIgnoreCase(filterVal);
          }
          when 'contains' {
            // compare contains
            System.debug('task value: ' + taskValue);
            System.debug('match: ' + filterVal);
            matchFilter = taskValue.containsIgnoreCase(filterVal);
          }
          when 'notcontains' {
            // compare not contains
            matchFilter = !taskValue.containsIgnoreCase(filterVal);
          }
        }
        criteriaRes.put(count, String.valueof(matchFilter));
        count++;
      }
      System.debug('match: ' + criteriaRes);
      if (String.isBlank(filterLogic)) {
        filterLogic = String.join(criteriaRes.values(), ' AND ');
      } else {
        for (Integer factNumber = count - 1; factNumber > 0; factNumber--) {
          filterLogic = filterLogic.replace(
            String.valueOf(factNumber),
            criteriaRes.get(factNumber)
          );
        }
      }
      boolean eval = BooleanExpression.evaluate(filterLogic);
      return eval;
    } catch (Exception e) {
      System.debug(
        '*** Filter processing error ' +
        e.getMessage() +
        ' Stack trace: ' +
        e.getStackTraceString()
      );
    }
    return false;
  }

  public static boolean isAdmin() {
    List<String> fields = new List<String>{ 'Id', 'ProfileId' };
    if (ESAPI.accessController().isAuthorizedToView(User.sObjectType, fields)) {
      String loggedInId = UserInfo.getUserId();
      List<User> res = [
        SELECT Id
        FROM User
        WHERE OBMetrix_Admin__c = TRUE AND Id = :loggedInId
      ];
      return res.size() > 0 || Test.isRunningTest();
    } else {
      system.debug('ACCESS ERROR');
    }
    return false;
  }
}