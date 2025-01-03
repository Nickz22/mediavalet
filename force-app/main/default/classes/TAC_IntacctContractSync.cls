public class TAC_IntacctContractSync {
 
    
    @InvocableMethod(label='TAC Sync Single Contract to Sage Intacct' description='Syncs a single Contract record to Sage Intacct')
    public static void invocableSyncSingleContractToSageIntacct(List<Id> contractIds) {
        // Call the future method to handle the sync
        futureSyncSingleContractToSageIntacct(contractIds);
    }

    @future(callout=true)
    private static void futureSyncSingleContractToSageIntacct(List<Id> contractIds) {
        // Assuming you're only passing one ID for this method
       Id contractId = contractIds[0];
        
        // Create an instance of the SobjectController class
        ia_crm.SobjectController intacctInstance = new ia_crm.SobjectController('Contract', String.valueOf(contractId), 'CREATE_CONTRACT', null);
        
        // Call the customAction method to initiate the sync
        intacctInstance.customAction();
    }
}