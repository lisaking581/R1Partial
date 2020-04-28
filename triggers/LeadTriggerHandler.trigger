trigger LeadTriggerHandler on Lead (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	    
    //instantiate the LeadTriggerHandler class
    LeadTriggerHandlerClass lthc = new LeadTriggerHandlerClass();

    //before insert
    if(trigger.isBefore && trigger.isInsert){
        lthc.beforeInsert(trigger.new);
    }
    
    //before delete
    if(trigger.isBefore && trigger.isDelete){
        lthc.beforeDelete(trigger.oldMap);
    }   
    
    //before update
    if(trigger.isBefore && trigger.isUpdate){         
        lthc.beforeUpdate(trigger.newMap, trigger.oldMap);    
    }

    //after insert
    if(trigger.isAfter && trigger.isInsert){
        lthc.afterInsert(trigger.new);
    }
    
    //after update
    if(trigger.isAfter && trigger.isUpdate){         
        lthc.afterUpdate(trigger.new,trigger.oldMap);   
    } 

}//end LeadTriggerHandler()