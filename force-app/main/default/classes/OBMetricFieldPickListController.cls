/*
 * Provide list of fields for SObject given and related type of fields
 * Added On : 30th Jan 2020
 * Test Class :: OBMetricFieldPickListController_Test
 */
public with sharing class OBMetricFieldPickListController {
  /*
   * Get all required fields for given SObject and type of field
   * FieldType should be 'Text', 'User' or 'Date' accepted only
   */
  @AuraEnabled(cacheable=true)
  public static List<OBNDSelectOption> getFieldList(
    String objectApi,
    String fieldType
  ) {
    objectApi = String.isBlank(objectApi)
      ? ''
      : String.escapeSingleQuotes(objectApi);

    Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectApi);
    List<OBNDSelectOption> fieldList = new List<OBNDSelectOption>();

    // escape

    if (String.isBlank(objectApi)) {
      return fieldList;
    }
    Map<String, Schema.SobjectField> fmap = sObjType.getDescribe()
      .fields.getMap();
    fieldList.addAll(getFieldList(objectApi, fieldType, fmap.values(), false));
    fieldList.addAll(getFieldList(objectApi, fieldType, fmap.values(), true));
    return fieldList;
  }

  /**
   * Retrieve type related fields from all field passed.
   * FieldType should be 'Text', 'User' or 'Date' accepted only
   */
  public static List<OBNDSelectOption> getFieldList(
    String objectApi,
    String fieldType,
    List<Schema.SobjectField> sObjFieldList,
    boolean isSystem
  ) {
    objectApi = String.isBlank(objectApi)
      ? ''
      : String.escapeSingleQuotes(objectApi);

    List<OBNDSelectOption> fieldList = new List<OBNDSelectOption>();
    for (Schema.SObjectField sObjField : sObjFieldList) {
      Schema.DescribeFieldResult descField = sObjField.getDescribe();
      if (isSystem && descField.getName().endsWith('__c')) {
        continue;
      }
      if (!isSystem && !descField.getName().endsWith('__c')) {
        continue;
      }
      String dataType = String.valueOf(descField.getType());
      //System.debug('descField.getName() ' + descField.getName());
      //System.debug('descField.getType() ' + descField.getType());
      if (
        fieldType.endsWithIgnoreCase('Date') &&
        (dataType == 'DATE' ||
        dataType == 'DATETIME')
      ) {
        fieldList.add(
          new OBNDSelectOption(descField.getLabel(), descField.getName())
        );
      }
      if (
        fieldType.endsWithIgnoreCase('Text') &&
        (dataType == 'STRING' ||
        dataType == 'TEXTAREA' ||
        dataType == 'PICKLIST' ||
        dataType == 'MULTIPICKLIST' ||
        dataType == 'PHONE' ||
        dataType == 'COMBOBOX' ||
        dataType == 'EMAIL' ||
        dataType == 'URL')
      ) {
        fieldList.add(
          new OBNDSelectOption(descField.getLabel(), descField.getName())
        );
      }

      List<String> excludeNameFields = new List<String>();
      excludeNameFields.add('ConnectionReceived');
      excludeNameFields.add('ConnectionSent');
      excludeNameFields.add('ActivityRecurrence2');
      excludeNameFields.add('ActivityRecurrence2Exception');
      excludeNameFields.add('ProposedEventTimeframe');
      if (
        fieldType.endsWithIgnoreCase('Text') &&
        dataType == 'REFERENCE' &&
        descField.getReferenceTo() != null &&
        descField.getReferenceTo().size() > 0 &&
        descField.getRelationshipName() != null &&
        //exclude certain lookup fields because they do not have a "Name" field
        !excludeNameFields.contains(descField.getRelationshipName())
      ) {
        fieldList.add(
          new OBNDSelectOption(
            descField.getLabel().replace(' ID', ''),
            descField.getRelationshipName() + '.Name'
          )
        );
      }
      if (fieldType.endsWithIgnoreCase('User') && dataType == 'REFERENCE') {
        for (SObjectType refType : descField.getReferenceTo()) {
          String refObjName = refType.getDescribe().getName();
          if (refObjName == 'User') {
            fieldList.add(
              new OBNDSelectOption(
                descField.getLabel().replace(' ID', ''),
                descField.getName()
              )
            );
          }
        }
      }
      if (
        fieldType.endsWithIgnoreCase('Number') &&
        (dataType == 'CURRENCY' ||
        dataType == 'DOUBLE' ||
        dataType == 'INTEGER')
      ) {
        fieldList.add(
          new OBNDSelectOption(descField.getLabel(), descField.getName())
        );
      }
      if (fieldType.endsWithIgnoreCase('Currency') && dataType == 'CURRENCY') {
        fieldList.add(
          new OBNDSelectOption(descField.getLabel(), descField.getName())
        );
      }
    }
    return fieldList;
  }

  /**
   * Return field label for object and field api name
   */
  public static String getFieldLabel(String objectApi, String fieldApi) {
    Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectApi);
    if (String.isBlank(objectApi)) {
      return fieldApi;
    }
    Map<String, Schema.SobjectField> fmap = sObjType.getDescribe()
      .fields.getMap();
    for (Schema.SObjectField sObjField : fmap.values()) {
      Schema.DescribeFieldResult descField = sObjField.getDescribe();
      String dataType = String.valueOf(descField.getType());
      if (fieldApi == descField.getName()) {
        return dataType == 'REFERENCE'
          ? descField.getLabel().replace(' ID', '')
          : descField.getLabel();
      }
    }

    return fieldApi;
  }
}