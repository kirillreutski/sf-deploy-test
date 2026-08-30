@isTest
private class MTDT_QA_TrgTest_DBGTRG4 {
 @isTest static void marksField() {
 MtdtQaTrgDbg4__c o = new MtdtQaTrgDbg4__c(Name='x');
 insert o;
 o = [SELECT QaMark__c FROM MtdtQaTrgDbg4__c WHERE Id=:o.Id];
 System.assertEquals('MTDT_QA_TRIGGER_RAN', o.QaMark__c);
 }
}