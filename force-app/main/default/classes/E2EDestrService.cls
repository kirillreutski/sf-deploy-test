public with sharing class E2EDestrService {
    public static void touch(List<E2EDestr__c> records) {
        for (E2EDestr__c r : records) {
            if (r.Name == null) r.Name = 'e2e';
        }
    }
}