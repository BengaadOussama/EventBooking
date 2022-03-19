/**
 * @description       : External web service callout and email service
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 19-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class ExternalSystemService {

    private static final String WEBSERVICEURL = 'callout:Event_Booking_System/animals';

    /**
    * @description : register our clients
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param accountIds 
    **/
    
    public static void registerAttendees(Set<Id> accountIds){

        Map<Id,String> contactsToNotify = new Map<Id,String>();

        /*
        Prepare the JSON req body, if we send contacts 1 by 1 ,
        we will exceed the API governor limit of 100 , in case 
        there are more than 100 contacts to be sent to the 
        external system
        */
        for(Contact c : ContactDAO.getContactsByAccountsId(accountIds)){
            //Prepare the HTTP request body
            String body = '{"name":"'+ c.name + '-' + c.email  +'"}';
            contactsToNotify.put(c.Id, body);
        }

        if(contactsToNotify.size()!=0){
            externalSystemCallout(contactsToNotify);
        }
    } 

    /**
    * @description : Methods that handles the callout to the external system 
    * and sends conatcts infos at one shot to avoid API governor limit of 
    * 100 calls in a transaction
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param c 
    **/
    @future (callout=true)
    private static void externalSystemCallout(Map<Id,String> contactsToNotify){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        //Prepare the HTTP request
        request.setEndpoint(WEBSERVICEURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json; charset=UTF-8');
        String reqBody = Json.serialize(contactsToNotify.values());
        request.setBody(reqBody);

        //Send the HTTP request
        HttpResponse response = http.send(request);

        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            String errorMsg = 'The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus();
            Log.error(errorMsg);
        } else {
            notifyAttendeesByEmail(contactsToNotify.keySet());
        }
    } 

    /**
    * @description : create tasks and email clients
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param c 
    **/
    private static void notifyAttendeesByEmail(Set<Id> cs){
        TaskDAO.createEmailTasksForContacts(cs);
        EmailService.sendSingleEmails(cs);
    } 

}