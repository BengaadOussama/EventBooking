/**
 * @description       : Data access for Account
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class AccountDAO {
 
    public static Map<Id,Account> getAccountsMapAndTheirContactsByIds( Set<Id> ids ){
        return new Map<Id,Account>([SELECT id, (select id from contacts) FROM Account WHERE id IN :ids]);
    }
}
