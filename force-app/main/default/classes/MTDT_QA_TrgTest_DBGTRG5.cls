@isTest
private class MTDT_QA_TrgTest_DBGTRG5 {
 @isTest static void marksField() {
 MtdtQaTrgDbg5__c o = new MtdtQaTrgDbg5__c(Name='x');
 insert o;
 o = [SELECT Blind__c FROM MtdtQaTrgDbg5__c WHERE Id=:o.Id];
 System.assertEquals('MTDT_QA_TRIGGER_RAN', o.Blind__c);
 }
}