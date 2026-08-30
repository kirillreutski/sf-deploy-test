trigger E2EFX_CaseTrigger on E2EFX_Case__c (before insert) {
    for (E2EFX_Case__c c : Trigger.new) {
        if (c.Info__c == null) {
            c.Info__c = E2EFX_Service.ping();
        }
    }
}