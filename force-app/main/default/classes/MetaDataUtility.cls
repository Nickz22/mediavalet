public class MetaDataUtility {
  public static String upsertMetadata(List<sObject> customMetadataList) {
    //Create Deployment container for custom Metadata
    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
    for (sobject sObMD : customMetadataList) {
      //Get metadata object name and details
      String sObjectname = sObMD.getSObjectType().getDescribe().getName();

      //Create custom Metadata instance
      Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
      String recordName = String.valueOf(sObMD.get('DeveloperName'))
        .replaceAll(' ', '_');
      customMetadata.fullName = sObjectname + '.' + recordName;
      customMetadata.label = (String) sObMD.get('MasterLabel');

      //Get all fields
      schema.SObjectType sobjType = Schema.getGlobalDescribe().get(sObjectname);

      Map<String, Schema.sObjectField> sObjectFields = sobjType.getDescribe()
        .fields.getMap();
      Set<String> skipFieldSet = new Set<String>{
        'developername',
        'masterlabel',
        'language',
        'namespaceprefix',
        'label',
        'qualifiedapiname',
        'id'
      };

      // Use getPopulatedFieldsAsMap to get the populate field and iterate over them
      for (String fieldName : sObMD.getPopulatedFieldsAsMap().keySet()) {
        if (
          skipFieldSet.contains(fieldName.toLowerCase()) ||
          sObMD.get(fieldName) == null
        )
          continue;

        Object value = sObMD.get(fieldName);
        //create field instance and populate it with field API name and value
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = fieldName;

        Schema.DisplayType valueType = sObjectFields.get(fieldName)
          .getDescribe()
          .getType();
        if (value instanceof String && valueType != Schema.DisplayType.String) {
          String svalue = (String) value;
          if (valueType == Schema.DisplayType.Date)
            customField.value = Date.valueOf(svalue);
          else if (valueType == Schema.DisplayType.DateTime) {
            //DateTime is a special case which we need to handle carefully. It is working in my case you need to handle it.
            try {
              String d1 = svalue;
              list<String> d2 = d1.split('-');
              list<integer> timeComponent = new List<integer>();
              timeComponent.add(Integer.valueOf(d2[0]));
              timeComponent.add(Integer.valueOf(d2[1]));
              timeComponent.add(Integer.valueOf(d2[2].left(2)));

              String t = d2[2].substringBetween('T', '.');

              list<String> time1 = t.split(':');
              timeComponent.add(Integer.valueOf(time1[0]));
              timeComponent.add(Integer.valueOf(time1[1]));
              timeComponent.add(Integer.valueOf(time1[2]));

              Datetime dt = Datetime.newInstance(
                timeComponent[0],
                timeComponent[1],
                timeComponent[2],
                timeComponent[3],
                timeComponent[4],
                timeComponent[5]
              );
              customField.value = dt;
            } catch (exception ex) {
            }
          } else if (
            valueType == Schema.DisplayType.Percent ||
            valueType == Schema.DisplayType.Currency
          )
            customField.value = Decimal.valueOf(svalue);
          else if (valueType == Schema.DisplayType.Double)
            customField.value = Double.valueOf(svalue);
          else if (valueType == Schema.DisplayType.Integer)
            customField.value = Integer.valueOf(svalue);
          else if (valueType == Schema.DisplayType.Base64)
            customField.value = Blob.valueOf(svalue);
          else
            customField.value = svalue;
        } else
          customField.value = value;
        //Add fields in the object, similar to creating sObject instance
        customMetadata.values.add(customField);
      }
      //Add metadata in container
      mdContainer.addMetadata(customMetadata);
    }

    // Callback class instance
    CustomMetadataCallback callback = new CustomMetadataCallback();

    // Enqueue custom metadata deployment
    // jobId is the deployment ID
    Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    return jobId;
  }

  //use it to pass single metadata instance
  public static String upsertMetadata(sObject customMetadata) {
    return upsertMetadata(new List<sObject>{ customMetadata });
  }
}