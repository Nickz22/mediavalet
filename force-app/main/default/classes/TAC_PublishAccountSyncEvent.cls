public class TAC_PublishAccountSyncEvent {

    public class Request {
        @InvocableVariable(label='Account ID' required=true)
        public Id accountId;
    }

    @InvocableMethod(label='Publish Account Sync Event' description='Publishes the TAC AccountSyncEvent for the given Account ID')
    public static void publishEvent(List<Request> requests) {
        List<TAC_AccountSyncEvent__e> eventsToPublish = new List<TAC_AccountSyncEvent__e>();

        for (Request req : requests) {
            eventsToPublish.add(new TAC_AccountSyncEvent__e(AccountId__c = req.accountId));
        }

        // Publish the events
        List<Database.SaveResult> results = EventBus.publish(eventsToPublish);
        // Handle results as necessary (e.g., logging failures)
    }
}