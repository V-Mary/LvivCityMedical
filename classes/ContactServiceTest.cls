@IsTest

public with sharing class ContactServiceTest {

    @IsTest
    static void createNewAppPayout_positive(){
        //given
        Contact doctor = new Contact(LastName = 'test', Specialization__c = '', Hourly_Rate__c = 100, Work_start__c = '07:00:00.000Z', Work_end__c= '18:00:00.000Z');
        
        Event event1 = new Event(Subject = 'Meeting', Status__c = 'Pending', Doctor__c = doctor.Id, StartDateTime = DateTime.parse('05/22/2022 11:00 AM'), EndDateTime = DateTime.parse('05/22/2022 12:00 AM'));
        
        Event event2 = new Event(Subject = 'Meeting', Status__c = 'Pending', Doctor__c = doctor.Id, StartDateTime = DateTime.parse('06/22/2022 11:00 AM'), EndDateTime = DateTime.parse('06/22/2022 12:00 AM'));
        
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

    @IsTest
    static void createNewAppPayout_negative(){
        //given
        //when
        //then
    }

}