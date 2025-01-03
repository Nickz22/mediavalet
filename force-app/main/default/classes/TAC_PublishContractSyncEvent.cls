public class TAC_PublishContractSyncEvent {

    public class Request {
        @InvocableVariable(label='Contract ID' required=true)
        public Id contractId;
    }

    @InvocableMethod(label='Publish Contract Sync Event' description='Publishes the TAC ContractSyncEvent for the given Contract ID')
    public static void publishEvent(List<Request> requests) {
        List<TAC_ContractSyncEvent__e> eventsToPublish = new List<TAC_ContractSyncEvent__e>();

        for (Request req : requests) {
            eventsToPublish.add(new TAC_ContractSyncEvent__e(ContractId__c = req.contractId));
        }

        // Publish the events
        List<Database.SaveResult> results = EventBus.publish(eventsToPublish);
        // Handle results as necessary (e.g., logging failures)
    }
}