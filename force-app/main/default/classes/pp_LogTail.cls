/**
 * Created by kirillreutski on 31.10.24.
 */

public without sharing class pp_LogTail {
    private static final String bearer {get {return setting.Bearer__c;}}
    private static final Boolean async {get {return setting.Async__c == true;}}

    private static final SObjectField accountFieldReference {get {return Account.Active__c;}}
    private static LogTail_Settings__mdt setting {
        get {
            if (setting == null) {
                List<LogTail_Settings__mdt> settings = [SELECT Bearer__c, Async__c FROM LogTail_Settings__mdt LIMIT 1];
                if (settings.size() > 0) setting = settings[0];
                else throw new NoSettingsException();
            }

            return setting;
        }
        private set;
    }

    @TestVisible
    private static void setSetting(LogTail_Settings__mdt overrideSetting) {
        setting = overrideSetting;
    }

    public static void log(Object data) {
        if (async) log_async(data);
        else log_sync(data);
    }

    public static Boolean log_async(Object data) {
        LogTail_Event__e event = (LogTail_Event__e)LogTail_Event__e.SObjectType.newSObject(null, true);

        event.Data__c = JSON.serialize(getParsedData(data));

        Database.SaveResult result = EventBus.publish(event);
        if (result.isSuccess()) {
            System.debug('Successfully published event: ' + event.EventUuid);
            return true;
        } else {
            for(Database.Error err : result.getErrors()) {
                System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
            }
        }

        return false;
    }

    public static void log_sync(Object data) {
        pp_LogTail log = new pp_LogTail();
        log.setData(getParsedData(data));
        log.send();
    }

    private static Map<String, Object> getParsedData(Object data) {
        if (data instanceof String) return new Map<String, Object>{'message' => data};
        if (data instanceof Map<String, Object>) return (Map<String, Object>) data;

        return new Map<String, Object>{'notParsed' => data};
    }
//
//    private static Map<String, Object> castStringToObjectMap(Map<String, String> inputData) {
//        Map<String, Object> output = new Map<String, Object>();
//        for (String key : inputData.keySet()) {
//            output.put(key, inputData.get(key));
//        }
//        return output;
//    }


    public static void handleEvents(List<LogTail_Event__e> events) {
        for (LogTail_Event__e event : events) {
            pp_LogTail log = new pp_LogTail();
            Map<String, Object> preparedData = prepareData(event);
            log.setData(preparedData);
            log.send();
        }
    }

    private static Map<String, Object> prepareData(LogTail_Event__e event) {
        Map<String, Object> output = new Map<String, Object>();
        Object data = event.Data__c;
        try {
            output = (Map<String, Object>) JSON.deserializeUntyped((String) data);
            return output;
        }
        catch (Exception e) {
            return output;
        }
    }

    @Future(Callout=true)
    public static void sendLog(String data) {
        Map<String, Object> preparedData = (Map<String, Object>) JSON.deserializeUntyped(data);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://in.logs.betterstack.com');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + bearer);
        Datetime n = Datetime.now();
        if (!preparedData.containsKey('dt')) preparedData.put('dt', n);
        if (!preparedData.containsKey('ts')) preparedData.put('dt', n.getTime());
        req.setBody(JSON.serialize(preparedData));
        Http h = new Http();
        if (!Test.isRunningTest()) {
            HttpResponse res = h.send(req);
            System.debug(res.getBody());
        }
    }

    private Map<String, Object> data = new Map<String, Object>();
    public pp_LogTail() {}

    public pp_LogTail addData(String key, Object value) {
        data.put(key, value);
        return this;
    }

    public pp_LogTail addData(Map<String, Object> newData) {
        for (String key : newData.keySet()) {
            data.put(key, newData.get(key));
        }
        return this;
    }

    public pp_LogTail setData(Map<String, Object> newData) {
        data = newData == null ? new Map<String, Object>() : newData;
        return this;
    }

    public pp_LogTail setData(Object newData) {
        setData(getParsedData(newData));
        return this;
    }

    public pp_LogTail setLevel(String level) {
        data.put('level', level);
        return this;
    }

    public pp_LogTail setMessage(String message) {
        data.put('message', message);
        return this;
    }

    public void send() {
        sendLog(JSON.serialize(data));
    }

    public Map<String, Object> getData(){
        return new Map<String, Object>(data);
    }

    public class NoSettingsException extends Exception {}
}