public with sharing class EventSelector {
  public EventSelector() {
  }

  public List<Event> selectIoOwnedEventsByWhoIdInTrackingPeriod(
    Set<Id> whoIds
  ) {
    Datetime trackingPeriodStart = Datetime.now()
      .addDays(
        -Integer.valueOf(CustomMetadataCache.setting.Timeframe_Days_Contact1__c)
      );
    return [
      SELECT WhoId
      FROM Event
      WHERE
        WhoId IN :whoIds
        AND CreatedDate >= :trackingPeriodStart
        AND OwnerId IN :PermissionsCache.ioUserIds
      WITH USER_MODE
    ];
  }
}