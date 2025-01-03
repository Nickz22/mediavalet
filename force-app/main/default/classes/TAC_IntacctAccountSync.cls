public class TAC_IntacctAccountSync {

    @InvocableMethod(label='TAC Sync Single Account to Sage Intacct' description='Syncs a single Account record to Sage Intacct')
    public static void invocableSyncSingleAccountToSageIntacct(List<Id> accountIds) {
        // Call the future method to handle the sync
        futureSyncSingleAccountToSageIntacct(accountIds);
    }

    @future(callout=true)
    private static void futureSyncSingleAccountToSageIntacct(List<Id> accountIds) {
        // Ensure the list is not empty and only take the first ID
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        Id accountId = accountIds[0];
        
        // Create an instance of the SobjectController class
        ia_crm.SobjectController intacctInstance = new ia_crm.SobjectController('Account', String.valueOf(accountId), 'SYNC_CUSTOMER', null);
        
        // Call the customAction method to initiate the sync
        intacctInstance.customAction();
    }
}