/**
 * @description       : Email service that notifies clients
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 19-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class EmailService {
    
    /**
    * @description : Sending single emails
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param c 
    **/
    public static void sendSingleEmails(Set<Id> csId){
        List<Contact> myContacts = ContactDAO.getContactsByIds(csId);

        //Send email in bulk to avoid governer limit of 10 Messaging.sendEmail in one transaction
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();


        For(Contact c : myContacts){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // To address
            String[] toAddresses = new String[] {c.Email};
            mail.setToAddresses(toAddresses);
    
            
            // Email content
            mail.setSenderDisplayName('B. Hotels');
            mail.setSubject('Confirm reservation');
            mail.setPlainTextBody('Your reservation has been confirmed');
    
            lstMails.add(mail);
        }

        try {
                // Send the emails
                Messaging.sendEmail(lstMails);
        } catch (Exception e) {
                Log.error(e.getMessage());
        }
    }

    
}
