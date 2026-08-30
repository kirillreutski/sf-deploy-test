trigger MTDT_QA_Trg_DBGTRG6 on MtdtQaTrgDbg6__c (before insert) {
 for (MtdtQaTrgDbg6__c o : Trigger.new) { o.Name = o.Name + '_MTDT_QA_TRIGGER_RAN'; }
}