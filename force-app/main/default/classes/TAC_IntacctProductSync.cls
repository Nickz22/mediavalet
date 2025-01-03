public class TAC_IntacctProductSync {

    @InvocableMethod(label='TAC Sync Single Product to Sage Intacct' description='Syncs a single Product record to Sage Intacct')
    public static void invocableSyncSingleProductToSageIntacct(List<Id> productIds) {
        // Call the future method to handle the sync
        futureSyncSingleProductToSageIntacct(productIds);
    }

    @future(callout=true)
    private static void futureSyncSingleProductToSageIntacct(List<Id> productIds) {
        // Ensure the list is not empty and only take the first ID
        if (productIds == null || productIds.isEmpty()) {
            return;
        }
        Id productId = productIds[0];
        
        // Create an instance of the SobjectController class
        ia_crm.SobjectController intacctInstance = new ia_crm.SobjectController('Product2', String.valueOf(productId), 'SYNC_PRODUCT', null);
        
        // Call the customAction method to initiate the sync
        intacctInstance.customAction();
    }
}