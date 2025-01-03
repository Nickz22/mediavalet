public class TAC_PublishProductSyncEvent {

    public class Request {
        @InvocableVariable(label='Product ID' required=true)
        public Id productId;
    }

    @InvocableMethod(label='Publish Product Sync Event' description='Publishes the TAC ProductSyncEvent for the given Product ID')
    public static void publishEvent(List<Request> requests) {
        List<TAC_ProductSyncEvent__e> eventsToPublish = new List<TAC_ProductSyncEvent__e>();

        for (Request req : requests) {
            eventsToPublish.add(new TAC_ProductSyncEvent__e(ProductId__c = req.productId));
        }

        // Publish the events
        List<Database.SaveResult> results = EventBus.publish(eventsToPublish);
        // Handle results as necessary (e.g., logging failures)
    }
}