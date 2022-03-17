/**
 * @description       : Case trigger handler class
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 17-03-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public with sharing class CaseTriggerHandler extends TriggerHandler {
    private List<Case> oldCaseList, newCaseList;
    private Map<Id, Case> oldCaseMap, newCaseMap;
   
    public CaseTriggerHandler() {
        oldCaseList = (List<Case>) Trigger.old;
        newCaseList = (List<Case>) Trigger.new;
        oldCaseMap = (Map<Id, Case>) Trigger.oldMap;
        newCaseMap = (Map<Id, Case>) Trigger.newMap;
    }
   
    protected override void beforeInsert() {
       CaseTriggerHelper.beforeInsertLogic(newCaseList,newCaseMap);
    }
    
    protected override void afterUpdate() {
        CaseTriggerHelper.beforeUpdateLogic(oldCaseList,newCaseList,oldCaseMap,newCaseMap);
    }
 
}
