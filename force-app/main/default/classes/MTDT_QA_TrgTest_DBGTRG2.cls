@isTest
private class MTDT_QA_TrgTest_DBGTRG2 {
 @isTest static void marksBlindField() {
 MtdtQaTrgDbg2__c o = new MtdtQaTrgDbg2__c(Name='x');
 insert o;
 o = [SELECT Blind__c FROM MtdtQaTrgDbg2__c WHERE Id=:o.Id];
 System.assertEquals('MTDT_QA_TRIGGER_RAN', o.Blind__c);
 }
}