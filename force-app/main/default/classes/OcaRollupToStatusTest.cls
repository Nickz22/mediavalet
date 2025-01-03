@isTest
public with sharing class OcaRollupToStatusTest {
  @isTest
  static void given() {
    twoEngagedOutboundStatuses();
    ocasWithOutboundStatuses();
  }

  static void twoEngagedOutboundStatuses() {
    System.assertEquals(
      2,
      [
        SELECT COUNT()
        FROM Status__c
        WHERE
          Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ENGAGED
          AND Engaged_Date__c = :Date.today()
      ]
    );
  }

  static void ocasWithOutboundStatuses() {
    for (Outbound_Contact_Activation__c oca : [
      SELECT Outbound_Status__c
      FROM Outbound_Contact_Activation__c
    ]) {
      Assert.isNotNull(
        oca.Outbound_Status__c,
        'Outbound Status should be set on all Outbound Contact Activations'
      );
    }
  }

  @isTest
  static void whenNewProspectingActivityCreatedUnderExistingStatus_verifyLastOutboundActivityDateChanged() {
    CustomMetadataCache.enableActivateAutomatically = true;
    System.runAs(TestFactory.ioAgent) {
      System.assertEquals(
        2,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ENGAGED
            AND Last_Outbound_Activity__c = NULL
        ]
      );
      Test.startTest();
      fflib_SObjectUnitOfWOrk uow = new fflib_SObjectUnitOfWOrk(
        new List<SObjectType>{ Task.SObjectType }
      );

      Contact testContact = [SELECT AccountId FROM Contact LIMIT 1];

      Task outboundEmail = TestFactory.createEligibleActivityForFilter(
        CustomMetadataCache.setting.Outbound_Email_Advance__c
      );
      outboundEmail.WhoId = testContact.Id;
      outboundEmail.WhatId = testContact.AccountId;
      uow.registerNew(outboundEmail);

      uow.commitWork();
      Test.stopTest();

      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ENGAGED
            AND Last_Outbound_Activity__c = :Date.today()
            AND First_Outbound_Activity__c = :Date.today()
        ]
      );
      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_ENGAGED
            AND Last_Outbound_Activity__c = NULL
        ]
      );

      // create meeting
      SObject meeting;
      if (CustomMetadataCache.setting.Meeting_Object__c == 'Task') {
        meeting = TestFactory.createEligibleActivityForFilter(
          CustomMetadataCache.setting.Outbound_Meeting_Advance__c
        );
      } else {
        meeting = TestFactory.createEligibleEventForFilter(
          CustomMetadataCache.setting.Outbound_Meeting_Advance__c
        );
      }

      meeting.put('WhoId', testContact.Id);
      fflib_SObjectUnitOfWork uow2 = new fflib_SObjectUnitOfWork(
        new List<SObjectType>{ Task.SObjectType, Event.SObjectType }
      );
      uow2.registerNew(meeting);
      uow2.commitWork();

      System.assertEquals(
        1,
        [
          SELECT COUNT()
          FROM Status__c
          WHERE
            Prospecting_Status__c = :C.OUTBOUND_PROSPECTING_STATUS_MEETING_SET
            AND Last_Outbound_Activity__c = :Date.today()
            AND First_Outbound_Activity__c = :Date.today()
            AND First_Meeting_Date__c = :Date.today()
            AND Last_Meeting_Date__c = :Date.today()
        ],
        [
          SELECT
            Prospecting_Status__c,
            Last_Outbound_Activity__c,
            First_Outbound_Activity__c,
            First_Meeting_Date__c,
            Last_Meeting_Date__c
          FROM Status__c
        ]
      );
    }

  }

  @TestSetup
  static void setup() {
    System.runAs(TestFactory.ioAgent) {
      CustomMetadataCache.enableActivateAutomatically = true;
      Test.startTest();
      fflib_SObjectUnitOfWOrk uow = new fflib_SObjectUnitOfWOrk(
        new List<SObjectType>{
          Account.SObjectType,
          Contact.SObjectType,
          Task.SObjectType
        }
      );

      for (Integer i = 0; i < 2; i++) {
        uow = TestFactory.initActivatedContactData(
          CustomMetadataCache.setting.Inbound_Email_Advance__c,
          uow
        );
      }

      uow.commitWork();
      Test.stopTest();
    }
  }
}