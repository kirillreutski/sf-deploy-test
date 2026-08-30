trigger MTDT_QA_Trg_DBGTRG3 on MtdtQaTrgDbg3__c (before insert) {
 for (MtdtQaTrgDbg3__c o : Trigger.new) { if (o.QaMark__c == null) { o.QaMark__c = 'MTDT_QA_TRIGGER_RAN'; } }
}