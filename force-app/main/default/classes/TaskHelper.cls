public with sharing class TaskHelper {
  private static final String DELIMITER = ';';
  private static Settings__mdt settings = CustomMetadataCache.setting;
  private static final Pattern inboundPattern { get; set; }
  private static final Pattern inboundFilterPattern { get; set; }
  private static final Pattern outboundPattern { get; set; }
  private static final Pattern callPattern { get; set; }
  private static final Pattern engagedCallPattern { get; set; }
  private static final Pattern meetingSetPattern { get; set; }

  /**
   * Filters out newTasks belonging to Accounts that have prospecting activities within previousProspectingActivities
   * @param newTasks - List of new tasks
   * @param contacts - List of contacts, should match the contacts in newTasks.WhoId
   * @param previousProspectingActivities - List of previous prospecting activities
   * @return List of tasks that are not part of accounts with prospecting activities
   */
  public static List<Task> filterActivitiesFromAccountsWithOtherProspectingActivities(
    List<Task> newTasks,
    List<Task> previousActivities
  ) {
    Set<Id> accountIds = Pluck.ids(newTasks, C.ACTIVITY_WHAT_ID_FIELD);
    Map<Id, List<SObject>> newTasksByAccountId = Mapper.byId(
      newTasks,
      C.ACTIVITY_WHAT_ID_FIELD
    );

    Map<Id, ActivityStats> previousActivityStatByWhoId = TaskHelper.getActivityStatsByWhoId(
      previousActivities
    );

    for (
      Id prevProspectingActivityContactId : previousActivityStatByWhoId.keySet()
    ) {
      ActivityStats stats = previousActivityStatByWhoId.get(
        prevProspectingActivityContactId
      );
      if (stats.hasProspectingActivity()) {
        newTasksByAccountId.remove(stats.accountId);
      }
    }

    // we don't consider Tasks without an account id explicitly set in the WhatId
    newTasksByAccountId.remove(null);

    // now we only have activities under Accounts who
    // didn't have a prospecting activity within previousActivities
    newTasks = new List<Task>();

    for (List<Task> tasks : newTasksByAccountId.values()) {
      newTasks.addAll(tasks);
    }

    return newTasks;
  }

  static {
    inboundPattern = getPattern(settings.Inbound_Email_Subject__c);
    inboundFilterPattern = getPattern(settings.Inbound_Email_Subject_Filter__c);
    outboundPattern = getPattern(settings.Outbound_Email_Subject__c);
    callPattern = getPattern(settings.Call_Subject__c);
    engagedCallPattern = getPattern(settings.Engaged_Call_Subject__c);
    meetingSetPattern = getPattern(settings.Outbound_Meeting_Subject__c);
  }

  /**
   * we need to understand two things
   * 1) is the incoming task outbound activity, meeting or engaged?
   * 2) if it is, and the in progress stat map does not have outbound activity, meeting or engaged, then count that new Task's CreatedDate as the First/Last Date for those things
   */
  public static Map<Id, ActivityStats> getTaskActivityStatusMap(
    Map<Id, ActivityStats> activitiesStatsMap,
    Task theTask,
    Contact contact
  ) {
    Settings__mdt thisSetting = settings;
    ActivityStats stats = activitiesStatsMap.get(theTask.WhoId);
    if (stats == null) {
      String userField = String.isNotBlank(settings.User_Credit_Field__c) &&
        settings.Meeting_Object__c == 'Task'
        ? settings.User_Credit_Field__c
        : 'OwnerId';
      Id meetingUserId = (Id) theTask.get(userField);
      system.debug('theTask.OwnerId ' + theTask.OwnerId);
      stats = new ActivityStats(theTask.WhoId, theTask.OwnerId, meetingUserId);
      stats.accountId = theTask.WhatId?.getSobjectType() == Account.SObjectType
        ? theTask.WhatId
        : null;
      stats.activityIds.add(theTask.Id);
    }

    ActivityContactWrapper criteriaWrapper = new ActivityContactWrapper(
      theTask,
      contact
    );
    Boolean inboundMatched = isApplicable(
      criteriaWrapper,
      settings.Inbound_Email_Advance__c,
      inboundPattern
    );
    Boolean inboundFilterMatched =
      inboundFilterPattern.matcher(theTask.Subject).find() &&
      String.isNotBlank(settings.Inbound_Email_Subject_Filter__c);
    System.debug(JSON.serializePretty(thisSetting.Outbound_Email_Advance__c));
    Boolean outboundMatched = isApplicable(
      criteriaWrapper,
      settings.Outbound_Email_Advance__c,
      outboundPattern
    );
    Boolean callMatched = isApplicable(
      criteriaWrapper,
      settings.Call_Advance__c,
      callPattern
    );
    Boolean engagedCallMatched = isApplicable(
      criteriaWrapper,
      settings.Engaged_Call_Advance__c,
      engagedCallPattern
    );
    Boolean giftMatched = isApplicable(
      criteriaWrapper,
      settings.Gift_Advance1__c,
      null
    );
    Boolean inMailMatched = isApplicable(
      criteriaWrapper,
      settings.InMail_Advance1__c,
      null
    );
    Boolean meetingSetMatched =
      settings.Meeting_Object__c == 'Task' &&
      isApplicable(
        criteriaWrapper,
        settings.Outbound_Meeting_Advance__c,
        meetingSetPattern
      );
    System.debug('inboundMatched: ' + inboundMatched);
    System.debug('inboundFiltered: ' + inboundFilterMatched);
    System.debug('outboundMatched: ' + outboundMatched);
    System.debug('callMatched: ' + callMatched);
    System.debug('engagedCallMatched: ' + engagedCallMatched);
    System.debug('giftMatched: ' + giftMatched);
    System.debug('inMailMatched: ' + inMailMatched);
    System.debug('meetingSetMatched: ' + meetingSetMatched);
    if (inboundMatched && !inboundFilterMatched) {
      stats.inboundEmails += 1;
    }
    if (outboundMatched && !callMatched) {
      stats.outboundEmails += 1;
    }
    if (engagedCallMatched) {
      stats.engagedDials += 1;
      // stats.dials += 1;
    } else if (callMatched) {
      stats.dials += 1;
    }
    if (giftMatched) {
      stats.gifts += 1;
    }
    if (inMailMatched) {
      stats.inMails += 1;
    }
    if (meetingSetMatched) {
      stats.meetings += 1;
      stats.lastMeetingDate = stats.lastMeetingDate == null ||
        theTask.CreatedDate.date() > stats.lastMeetingDate
        ? theTask.CreatedDate.date()
        : stats.lastMeetingDate;
      stats.firstMeetingDate = stats.firstMeetingDate == null ||
        theTask.CreatedDate.date() < stats.firstMeetingDate
        ? theTask.CreatedDate.date()
        : stats.firstMeetingDate;
    }

    if (stats.isOutboundActivity()) {
      stats.lastOutboundActivityDate = (stats.lastOutboundActivityDate ==
        null ||
        theTask.CreatedDate > stats.lastOutboundActivityDate)
        ? theTask.CreatedDate.date()
        : stats.lastOutboundActivityDate;
      stats.firstOutboundActivityDate = (stats.firstOutboundActivityDate ==
        null ||
        theTask.CreatedDate < stats.firstOutboundActivityDate)
        ? theTask.CreatedDate.date()
        : stats.firstOutboundActivityDate;
    }

    if (stats.hasProspectingActivity()) {
      stats.lastProspectingActivityDate = (stats.lastProspectingActivityDate ==
        null ||
        theTask.CreatedDate > stats.lastProspectingActivityDate)
        ? theTask.CreatedDate.date()
        : stats.lastProspectingActivityDate;
      stats.firstProspectingActivityDate = (stats.firstProspectingActivityDate ==
        null ||
        theTask.CreatedDate < stats.firstProspectingActivityDate)
        ? theTask.CreatedDate.date()
        : stats.firstProspectingActivityDate;
    }

    activitiesStatsMap.put(theTask.WhoId, stats);
    return activitiesStatsMap;
  }

  public static Map<Id, ActivityStats> getActivityStatsByWhoId(
    List<Task> tasks
  ) {
    return getActivityStatsByWhoId(tasks, null);
  }

  public static Map<Id, ActivityStats> getActivityStatsByWhoId(
    List<Task> tasks,
    Map<Id, Contact> whoById
  ) {
    Map<Id, ActivityStats> activityStatsByWhoId = new Map<Id, ActivityStats>();
    for (Task t : tasks) {
      activityStatsByWhoId = TaskHelper.getTaskActivityStatusMap(
        activityStatsByWhoId,
        t,
        whoById.get(t.WhoId)
      );
    }
    return activityStatsByWhoId;
  }

  public static Pattern getPattern(String regex) {
    List<String> words = String.isNotBlank(regex)
      ? regex.split(DELIMITER)
      : new List<String>();
    List<String> escapedWords = new List<String>();
    for (String word : words) {
      String escapedWord = word.replace('[', '\\[').replace(']', '\\]');
      escapedWord = escapedWord.replace('(', '\\(').replace(')', '\\)');
      escapedWords.add(escapedWord);
    }
    // System.debug('*** escapedWords: ' + escapedWords);
    String patternRegex = String.join(escapedWords, '|');
    Pattern thePattern = Pattern.compile('(?i)' + patternRegex);
    return thePattern;
  }

  private static Boolean matchesFilter(
    String operator,
    String taskValue,
    String filterVal
  ) {
    if (operator.toLowerCase() == '=')
      return taskValue == filterVal;
    if (operator.toLowerCase() == '!=')
      return taskValue != filterVal;
    if (operator.toLowerCase() == 'starts')
      return taskValue.startsWithIgnoreCase(filterVal);
    if (operator.toLowerCase() == 'ends')
      return taskValue.endsWithIgnoreCase(filterVal);
    if (operator.toLowerCase() == 'contains')
      return taskValue.containsIgnoreCase(filterVal);
    if (operator.toLowerCase() == 'notcontains')
      return !taskValue.containsIgnoreCase(filterVal);
    return false;
  }

  public static boolean isApplicable(
    ActivityContactWrapper tw,
    String filterString,
    Pattern filterPattern
  ) {
    if (tw == null || (tw.t == null && tw.e == null))
      return false;
    SObject record;
    if (tw.t == null) {
        record = tw.e;
    } else {
        record = tw.t;
    }
    if (String.isBlank(filterString)) {
      if (
        record.Id.getSobjectType() == Task.SObjectType ||
        record.Id.getSobjectType() == Event.SObjectType
      ) {
        String subject = record.get('Subject') == null
          ? null
          : String.valueOf(record.get('Subject'));
        return filterPattern == null ||
          (subject != null && filterPattern.matcher(subject).find());
      }
      return false;
    }
    FieldFilter fieldFilter = (FieldFilter) JSON.deserialize(
      filterString,
      FieldFilter.class
    );
    if (
      fieldFilter.filters == null ||
      fieldFilter.filters.isEmpty() ||
      fieldFilter.disabled
    ) {
      return !fieldFilter.disabled;
    }
    Map<Integer, String> criteriaRes = new Map<Integer, String>();
    Integer count = 1;
    String filterLogic = fieldFilter.filterLogic;
    for (FieldFilterRow rowFilter : fieldFilter.filters) {
      String[] keyPath = rowFilter.field.split('\\.');
      Object fieldValue = resolveFieldValue(tw, keyPath);
      String actualVal = fieldValue == null ? '' : String.valueOf(fieldValue);
      String filterVal = rowFilter.value == null ? '' : rowFilter.value;
      Boolean matched = matchesFilter(rowFilter.operator, actualVal, filterVal);
      criteriaRes.put(count, String.valueOf(matched));
      count++;
    }
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
    return BooleanExpression.evaluate(filterLogic);
  }

  private static Object resolveFieldValue(
    ActivityContactWrapper tw,
    String[] keyPath
  ) {
    SObject record;
    if (tw.t != null) {
        record = tw.t;
    } else {
        record = tw.e;
    }
    if (
      keyPath.size() > 0 &&
      keyPath[0].equalsIgnoreCase('Who') &&
      tw.c != null
    ) {
      record = tw.c;
    }
    for (Integer i = 1; i < keyPath.size(); i++) {
      if (record == null)
        break;
      if (i + 1 == keyPath.size()) {
        return record.get(keyPath[i]);
      }
      record = record.getSObject(keyPath[i]);
    }
    return record;
  }
}
