public with sharing class EventTriggerHandler {

    public static void handle(List<Event> newEvents, Map<Id, Event> oldEventsMap, System.TriggerOperation triggerOperation){
        switch on triggerOperation {

            when AFTER_UPDATE {
                EventService.createNewAppPayout(newEvents, oldEventsMap);
            }
        }
    }

}