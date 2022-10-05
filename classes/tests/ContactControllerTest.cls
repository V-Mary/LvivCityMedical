@IsTest
public with sharing class ContactControllerTest {

    @IsTest
    static void getContactsBySpecialization_test() {
        Contact doctor1 = new Contact(LastName = 'test1', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        Contact doctor2 = new Contact(LastName = 'test2', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        Contact doctor3 = new Contact(LastName = 'test3', Specialization__c = 'Dermatology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        
        Test.startTest();
            insert doctor1;
            insert doctor2;
            insert doctor3;
        Test.stopTest();

        List<Contact> contList =  ContactController.getContactsBySpecialization('Anesthesiology');
        
        System.assertEquals(2, contList.size(), 'Do not get contacts with needed specialization!');
    }

    @IsTest
    static void getDoctorBusinessHours_test() {
        Contact doctor1 = new Contact(LastName = 'test1', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '08:00:00.000Z', Work_end__c= '19:00:00.000Z');
        Contact doctor2 = new Contact(LastName = 'test2', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        insert doctor1;
        insert doctor2;

        Test.startTest();

        List<Contact> contList =  ContactController.getDoctorBusinessHours(doctor1.Id);

        Test.stopTest();
        
        System.assertEquals('08:00:00.000Z', contList.get(0).Work_start__c);
        System.assertEquals('19:00:00.000Z', contList.get(0).Work_end__c);
    }

    @IsTest
    static void getBookedEvents_test() {
        Contact doctor1 = new Contact(LastName = 'test1', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        Event event2 = new Event(Subject = 'Meeting', Status__c = 'Pending', Doctor__c = doctor1.Id, StartDateTime = DateTime.newInstance(2022, 1, 30, 7, 8, 16), EndDateTime = DateTime.newInstance(2022, 1, 31, 7, 8, 16));
        Event event1 = new Event(Doctor__c = doctor1.Id, StartDateTime = DateTime.newInstance(2022, 1, 30, 7, 8, 16), EndDateTime = DateTime.newInstance(2022, 1, 30, 8, 8, 16), Subject = 'Meeting', Status__c = 'Pending');
        insert doctor1;
        insert event1;
        insert event2;

        Test.startTest();

        List<Event> eventList =  ContactController.getBookedEvents(doctor1.Id, DateTime.newInstance(2022, 1, 30, 7, 8, 16));

        Test.stopTest();

        System.assertEquals(1, eventList.size());
    }

    @IsTest
    static void createEvent_test() {
        Contact doctor1 = new Contact(LastName = 'test1', Specialization__c = 'Anesthesiology', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        insert doctor1;
        
        Test.startTest();
        ContactController.createEvent(DateTime.newInstance(2022, 1, 30, 7, 8, 16),DateTime.newInstance(2022, 1, 30, 8, 8, 16), doctor1.Id, 'Anesthesiology', doctor1.Id);
        Test.stopTest();

        List<Event> eventList = [SELECT ID FROM Event WHERE Doctor__c=:doctor1.Id AND WhoId=:doctor1.Id AND Specialization__c=:'Anesthesiology'];

        System.assertEquals(1, eventList.size());
    }

}