@IsTest
public class OBMetricFieldPickListController_Test {
  @IsTest
  public static void runTest() {
    List<OBNDSelectOption> fieldList = OBMetricFieldPickListController.getFieldList(
      'Account',
      'Date'
    );
    System.debug('fieldList :: ' + fieldList);
    System.assert(fieldList.size() > 0);
    fieldList = OBMetricFieldPickListController.getFieldList('Account', 'Text');
    System.debug('fieldList :: ' + fieldList);
    System.assert(fieldList.size() > 0);
    fieldList = OBMetricFieldPickListController.getFieldList('Account', 'User');
    System.debug('fieldList :: ' + fieldList);
    System.assert(fieldList.size() > 0);
    fieldList = OBMetricFieldPickListController.getFieldList(
      'Account',
      'Number'
    );
    System.debug('fieldList :: ' + fieldList);
    System.assert(fieldList.size() > 0);
    fieldList = OBMetricFieldPickListController.getFieldList(
      'Account',
      'Currency'
    );
    System.debug('fieldList :: ' + fieldList);
    fieldList = OBMetricFieldPickListController.getFieldList('Task', 'Text');
    System.debug('fieldList :: ' + fieldList);
    System.assert(fieldList.size() > 0);
    OBMetricFieldPickListController.getFieldLabel('', 'CreatedDate');
    OBMetricFieldPickListController.getFieldLabel('Account', 'CreatedDate');
    OBMetricFieldPickListController.getFieldLabel('Account', 'test');
  }
}