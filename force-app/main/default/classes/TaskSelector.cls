public with sharing class TaskSelector {
  public TaskSelector() {
  }

  public List<Task> selectIoOwnedTasksWithinTrackingPeriodByWhoIdsNotInIds(
    Set<Id> contactIds,
    Set<Id> notInIds
  ) {
    Integer trackingPeriod = Integer.valueOf(
      CustomMetadataCache.setting.Timeframe_Days_Contact1__c
    );
    Date trackingPeriodStartDate = Date.today().addDays(-trackingPeriod);
    return [
      SELECT
        Id,
        WhoId,
        WhatId,
        Subject,
        ActivityDate,
        Status,
        Priority,
        OwnerId,
        Type,
        CreatedDate
      FROM Task
      WHERE
        WhoId IN :contactIds
        AND Id NOT IN :notInIds
        AND OwnerId IN :PermissionsCache.ioUserIds
        AND CreatedDate >= :trackingPeriodStartDate
      WITH USER_MODE
    ];
  }

  public List<Task> selectTasksByAccountIdsCreatedAfterDateBeforeTodayAndNotInIds(
    Set<Id> accountIds,
    Set<Id> notInIds,
    Date startRange
  ) {
    return [
      SELECT
        Id,
        WhoId,
        WhatId,
        Subject,
        ActivityDate,
        Status,
        Priority,
        OwnerId,
        Type,
        CreatedDate
      FROM Task
      WHERE
        WhatId IN :accountIds
        AND Id NOT IN :notInIds
        AND CreatedDate >= :startRange
        AND CreatedDate < TODAY
      WITH USER_MODE
    ];
  }
}