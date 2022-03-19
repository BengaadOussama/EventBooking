/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 18-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class TaskDAO {
    public static void createEmailTasksForContacts(Set<Id> csId){
        List<Contact> myContacts = ContactDAO.getContactsByIds(csId);

        List<Task> tks = new List<Task>();

        for(Contact c : myContacts){
            Task tk = new Task();
            tk.Subject = 'Send Email To ' + c.name;
            tk.Status = 'Open';
            tk.Priority = 'Normal';
            tk.WhoId = c.ID;

            tks.add(tk);
        }

        Database.SaveResult[] srList = Database.insert(tks, false);
        Log.error(srList);
    }
}
