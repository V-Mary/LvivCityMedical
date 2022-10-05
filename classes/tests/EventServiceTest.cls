@IsTest

public with sharing class EventServiceTest {

    @IsTest
    static void createNewAppPayout_positive(){
        //given
        Contact doctor = new Contact(LastName = 'test', Specialization__c = '', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        
        insert doctor;
        
        Event event1 = new Event(Subject = 'Meeting', Status__c = 'Pending', Doctor__c = doctor.Id, StartDateTime = DateTime.newInstance(2022, 1, 30, 7, 8, 16), EndDateTime = DateTime.newInstance(2022, 1, 30, 8, 8, 16));
        
        Event event2 = new Event(Subject = 'Meeting', Status__c = 'Pending', Doctor__c = doctor.Id, StartDateTime = DateTime.newInstance(2022, 1, 30, 7, 8, 16), EndDateTime = DateTime.newInstance(2022, 1, 31, 7, 8, 16));
        
        insert event1;
        event1.Status__c = 'Completed';
        //when
        Test.startTest();
            update event1;
        Test.stopTest();
        //then
        List<Appointment_Payout__c> listPayout = [SELECT Id from Appointment_Payout__c WHERE Contact__c=: doctor.Id];
        System.assertEquals(1, listPayout.size(), 'Do not create new appointment payout!');

    }

}