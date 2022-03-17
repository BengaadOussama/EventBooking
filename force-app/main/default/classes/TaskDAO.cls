/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class TaskDAO {
    public static void createEmailTasksForContacts(List<Contact> cs){
        List<Task> tks = new List<Task>();

        for(Contact c : cs){
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
