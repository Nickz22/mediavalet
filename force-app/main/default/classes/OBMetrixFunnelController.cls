/*
 * OBMetring Funnel Controller
 * Provide facility to get funnel data and all other data required to build funnel screen
 * Test Class :: OBMetrixFunnelControllerTest
 * Added On : 10th Feb 2020
 */
public with sharing class OBMetrixFunnelController {
  // @AuraEnabled
  // public static Map<String, Object> getOBFunnelData(String userId) {
  //   String query =
  //     'Select SUM(Binary_Engaged__c), ' +
  //     'SUM(Binary_Meeting__c), SUM(Binary_Opportunity__c), SUM(Binary_Activated__c) ' +
  //     'From Status__c WHERE Id != NULL';

  //   if (String.isNotBlank(userId)) {
  //     query += ' AND Activated_By__c = :userId';
  //   } else if (!OBMetrixPerformanceController.isAdmin()) {
  //     userId = UserInfo.getUserId();
  //     query += ' AND (Activated_By__c = :userId OR Activated_By__r.OBMetrix_Manager__c = :userId)';
  //   }

  //   Decimal totalActivited = 0;
  //   Decimal totalEnaged = 0;
  //   Decimal totalMeetingSet = 0;
  //   Decimal totalOpportunity = 0;
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToView(
  //         Status__c.sObjectType,
  //         new List<String>{
  //           'Id',
  //           'Activated_By__c',
  //           'Binary_Engaged__c',
  //           'Binary_Meeting__c',
  //           'Binary_Opportunity__c',
  //           'Binary_Activated__c'
  //         }
  //       )
  //   ) {
  //     AggregateResult[] groupedResults = Database.query(query);
  //     for (AggregateResult ar : groupedResults) {
  //       totalEnaged = (Decimal) ar.get('expr0');
  //       totalMeetingSet = (Decimal) ar.get('expr1');
  //       totalOpportunity = (Decimal) ar.get('expr2');
  //       totalActivited = (Decimal) ar.get('expr3');
  //     }
  //   }

  //   Map<String, Object> resp = new Map<String, Object>();
  //   List<Decimal> dataList = new List<Decimal>();
  //   List<String> colorList = new List<String>();
  //   List<String> titleList = new List<String>();

  //   dataList.add(totalActivited);
  //   colorList.add('#FF6384');
  //   titleList.add('Activated');

  //   dataList.add(totalEnaged);
  //   colorList.add('#0AF0BA');
  //   titleList.add('Engaged');

  //   if (CustomMetadataCache.setting.Meeting_Object__c != 'Opportunity') {
  //     dataList.add(totalMeetingSet);
  //     colorList.add('#36A2EB');
  //     titleList.add('Meeting Set');
  //   }

  //   dataList.add(totalOpportunity);
  //   colorList.add('#FFCE56');
  //   titleList.add('Opportunity');

  //   resp.put('labels', titleList);

  //   Map<String, Object> datasetsObj = new Map<String, Object>();
  //   datasetsObj.put('data', dataList);
  //   datasetsObj.put('backgroundColor', colorList);
  //   datasetsObj.put('hoverBackgroundColor', colorList);

  //   resp.put('datasets', new List<Object>{ datasetsObj });

  //   return resp;
  // }

  // /**
  //  * Get Funnel Metrics Data based on Given Time frames. Also it will fetch user settings for selected Metrics
  //  * By Default It will returns data for 3 metrics  :: NEW_ACCOUNT_ACTIVATIONS, NEW_CONTACT_ACTIVATED, OPPORTUNITY_CREATED
  //  */
  // @AuraEnabled
  // public static Map<String, Object> getFunnelMetrix(
  //   String timeFrameSelected,
  //   String userId,
  //   List<OBNDSelectOption> users
  // ) {
  //   if (users == null || users.isEmpty()) {
  //     users = (List<OBNDSelectOption>) getOBMetrixUser();
  //     System.debug('**USERS: ' + users);
  //   }
  //   String userMetrixConfig = '';
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToView(
  //         User.sObjectType,
  //         new List<String>{ 'Id', 'Outbound_Funnel_Metric_Settings__c' }
  //       )
  //   ) {
  //     User u = [
  //       SELECT Id, Outbound_Funnel_Metric_Settings__c
  //       FROM User
  //       WHERE Id = :UserInfo.getUserId()
  //     ];
  //     userMetrixConfig = u.Outbound_Funnel_Metric_Settings__c;
  //   }

  //   UserConfig uc = null;
  //   try {
  //     uc = (UserConfig) JSON.deserialize(userMetrixConfig, UserConfig.class);
  //   } catch (Exception e) {
  //     uc = new UserConfig();
  //   }

  //   if (uc.rows == null) {
  //     uc.rows = new List<UserConfigRow>();
  //     UserConfigRow ucr = new UserConfigRow();
  //     ucr.header = 'Outbound Funnel Metrics';
  //     ucr.metrics = new List<UserConfigBox>{
  //       new UserConfigBox('NEW_ACCOUNT_ACTIVATIONS'),
  //       new UserConfigBox('NEW_CONTACT_ACTIVATED'),
  //       new UserConfigBox('OPPORTUNITY_CREATED')
  //     };
  //     uc.rows.add(ucr);
  //   }

  //   List<OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix> allMetrics = OBMetrixFunnelMetrixHelper.allMetrixs;
  //   Map<String, Date> period = getPeriod(timeFrameSelected);
  //   Date startDate = period.get('startDate'), endDate = period.get('endDate');

  //   Set<String> metrixCategories = new Set<String>();
  //   Integer noOfUser = 1;
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToView(
  //         User.sObjectType,
  //         new List<String>{ 'Id', 'IsActive' }
  //       )
  //   ) {
  //     noOfUser = Database.countQuery(
  //       'SELECT COUNT() FROM User WHERE IsActive=true'
  //     );
  //   }

  //   System.debug('*USERS: ' + users);
  //   boolean isAdmin = OutboundCalculationService.isAdmin();
  //   boolean SDROnly = String.isNotBlank(userId);
  //   userId = SDROnly == true ? userId : UserInfo.getUserId();
  //   for (
  //     OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix obMetricFun : allMetrics
  //   ) {
  //     metrixCategories.add(obMetricFun.metrixCategory);
  //     for (UserConfigRow ucr : uc.rows) {
  //       for (UserConfigBox ucb : ucr.metrics) {
  //         if (ucb.Name == obMetricFun.metrixName) {
  //           obMetricFun.getValue(
  //             startDate,
  //             endDate,
  //             userId,
  //             noOfUser,
  //             ucb.showTeam,
  //             isAdmin,
  //             SDROnly,
  //             users
  //           );
  //           obMetricFun.calcValue(
  //             startDate,
  //             endDate,
  //             userId,
  //             noOfUser,
  //             ucb.showTeam,
  //             isAdmin,
  //             SDROnly,
  //             users
  //           );
  //         }
  //       }
  //     }
  //   }

  //   Map<String, Object> result = new Map<String, Object>();
  //   result.put('userSettings', uc);
  //   result.put('allMetrixs', OBMetrixFunnelMetrixHelper.allMetrixs);
  //   result.put('allMetrixCat', metrixCategories);
  //   return result;
  // }

  // @AuraEnabled
  // public static Map<String, Object> getMetricChart(
  //   String metricName,
  //   String timeFrame,
  //   String userId,
  //   List<OBNDSelectOption> users
  // ) {
  //   Map<String, Object> result = new Map<String, Object>();

  //   OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix metric = null;
  //   for (
  //     OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix metrixItem : OBMetrixFunnelMetrixHelper.allMetrixs
  //   ) {
  //     if (metrixItem.metrixName == metricName) {
  //       metric = metrixItem;
  //       break;
  //     }
  //   }

  //   if (metric != null) {
  //     boolean isAdmin = OutboundCalculationService.isAdmin();
  //     Map<String, Date> period = getPeriod(timeFrame);
  //     Date startDate = period.get('startDate'), endDate = period.get('endDate');

  //     boolean SDROnly = String.isNotBlank(userId);
  //     OBMetrixFunnelMetrixHelper.getActivities(
  //       startDate,
  //       endDate,
  //       UserInfo.getUserId(),
  //       SDROnly
  //     );
  //     OBMetrixFunnelMetrixHelper.getTeamActivities(startDate, endDate);

  //     if (timeFrame == 'This Month' || timeFrame == 'Last Month') {
  //       result.put(
  //         'chartData',
  //         getMetricsByWeek(metric, startDate, endDate, isAdmin, userId, users)
  //       );
  //     } else if (timeFrame == 'This Quarter' || timeFrame == 'Last Quarter') {
  //       result.put(
  //         'chartData',
  //         getMetricsByMonth(metric, startDate, endDate, isAdmin, userId, users)
  //       );
  //     } else if (timeFrame == 'This Week' || timeFrame == 'Last Week') {
  //       result.put(
  //         'chartData',
  //         getMetricsByDay(metric, startDate, endDate, isAdmin, userId, users)
  //       );
  //     }
  //   }
  //   return result;
  // }

  // private static Map<String, Date> getPeriod(String timeFrame) {
  //   Date endDate = Date.today().addDays(2);
  //   Date startDate = endDate.addMonths(-1);

  //   if (timeFrame == 'This Month') {
  //     startDate = Date.today().toStartOfMonth();
  //     endDate = startDate.addMonths(1).toStartofMonth();
  //   } else if (timeFrame == 'Last Month') {
  //     startDate = Date.today().toStartOfMonth();
  //     endDate = startDate;
  //     startDate = startDate.addMonths(-1);
  //   } else if (timeFrame == 'This Quarter') {
  //     Integer startMonth = ((Date.today().month() / 3) * 3) + 1;
  //     startDate = Date.newInstance(Date.today().year(), startMonth, 1);
  //     endDate = startDate.addMonths(3);
  //   } else if (timeFrame == 'Last Quarter') {
  //     Integer startMonth = ((Date.today().month() / 3) * 3) + 1;
  //     startDate = Date.newInstance(Date.today().year(), startMonth, 1);
  //     endDate = startDate;
  //     startDate = startDate.addMonths(-3);
  //   } else if (timeFrame == 'This Week') {
  //     startDate = Date.today().toStartOfWeek();
  //     endDate = startDate.addDays(7);
  //   } else if (timeFrame == 'Last Week') {
  //     endDate = Date.today().toStartOfWeek();
  //     startDate = endDate.addDays(-7);
  //   }

  //   return new Map<String, Date>{
  //     'startDate' => startDate,
  //     'endDate' => endDate
  //   };
  // }

  // private static List<Map<String, Object>> getMetricsByDay(
  //   OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix metric,
  //   Date startDate,
  //   Date endDate,
  //   boolean isAdmin,
  //   String userId,
  //   List<OBNDSelectOption> users
  // ) {
  //   List<Map<String, Object>> result = new List<Map<String, Object>>();
  //   boolean SDROnly = String.isNotBlank(userId);
  //   userId = SDROnly == true ? userId : UserInfo.getUserId();
  //   if (metric.metrixChartType == 'line') {
  //     for (Integer day = 0; day < 7; day++) {
  //       result.add(
  //         new Map<String, Object>{
  //           'label' => ((DateTime) startDate.addDays(day)).format('E', 'GMT'),
  //           'value' => metric.getValue(
  //               startDate.addDays(day),
  //               startDate.addDays(day).addDays(1),
  //               userId,
  //               1,
  //               false,
  //               isAdmin,
  //               SDROnly,
  //               users
  //             )
  //             .value
  //         }
  //       );
  //     }
  //   }

  //   return result;
  // }

  // private static List<Map<String, Object>> getMetricsByWeek(
  //   OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix metric,
  //   Date startDate,
  //   Date endDate,
  //   boolean isAdmin,
  //   String userId,
  //   List<OBNDSelectOption> users
  // ) {
  //   List<Map<String, Object>> result = new List<Map<String, Object>>();
  //   boolean SDROnly = String.isNotBlank(userId);
  //   userId = SDROnly == true ? userId : UserInfo.getUserId();
  //   if (metric.metrixChartType == 'line') {
  //     for (Integer week = 0; week < 7; week++) {
  //       Date startOfWeek = startDate.addDays(week * 7).toStartOfWeek();
  //       startOfWeek = startOfWeek < startDate ? startDate : startOfWeek;
  //       if (startOfWeek >= endDate)
  //         break;

  //       Date endOfWeek = startDate.addDays(week * 7).toStartOfWeek().addDays(7);
  //       endOfWeek = endOfWeek > endDate ? endDate : endOfWeek;

  //       result.add(
  //         new Map<String, Object>{
  //           'label' => ((DateTime) startOfWeek).format('M/d', 'GMT') +
  //           ' - ' +
  //           ((DateTime) endOfWeek.addDays(-1)).format('M/d', 'GMT'),
  //           'value' => metric.getValue(
  //               startOfWeek,
  //               endOfWeek,
  //               userId,
  //               1,
  //               false,
  //               isAdmin,
  //               SDROnly,
  //               users
  //             )
  //             .value
  //         }
  //       );
  //     }
  //   }

  //   return result;
  // }

  // private static List<Map<String, Object>> getMetricsByMonth(
  //   OBMetrixFunnelMetrixHelper.OBMetrixFunnelMetrix metric,
  //   Date startDate,
  //   Date endDate,
  //   boolean isAdmin,
  //   String userId,
  //   List<OBNDSelectOption> users
  // ) {
  //   List<Map<String, Object>> result = new List<Map<String, Object>>();
  //   boolean SDROnly = String.isNotBlank(userId);
  //   userId = SDROnly == true ? userId : UserInfo.getUserId();
  //   if (metric.metrixChartType == 'line') {
  //     for (Integer month = 0; month < 3; month++) {
  //       result.add(
  //         new Map<String, Object>{
  //           'label' => ((DateTime) startDate.addMonths(month))
  //             .format('MMM', 'GMT'),
  //           'value' => metric.getValue(
  //               startDate.addMonths(month),
  //               startDate.addMonths(month + 1),
  //               userId,
  //               1,
  //               false,
  //               isAdmin,
  //               SDROnly,
  //               users
  //             )
  //             .value
  //         }
  //       );
  //     }
  //   }
  //   return result;
  // }

  // /**
  //  * Save user for loggedIn Users
  //  */
  // @AuraEnabled
  // public static List<OBNDSelectOption> getOBMetrixUser() {
  //   boolean isAdmin = OutboundCalculationService.isAdmin();
  //   String pSetName = OBMetrixUserSettingsService.OBMetrix_PermissionSet_Name;
  //   List<OBNDSelectOption> selectedUsersPerf = new List<OBNDSelectOption>();
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToView(
  //         PermissionSetAssignment.sObjectType,
  //         new List<String>{ 'Id', 'PermissionSetId', 'AssigneeId' }
  //       )
  //   ) {
  //     String userId = UserInfo.getUserId();
  //     for (PermissionSetAssignment psa : [
  //       SELECT Id, AssigneeId, Assignee.Name, Assignee.OBMetrix_Manager__c
  //       FROM PermissionSetAssignment
  //       WHERE PermissionSet.Name = :pSetName AND Assignee.IsActive = TRUE
  //       ORDER BY Assignee.Name
  //     ]) {
  //       if (
  //         isAdmin ||
  //         userId == psa.AssigneeId ||
  //         userId == psa.Assignee.OBMetrix_Manager__c
  //       ) {
  //         selectedUsersPerf.add(
  //           new OBNDSelectOption(psa.Assignee.Name, psa.AssigneeId)
  //         );
  //       }
  //     }
  //   }
  //   return selectedUsersPerf;
  // }

  // /**
  //  * Save user settings to user object
  //  */
  // @AuraEnabled
  // public static void saveUserSettings(String userSettings) {
  //   if (
  //     ESAPI.accessController()
  //       .isAuthorizedToUpdate(
  //         User.sObjectType,
  //         new List<String>{ 'Outbound_Funnel_Metric_Settings__c' }
  //       )
  //   ) {
  //     User u = new User();
  //     u.Id = UserInfo.getUserId();
  //     u.Outbound_Funnel_Metric_Settings__c = userSettings;
  //     ESAPI.accessController()
  //       .updateAsUser(
  //         new Map<Id, User>(new List<User>{ u }),
  //         new List<String>{ 'Outbound_Funnel_Metric_Settings__c' }
  //       );
  //   }
  // }

  // /**
  //  * This class represents User setting structure saved on User
  //  */
  // public class UserConfig {
  //   @AuraEnabled
  //   public List<UserConfigRow> rows { get; set; }
  // }
  // public class UserConfigRow {
  //   @AuraEnabled
  //   public String header { get; set; }
  //   @AuraEnabled
  //   public List<UserConfigBox> metrics { get; set; }
  // }
  // public class UserConfigBox {
  //   @AuraEnabled
  //   public String Name { get; set; }
  //   @AuraEnabled
  //   public Boolean showTeam { get; set; }
  //   public UserConfigBox(String Name) {
  //     this.Name = Name;
  //   }
  //   public UserConfigBox(String Name, boolean showTeam) {
  //     this.Name = Name;
  //     this.showTeam = showTeam;
  //   }
  // }
}