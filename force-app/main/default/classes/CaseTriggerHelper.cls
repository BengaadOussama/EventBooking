/**
 * @description       : Case Trigger Helper Class
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 16-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class CaseTriggerHelper {

    /**
    * @description : before insert logic
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param newCaseList 
    * @param newCaseMap 
    **/
    public static void beforeInsertLogic(List<Case> newCaseList,Map<Id, Case>  newCaseMap) {
        
        //Get attached accounts Ids
        Set<Id> accountIds = new Set<Id>(); 
        For(Case c : newCaseList){
            accountIds.add(c.accountId);
        }
  
        //Get account records
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT id, (select id from contacts) FROM Account WHERE id IN :accountIds]);
       
        // Bulkify the logic
        for(Case r : newCaseList){
            
            // Testing if the content of case is null or not to avoid NPE ;) 
            if(r != null && r.AccountId != null){

                Integer s = accounts.get(r.AccountId).Contacts.size();

                if(s ==0){
                    r.addError('You cannot create a request for accounts without contacts');
                }   else {
                    switch on r.Origin {
                        when 'Web' {
                            if(s >= 2 ){
                                r.addError('Web request are only allowed to have one attendee');
                            }
                        }
                        when 'Phone'{
                            if(s >= 4 ){
                                r.addError('Phone request are only allowed to have three attendee');
                            }
                        }
                    }    
                                
                }

            }else {
                r.addError('You cannot create a request without attaching an account');
            }
        }
    }


    /**
    * @description :before update logic
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param oldCaseList 
    * @param newCaseList 
    * @param oldCaseMap 
    * @param newCaseMap 
    **/
    public static void beforeUpdateLogic(List<Case> oldCaseList,List<Case> newCaseList,Map<Id, Case>  oldCaseMap,Map<Id, Case>  newCaseMap) {
         
        // Bulkify the logic
        Set<Id> accountIds = new Set<Id>(); 
        For(Case c : newCaseList){
            if(r.Status == 'Closed'){
                accountIds.add(c.accountId);
            }
        }
   
        // web service callout
        if(accountIds.size()!=0){
                ExternalSystemService service = new ExternalSystemService();
                service.registerAttendees(accountIds);
        }
    }
}
