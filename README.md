# LvivCityMedical

● Create a Salesforce application

● Add record Types to Contacts - Patient, Doctor

● Add Specialization global picklist, values: ('Immunology', 'Anesthesiology',
'Dermatology', 'Emergency medicine', 'Neurology', 'Gynecology', 'Ophthalmology',
'Pathology', 'Pediatrics', 'Rehabilitation', 'Psychiatry')

● Add Specialization__c picklist fields to Doctor and Activity object, use values from
global picklistAdd a new currency field for Doctors - Hourly Rate, which will determine
how much to pay at the end of the month for his services

● Add “Status__c” picklist to the Activity object (values - ‘Pending’, ‘Completed’), which
will determine if the Activity is completed. Doctor should be able to edit this picklist.
Patient should be able to view it only.

● Creating UI for better user experience: Booking appointments (Events) with
Doctors (create an LWC component/Tab and controller to determine which doctor is
available and can make an appointment with a patient - match by specialization, use
BusinessHours and existing Events to determine availability). In other words, the
Doctor is available, when Event Start/End times are within Doctor’s business hours,
his Specialization__c == Event.Specialization__c and he has no existing overlapping
events during this time period.

● Flow: to send an email to the patient after booking an appointment

● Create a new object - Appointment Payout (master-detail to Contact, Appointment
Date, Duration, Hourly Rate, Total Payout)

● When an Event completes (Status__c is changed to ‘Completed’ - this will be done
manually), create a new Appointment Payout record with the populated info: Date,
Duration, Rate, Total Payout (Duration in hours * Hourly Rate)

● Add reporting: Create monthly reports for each Doctor and his payouts

● Track all your changes in GIT

● Add Unit Test coverage for your Apex classes
