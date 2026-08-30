@isTest
private class MTDT_QA_TrgTest_DBGTRG3 {
 @isTest static void marksField() {
 MtdtQaTrgDbg3__c o = new MtdtQaTrgDbg3__c(Name='x');
 insert o;
 o = [SELECT QaMark__c FROM MtdtQaTrgDbg3__c WHERE Id=:o.Id];
 System.assertEquals('MTDT_QA_TRIGGER_RAN', o.QaMark__c);
 }
}