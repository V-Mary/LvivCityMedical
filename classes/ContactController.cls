public with sharing class ContactController {

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactsBySpecialization(String special) {
        return [SELECT Name FROM Contact WHERE Specialization__c = :special];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getDoctorBusinessHours(Id contactId) {
        return [SELECT Work_start__c, Work_end__c  FROM Contact WHERE Id = :contactId];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Event> getBookedEvents(Id contactId, DateTime startDateTime) {
        return [SELECT Id FROM Event WHERE Doctor__c = :contactId AND StartDateTime =:startDateTime];
    }

    @AuraEnabled
    public static void createEvent(Datetime startTime, Datetime endTime, Id nameId, String special, Id doctocId) {
        insert new Event(Subject = 'Meeting', Status__c = 'Pending', Specialization__c = special, Doctor__c = doctocId,
                StartDateTime = startTime, EndDateTime = endTime, WhoId = nameId);
    }
}