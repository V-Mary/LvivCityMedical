
trigger EventTrigger on Event (after update) {

    EventTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.operationType);
}