trigger MTDT_QA_Trg_DBGTRG5 on MtdtQaTrgDbg5__c (before insert) {
 for (MtdtQaTrgDbg5__c o : Trigger.new) { if (o.Blind__c == null) { o.Blind__c = 'MTDT_QA_TRIGGER_RAN'; } }
}