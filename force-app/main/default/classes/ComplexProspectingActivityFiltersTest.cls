@isTest
class ComplexProspectingActivityFiltersTest {
  static final Integer ACTIVITIES_PER_CONTACT = C.CONTACT_PER_ACCOUNT_ACTIVATION_THRESHOLD;
  static final Integer CONTACTS_PER_ACCOUNT = C.ACTIVITIES_FOR_CONTACT_ACTIVATION;

  @isTest
  static void whenMultiCriteria_andFilterLogicIsLowerCased_thenCriteriaIsStillApplied() {
    /**
     * define multi-criteria with lower cased logic
     */
    FieldFilter filter = new FieldFilter();
    filter.disabled = false;
    filter.filterLogic = '1 and 2';
    filter.filters = new List<FieldFilterRow>{
      new FieldFilterRow(
        C.ACTIVITY_SUBJECT_FIELD,
        C.FilterLogicOperator.CONTAINS.toString(),
        'Test'
      ),
      new FieldFilterRow(
        C.ACTIVITY_SUBJECT_FIELD,
        C.FilterLogicOperator.NOTCONTAINS.toString(),
        '[Auto]'
      )
    };
    /**
     * mock the outbound email advance criteria
     */
    CustomMetadataCache.withOutboundEmailAdvance = JSON.serialize(filter);
    CustomMetadataCache.enableActivateAutomatically = true;
    /**
     * insert Account, Contacts and Tasks
     */
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.withOutboundEmailAdvance,
        uow
      );
      uow.commitWork();
    }

    Assert.areEqual(1, [SELECT COUNT() FROM Status__c]);
    Assert.areNotEqual(0, [SELECT COUNT() FROM Outbound_Contact_Activation__c]);
  }

  @isTest
  static void whenMultiCriteria_andFilterLogicIsUpperCase_thenCriteriaIsStillApplied() {
    /**
     * define multi-criteria with upper cased logic
     */
    FieldFilter filter = new FieldFilter();
    filter.disabled = false;
    filter.filterLogic = '1 AND 2';
    filter.filters = new List<FieldFilterRow>{
      new FieldFilterRow(
        C.ACTIVITY_SUBJECT_FIELD,
        C.FilterLogicOperator.CONTAINS.toString(),
        'Test'
      ),
      new FieldFilterRow(
        C.ACTIVITY_SUBJECT_FIELD,
        C.FilterLogicOperator.NOTCONTAINS.toString(),
        '[Auto]'
      )
    };
    /**
     * mock the outbound email advance criteria
     */
    CustomMetadataCache.withOutboundEmailAdvance = JSON.serialize(filter);
    CustomMetadataCache.enableActivateAutomatically = true;
    /**
     * insert Account, Contacts and Tasks
     */
    System.runAs(TestFactory.ioAgent) {
      fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );
      TestFactory.initActivatedContactData(
        CustomMetadataCache.withOutboundEmailAdvance,
        uow
      );
      uow.commitWork();
    }

    Assert.areEqual(1, [SELECT COUNT() FROM Status__c]);
    Assert.areNotEqual(0, [SELECT COUNT() FROM Outbound_Contact_Activation__c]);
  }
}