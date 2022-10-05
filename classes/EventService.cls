public with sharing class EventService {

    public static void createNewAppPayout(List<Event> events, Map<Id, Event> oldEventsMap){

        List<Appointment_Payout__c> newApps = new List<Appointment_Payout__c>();

        for(Event e: events){
            if(e.Status__c != oldEventsMap.get(e.Id).Status__c && e.Status__c == 'Completed'){
                newApps.add(new Appointment_Payout__c(Appointment_Date__c = e.StartDateTime, Appointment_Date_Finished__c = e.EndDateTime, Contact__c = e.Doctor__c));
            }
        }

        insert newApps;

    }

}