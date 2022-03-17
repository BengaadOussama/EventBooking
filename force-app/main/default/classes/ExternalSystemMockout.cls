/**
 * @description       : External System Mock
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class ExternalSystemMockout implements HttpCalloutMock {

    //implementation of respond
    public HTTPResponse respond(HttpRequest req){
        HttpResponse resp=new HttpResponse();

        if(req.getMethod() == 'POST' && req.getEndpoint()=='callout:Event_Booking_System/animals'){
            resp.setStatusCode(201);
        }

        return resp;
    }
}