trigger ContactTriggerHandler on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	    
    //instantiate the ContactTriggerHandler class
    ContactTriggerHandlerClass cthc = new ContactTriggerHandlerClass();

    //before insert
    if(trigger.isBefore && trigger.isInsert){
        cthc.beforeInsert(trigger.new);
    }
    
    //before delete
    if(trigger.isBefore && trigger.isDelete){
        cthc.beforeDelete(trigger.oldMap);
    }   
    
    //before update
    if(trigger.isBefore && trigger.isUpdate){         
        cthc.beforeUpdate(trigger.newMap, trigger.oldMap);    
    }

    //after insert
    if(trigger.isAfter && trigger.isInsert){
        cthc.afterInsert(trigger.new);
    }
    
    //after update
    if(trigger.isAfter && trigger.isUpdate){         
        cthc.afterUpdate(trigger.new,trigger.oldMap);   
    } 

}//end ContactTriggerHandler()