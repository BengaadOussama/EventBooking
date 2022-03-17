/**
 * @description       : Test Class for event booking system
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
public class EventBookingTest {  

        @TestSetup
        static void makeData(){
            makeAccount('Salesforce');

            makeCase('Phone', 'phone case', null);

            makeCase('Web', 'web case', null);
        }

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Given
            Case request = makeCase('Phone', 'phone case', null);
        
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Given
            Account a1 = makeAccount('Salesforce');

            Case request = makeCase('Phone', 'Event Booking', a1.ID);
            
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // Given
            Account a1 = makeAccount('Salesforce');
            
            Contact c1 = makeContact('Contact1', a1.Id, 'Contact1@test.com');
            Contact c2 = makeContact('Contact2', a1.Id, 'Contact2@test.com');
            Contact c3 = makeContact('Contact3', a1.Id, 'Contact3@test.com');
    
            Case request = makeCase('Phone', 'Event Booking', a1.ID);
            
            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assert(result.isSuccess());

        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given
            Account a1 = makeAccount('Salesforce');
            
            Contact c1 = makeContact('Contact1', a1.Id, 'Contact1@test.com');
            Contact c2 = makeContact('Contact2', a1.Id, 'Contact2@test.com');
            Contact c3 = makeContact('Contact3', a1.Id, 'Contact3@test.com');
            Contact c4 = makeContact('Contact4', a1.Id, 'Contact4@test.com');
    
            Case request = makeCase('Phone', 'Event Booking', a1.ID);

            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage());

        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            // Given
            Account a1 = makeAccount('Salesforce');
            
            Contact c1 = makeContact('Contact1', a1.Id, 'Contact1@test.com');
    
            Case request = makeCase('Web', 'Event Booking', a1.ID);

            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then

            System.assert(result.isSuccess());

                
        } 
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given
           // Given
           Account a1 = makeAccount('Salesforce');
            
           Contact c1 = makeContact('Contact1', a1.Id, 'Contact1@test.com');
           Contact c2 = makeContact('Contact2', a1.Id, 'Contact1@test.com');
   
           Case request = makeCase('Web', 'Event Booking', a1.ID);

            // When 
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage());
                
        } 
    
         @isTest
         public static void BestCaseScenarioOfClosingACase(){
            
            Test.setMock(HttpCalloutMock.class, new ExternalSystemMockout());
            Test.startTest();
            Account a1 = makeAccount('Salesforce');
            Contact c1 = makeContact('Contact1', a1.Id, 'Contact1@test.com');
            Case request = makeCase('Web', 'Event Booking', a1.ID);
            Database.SaveResult result = Database.insert(request, false);
            
            request.Status = 'Closed';
            result = Database.update(request, false);
            Test.stopTest();
 
            // Then
            System.assert(result.isSuccess());
        }


        static account makeAccount(String name){
            return (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => name
            },true);
        }

        static Contact makeContact(String lastname,Id accountId, String email){
            return (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
                'LastName' => lastname,
                'AccountId' => accountId,
                'Email' => email
            },true);
        }

        static Case makeCase(String origin,String subject, Id accountId){
            return (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                'Origin' => origin,
                'Subject' => subject,
                'AccountId' => accountId
            }, true);
        }
}