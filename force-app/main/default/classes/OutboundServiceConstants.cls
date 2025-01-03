/**
 * @description Class contains constants used in Outbound calculation logic
 */
public with sharing class OutboundServiceConstants {
  public static final String CONTACT_PREFIX = '003';
  public enum ACCOUNT_STATUSES {
    Not_Started,
    Activated,
    Engaged,
    Meeting_Set,
    Opportunity_Created,
    Expired,
    Nurture,
    Claimed,
    Available,
    Deactivated
  }
  public static List<String> activeStatuses = new List<String>{
    ACCOUNT_STATUSES.Claimed.name(),
    ACCOUNT_STATUSES.Not_Started.name(),
    ACCOUNT_STATUSES.Activated.name(),
    ACCOUNT_STATUSES.Engaged.name(),
    ACCOUNT_STATUSES.Meeting_Set.name()
  };
  public static List<String> inactiveStatuses = new List<String>{
    ACCOUNT_STATUSES.Opportunity_Created.name(),
    ACCOUNT_STATUSES.Expired.name(),
    ACCOUNT_STATUSES.Deactivated.name()
  };
}