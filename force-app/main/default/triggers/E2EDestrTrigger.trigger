trigger E2EDestrTrigger on E2EDestr__c (before insert) {
    E2EDestrService.touch(Trigger.new);
}