trigger ProjectResource on Project_Resource__c (before insert) {

        ProjectServiceTrigger.onBeforeInsert(Trigger.New);

        
    
}    


