/*
 * OBMetrix Funnel Helper class to contains all Metrics definition and its calculations
 * Test Class :: OBMetrixFunnelControllerTest
 * Added On : 10th Feb 2020
 */
public with sharing class OBMetrixFunnelMetrixHelper {
  // public static final List<OBMetrixFunnelMetrix> allMetrixs { get; set; }
  // /**
  //  * All Metrics Definition with its Query or Filter
  //  */
  // static {
  //   allMetrixs = new List<OBMetrixFunnelMetrix>();

  //   OBMetrixFunnelMetrix newOppAct = new OBMetrixFunnelMetrix();
  //   newOppAct.metrixName = 'OPPORTUNITY_CREATED';
  //   newOppAct.metrixTitle = 'Opportunities Created';
  //   newOppAct.metrixDesc = 'How many opportunities have been created during the selected period?';
  //   newOppAct.metrixCategory = 'Outcomes';
  //   newOppAct.metrixQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   newOppAct.metrixUserQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId)';
  //   newOppAct.metrixAllQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   newOppAct.metrixBestQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :thisUserId OR CreatedBy.OBMetrix_Manager__c = :thisUserId) GROUP BY CreatedById';
  //   newOppAct.metrixChartType = 'number';
  //   allMetrixs.add(newOppAct);

  //   OBMetrixFunnelMetrix newOppValAct = new OBMetrixFunnelMetrix();
  //   newOppValAct.metrixName = 'OPPORTUNITY_VALUE_CREATED';
  //   newOppValAct.metrixTitle = 'Total Opportunity Value';
  //   newOppValAct.metrixDesc = 'What is the total value of all outbound opportunities that you created during the selected period?';
  //   newOppValAct.metrixCategory = 'Outcomes';
  //   newOppValAct.metrixQuery =
  //     'SELECT SUM(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   newOppValAct.metrixUserQuery =
  //     'SELECT SUM(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId)';
  //   newOppValAct.metrixAllQuery =
  //     'SELECT SUM(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   newOppValAct.metrixBestQuery =
  //     'SELECT SUM(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId) GROUP BY CreatedById';
  //   newOppValAct.metrixChartType = 'currency';
  //   allMetrixs.add(newOppValAct);

  //   OBMetrixFunnelMetrix newOppAvgValAct = new OBMetrixFunnelMetrix();
  //   newOppAvgValAct.metrixName = 'OPPORTUNITY_VALUE_AVG';
  //   newOppAvgValAct.metrixTitle = 'Average Opportunity Value';
  //   newOppAvgValAct.metrixDesc = 'What is the average value of outbound opportunities that you created during the selected period?';
  //   newOppAvgValAct.metrixCategory = 'Outcomes';
  //   newOppAvgValAct.metrixQuery =
  //     'SELECT AVG(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   newOppAvgValAct.metrixUserQuery =
  //     'SELECT AVG(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId)';
  //   newOppAvgValAct.metrixAllQuery =
  //     'SELECT AVG(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   newOppAvgValAct.metrixBestQuery =
  //     'SELECT AVG(' +
  //     CustomMetadataCache.setting.Opportunity_Value_Field__c +
  //     ') FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId) GROUP BY CreatedById';
  //   newOppAvgValAct.metrixChartType = 'currency';
  //   allMetrixs.add(newOppAvgValAct);

  //   OBMetrixFunnelMetrix newMeetSetOut = new OBMetrixFunnelMetrix();
  //   newMeetSetOut.metrixName = 'MEETINGS_SET';
  //   newMeetSetOut.metrixTitle = 'Meetings Set';
  //   newMeetSetOut.metrixDesc = 'How many outbound meetings did you set during the selected period?';
  //   newMeetSetOut.metrixCategory = 'Outcomes';
  //   newMeetSetOut.metrixQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   newMeetSetOut.metrixUserQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId)';
  //   newMeetSetOut.metrixAllQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   newMeetSetOut.metrixFilter = CustomMetadataCache.setting.Outbound_Meeting_Advance__c;
  //   newMeetSetOut.metrixBestQuery = 'SELECT COUNT(Id) FROM Opportunity WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId) GROUP BY CreatedById';
  //   newMeetSetOut.metrixChartType = 'number';
  //   if (CustomMetadataCache.setting.Meeting_Object__c != 'Opportunity') {
  //     allMetrixs.add(newMeetSetOut);
  //   }

  //   OBMetrixFunnelMetrix newOutDialAct = new OBMetrixFunnelMetrix();
  //   newOutDialAct.metrixName = 'TOTAL_CALLS';
  //   newOutDialAct.metrixTitle = 'Total Calls';
  //   newOutDialAct.metrixDesc = 'How many outbound calls (regardless of the outcome) did you make during the selected period?';
  //   newOutDialAct.metrixCategory = 'Activities';
  //   newOutDialAct.metrixFilter = CustomMetadataCache.setting.Engaged_Call_Advance__c;
  //   newOutDialAct.metrixFilter1 = CustomMetadataCache.setting.Call_Advance__c;
  //   newOutDialAct.metrixChartType = 'line';
  //   allMetrixs.add(newOutDialAct);

  //   OBMetrixFunnelMetrix dialCalls = new OBMetrixFunnelMetrix();
  //   dialCalls.metrixName = 'DIAL_CALLS';
  //   dialCalls.metrixTitle = 'Dial Calls';
  //   dialCalls.metrixDesc = 'Description for Dial Calls Metric';
  //   dialCalls.metrixCategory = 'Activities';
  //   dialCalls.metrixFilter = CustomMetadataCache.setting.Call_Advance__c;
  //   dialCalls.metrixVisible = false;
  //   dialCalls.metrixChartType = 'line';
  //   allMetrixs.add(dialCalls);

  //   OBMetrixFunnelMetrix totalEmails = new OBMetrixFunnelMetrix();
  //   totalEmails.metrixName = 'TOTAL_EMAILS';
  //   totalEmails.metrixTitle = 'Total Email';
  //   totalEmails.metrixDesc = 'Description for Total Emails Metric';
  //   totalEmails.metrixCategory = 'Activities';
  //   totalEmails.metrixFilter = CustomMetadataCache.setting.Outbound_Email_Advance__c;
  //   totalEmails.metrixFilter1 = CustomMetadataCache.setting.Inbound_Email_Advance__c;
  //   totalEmails.metrixVisible = false;
  //   totalEmails.metrixChartType = 'line';
  //   allMetrixs.add(totalEmails);

  //   OBMetrixFunnelMetrix inboundEmails = new OBMetrixFunnelMetrix();
  //   inboundEmails.metrixName = 'INBOUND_EMAILS';
  //   inboundEmails.metrixTitle = 'Inbound Email';
  //   inboundEmails.metrixDesc = 'Description for Inbound Emails Metric';
  //   inboundEmails.metrixCategory = 'Activities';
  //   inboundEmails.metrixFilter = CustomMetadataCache.setting.Inbound_Email_Advance__c;
  //   inboundEmails.metrixVisible = false;
  //   inboundEmails.metrixChartType = 'line';
  //   allMetrixs.add(inboundEmails);

  //   OBMetrixFunnelMetrix newOutEmailAct = new OBMetrixFunnelMetrix();
  //   newOutEmailAct.metrixName = 'OUTBOUND_EMAILS';
  //   newOutEmailAct.metrixTitle = 'Outbound Emails';
  //   newOutEmailAct.metrixDesc = 'How many outbound emails did you make during the selected period?';
  //   newOutEmailAct.metrixCategory = 'Activities';
  //   newOutEmailAct.metrixFilter = CustomMetadataCache.setting.Outbound_Email_Advance__c;
  //   newOutEmailAct.metrixChartType = 'line';
  //   allMetrixs.add(newOutEmailAct);

  //   OBMetrixFunnelMetrix newInMailAct = new OBMetrixFunnelMetrix();
  //   newInMailAct.metrixName = 'INMAILS';
  //   newInMailAct.metrixTitle = 'Total LinkedIn Tasks';
  //   newInMailAct.metrixDesc = 'How many outbound LinkedIn tasks did you create during the selected period?';
  //   newInMailAct.metrixCategory = 'Activities';
  //   newInMailAct.metrixFilter = CustomMetadataCache.setting.InMail_Advance1__c;
  //   newInMailAct.metrixChartType = 'line';
  //   allMetrixs.add(newInMailAct);

  //   OBMetrixFunnelMetrix newGiftAct = new OBMetrixFunnelMetrix();
  //   newGiftAct.metrixName = 'GIFTS_SENT';
  //   newGiftAct.metrixTitle = 'Total Gifts';
  //   newGiftAct.metrixDesc = 'How many gifts did you send during the selected period?';
  //   newGiftAct.metrixCategory = 'Activities';
  //   newGiftAct.metrixFilter = CustomMetadataCache.setting.Gift_Advance1__c;
  //   newGiftAct.metrixChartType = 'line';
  //   allMetrixs.add(newGiftAct);

  //   OBMetrixFunnelMetrix newAccAct = new OBMetrixFunnelMetrix();
  //   newAccAct.metrixName = 'NEW_ACCOUNT_ACTIVATIONS';
  //   newAccAct.metrixTitle = 'Accounts Approaching [replaced]';
  //   newAccAct.metrixDesc = 'How many accounts have been approaching [replaced] during the selected period?';
  //   newAccAct.metrixCategory = 'Funnel';
  //   newAccAct.metrixQuery = 'SELECT COUNT(Id) FROM Account WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newAccAct.metrixUserQuery = 'SELECT COUNT(Id) FROM Account WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   newAccAct.metrixAllQuery = 'SELECT COUNT(Id) FROM Account WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   newAccAct.metrixChartType = 'line';
  //   newAccAct.userField = 'Activated_By__c';
  //   allMetrixs.add(newAccAct);

  //   OBMetrixFunnelMetrix newAccEng = new OBMetrixFunnelMetrix();
  //   newAccEng.metrixName = 'ACCOUNTS_ENGAGED';
  //   newAccEng.metrixTitle = 'Accounts Enagaged';
  //   newAccEng.metrixDesc = 'How many accounts "In Contact[replaced]" with you during the selected period?';
  //   newAccEng.metrixCategory = 'Funnel';
  //   newAccEng.metrixQuery = 'SELECT COUNT(Id) FROM Status__c WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newAccEng.metrixUserQuery = 'SELECT COUNT(Id) FROM Status__c WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate AND Activated_By__c = :userId';
  //   newAccEng.metrixAllQuery = 'SELECT COUNT(Id) FROM Status__c WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate';
  //   newAccEng.metrixChartType = 'line';
  //   newAccEng.userField = 'Activated_By__c';
  //   allMetrixs.add(newAccEng);

  //   OBMetrixFunnelMetrix actPerAcct = new OBMetrixFunnelMetrix();
  //   actPerAcct.metrixName = 'ACTIVITIES_PER_ACCOUNT';
  //   actPerAcct.metrixTitle = 'Activities per Account';
  //   actPerAcct.metrixDesc = 'What is the average number of activities created per account that is approached [replaced] (regardless if you are successful in creating an opportunity)?';
  //   actPerAcct.metrixCategory = 'General Outbound';
  //   actPerAcct.metrixQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   actPerAcct.metrixUserQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   actPerAcct.metrixAllQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   actPerAcct.metrixBestQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   actPerAcct.metrixChartType = 'number';
  //   allMetrixs.add(actPerAcct);

  //   OBMetrixFunnelMetrix callsPerAcct = new OBMetrixFunnelMetrix();
  //   callsPerAcct.metrixName = 'CALLS_PER_ACCOUNT';
  //   callsPerAcct.metrixTitle = 'Calls per Account';
  //   callsPerAcct.metrixDesc = 'What is the average number of calls made per account that is approached [replaced] (regardless if you are successful in creating an opportunity)?';
  //   callsPerAcct.metrixCategory = 'General Outbound';
  //   callsPerAcct.metrixQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   callsPerAcct.metrixUserQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   callsPerAcct.metrixAllQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   callsPerAcct.metrixBestQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   callsPerAcct.metrixChartType = 'number';
  //   allMetrixs.add(callsPerAcct);

  //   OBMetrixFunnelMetrix connectsPerAcct = new OBMetrixFunnelMetrix();
  //   connectsPerAcct.metrixName = 'CONNECTS_PER_ACCOUNT';
  //   connectsPerAcct.metrixTitle = 'Connects per Account';
  //   connectsPerAcct.metrixDesc = 'What is the average number of call connects per account that is approached [replaced] (regardless if you are successful in creating an opportunity)?';
  //   connectsPerAcct.metrixCategory = 'General Outbound';
  //   connectsPerAcct.metrixQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   connectsPerAcct.metrixUserQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   connectsPerAcct.metrixAllQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   connectsPerAcct.metrixBestQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   connectsPerAcct.metrixChartType = 'number';
  //   allMetrixs.add(connectsPerAcct);

  //   OBMetrixFunnelMetrix contactsPerAcct = new OBMetrixFunnelMetrix();
  //   contactsPerAcct.metrixName = 'CONTACTS_PER_ACCOUNT';
  //   contactsPerAcct.metrixTitle = 'Contacts per Account';
  //   contactsPerAcct.metrixDesc = 'On average, how many contacts do you target within each approached [replaced] account?';
  //   contactsPerAcct.metrixCategory = 'General Outbound';
  //   contactsPerAcct.metrixQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   contactsPerAcct.metrixUserQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   contactsPerAcct.metrixAllQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   contactsPerAcct.metrixBestQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   contactsPerAcct.metrixChartType = 'number';
  //   allMetrixs.add(contactsPerAcct);

  //   OBMetrixFunnelMetrix actsPerContact = new OBMetrixFunnelMetrix();
  //   actsPerContact.metrixName = 'ACTIVITIES_PER_CONTACT';
  //   actsPerContact.metrixTitle = 'Activities per Contact';
  //   actsPerContact.metrixDesc = 'On average, how many activities do you create per contact that you target?';
  //   actsPerContact.metrixCategory = 'General Outbound';
  //   actsPerContact.metrixQuery = 'SELECT AVG(Emails__c) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   actsPerContact.metrixUserQuery = 'SELECT AVG(Emails__c) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND Activated_By__c = :userId';
  //   actsPerContact.metrixAllQuery = 'SELECT AVG(Emails__c) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   actsPerContact.metrixBestQuery = 'SELECT AVG(Emails__c) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   actsPerContact.metrixChartType = 'number';
  //   allMetrixs.add(actsPerContact);

  //   OBMetrixFunnelMetrix actsPerOpp = new OBMetrixFunnelMetrix();
  //   actsPerOpp.metrixName = 'ACTIVITIES_PER_OPP';
  //   actsPerOpp.metrixTitle = 'Activities per Opportunity';
  //   actsPerOpp.metrixDesc = 'What is the average number of activities it takes to create an opportunity? This metric only includes accounts where an opportunity exists. It does not factor in unsuccessful attempts to set an opportunity. See "Activities per Account" for an average number of activities for all accounts.';
  //   actsPerOpp.metrixCategory = 'General Outbound';
  //   actsPerOpp.metrixQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   actsPerOpp.metrixUserQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   actsPerOpp.metrixAllQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   actsPerOpp.metrixBestQuery = 'SELECT AVG(Total_Outbound_Activities__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   actsPerOpp.metrixChartType = 'number';
  //   allMetrixs.add(actsPerOpp);

  //   OBMetrixFunnelMetrix callsPerOpp = new OBMetrixFunnelMetrix();
  //   callsPerOpp.metrixName = 'CALLS_PER_OPP';
  //   callsPerOpp.metrixTitle = 'Calls per Opportunity';
  //   callsPerOpp.metrixDesc = 'What is the average number of calls it takes to create an opportunity? This metric only includes accounts where an opportunity exists. It does not factor in unsuccessful attempts to set an opportunity. See "Calls per Account" for an average number of activities for all accounts.';
  //   callsPerOpp.metrixCategory = 'General Outbound';
  //   callsPerOpp.metrixQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   callsPerOpp.metrixUserQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   callsPerOpp.metrixAllQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   callsPerOpp.metrixBestQuery = 'SELECT AVG(Total_Outbound_Calls__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   callsPerOpp.metrixChartType = 'number';
  //   allMetrixs.add(callsPerOpp);

  //   OBMetrixFunnelMetrix connectsPerOpp = new OBMetrixFunnelMetrix();
  //   connectsPerOpp.metrixName = 'CONNECTS_PER_OPP';
  //   connectsPerOpp.metrixTitle = 'Connects per Opportunity';
  //   connectsPerOpp.metrixDesc = 'What is the average number of call connects it takes to create an opportunity? This metric only includes accounts where an opportunity exists. It does not factor in unsuccessful attempts to set an opportunity. See "Connects per Account" for an average number of connects across all accounts.';
  //   connectsPerOpp.metrixCategory = 'General Outbound';
  //   connectsPerOpp.metrixQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   connectsPerOpp.metrixUserQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   connectsPerOpp.metrixAllQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   connectsPerOpp.metrixBestQuery = 'SELECT AVG(Total_Call_Connects__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   connectsPerOpp.metrixChartType = 'number';
  //   allMetrixs.add(connectsPerOpp);

  //   OBMetrixFunnelMetrix meetingsPerOpp = new OBMetrixFunnelMetrix();
  //   meetingsPerOpp.metrixName = 'MEETINGS_PER_OPP';
  //   meetingsPerOpp.metrixTitle = 'Meetings per Opportunity';
  //   meetingsPerOpp.metrixDesc = 'What is the average number of meetings that happen before you create an opportunity? This metric only includes accounts where an opportunity exists. It does not factor in unsuccessful attempts to set an opportunity.';
  //   meetingsPerOpp.metrixCategory = 'General Outbound';
  //   meetingsPerOpp.metrixQuery = 'SELECT AVG(Total_Meetings__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   meetingsPerOpp.metrixUserQuery = 'SELECT AVG(Total_Meetings__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   meetingsPerOpp.metrixAllQuery = 'SELECT AVG(Total_Meetings__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   meetingsPerOpp.metrixBestQuery = 'SELECT AVG(Total_Meetings__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   meetingsPerOpp.metrixChartType = 'number';
  //   allMetrixs.add(meetingsPerOpp);

  //   OBMetrixFunnelMetrix consPerOpp = new OBMetrixFunnelMetrix();
  //   consPerOpp.metrixName = 'CONTACTS_PER_OPP';
  //   consPerOpp.metrixTitle = 'Contacts per Opportunity';
  //   consPerOpp.metrixDesc = 'What is the average number of contacts approached [replaced] when you create an opportunity? This metric only includes accounts where an opportunity exists. It does not factor in unsuccessful attempts to set an opportunity. See "Contacts per Account" for an average number of contacts approached [replaced] for all accounts.';
  //   consPerOpp.metrixCategory = 'General Outbound';
  //   consPerOpp.metrixQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   consPerOpp.metrixUserQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   consPerOpp.metrixAllQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   consPerOpp.metrixBestQuery = 'SELECT AVG(Total_Activated_Contacts__c) FROM Status__c WHERE Binary_Opportunity__c = 1 AND First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   consPerOpp.metrixChartType = 'number';
  //   allMetrixs.add(consPerOpp);

  //   OBMetrixFunnelMetrix newAccMeeting = new OBMetrixFunnelMetrix();
  //   newAccMeeting.metrixName = 'ACCOUNTS_MEETING';
  //   newAccMeeting.metrixTitle = 'Accounts Meeting';
  //   newAccMeeting.metrixDesc = 'Description for Accounts Meeting Set Metric';
  //   newAccMeeting.metrixCategory = 'Funnel';
  //   newAccMeeting.metrixQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Meeting_Date__c >= :startDate AND First_Meeting_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newAccMeeting.metrixUserQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Meeting_Date__c >= :startDate AND First_Meeting_Date__c < :endDate AND Activated_By__c = :userId';
  //   newAccMeeting.metrixAllQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Meeting_Date__c >= :startDate AND First_Meeting_Date__c < :endDate';
  //   newAccMeeting.metrixVisible = false;
  //   newAccMeeting.metrixChartType = 'line';
  //   newAccMeeting.userField = 'Activated_By__c';
  //   newAccMeeting.metrixVisible = false;
  //   allMetrixs.add(newAccMeeting);

  //   OBMetrixFunnelMetrix newAccOpportunity = new OBMetrixFunnelMetrix();
  //   newAccOpportunity.metrixName = 'ACCOUNTS_OPPORTUNITY';
  //   newAccOpportunity.metrixTitle = 'Accounts Opportunity';
  //   newAccOpportunity.metrixDesc = 'Description for Accounts Opportunity Metric';
  //   newAccOpportunity.metrixCategory = 'Funnel';
  //   newAccOpportunity.metrixQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newAccOpportunity.metrixUserQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate AND Activated_By__c = :userId';
  //   newAccOpportunity.metrixAllQuery = 'SELECT COUNT(Id) FROM Status__c WHERE First_Opportunity_Created__c >= :startDate AND First_Opportunity_Created__c < :endDate';
  //   newAccOpportunity.metrixVisible = false;
  //   newAccOpportunity.metrixChartType = 'line';
  //   newAccOpportunity.userField = 'Activated_By__c';
  //   newAccOpportunity.metrixVisible = false;
  //   allMetrixs.add(newAccOpportunity);

  //   OBMetrixFunnelMetrix newConAct = new OBMetrixFunnelMetrix();
  //   newConAct.metrixName = 'NEW_CONTACT_ACTIVATED';
  //   newConAct.metrixTitle = 'Contacts approached [replaced]';
  //   newConAct.metrixDesc = 'Description for New Contact approached [replaced] Metric';
  //   newConAct.metrixCategory = 'Funnel';
  //   newConAct.metrixQuery = 'SELECT COUNT(Id) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newConAct.metrixUserQuery = 'SELECT COUNT(Id) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate AND (Activated_By__c = :userId)';
  //   newConAct.metrixAllQuery = 'SELECT COUNT(Id) FROM Contact WHERE Activated_Date__c >= :startDate AND Activated_Date__c < :endDate';
  //   newConAct.metrixChartType = 'line';
  //   newConAct.metrixVisible = false;
  //   allMetrixs.add(newConAct);

  //   OBMetrixFunnelMetrix newConEng = new OBMetrixFunnelMetrix();
  //   newConEng.metrixName = 'CONTACTS_ENGAGED';
  //   newConEng.metrixTitle = 'Contacts Engaged';
  //   newConEng.metrixDesc = 'Description for Contact Enaged Metric';
  //   newConEng.metrixCategory = 'Funnel';
  //   newConEng.metrixQuery = 'SELECT COUNT(Id) FROM Contact WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   newConEng.metrixUserQuery = 'SELECT COUNT(Id) FROM Contact WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate AND (Activated_By__c = :userId)';
  //   newConEng.metrixAllQuery = 'SELECT COUNT(Id) FROM Contact WHERE Engaged_Date__c >= :startDate AND Engaged_Date__c < :endDate';
  //   newConEng.metrixChartType = 'line';
  //   newConEng.metrixVisible = false;
  //   allMetrixs.add(newConEng);

  //   OBMetrixFunnelMetrix daysActivatedStage = new OBMetrixFunnelMetrix();
  //   daysActivatedStage.metrixName = 'DAYS_STAGE_ACTIVATED';
  //   daysActivatedStage.metrixTitle = 'Average Days in Stage - Approaching [replaced]';
  //   daysActivatedStage.metrixDesc = 'Description for Average Days in Stage - Approaching [replaced] Metric';
  //   daysActivatedStage.metrixCategory = 'Funnel';
  //   daysActivatedStage.metrixQuery = 'SELECT AVG(Days_in_Activated_Stage__c) FROM Status__c WHERE Days_in_Activated_Stage__c != NULL AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   daysActivatedStage.metrixUserQuery = 'SELECT AVG(Days_in_Activated_Stage__c) FROM Status__c WHERE  Days_in_Activated_Stage__c != NULL AND (CreatedById = :userId)';
  //   daysActivatedStage.metrixAllQuery = 'SELECT AVG(Days_in_Activated_Stage__c) FROM Status__c WHERE Days_in_Activated_Stage__c != NULL';
  //   daysActivatedStage.metrixChartType = 'line';
  //   daysActivatedStage.metrixVisible = false;
  //   allMetrixs.add(daysActivatedStage);

  //   OBMetrixFunnelMetrix daysEngagedStage = new OBMetrixFunnelMetrix();
  //   daysEngagedStage.metrixName = 'DAYS_STAGE_ENGAGED';
  //   daysEngagedStage.metrixTitle = 'Average Days in Stage - In Contact[replaced]';
  //   daysEngagedStage.metrixDesc = 'Description for Average Days in Stage - In Contact[replaced] Metric';
  //   daysEngagedStage.metrixCategory = 'Funnel';
  //   daysEngagedStage.metrixQuery = 'SELECT AVG(Days_in_Engaged_Stage__c) FROM Status__c WHERE Days_in_Engaged_Stage__c != NULL AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   daysEngagedStage.metrixUserQuery = 'SELECT AVG(Days_in_Engaged_Stage__c) FROM Status__c WHERE  Days_in_Engaged_Stage__c != NULL AND (CreatedById = :userId)';
  //   daysEngagedStage.metrixAllQuery = 'SELECT AVG(Days_in_Engaged_Stage__c) FROM Status__c WHERE Days_in_Engaged_Stage__c != NULL';
  //   daysEngagedStage.metrixChartType = 'line';
  //   daysEngagedStage.metrixVisible = false;
  //   allMetrixs.add(daysEngagedStage);

  //   OBMetrixFunnelMetrix daysMeetingSetStage = new OBMetrixFunnelMetrix();
  //   daysMeetingSetStage.metrixName = 'DAYS_STAGE_MEETINGSET';
  //   daysMeetingSetStage.metrixTitle = 'Average Days in Stage - Meeting Set';
  //   daysMeetingSetStage.metrixDesc = 'Description for Average Days in Stage - Meeting Set Metric';
  //   daysMeetingSetStage.metrixCategory = 'Funnel';
  //   daysMeetingSetStage.metrixQuery = 'SELECT AVG(Days_in_Meeting_Set_Stage__c) FROM Status__c WHERE Days_in_Meeting_Set_Stage__c != NULL AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   daysMeetingSetStage.metrixUserQuery = 'SELECT AVG(Days_in_Meeting_Set_Stage__c) FROM Status__c WHERE  Days_in_Meeting_Set_Stage__c != NULL AND (CreatedById = :userId)';
  //   daysMeetingSetStage.metrixAllQuery = 'SELECT AVG(Days_in_Meeting_Set_Stage__c) FROM Status__c WHERE Days_in_Meeting_Set_Stage__c != NULL';
  //   daysMeetingSetStage.metrixChartType = 'line';
  //   daysMeetingSetStage.metrixVisible = false;
  //   allMetrixs.add(daysMeetingSetStage);

  //   OBMetrixFunnelMetrix daysOpportunityStage = new OBMetrixFunnelMetrix();
  //   daysOpportunityStage.metrixName = 'DAYS_STAGE_OPPORTUNITY';
  //   daysOpportunityStage.metrixTitle = 'Average Days in Stage - Opportunity';
  //   daysOpportunityStage.metrixDesc = 'Description for Average Days in Stage - Opportunity Metric';
  //   daysOpportunityStage.metrixCategory = 'Funnel';
  //   daysOpportunityStage.metrixQuery = 'SELECT AVG(Days_in_Opportunity_Stage__c) FROM Status__c WHERE Days_in_Opportunity_Stage__c != NULL AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   daysOpportunityStage.metrixUserQuery = 'SELECT AVG(Days_in_Opportunity_Stage__c) FROM Status__c WHERE  Days_in_Opportunity_Stage__c != NULL AND (CreatedById = :userId)';
  //   daysOpportunityStage.metrixAllQuery = 'SELECT AVG(Days_in_Opportunity_Stage__c) FROM Status__c WHERE Days_in_Opportunity_Stage__c != NULL';
  //   daysOpportunityStage.metrixChartType = 'line';
  //   daysOpportunityStage.metrixVisible = false;
  //   allMetrixs.add(daysOpportunityStage);

  //   OBMetrixFunnelMetrix daysToExpired = new OBMetrixFunnelMetrix();
  //   daysToExpired.metrixName = 'DAYS_TO_EXPIRED';
  //   daysToExpired.metrixTitle = 'Average Days Approaching [replaced] to Expiration';
  //   daysToExpired.metrixDesc = 'Description for Average Days Approaching [replaced] to Expiration Metric';
  //   daysToExpired.metrixCategory = 'Funnel';
  //   daysToExpired.metrixQuery = 'SELECT AVG(Days_to_Expired__c) FROM Status__c WHERE Days_to_Expired__c != NULL AND (CreatedById = :userId OR CreatedBy.OBMetrix_Manager__c = :userId)';
  //   daysToExpired.metrixUserQuery = 'SELECT AVG(Days_to_Expired__c) FROM Status__c WHERE  Days_to_Expired__c != NULL AND (CreatedById = :userId)';
  //   daysToExpired.metrixAllQuery = 'SELECT AVG(Days_to_Expired__c) FROM Status__c WHERE Days_to_Expired__c != NULL';
  //   daysToExpired.metrixChartType = 'line';
  //   daysToExpired.metrixVisible = false;
  //   allMetrixs.add(daysToExpired);

  //   OBMetrixFunnelMetrix daysToEngaged = new OBMetrixFunnelMetrix();
  //   daysToEngaged.metrixName = 'DAYS_TO_ENGAGED';
  //   daysToEngaged.metrixTitle = 'Account: Average Time - Approaching [replaced] to In Contact[replaced]';
  //   daysToEngaged.metrixDesc = 'When an account engages with you, how long does it take, on average, between activating the account and the first engagement?';
  //   daysToEngaged.metrixCategory = 'Funnel';
  //   daysToEngaged.metrixQuery = 'SELECT AVG(Days_Engaged__c) FROM Status__c WHERE Days_Engaged__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   daysToEngaged.metrixUserQuery = 'SELECT AVG(Days_Engaged__c) FROM Status__c WHERE  Days_Engaged__c != NULL AND (Activated_By__c = :userId)';
  //   daysToEngaged.metrixAllQuery = 'SELECT AVG(Days_Engaged__c) FROM Status__c WHERE Days_Engaged__c != NULL';
  //   daysToEngaged.metrixBestQuery = 'SELECT AVG(Days_Engaged__c) FROM Status__c WHERE Days_Engaged__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   daysToEngaged.metrixChartType = 'number';
  //   allMetrixs.add(daysToEngaged);

  //   OBMetrixFunnelMetrix daysToMeeting = new OBMetrixFunnelMetrix();
  //   daysToMeeting.metrixName = 'DAYS_TO_MEETINGSET';
  //   daysToMeeting.metrixTitle = 'Account: Average Time - Approaching [replaced] to Meeting';
  //   daysToMeeting.metrixDesc = 'When an account agrees to a meeting, how long does it take, on average, between activating the account and the first meeting?';
  //   daysToMeeting.metrixCategory = 'Funnel';
  //   daysToMeeting.metrixQuery = 'SELECT AVG(Days_Activated__c) FROM Status__c WHERE Days_Activated__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   daysToMeeting.metrixUserQuery = 'SELECT AVG(Days_Activated__c) FROM Status__c WHERE  Days_Activated__c != NULL AND (Activated_By__c = :userId)';
  //   daysToMeeting.metrixAllQuery = 'SELECT AVG(Days_Activated__c) FROM Status__c WHERE Days_Activated__c != NULL';
  //   daysToMeeting.metrixBestQuery = 'SELECT AVG(Days_Activated__c) FROM Status__c WHERE Days_Activated__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   daysToMeeting.metrixChartType = 'number';
  //   allMetrixs.add(daysToMeeting);

  //   OBMetrixFunnelMetrix daysToOpportunity = new OBMetrixFunnelMetrix();
  //   daysToOpportunity.metrixName = 'DAYS_TO_OPPORTUNITY';
  //   daysToOpportunity.metrixTitle = 'Account: Average Time - Approaching [replaced] to Opportunity';
  //   daysToOpportunity.metrixDesc = 'When you are successful in creating an opportunity, how long does it take, on average, between activating an account and creating the opportunity?';
  //   daysToOpportunity.metrixCategory = 'Funnel';
  //   daysToOpportunity.metrixQuery = 'SELECT AVG(Days_to_Opportunity__c) FROM Status__c WHERE Days_to_Opportunity__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   daysToOpportunity.metrixUserQuery = 'SELECT AVG(Days_to_Opportunity__c) FROM Status__c WHERE  Days_to_Opportunity__c != NULL AND (Activated_By__c = :userId)';
  //   daysToOpportunity.metrixAllQuery = 'SELECT AVG(Days_to_Opportunity__c) FROM Status__c WHERE Days_to_Opportunity__c != NULL';
  //   daysToOpportunity.metrixBestQuery = 'SELECT AVG(Days_to_Opportunity__c) FROM Status__c WHERE Days_to_Opportunity__c != NULL AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId) GROUP BY Activated_By__c';
  //   daysToOpportunity.metrixChartType = 'number';
  //   allMetrixs.add(daysToOpportunity);

  //   OBMetrixFunnelMetrix activatedToEngaged = new OBMetrixFunnelMetrix();
  //   activatedToEngaged.metrixName = 'ACCTIVATED_ENGAGED';
  //   activatedToEngaged.metrixTitle = 'Account: Approaching [replaced] to In Contact[replaced] Ratio';
  //   activatedToEngaged.metrixDesc = 'What percentage of approached [replaced] accounts respond to your outreach (regardless if it’s a positive or negative response)?';
  //   activatedToEngaged.metrixCategory = 'Funnel';
  //   activatedToEngaged.upperMetrix = 'ACCOUNTS_ENGAGED';
  //   activatedToEngaged.totalMetrix = 'NEW_ACCOUNT_ACTIVATIONS';
  //   activatedToEngaged.metrixChartType = 'percent';
  //   allMetrixs.add(activatedToEngaged);

  //   OBMetrixFunnelMetrix activatedToMeeting = new OBMetrixFunnelMetrix();
  //   activatedToMeeting.metrixName = 'ACCTIVATED_MEETING';
  //   activatedToMeeting.metrixTitle = 'Accounts - Approaching [replaced] to Meeting';
  //   activatedToMeeting.metrixDesc = 'Description for Accounts - Approaching [replaced] to Meeting Metric';
  //   activatedToMeeting.metrixCategory = 'Funnel';
  //   activatedToMeeting.upperMetrix = 'ACCOUNTS_MEETING';
  //   activatedToMeeting.totalMetrix = 'NEW_ACCOUNT_ACTIVATIONS';
  //   activatedToMeeting.metrixChartType = 'line';
  //   activatedToMeeting.metrixVisible = false;
  //   if (CustomMetadataCache.setting.Meeting_Object__c != 'Opportunity') {
  //     allMetrixs.add(activatedToMeeting);
  //   }

  //   OBMetrixFunnelMetrix activatedToOpp = new OBMetrixFunnelMetrix();
  //   activatedToOpp.metrixName = 'ACCTIVATED_OPPORTUNITY';
  //   activatedToOpp.metrixTitle = 'Account: Approaching [replaced] to Opportunity Ratio';
  //   activatedToOpp.metrixDesc = 'What percentage of approached [replaced] accounts become opportunities?';
  //   activatedToOpp.metrixCategory = 'Funnel';
  //   activatedToOpp.upperMetrix = 'ACCOUNTS_OPPORTUNITY';
  //   activatedToOpp.totalMetrix = 'NEW_ACCOUNT_ACTIVATIONS';
  //   activatedToOpp.metrixChartType = 'percent';
  //   allMetrixs.add(activatedToOpp);

  //   OBMetrixFunnelMetrix engagedToMeeting = new OBMetrixFunnelMetrix();
  //   engagedToMeeting.metrixName = 'ENGAGED_MEETING';
  //   engagedToMeeting.metrixTitle = 'Account: In Contact[replaced] to Meeting Ratio';
  //   engagedToMeeting.metrixDesc = 'What percentage of companies that engage with you (regardless if it’s a positive or negative response) agree to a meeting?';
  //   engagedToMeeting.metrixCategory = 'Funnel';
  //   engagedToMeeting.upperMetrix = 'ACCOUNTS_MEETING';
  //   engagedToMeeting.totalMetrix = 'ACCOUNTS_ENGAGED';
  //   engagedToMeeting.metrixChartType = 'percent';
  //   if (CustomMetadataCache.setting.Meeting_Object__c != 'Opportunity') {
  //     allMetrixs.add(engagedToMeeting);
  //   }

  //   OBMetrixFunnelMetrix engagedToOpp = new OBMetrixFunnelMetrix();
  //   engagedToOpp.metrixName = 'ENGAGED_OPPORTUNITY';
  //   engagedToOpp.metrixTitle = 'Accounts - In Contact[replaced] to Opportunity';
  //   engagedToOpp.metrixDesc = 'Description for Accounts - In Contact[replaced] to Opportunity Metric';
  //   engagedToOpp.metrixCategory = 'Funnel';
  //   engagedToOpp.upperMetrix = 'ACCOUNTS_OPPORTUNITY';
  //   engagedToOpp.totalMetrix = 'ACCOUNTS_ENGAGED';
  //   engagedToOpp.metrixChartType = 'line';
  //   engagedToOpp.metrixVisible = false;
  //   allMetrixs.add(engagedToOpp);

  //   OBMetrixFunnelMetrix meetingToOpp = new OBMetrixFunnelMetrix();
  //   meetingToOpp.metrixName = 'MEETING_OPPORTUNITY';
  //   meetingToOpp.metrixTitle = 'Account: Meeting to Opportunity Ratio';
  //   meetingToOpp.metrixDesc = 'What percentage of accounts that agree to a meeting become opportunities?';
  //   meetingToOpp.metrixCategory = 'Funnel';
  //   meetingToOpp.upperMetrix = 'ACCOUNTS_OPPORTUNITY';
  //   meetingToOpp.totalMetrix = 'ACCOUNTS_MEETING';
  //   meetingToOpp.metrixChartType = 'percent';
  //   if (CustomMetadataCache.setting.Meeting_Object__c != 'Opportunity') {
  //     allMetrixs.add(meetingToOpp);
  //   }

  //   OBMetrixFunnelMetrix dialsToConnects = new OBMetrixFunnelMetrix();
  //   dialsToConnects.metrixName = 'DIALS_CONNECTS';
  //   dialsToConnects.metrixTitle = 'Ratio: Dials to Connects';
  //   dialsToConnects.metrixDesc = 'What percentage of the calls you made during the selected period led to conversations (regardless of the outcomes of the calls)?';
  //   dialsToConnects.metrixCategory = 'Activities';
  //   dialsToConnects.upperMetrix = 'DIAL_CALLS';
  //   dialsToConnects.totalMetrix = 'TOTAL_CALLS';
  //   dialsToConnects.metrixChartType = 'percent';
  //   allMetrixs.add(dialsToConnects);

  //   OBMetrixFunnelMetrix emailToResponse = new OBMetrixFunnelMetrix();
  //   emailToResponse.metrixName = 'EMAIL_RESPONSE';
  //   emailToResponse.metrixTitle = 'Ratio: Outbound Emails to Responses';
  //   emailToResponse.metrixDesc = 'This metric (%) answers the question: For every 100 outbound emails sent, how many inbound emails do I receive on average? This metric does not take into account the sentiment of the responses ("No thanks" vs "Yes, let’s meet").';
  //   emailToResponse.metrixCategory = 'Activities';
  //   emailToResponse.upperMetrix = 'INBOUND_EMAILS';
  //   emailToResponse.totalMetrix = 'OUTBOUND_EMAILS';
  //   emailToResponse.metrixChartType = 'percent';
  //   allMetrixs.add(emailToResponse);
  // }

  // public class OBMetrixFunnelMetrixValue {
  //   public Decimal value { get; set; }
  //   public Decimal teamValue { get; set; }

  //   public OBMetrixFunnelMetrixValue() {
  //     this.value = 0;
  //     this.teamValue = 0;
  //   }
  // }

  // public class OBMetrixFunnelMetrix {
  //   @AuraEnabled
  //   public String metrixName { get; set; }
  //   @AuraEnabled
  //   public String metrixTitle { get; set; }
  //   @AuraEnabled
  //   public String metrixDesc { get; set; }
  //   @AuraEnabled
  //   public String metrixCategory { get; set; }
  //   @AuraEnabled
  //   public Decimal metrixValue { get; set; }
  //   @AuraEnabled
  //   public Decimal metrixUserValue { get; set; }
  //   @AuraEnabled
  //   public boolean metrixVisible { get; set; }
  //   @AuraEnabled
  //   public Decimal metrixTeamValue { get; set; }
  //   @AuraEnabled
  //   public Decimal metrixBestValue { get; set; }
  //   @AuraEnabled
  //   public String metrixChartType { get; set; }
  //   public String metrixQuery { get; set; }
  //   public String metrixAllQuery { get; set; }
  //   public String metrixBestQuery { get; set; }
  //   public String metrixUserQuery { get; set; }
  //   public String metrixFilter { get; set; }
  //   public String metrixFilter1 { get; set; }
  //   public String upperMetrix { get; set; }
  //   public String totalMetrix { get; set; }

  //   public String userField { get; set; }
  //   public List<String> teamUserIds { get; set; }
  //   public Map<Id, Decimal> resultsById { get; set; }

  //   public OBMetrixFunnelMetrix() {
  //     metrixVisible = true;
  //   }

  //   /**
  //    * Calculated metric value based on Query or Filter configured.
  //    * We have some custom logic for 'MEETINGS_SET' as it has extra logic for object type checkings
  //    */
  //   public void calcValue(
  //     Date startDate,
  //     Date endDate,
  //     String userId,
  //     Integer allUsers,
  //     boolean showTeam,
  //     boolean isAdmin,
  //     boolean onlySDR,
  //     List<OBNDSelectOption> users
  //   ) {
  //     System.debug(metrixName + ' SOQL queries: ' + Limits.getQueries());
  //     //get list of users on team - have OBMetrix permission
  //     teamUserIds = new List<String>();
  //     //System.debug('USERS: ' + users);
  //     for (OBNDSelectOption u : users) {
  //       teamUserIds.add(u.value);
  //     }
  //     System.debug('teamUserIds: ' + teamUserIds);
  //     // Suggested solution:
  //     // OBMetrixFunnelMetrixValue metricValue = getValue(startDate, endDate, userId, allUsers, showTeam, isAdmin);
  //     // metrixValue = metricValue.value;
  //     // metrixTeamValue = metricValue.teamValue;

  //     if (String.isNotBlank(upperMetrix)) {
  //       //calculations for Team Best - with query
  //       OBMetrixFunnelMetrix upperMet = getMetrix(upperMetrix);
  //       upperMet.calcValue(
  //         startDate,
  //         endDate,
  //         userId,
  //         allUsers,
  //         showTeam,
  //         isAdmin,
  //         onlySDR,
  //         users
  //       );
  //       OBMetrixFunnelMetrix lowerMet = getMetrix(totalMetrix);
  //       lowerMet.calcValue(
  //         startDate,
  //         endDate,
  //         userId,
  //         allUsers,
  //         showTeam,
  //         isAdmin,
  //         onlySDR,
  //         users
  //       );
  //       System.debug('upperMet: ' + upperMet.resultsById);
  //       System.debug('lowerMet: ' + lowerMet.resultsById);
  //       List<Id> userIdsForBest = new List<Id>();
  //       if (upperMet.resultsById != null && !upperMet.resultsById.isEmpty()) {
  //         for (Id theIdUpper : upperMet.resultsById.keySet()) {
  //           if (!userIdsForBest.contains(theIdUpper)) {
  //             userIdsForBest.add(theIdUpper);
  //           }
  //         }
  //       }
  //       if (lowerMet.resultsById != null && !lowerMet.resultsById.isEmpty()) {
  //         for (Id theIdLower : lowerMet.resultsById.keySet()) {
  //           if (!userIdsForBest.contains(theIdLower)) {
  //             userIdsForBest.add(theIdLower);
  //           }
  //         }
  //       }
  //       metrixBestValue = metrixBestValue != null ? metrixBestValue : 0;
  //       for (Id theId : userIdsForBest) {
  //         System.debug('****' + theId);
  //         System.debug('ratio for ID ' + theId);
  //         Decimal upperCount = upperMet.resultsById.containsKey(theId)
  //           ? (Decimal) upperMet.resultsById.get(theId)
  //           : 0;
  //         System.debug('upperCount: ' + upperCount);
  //         Decimal lowerCount = lowerMet.resultsById.containsKey(theId)
  //           ? (Decimal) lowerMet.resultsById.get(theId)
  //           : 0;
  //         System.debug('lowerCount: ' + lowerCount);
  //         Decimal theRatio = lowerCount != 0 ? (upperCount / lowerCount) : 0;
  //         if (theRatio > metrixBestValue) {
  //           metrixBestValue = theRatio;
  //         }
  //         if (theId == UserInfo.getUserId()) {
  //           metrixUserValue = theRatio;
  //         }
  //       }
  //       System.debug(metrixName + ' metrixBestValue: ' + metrixBestValue);
  //       System.debug(metrixName + ' metrixUserValue: ' + metrixUserValue);

  //       //normal metric value calculations
  //       OBMetrixFunnelMetrix up = upperMet;
  //       OBMetrixFunnelMetrix total = lowerMet;
  //       System.debug('??');
  //       //up.calcValue(startDate, endDate, userId, allUsers, showTeam, isAdmin, onlySDR);
  //       //total.calcValue(startDate, endDate, userId, allUsers, showTeam, isAdmin, onlySDR);
  //       metrixValue = up.metrixValue;
  //       metrixTeamValue = up.metrixTeamValue;
  //       if (total.metrixValue != null) {
  //         metrixValue = total.metrixValue > 0
  //           ? metrixValue / total.metrixValue
  //           : 0;
  //         metrixValue = metrixValue == null ? 0 : metrixValue.setScale(2);
  //       }
  //       if (total.metrixTeamValue != null) {
  //         //System.debug(metrixName + ' metrixTeamValue: ' + total.metrixTeamValue);
  //         Decimal upperAll = up.metrixValue * up.teamUserIds.size();
  //         Decimal lowerAll = total.metrixValue * total.teamUserIds.size();
  //         metrixTeamValue = (lowerAll != 0) ? (upperAll / lowerAll) : 0;
  //         //metrixTeamValue = total.metrixTeamValue;
  //         metrixTeamValue = metrixTeamValue == null
  //           ? 0
  //           : metrixTeamValue.setScale(2);
  //       }
  //       return;
  //     }

  //     metrixValue = 0;
  //     Decimal metrixAllValue = 0;
  //     metrixTeamValue = 0;
  //     //query to group by user ID
  //     userField = userField != null ? userField : 'OwnerId';
  //     String queryById;
  //     if (
  //       String.isNotBlank(metrixQuery) &&
  //       (metrixName != 'MEETINGS_SET' ||
  //       CustomMetadataCache.setting.Meeting_Object__c == 'Opportunity')
  //     ) {
  //       String queryFields = metrixQuery.substringBetween('SELECT ', ' FROM');
  //       if (!queryFields.contains(userField)) {
  //         String newQueryFields = queryFields + ', ' + userField;
  //         metrixQuery = metrixQuery.replace(queryFields, newQueryFields);
  //         queryById = metrixQuery.contains('GROUP BY')
  //           ? metrixQuery
  //           : metrixQuery + ' GROUP BY ' + userField;
  //       }

  //       System.debug(metrixName + ' QUERYING queryById in calcValue()');
  //       AggregateResult[] sObjectsForId = Database.query(queryById);
  //       System.debug(queryById);
  //       System.debug(sObjectsForId);
  //       Map<Id, Decimal> aggregateResultByOwner = new Map<Id, Decimal>();
  //       for (AggregateResult ag : sObjectsForId) {
  //         System.debug(ag);
  //         Decimal agResult = (Decimal) ag.get('expr0');
  //         Id theUserId = (Id) ag.get(userField);

  //         /* if(aggregateResultByOwner.containsKey(theUserId)){

  //                       recordCount++;
  //                   }else{
  //                       recordCount = 1;*/

  //         aggregateResultByOwner.put(theUserId, agResult);
  //       }

  //       resultsById = aggregateResultByOwner;
  //       System.debug('resultsById: ' + resultsById);
  //       //set metrixValue
  //       metrixValue = 0;
  //       metrixAllValue = 0;
  //       metrixTeamValue = 0;
  //       metrixUserValue = 0;
  //       metrixBestValue = 0;
  //       for (Id theId : resultsById.keySet()) {
  //         Decimal theResult = resultsById.get(theId);
  //         if (theId == UserInfo.getUserId()) {
  //           metrixUserValue += theResult;
  //         }
  //         if (teamUserIds.contains(theId)) {
  //           metrixValue += theResult;
  //         }
  //         if (theResult > metrixBestValue) {
  //           metrixBestvalue = theResult;
  //         }
  //         metrixAllValue += theResult;
  //       }
  //     }

  //     if (isAdmin == true) {
  //       metrixQuery = metrixAllQuery;
  //     }
  //     if (onlySDR == true) {
  //       metrixQuery = metrixUserQuery;
  //     }
  //     //////////
  //     if (
  //       String.isNotBlank(metrixQuery) &&
  //       (metrixName != 'MEETINGS_SET' ||
  //       CustomMetadataCache.setting.Meeting_Object__c == 'Opportunity')
  //     ) {
  //       /*System.debug(metrixName + ' QUERYING metrixQuery in calcValue()');
  //               AggregateResult[] groupedResults = Database.query(metrixQuery);
  //               for (AggregateResult ar : groupedResults)  {
  //                   metrixValue = (Decimal)ar.get('expr0');
  //                   metrixValue = metrixValue == null ? 0 : metrixValue.setScale(2);
  //               }*/
  //       //if (showTeam == true) {
  //       /*System.debug(metrixName + ' QUERYING metrixAllQuery in calcValue()');
  //                   AggregateResult[] groupedResults = Database.query(metrixAllQuery);
  //                   for (AggregateResult ar : groupedResults)  {
  //                       metrixAllValue = (Decimal)ar.get('expr0');
  //                       metrixAllValue = metrixAllValue == null ? 0 : metrixAllValue;
  //                   }   */
  //       //}
  //       /*Id thisUserId = UserInfo.getUserId();
  //               String thisUserQuery = metrixUserQuery.replace(':userId', ':thisUserId');
  //               System.debug(metrixName + ' QUERYING thisUserQuery in calcValue()');
  //               AggregateResult[] groupedUserResults = Database.query(thisUserQuery);
  //               for (AggregateResult ar : groupedUserResults)  {
  //                   metrixUserValue = (Decimal)ar.get('expr0');
  //                   metrixUserValue = metrixUserValue == null ? 0 : metrixUserValue.setScale(2);
  //               }*/
  //       /*Id thisUserId = UserInfo.getUserId();
  //               if (String.isNotBlank(metrixBestQuery)){
  //                   System.debug(metrixName + ' QUERYING metrixBestQuery in calcValue()');
  //                   AggregateResult[] bestResults = Database.query(metrixBestQuery);
  //                   metrixBestValue = metrixBestValue != null ? metrixBestValue : 0;
  //                   for (AggregateResult ar : bestResults)  {
  //                       if((Decimal)ar.get('expr0') > metrixBestValue){
  //                           metrixBestValue = (Decimal)ar.get('expr0');
  //                           metrixBestValue = metrixBestValue == null ? 0 : metrixBestValue.setScale(2);
  //                       }

  //                   }
  //               }*/
  //     }
  //     if (String.isNotBlank(metrixFilter)) {
  //       //list of all activities for calculating team best
  //       List<SObject> allActivitiesForBest = new List<SObject>();
  //       allActivitiesForBest = getTeamActivities(startDate, endDate);
  //       metrixBestValue = metrixBestValue != null ? metrixBestValue : 0;
  //       Map<Id, Integer> activityByOwner = new Map<Id, Integer>();
  //       for (SObject act : allActivitiesForBest) {
  //         boolean applicableForBest = OutboundCalculationService.isApplicable(
  //           act,
  //           metrixFilter,
  //           null
  //         );
  //         if (applicableForBest == false && String.isNotBlank(metrixFilter1)) {
  //           applicableForBest = OutboundCalculationService.isApplicable(
  //             act,
  //             metrixFilter1,
  //             null
  //           );
  //         }
  //         Integer actCount = 0;
  //         if (applicableForBest) {
  //           Id ownerId = (Id) act.get('OwnerId');
  //           System.debug('ownerId: ' + ownerId);
  //           if (activityByOwner.containsKey(ownerId)) {
  //             actCount = activityByOwner.get(ownerId);
  //             actCount++;
  //           } else {
  //             actCount = 1;
  //           }
  //           activityByOwner.put(ownerId, actCount);
  //         }
  //       }
  //       for (Id theOwnerId : activityByOwner.keySet()) {
  //         if (activityByOwner.get(theOwnerId) > metrixBestValue) {
  //           metrixBestValue = activityByOwner.get(theOwnerId);
  //         }
  //       }
  //       resultsById = activityByOwner;
  //       List<SObject> allActivities = new List<SObject>();
  //       if (isAdmin == true) {
  //         allActivities = getTeamActivities(startDate, endDate);
  //       } else {
  //         allActivities = getActivities(startDate, endDate, userId, onlySDR);
  //       }
  //       for (SObject act : allActivities) {
  //         if (
  //           metrixName != 'MEETINGS_SET' ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Task' &&
  //           act instanceof Task) ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Event' &&
  //           act instanceof Event)
  //         ) {
  //           boolean applicable = OutboundCalculationService.isApplicable(
  //             act,
  //             metrixFilter,
  //             null
  //           );
  //           if (applicable == false && String.isNotBlank(metrixFilter1)) {
  //             applicable = OutboundCalculationService.isApplicable(
  //               act,
  //               metrixFilter1,
  //               null
  //             );
  //           }

  //           metrixValue += applicable ? 1 : 0;
  //         }
  //       }
  //       //if (showTeam == true) {
  //       List<SObject> allUserActivities = getTeamActivities(startDate, endDate);
  //       for (SObject act : allUserActivities) {
  //         if (
  //           metrixName != 'MEETINGS_SET' ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Task' &&
  //           act instanceof Task) ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Event' &&
  //           act instanceof Event)
  //         ) {
  //           boolean applicable = OutboundCalculationService.isApplicable(
  //             act,
  //             metrixFilter,
  //             null
  //           );
  //           if (applicable == false && String.isNotBlank(metrixFilter1)) {
  //             applicable = OutboundCalculationService.isApplicable(
  //               act,
  //               metrixFilter1,
  //               null
  //             );
  //           }
  //           metrixAllValue += applicable ? 1 : 0;
  //         }
  //       }

  //       //}
  //     }
  //     metrixTeamValue = !teamUserIds.isEmpty()
  //       ? (metrixAllValue / teamUserIds.size()).setScale(2)
  //       : metrixAllValue;
  //   }

  //   public OBMetrixFunnelMetrixValue getValue(
  //     Date startDate,
  //     Date endDate,
  //     String userId,
  //     Integer allUsers,
  //     boolean showTeam,
  //     boolean isAdmin,
  //     boolean onlySDR,
  //     List<OBNDSelectOption> userList
  //   ) {
  //     OBMetrixFunnelMetrixValue result = new OBMetrixFunnelMetrixValue();
  //     if (String.isNotBlank(upperMetrix)) {
  //       //calculations for Team Best
  //       OBMetrixFunnelMetrix upperMet = getMetrix(upperMetrix);
  //       upperMet.calcValue(
  //         startDate,
  //         endDate,
  //         userId,
  //         allUsers,
  //         showTeam,
  //         isAdmin,
  //         onlySDR,
  //         userList
  //       );
  //       OBMetrixFunnelMetrix lowerMet = getMetrix(totalMetrix);
  //       lowerMet.calcValue(
  //         startDate,
  //         endDate,
  //         userId,
  //         allUsers,
  //         showTeam,
  //         isAdmin,
  //         onlySDR,
  //         userList
  //       );
  //       List<Id> userIdsForBest = new List<Id>();
  //       if (upperMet.resultsById != null && !upperMet.resultsById.isEmpty()) {
  //         for (Id theIdUpper : upperMet.resultsById.keySet()) {
  //           if (!userIdsForBest.contains(theIdUpper)) {
  //             userIdsForBest.add(theIdUpper);
  //           }
  //         }
  //       }
  //       if (lowerMet.resultsById != null && !lowerMet.resultsById.isEmpty()) {
  //         for (Id theIdLower : lowerMet.resultsById.keySet()) {
  //           if (!userIdsForBest.contains(theIdLower)) {
  //             userIdsForBest.add(theIdLower);
  //           }
  //         }
  //       }
  //       metrixBestValue = metrixBestValue != null ? metrixBestValue : 0;
  //       metrixUserValue = metrixUserValue != null ? metrixUserValue : 0;
  //       for (Id theId : userIdsForBest) {
  //         System.debug('ratio for ID ' + theId);
  //         Decimal upperCount = upperMet.resultsById.containsKey(theId)
  //           ? (Decimal) upperMet.resultsById.get(theId)
  //           : 0;
  //         System.debug('upperCount: ' + upperCount);
  //         Decimal lowerCount = lowerMet.resultsById.containsKey(theId)
  //           ? (Decimal) lowerMet.resultsById.get(theId)
  //           : 0;
  //         System.debug('lowerCount: ' + lowerCount);
  //         Decimal theRatio = lowerCount != 0 ? (upperCount / lowerCount) : 0;
  //         if (theRatio > metrixBestValue) {
  //           metrixBestValue = theRatio;
  //         }
  //         if (theId == UserInfo.getUserId()) {
  //           metrixUserValue = theRatio;
  //         }
  //       }
  //       System.debug(metrixName + ' metrixUserValue: ' + metrixUserValue);

  //       //normal metric value calculations
  //       OBMetrixFunnelMetrixValue up = getMetrix(upperMetrix)
  //         .getValue(
  //           startDate,
  //           endDate,
  //           userId,
  //           allUsers,
  //           showTeam,
  //           isAdmin,
  //           onlySDR,
  //           userList
  //         );
  //       OBMetrixFunnelMetrixValue total = getMetrix(totalMetrix)
  //         .getValue(
  //           startDate,
  //           endDate,
  //           userId,
  //           allUsers,
  //           showTeam,
  //           isAdmin,
  //           onlySDR,
  //           userList
  //         );

  //       result.value = up.value;
  //       result.teamValue = up.teamValue;
  //       if (total.value != null && total.value > 0) {
  //         result.value = result.value / total.value;
  //         result.value = result.value == null ? 0 : result.value.setScale(2);
  //       }
  //       if (total.teamValue != null && total.teamValue > 0) {
  //         result.teamValue = result.teamValue / total.teamValue;
  //         result.teamValue = result.teamValue == null
  //           ? 0
  //           : result.teamValue.setScale(2);
  //       }
  //       return result;
  //     }

  //     Decimal metrixAllValue = 0;
  //     String query = isAdmin == true ? this.metrixAllQuery : this.metrixQuery;

  //     if (
  //       String.isNotBlank(query) &&
  //       (metrixName != 'MEETINGS_SET' ||
  //       CustomMetadataCache.setting.Meeting_Object__c == 'Opportunity')
  //     ) {
  //       System.debug(metrixName + ' QUERYING query in getValue()');
  //       AggregateResult[] groupedResults = Database.query(query);
  //       for (AggregateResult ar : groupedResults) {
  //         result.value = (Decimal) ar.get('expr0');
  //         result.value = result.value == null ? 0 : result.value.setScale(2);
  //       }
  //       //if (showTeam == true) {
  //       System.debug(metrixName + ' QUERYING metrixAllQuery in getValue()');
  //       groupedResults = Database.query(metrixAllQuery);
  //       for (AggregateResult ar : groupedResults) {
  //         result.teamValue = (Decimal) ar.get('expr0');
  //         result.teamValue = result.teamValue == null ? 0 : result.teamValue;
  //       }
  //       result.teamValue = (result.teamValue / allUsers).setScale(2);
  //       //}
  //     } else if (String.isNotBlank(metrixFilter)) {
  //       List<SObject> allActivities = isAdmin == true
  //         ? getTeamActivities(startDate, endDate)
  //         : getActivities(startDate, endDate, userId, onlySDR);

  //       for (SObject act : allActivities) {
  //         if (
  //           metrixName != 'MEETINGS_SET' ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Task' &&
  //           act instanceof Task) ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Event' &&
  //           act instanceof Event)
  //         ) {
  //           DateTime activityCreatedDate = (DateTime) act.get('CreatedDate');
  //           if (
  //             activityCreatedDate != null &&
  //             !(activityCreatedDate >= startDate &&
  //             activityCreatedDate < endDate)
  //           )
  //             continue;

  //           boolean applicable = OutboundCalculationService.isApplicable(
  //             act,
  //             metrixFilter,
  //             null
  //           );
  //           if (applicable == false && String.isNotBlank(metrixFilter1)) {
  //             applicable = OutboundCalculationService.isApplicable(
  //               act,
  //               metrixFilter1,
  //               null
  //             );
  //           }
  //           result.value += (applicable ? 1 : 0);
  //         }
  //       }

  //       //if (showTeam == true) {
  //       List<SObject> allUserActivities = getTeamActivities(startDate, endDate);
  //       for (SObject act : allUserActivities) {
  //         if (
  //           metrixName != 'MEETINGS_SET' ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Task' &&
  //           act instanceof Task) ||
  //           (CustomMetadataCache.setting.Meeting_Object__c == 'Event' &&
  //           act instanceof Event)
  //         ) {
  //           DateTime activityCreatedDate = (DateTime) act.get('CreatedDate');
  //           if (
  //             activityCreatedDate != null &&
  //             !(activityCreatedDate >= startDate &&
  //             activityCreatedDate < endDate)
  //           )
  //             continue;

  //           boolean applicable = OutboundCalculationService.isApplicable(
  //             act,
  //             metrixFilter,
  //             null
  //           );
  //           if (applicable == false && String.isNotBlank(metrixFilter1)) {
  //             applicable = OutboundCalculationService.isApplicable(
  //               act,
  //               metrixFilter1,
  //               null
  //             );
  //           }
  //           result.teamValue += (applicable ? 1 : 0);
  //         }
  //       }
  //       result.teamValue = (result.teamValue / allUsers).setScale(2);
  //       //}
  //     }
  //     //System.debug(metrixName + ' metrixBestValue: ' + metrixBestValue);
  //     return result;
  //   }
  // }

  // /**
  //  * All activities for loggedin user keep as static because we don't need to load for next metric calculation.
  //  * It will use as cache in running transaction
  //  */
  // public static List<SObject> allActivities;
  // public static List<SObject> getActivities(
  //   Date startDate,
  //   Date endDate,
  //   String userId,
  //   boolean onlySDR
  // ) {
  //   if (allActivities == null) {
  //     allActivities = new List<SObject>();
  //     allActivities.addAll(
  //       getSObject(startDate, endDate, userId, 'Task', false, onlySDR)
  //     );
  //     allActivities.addAll(
  //       getSObject(startDate, endDate, userId, 'Event', false, onlySDR)
  //     );
  //   }
  //   return allActivities;
  // }
  // /**
  //  * All activities for all active users keep as static because we don't need to load for next metric calculation.
  //  * It will use as cache in running transaction
  //  */
  // public static List<SObject> allUserActivities;
  // public static List<SObject> getTeamActivities(Date startDate, Date endDate) {
  //   if (allUserActivities == null) {
  //     allUserActivities = new List<SObject>();
  //     allUserActivities.addAll(
  //       getSObject(startDate, endDate, null, 'Task', true, false)
  //     );
  //     allUserActivities.addAll(
  //       getSObject(startDate, endDate, null, 'Event', true, false)
  //     );
  //   }
  //   System.debug('alluserActivities: ' + allUserActivities);
  //   return allUserActivities;
  // }

  // /**
  //  * All Users Where given iserId is employee
  //  */
  // public static Map<String, List<String>> ManagerToUsersMap;
  // public static List<String> getUsers(String managerId) {
  //   if (ManagerToUsersMap == null) {
  //     ManagerToUsersMap = new Map<String, List<String>>();
  //   }
  //   if (ManagerToUsersMap.get(managerId) == null) {
  //     ManagerToUsersMap.put(managerId, new List<String>());
  //   }
  //   return ManagerToUsersMap.get(managerId);
  // }

  // /**
  //  * Load all activities for logged in users
  //  * Activity means Task + Events
  //  */
  // public static List<SObject> getSObject(
  //   Date startDate,
  //   Date endDate,
  //   String userId,
  //   String objApiName,
  //   boolean all,
  //   boolean onlySDR
  // ) {
  //   List<String> fields = new List<String>();
  //   List<String> fieldApis = new List<String>();
  //   List<OBMetrixSettingsService.FieldWrapper> wrpList;
  //   if (objApiName == 'Task') {
  //     fieldApis.addAll(OBMetrixSettingsService.TASKS_FIELDS);
  //     if (!fieldApis.contains('CreatedDate'))
  //       fieldApis.add('CreatedDate');
  //     wrpList = getFields(
  //       fieldApis,
  //       Task.getSObjectType().getDescribe().fields.getMap().values()
  //     );
  //   }
  //   if (objApiName == 'Event') {
  //     fieldApis.addAll(OBMetrixSettingsService.EVENTS_FIELDS);
  //     if (!fieldApis.contains('CreatedDate'))
  //       fieldApis.add('CreatedDate');
  //     wrpList = getFields(
  //       fieldApis,
  //       Event.getSObjectType().getDescribe().fields.getMap().values()
  //     );
  //   }
  //   for (OBMetrixSettingsService.FieldWrapper wrp : wrpList) {
  //     fields.add(wrp.apiName);
  //   }
  //   //System.debug('endDate :: ' + endDate);
  //   List<String> empIds = new List<String>();
  //   String query =
  //     'SELECT Id, ' +
  //     String.join(fields, ', ') +
  //     ' FROM ' +
  //     objApiName +
  //     ' WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND OwnerId = :userId';
  //   if (all) {
  //     query =
  //       'SELECT Id, ' +
  //       String.join(fields, ', ') +
  //       ' FROM ' +
  //       objApiName +
  //       ' WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   }
  //   if (!onlySDR && userId != null) {
  //     empIds = getUsers(userId);
  //     //query = 'SELECT Id, ' + String.join(fields, ', ') + ' FROM ' + objApiName + ' WHERE CreatedDate >= :startDate AND CreatedDate < :endDate AND (OwnerId = :userId OR OwnerId IN :empIds)';
  //     query =
  //       'SELECT Id, ' +
  //       String.join(fields, ', ') +
  //       ' FROM ' +
  //       objApiName +
  //       ' WHERE CreatedDate >= :startDate AND CreatedDate < :endDate';
  //   }
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToView(
  //         Schema.getGlobalDescribe().get(objApiName),
  //         fieldApis
  //       )
  //   ) {
  //     System.debug(' QUERYING query2');
  //     List<SObject> objList = Database.query(query);
  //     //Integer error = 1/0;
  //     System.debug('objList: ' + objList);
  //     return objList;
  //   }
  //   return new List<SObject>();
  // }

  // /**
  //  * Retrieve field list for given object fields
  //  */
  // public static List<OBMetrixSettingsService.FieldWrapper> getFields(
  //   List<String> objfields,
  //   List<SObjectField> fieldTokens
  // ) {
  //   List<OBMetrixSettingsService.FieldWrapper> fields = new List<OBMetrixSettingsService.FieldWrapper>();
  //   for (String objField : objfields) {
  //     for (SObjectField fieldToken : fieldTokens) {
  //       if (objField == fieldToken.getDescribe().getName()) {
  //         fields.add(
  //           new OBMetrixSettingsService.FieldWrapper(fieldToken.getDescribe())
  //         );
  //         break;
  //       }
  //     }
  //   }
  //   return fields;
  // }

  // public static OBMetrixFunnelMetrix getMetrix(String metrixName) {
  //   for (OBMetrixFunnelMetrix fm : allMetrixs) {
  //     if (fm.metrixName == metrixName) {
  //       return fm;
  //     }
  //   }
  //   return null;
  // }
}