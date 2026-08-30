@isTest
private class MTDT_QA_TrgTest_DBGTRG6 {
 @isTest static void marksName() {
 MtdtQaTrgDbg6__c o = new MtdtQaTrgDbg6__c(Name='x');
 insert o;
 o = [SELECT Name FROM MtdtQaTrgDbg6__c WHERE Id=:o.Id];
 System.assert(o.Name.endsWith('_MTDT_QA_TRIGGER_RAN'));
 }
}