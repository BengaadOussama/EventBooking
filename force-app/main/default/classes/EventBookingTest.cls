/**
 * @description       : Test Class for event booking system
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 18-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
public class EventBookingTest {  

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Create data
            Case request = makeCase('Phone', 0 , false, false);
        
            // Insert case
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Asserts
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Create data
            Case request = makeCase('Phone', 0 , true, false);
            
            // Insert case
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Asserts
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // Create data
            Case request = makeCase('Phone', 3 , true, false);
            
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
            Case request = makeCase('Phone', 5 , true, false);

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
            Case request = makeCase('Web', 1 , true, false);

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
            Case request = makeCase('Web', 2 , true, false);

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
            //prepare case
            Case request = makeCase('Phone', 3 , true, false);

            //Insert case
            Test.setMock(HttpCalloutMock.class, new ExternalSystemMockout());
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            //Close Case
            request.Status = 'Closed';
            result = Database.update(request, false);
            Test.stopTest();
 
            // Then
            System.assert(result.isSuccess());
        }

        /**
        * @description : Automate account creation
        * @author Oussama Bengaad  (obengaad@salesforce.com) | 17-03-2022 
        * @param name : Account Name
        * @param doInsert : if true the account instance is inserted
        * @return account 
        **/
        static account makeAccount(String name,Boolean doInsert){
            return (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => name
            },doInsert);
        }

        /**
        * @description : Automate contact creation
        * @author Oussama Bengaad  (obengaad@salesforce.com) | 17-03-2022 
        * @param lastname 
        * @param accountId 
        * @param email 
        * @param doInsert : if true the contact instance is inserted
        * @return Contact 
        **/
        static Contact makeContact(String lastname,Id accountId, String email, Boolean doInsert){
            return (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
                'LastName' => lastname,
                'AccountId' => accountId,
                'Email' => email
            },doInsert);
        }

        /**
        * @description : Automate case creation
        * @author Oussama Bengaad  (obengaad@salesforce.com) | 17-03-2022 
        * @param origin 
        * @param nbContacts : nb of contact to create
        * @param withAccount :if True, create an account and link the case to it
        * @param doInsert : if true the case instance is inserted
        * @return Case 
        **/
        static Case makeCase(String origin,Integer nbContacts, Boolean withAccount, Boolean doInsert){
            Account acc = makeAccount('Salesforce',true);

            for(integer i=1;i<=nbContacts;i++){
                makeContact('Contact'+i, acc.Id, 'contact'+i+'@test.com',true);
            }

            return (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                'Origin' => origin,
                'Subject' => origin+' case',
                'AccountId' => withAccount==false?null:acc.Id
            }, doInsert);
        }
}