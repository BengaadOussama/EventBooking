/**
 * @description       : Case Trigger
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 16-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
trigger CaseTrigger on Case (
    before insert
    , before update
    , before delete
    , after insert
    , after update
    , after delete
    , after undelete)
{
        new CaseTriggerHandler().run();
}