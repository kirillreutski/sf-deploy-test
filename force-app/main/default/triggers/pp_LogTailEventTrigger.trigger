/**
 * Created by kirillreutski on 31.10.24.
 */

trigger pp_LogTailEventTrigger on LogTail_Event__e (after insert) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            pp_LogTail.handleEvents(Trigger.new);
        }
    }
}