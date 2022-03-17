/**
 * @description       : Email service that notifies clients
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class EmailService {
    
    /**
    * @description : Sending emails
    * @author Oussama Bengaad  (obengaad@salesforce.com) | 16-03-2022 
    * @param c 
    **/
    public static void sendEmail(List<Contact> cs){
        
        For(Contact c : cs){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            // To address
            String[] toAddresses = new String[] {c.Email};
            mail.setToAddresses(toAddresses);
    
            
            // Email content
            mail.setSenderDisplayName('B. Hotels');
            mail.setSubject('Confirm reservation');
            mail.setPlainTextBody('Your reservation has been confirmed');
    
            try {
                // Send the email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail} );
            } catch (Exception e) {
                Log.error(e.getMessage());
            }
        }
    }
}
