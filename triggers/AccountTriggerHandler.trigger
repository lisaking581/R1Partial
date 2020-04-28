trigger AccountTriggerHandler on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	    
    //instantiate the AccountTriggerHandler class
    AccountTriggerHandlerClass athc = new AccountTriggerHandlerClass();

    //before insert
    if(trigger.isBefore && trigger.isInsert){
        athc.beforeInsert(trigger.new);
    }
    
    //before delete
    if(trigger.isBefore && trigger.isDelete){
        athc.beforeDelete(trigger.oldMap);
    }   
    
    //before update
    if(trigger.isBefore && trigger.isUpdate){         
        athc.beforeUpdate(trigger.newMap, trigger.oldMap);    
    }

    //after insert
    if(trigger.isAfter && trigger.isInsert){
        athc.afterInsert(trigger.new);
    }
    
    //after update
    if(trigger.isAfter && trigger.isUpdate){         
        athc.afterUpdate(trigger.new,trigger.oldMap);   
    } 

}//end AccountTriggerHandler()