/**
 * @description       : Data access for Contact
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 18-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class ContactDAO {

    public static List<Contact> getContactsByAccountsId( Set<Id> accsId ){
        return [SELECT Id, Name, Email,AccountId FROM Contact WHERE AccountId IN :accsId ];
    }

    public static List<Contact> getContactsByIds( Set<Id> csId ){
        return [SELECT Id, Name, Email,AccountId FROM Contact WHERE Id IN :csId ];
    }
}
