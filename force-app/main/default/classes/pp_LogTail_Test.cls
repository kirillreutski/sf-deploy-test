/**
 * Created by kirillreutski on 31.10.24.
 */

@IsTest
private class pp_LogTail_Test {
    @IsTest
    static void testBehavior() {
        pp_LogTail logTail = new pp_LogTail();
        logTail.setData(new Map<String, Object>{'Test' => 'Value'});
        logTail.addData('Test2', 'Value2');
        logTail.setMessage('Hi!');
        logTail.setLevel('High');
        Map<String, Object> data = logTail.getData();
        System.assert(data.containsKey('Test'));
        System.assert(data.get('Test') == 'Value');
        System.assert(data.containsKey('Test2'));
        System.assert(data.get('Test2') == 'Value2');
        System.assert(data.containsKey('message'));
        System.assert(data.get('message') == 'Hi!');
        System.assert(data.containsKey('level'));
        System.assert(data.get('level') == 'High');

        Test.startTest();
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = true));
        logTail.send();
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = false));
        logTail.send();
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = true));
        pp_LogTail.log(new Map<String, String>{'Test' => 'Value'});
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = false));
        pp_LogTail.log(new Map<String, String>{'Test' => 'Value'});
        Test.stopTest();
    }

    @IsTest
    static void testBehaviorAsync() {
        LogTail_Event__e e = new LogTail_Event__e(
                Data__c = JSON.serialize(new Map<String, Object>{'Test' => 'Value'}));

        Test.startTest();
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = true));
        EventBus.publish(e);
        Test.stopTest();
    }

    @IsTest
    static void pooler(){
        pp_LogTail.setSetting(new LogTail_Settings__mdt(Bearer__c = 'test', Async__c = true));
        Test.startTest();
        pp_LogPooler.getInstance().log('test');
        Test.stopTest();
    }
}