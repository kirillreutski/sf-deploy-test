/**
 * Created by kirillreutski on 20.07.25.
 */

global class ScheduledSObjectMutator implements Schedulable {


    // === Configurable Settings ===
    public static final SObjectType DEFAULT_TARGET_OBJECT = Account.SObjectType;

    public static final Integer MIN_UPDATE = 10;
    public static final Integer MAX_UPDATE = 30;

    public static final Integer MIN_INSERT = 5;
    public static final Integer MAX_INSERT = 10;

    public static final Integer MIN_DELETE = 3;
    public static final Integer MAX_DELETE = 5;

    private SObjectType TARGET_OBJECT = null;
    private SObjectField TARGET_NAME_FIELD = null;

    global ScheduledSObjectMutator() {
        TARGET_OBJECT = DEFAULT_TARGET_OBJECT;
        TARGET_NAME_FIELD = TARGET_OBJECT.getDescribe().fields.getMap().get('Name');
    }

    global ScheduledSObjectMutator(SObjectType targetObject) {
        TARGET_OBJECT = targetObject;
        TARGET_NAME_FIELD = TARGET_OBJECT.getDescribe().fields.getMap().get('Name');
    }

    global ScheduledSObjectMutator(SObjectType targetObject, SObjectField targetNameField) {
        TARGET_OBJECT = targetObject;
        TARGET_NAME_FIELD = targetNameField;
    }

    global void execute(SchedulableContext sc) {
        mutateData();
    }

    private void mutateData() {
        mutateUpdates();
        mutateInserts();
        mutateDeletes();
    }

    private void mutateUpdates() {
        Integer count = getRandom(MIN_UPDATE, MAX_UPDATE);
        System.debug('Count: ' + count + ', MIN_UPDATE: ' + MIN_UPDATE + ', MAX_UPDATE: ' + MAX_UPDATE);
        if (count < 1) {
            count = 10;
        }
        Integer offset = getRandom(1, count);
        Integer field = getRandom(1, 2);
        String fieldName = field == 1 ? TARGET_NAME_FIELD.toString() : 'Id';

        String query = 'SELECT Id, ' + fieldName + ' FROM ' + TARGET_OBJECT.getDescribe().getName() + ' ORDER BY ' + fieldName + ' LIMIT ' + count;
        if (offset > 0) {
            query += ' OFFSET ' + offset;
        }
        System.debug('Update query: ' + query);
        List<SObject> records = Database.query(query);

        for (SObject record : records) {
            record.put(TARGET_NAME_FIELD, record.get(TARGET_NAME_FIELD) + ' #Updated_' + Datetime.now().getTime());
        }
        update records;
    }

    private void mutateInserts() {
        Integer count = getRandom(MIN_INSERT, MAX_INSERT);
        List<SObject> newRecords = new List<SObject>();
        for (Integer i = 0; i < count; i++) {
            SObject record = TARGET_OBJECT.newSObject();
            record.put(TARGET_NAME_FIELD, 'Generated ' + i + ' - ' + Datetime.now().getTime());
            newRecords.add(record);
        }
        insert newRecords;
    }

    private void mutateDeletes() {
        Integer count = getRandom(MIN_DELETE, MAX_DELETE);
        Integer field = getRandom(1, 2);
        Integer offset = getRandom(0, count);
        String fieldName = field == 1 ? TARGET_NAME_FIELD.toString() : 'Id';

        String query = 'SELECT Id FROM ' + TARGET_OBJECT.getDescribe().getName() + ' ORDER BY ' + fieldName + ' LIMIT ' + count;
        if (offset > 0) {
            query += ' OFFSET ' + offset;
        }
        System.debug('Delete query: ' + query);
        List<SObject> records = Database.query(query);
        Database.delete(records, false);
    }

    private static Integer getRandom(Integer min, Integer max) {
        if (min > max) {
            Integer temp = min;
            min = max;
            max = temp;
        }
        Integer border = max - min + 1;
        if (border < 1) {
            return min;
        }
        return Math.mod(Crypto.getRandomInteger(), max - min + 1) + min;
    }


    global static void schedule(SObjectType targetObject, Integer shift) {
        for (Integer i = 0; i < 4; i ++) {
            System.schedule('Test Mutator ' + targetObject + ' ' + i, '0 ' + (i * 15 + shift) + ' * * * ?', new ScheduledSObjectMutator(targetObject));
        }
    }

    global static void schedule(SObjectType targetObject, SObjectField targetNameField, Integer shift) {
        for (Integer i = 0; i < 4; i ++) {
            System.schedule('Test Mutator ' + targetObject + ' ' + i, '0 ' + (i * 15 + shift) + ' * * * ?', new ScheduledSObjectMutator(targetObject, targetNameField));
        }
    }
}