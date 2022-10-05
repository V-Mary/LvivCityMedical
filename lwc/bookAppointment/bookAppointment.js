import {LightningElement, wire, api, track} from 'lwc';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import SPECIALIZATION_FIELD from '@salesforce/schema/Contact.Specialization__c';
import getContactsBySpecialization from '@salesforce/apex/ContactController.getContactsBySpecialization';
import getDoctorBusinessHours from '@salesforce/apex/ContactController.getDoctorBusinessHours';
import getBookedEvents from '@salesforce/apex/ContactController.getBookedEvents';
import createEvent from '@salesforce/apex/ContactController.createEvent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

function startTime (day, time) {
    if(time<=10){
        time = Number(time) - 1;
        return day+"T0"+time+":00:00.000Z";
    }else{
        time = Number(time) - 1;
        return day+"T"+time+":00:00.000Z";
    }
}

function endTime(day, time) {
    if(time<=9){
        time = Number(time);
        return day+"T0"+time+":00:00.000Z";
    }else{
        time = Number(time);
        return day+"T"+time+":00:00.000Z";
    }
}

export default class BookAppointment extends LightningElement {

    @api recordId;

    showDate = false;
    @track recordOptions  = [];
    @track hourOptions  = [];
    @track doctor = '';
    @track hour = '';
    @track numEvents =[];
    value = '';
    eventTime = '';
    day = '';

    @wire(getObjectInfo, {objectApiName: CONTACT_OBJECT})
    contactMetadata;

    @wire(getPicklistValues,
        {
            recordTypeId: '0127Q000000AU3eQAG',
            fieldApiName: SPECIALIZATION_FIELD
        }
    )
    specializationPicklist;

    
    handleChange(event) {
        this.value = event.detail.value;
    }

    @wire(getContactsBySpecialization, {special: '$value'})
    contacts({error, data}){
        if (data) {
            this.recordOptions = [];
            for(let i=0; i < data.length; i++)  {
                this.recordOptions.push({value: data[i].Id , label: data[i].Name});
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    };

    handleDoctors(event) {
        this.doctor = event.detail.value;
    }

    @wire(getDoctorBusinessHours, {contactId: '$doctor'})
    hours({error, data}){
        if (data) {
            this.hourOptions = [];
            let doctorData = data[0];

            let numberofworkinghs = 0;
            if (Number(doctorData.Work_end__c) - Number(doctorData.Work_start__c)) {
                numberofworkinghs = Number(doctorData.Work_end__c) - Number(doctorData.Work_start__c);
            } 

            for (let i=0; i < numberofworkinghs; i++) {

                this.hourOptions.push({ value: String(Number(doctorData.Work_start__c) + i ), label: Number(doctorData.Work_start__c) + i });
                
            }
           
            this.error = undefined;
        } else if (error) {
            console.log('no data error');
            this.error = error;
        }
    };
    
    handleDays(event) {
        this.day = event.detail.value;
        console.log(this.day);
    }

    handleHours(event) {
        this.hour = event.detail.value;
        this.eventTime = startTime(this.day, this.hour);
        console.log(this.hour);
        
    }


    @wire(getBookedEvents, {contactId: '$doctor', startDateTime : '$eventTime'})
    numEvents;

    makeAppointment() {
      //  let eventTime = startTime(this.day, this.hour);
        //getBookedEvents(this.doctor, startTime(this.day, this.hour)).size();
        if(this.numEvents.data.length > 0 ){

            const event = new ShowToastEvent({
                title: 'Time is booked.',
                message: 'This time is already booked. Please, choose another time.',
            });
            this.dispatchEvent(event);
        }else{
            console.log('size = 0');
            createEvent({startTime: startTime(this.day, this.hour), endTime: endTime(this.day, this.hour), nameId: this.recordId, special: this.value, doctocId: this.doctor})
            .then(result => console.log('Event created'))
            .catch(error => console.log(error))
            
            window.location.reload();
            //eval("$A.get('e.force:refreshView').fire();");
        } 

        
    }


}