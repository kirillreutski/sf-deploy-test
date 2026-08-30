trigger MTDT_QA_Trg_DBGTRG4 on MtdtQaTrgDbg4__c (before insert) {
 for (MtdtQaTrgDbg4__c o : Trigger.new) { if (o.QaMark__c == null) { o.QaMark__c = 'MTDT_QA_TRIGGER_RAN'; } }
}