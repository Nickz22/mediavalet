public class ActivityStats {
  public Id contactId { get; set; }
  public Id accountId { get; set; }
  public Id ownerId { get; set; }
  public Id meetingUserId { get; set; }
  public Integer inboundEmails { get; set; }
  public Integer outboundEmails { get; set; }
  public Integer dials { get; set; }
  public Integer engagedDials { get; set; }
  public Integer meetings { get; set; }
  public Integer gifts { get; set; }
  public Integer inMails { get; set; }
  public Date firstMeetingDate { get; set; }
  public Date lastMeetingDate { get; set; }
  public Date firstOutboundActivityDate { get; set; }
  public Date lastOutboundActivityDate { get; set; }
  public Date firstProspectingActivityDate { get; set; }
  public Date lastProspectingActivityDate { get; set; }
  public Set<Id> activityIds = new Set<Id>();

  public ActivityStats(Id contactId, Id ownerId, Id meetingUserId) {
    this.contactId = contactId;
    this.ownerId = ownerId;
    this.meetingUserId = meetingUserId;
    this.inboundEmails = 0;
    this.outboundEmails = 0;
    this.dials = 0;
    this.engagedDials = 0;
    this.meetings = 0;
    this.gifts = 0;
    this.inMails = 0;
  }

  public Integer getTotalActivities() {
    // Added Gifts + InMails as Part of total activity count
    // Added on :: 8th Jan 2020
    return this.inboundEmails +
      this.outboundEmails +
      this.dials +
      this.engagedDials +
      this.gifts +
      this.inMails +
      this.meetings;
  }

  public Boolean isOutboundActivity() {
    return this.outboundEmails > 0 ||
      this.dials > 0 ||
      this.gifts > 0 ||
      this.inMails > 0;
  }

  public Boolean isEngagedActivity() {
    return this.inboundEmails > 0 || this.engagedDials > 0 || this.meetings > 0;
  }

  public Boolean hasProspectingActivity() {
    return this.outboundEmails > 0 ||
      this.dials > 0 ||
      this.gifts > 0 ||
      this.inMails > 0 ||
      this.inboundEmails > 0 ||
      this.engagedDials > 0;
  }

  public static ActivityStats consolidateStats(List<ActivityStats> stats){
    ActivityStats consolidatedStats = new ActivityStats(null, null, null);
    for(ActivityStats stat : stats){
      consolidatedStats.inboundEmails += stat.inboundEmails;
      consolidatedStats.outboundEmails += stat.outboundEmails;
      consolidatedStats.dials += stat.dials;
      consolidatedStats.engagedDials += stat.engagedDials;
      consolidatedStats.meetings += stat.meetings;
      consolidatedStats.gifts += stat.gifts;
      consolidatedStats.inMails += stat.inMails;
      consolidatedStats.activityIds.addAll(stat.activityIds);
    }
    return consolidatedStats;
  }
}