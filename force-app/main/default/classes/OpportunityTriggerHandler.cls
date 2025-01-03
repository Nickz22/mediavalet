public with sharing class OpportunityTriggerHandler extends fflib_SObjectDomain {
  fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new List<SObjectType>{ Opportunity.SObjectType, Status__c.SObjectType }
  );

  public OpportunityTriggerHandler(List<SObject> sObjectList) {
    super(sObjectList);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new OpportunityTriggerHandler(sObjectList);
    }
  }

  public override void onAfterInsert() {
    Map<Id, User> ioUserById = new Map<Id, User>(PermissionsCache.ioUsers);
    List<Opportunity> ioOpportunities = new List<Opportunity>();
    for (Opportunity opp : (List<Opportunity>) Records) {
      if (ioUserById.containsKey(opp.OwnerId)) {
        ioOpportunities.add(opp);
      }
    }
    if (ioOpportunities.isEmpty()) {
      return;
    }
    List<Status__c> newActivations = new List<Status__c>();
    if (
      CustomMetadataCache.setting.Set_Approaching_Outbound_Opps_Automatic__c
    ) {
      newActivations = new RollupEngine()
        .activateAccountsViaOpportunityCreation(ioOpportunities);
      this.uow.registerNew(newActivations);
    }

    Map<Id, Opportunity> ioOpportunityById = new Map<Id, Opportunity>(
      ioOpportunities
    );
    for (Status__c status : newActivations) {
      ioOpportunityById.remove(status.Opportunity__c);
    }
    List<Status__c> rollups = new RollupEngine()
      .rollupOpportunityToStatus(
        ioOpportunityById.values(),
        new StatusSelector()
          .selectActiveStatusByAccountIds(
            Pluck.ids(ioOpportunities, C.ACCOUNT_ID_FIELD)
          )
      );
    this.uow.registerDirty(rollups);
    this.uow.commitWork();
  }

  public override void onAfterUpdate(Map<Id, SObject> existingRecordById) {
    Map<Id, User> ioUserById = new Map<Id, User>(PermissionsCache.ioUsers);
    List<Opportunity> ioOpportunities = new List<Opportunity>();
    for (Opportunity opp : (List<Opportunity>) Records) {
      if (ioUserById.containsKey(opp.OwnerId)) {
        ioOpportunities.add(opp);
      }
    }
    if (ioOpportunities.isEmpty()) {
      return;
    }
    List<Status__c> rollups = new RollupEngine()
      .rollupOpportunityToStatus(
        ioOpportunities,
        new StatusSelector()
          .selectOpportunityCreatedStatusByAccountIds(
            Pluck.ids(ioOpportunities, C.ACCOUNT_ID_FIELD)
          )
      );
    this.uow.registerDirty(rollups);
    this.uow.commitWork();
  }
}