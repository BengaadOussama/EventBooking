/**
 * @description       : Case trigger handler class
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 16-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class CaseTriggerHandler extends TriggerHandler {
    private List<Account> oldCaseList, newCaseList;
    private Map<Id, Account> oldCaseMap, newCaseMap;
   
    public CaseTriggerHandler() {
        oldCaseList = (List<Account>) Trigger.old;
        newCaseList = (List<Account>) Trigger.new;
        oldCaseMap = (Map<Id, Account>) Trigger.oldMap;
        newCaseMap = (Map<Id, Account>) Trigger.newMap;
    }
   
    protected override void beforeInsert() {
       CaseTriggerHelper.beforeInsertLogic(newCaseList,newCaseMap);
    }
    protected override void afterUpdate() {
        CaseTriggerHelper.beforeUpdateLogic(oldCaseList,newCaseList,oldCaseMap,newCaseMap);
    }
 
}
