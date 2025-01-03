/**
 * need to activate Contact for whom a Meeting was created to ensure that meeting data is rolled up to Status
 */
public with sharing class EventTriggerHandler extends fflib_SObjectDomain {
  fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new List<SObjectType>{
      Event.SObjectType,
      Status__c.SObjectType,
      Outbound_Contact_Activation__c.SObjectType
    }
  );

  public EventTriggerHandler(List<SObject> sObjectList) {
    super(sObjectList);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new EventTriggerHandler(sObjectList);
    }
  }

  public override void onAfterInsert() {
    if (CustomMetadataCache.setting.Meeting_Object__c != C.EVENT_NAME) {
      return;
    }

    List<Event> contactEvents = new List<Event>();
    Set<Id> contactIds = new Set<Id>();
    for (Event e : (List<Event>) Records) {
      if (e.WhoId != null && e.WhoId.getSobjectType() == Contact.SObjectType) {
        contactEvents.add(e);
        contactIds.add(e.WhoId);
      }
    }

    contactIds.addAll(
      Pluck.ids(
        new ContactSelector().selectSiblingContactsByContactIds(contactIds)
      )
    );

    if (contactEvents.isEmpty()) {
      return;
    }

    List<Event> ioOwnedEvents = new List<Event>();
    List<Contact> activeContacts = new ContactSelector()
      .selectEligibleContactsByContactIds(contactIds);
    Set<Id> activeContactIds = Pluck.ids(activeContacts);
    for (Event e : contactEvents) {
      if (
        PermissionsCache.ioUserIds.contains(e.OwnerId) &&
        activeContactIds.contains(e.WhoId)
      ) {
        ioOwnedEvents.add(e);
      }
    }

    // only run for active contact, io-owned tasks
    if (ioOwnedEvents.isEmpty()) {
      return;
    }

    List<Outbound_Contact_Activation__c> meetingSetOcas = new RollupEngine()
      .createAndUpdateOcasViaMeetingSet(ioOwnedEvents, activeContacts);
    List<Status__c> meetingSetStatuses = new RollupEngine()
      .createAndUpdateMeetingSetStatuses(meetingSetOcas, activeContacts);

    Map<Id, SObject> statusByAccountId = Mapper.singleById(
      meetingSetStatuses,
      C.STATUS_ACCOUNT_FIELD
    );
    for (Outbound_Contact_Activation__c oca : meetingSetOcas) {
      if (statusByAccountId.containsKey(oca.Contact__r.AccountId)) {
        this.uow.registerRelationship(
          oca,
          Outbound_Contact_Activation__c.Outbound_Status__c,
          (Status__c) statusByAccountId.get(oca.Contact__r.AccountId)
        );
      }
    }

    List<Outbound_Contact_Activation__c> allOcasUnderStatus = new OutboundContactActivationSelector()
      .selectCurrentActivationsByAccountIdsNotInIds(
        statusByAccountId.keyset(),
        Pluck.ids(meetingSetOcas)
      );
    allOcasUnderStatus.addAll(meetingSetOcas);
    meetingSetStatuses = StatusHelper.rollupOcasToStatuses(
      meetingSetStatuses,
      allOcasUnderStatus
    );

    for (Outbound_Contact_Activation__c oca : meetingSetOcas) {
      oca.Outbound_Status__r = null;
    }

    this.uow.registerUpsert(meetingSetOcas);
    this.uow.registerUpsert(meetingSetStatuses);
    this.uow.commitWork();
  }

  public static void onAfterInsertTrigger(List<SObject> newRecords) {
    new EventTriggerHandler(newRecords).onAfterInsert();
  }
}