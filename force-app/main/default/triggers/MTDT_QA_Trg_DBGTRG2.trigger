trigger MTDT_QA_Trg_DBGTRG2 on MtdtQaTrgDbg2__c (before insert) {
 for (MtdtQaTrgDbg2__c o : Trigger.new) { if (o.Blind__c == null) { o.Blind__c = 'MTDT_QA_TRIGGER_RAN'; } }
}