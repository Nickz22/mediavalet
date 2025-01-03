public with sharing class EventHelper {
  private static final String DELIMITER = ';';
  private static boolean contact_updated = false;

  private static final Pattern inboundPattern { get; set; }
  private static final Pattern inboundFilterPattern { get; set; }
  private static final Pattern outboundPattern { get; set; }
  private static final Pattern callPattern { get; set; }
  private static final Pattern engagedCallPattern { get; set; }
  private static final Pattern meetingSetPattern { get; set; }

  static {
    inboundPattern = getPattern(
      CustomMetadataCache.setting.Inbound_Email_Subject__c
    );
    inboundFilterPattern = getPattern(
      CustomMetadataCache.setting.Inbound_Email_Subject_Filter__c
    );
    outboundPattern = getPattern(
      CustomMetadataCache.setting.Outbound_Email_Subject__c
    );
    callPattern = getPattern(CustomMetadataCache.setting.Call_Subject__c);
    engagedCallPattern = getPattern(
      CustomMetadataCache.setting.Engaged_Call_Subject__c
    );
    meetingSetPattern = getPattern(
      CustomMetadataCache.setting.Outbound_Meeting_Subject__c
    );
  }

  public static Map<Id, ActivityStats> getMeetingStatsByWhoId(
    List<Event> events
  ) {
    Map<Id, ActivityStats> meetingStatsByWhoId = new Map<Id, ActivityStats>();
    if (CustomMetadataCache.setting.Meeting_Object__c == C.EVENT_NAME) {
      for (Event event : events) {
        getEventActivityStatusMap(meetingStatsByWhoId, event);
      }
    }

    return meetingStatsByWhoId;
  }

  public static void getEventActivityStatusMap(
    Map<Id, ActivityStats> activitiesStatsMap,
    Event theEvent
  ) {
    ActivityStats stats = activitiesStatsMap.get(theEvent.WhoId);
    if (stats == null) {
      String userField = String.isNotBlank(
          CustomMetadataCache.setting.User_Credit_Field__c
        ) && CustomMetadataCache.setting.Meeting_Object__c == 'Event'
        ? CustomMetadataCache.setting.User_Credit_Field__c
        : 'OwnerId';
      Id meetingUserId = (Id) theEvent.get(userField);
      system.debug('theEvent.OwnerId ' + theEvent.OwnerId);
      stats = new ActivityStats(
        theEvent.WhoId,
        theEvent.OwnerId,
        meetingUserId
      );
      stats.activityIds.add(theEvent.Id);
    }
    stats.activityIds.add(theEvent.Id);
    if (String.isNotBlank(theEvent.Subject)) {
      Boolean meetingSetMatched =
        CustomMetadataCache.setting.Meeting_Object__c == 'Event' &&
        OutboundCalculationService.isApplicable(
          theEvent,
          CustomMetadataCache.setting.Outbound_Meeting_Advance__c,
          meetingSetPattern
        );
      System.debug('meetingSetMatched: ' + meetingSetMatched);
      if (meetingSetMatched) {
        stats.meetings += 1;
        stats.firstMeetingDate = theEvent.CreatedDate.date() <
          stats.firstMeetingDate ||
          stats.firstMeetingDate == null
          ? theEvent.CreatedDate.date()
          : stats.firstMeetingDate;
        stats.LastMeetingDate = theEvent.CreatedDate.date() >
          stats.LastMeetingDate ||
          stats.LastMeetingDate == null
          ? theEvent.CreatedDate.date()
          : stats.LastMeetingDate;
      }
    }
    activitiesStatsMap.put(theEvent.WhoId, stats);
  }

  private static Pattern getPattern(String regex) {
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
}