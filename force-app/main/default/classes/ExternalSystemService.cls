/**
 * @description       : External web service callout and email service
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class ExternalSystemService {

    private static final String WEBSERVICEURL = 'callout:Event_Booking_System/animals';

    /**
    * @description : register our clients
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param accountIds 
    **/
    @future (callout=true)
    public static void registerAttendees(Set<Id> accountIds){

        List<Contact> contactsToNotify = new List<Contact>();

        for(Contact c : ContactDAO.getContactsByAccountsId(accountIds)){
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            //Prepare the HTTP request
            request.setEndpoint(WEBSERVICEURL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json; charset=UTF-8');
            request.setBody('{"name":"'+ c.name + '-' + c.email  +'"}');

            //Send the HTTP request
            HttpResponse response = http.send(request);

            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                String errorMsg = 'The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus();
                Log.error(errorMsg);
            } else {
                // Everything went as expected.
                contactsToNotify.add(c);
            }
            
        }

        if(contactsToNotify.size()!=0){
            notifyAttendeesByEmail(contactsToNotify);
        }
    } 

    /**
    * @description : create tasks and email clients
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param c 
    **/
    public static void notifyAttendeesByEmail(List<Contact> cs){
        TaskDAO.createEmailTasksForContacts(cs);
        EmailService.sendEmail(cs);
    } 

}