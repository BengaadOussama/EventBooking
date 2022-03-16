*B. Hotels* is a multi billion dollar company that owns more than 350 Hotel brands and employs more than 60000 employees, they are using *Salesforce* mainly for two things handling their customer requests (Service Cloud) & Handling their customer reservations.

*B. Hotels* has been chosen to host an international trade show, In order to facilitate the reservation process they chose to allow reservation on two different channels :

* Web (Web To Case)
* Phone

*B. Hotels* wants to force some rules : 

* A reservation is _refused_ if the company (Account) does not provide the information of at least one attendee (contact) 
* Requests coming from the web should not exceed a single attendee.
* Requests coming from the phone should not exceed three attendees.
* Once a reservation request (Case) is closed, a message is broadcasted to an external system and the attendee receives an email confirm their registration

*B. Hotels* uses only out of the box objects :

* Companies are represented as “*Account*”
* Attendees are represented as “*Contacts*”
* Reservation Requests are represented as “*Cases*”

Here is a simple diagram explaining the flow :

<img width="629" alt="Screen Shot 2021-07-14 at 13 03 50" src="https://user-images.githubusercontent.com/46943760/158511398-b5dba656-f451-4a36-992d-59097bc59856.png">

*Requirements:*

The code is really messed up and contains multiple bad practices. You jobs is to : 

1. Separate the Logic from the triggers
2. Remove callouts from triggers
3. Refactor the code into helpers & services (Design Patterns, named Credentials ...)
4. Add TestDataFactory 
5. Add missing assertions to Test classes 
6. Add unit tests for classes that do not have a 100% test coverage
7. The current implementation creates a tasks and the users must manually send emails, you should implement a mail service to send emails to attendees automatically.



Frameworks to be used : 
 - Trigger framework https://github.com/kevinohara80/sfdc-trigger-framework
 - Error Logging Framework https://github.com/mehdisfdc/sfdx-ErrorLoggingFramework
 - Test Data Factory https://github.com/benahm/TestDataFactory
