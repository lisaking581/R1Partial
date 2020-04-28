global class EmailOpen2 implements Schedulable{
    global void execute (SchedulableContext ctx){
    
 
        List<Task> TasktoUpdate = new List<Task>();  
        
        
        list <Task> OpenedEMails = [Select Id, subject, Email_Opened_DT__c from Task where TaskSubtype = 'Email' and Email_Opened_DT__c = null
        and id in (Select  ActivityId from EmailMessage where FirstOpenedDate != null and ActivityId != null)];


        list<EmailMessage>myEmails = new list<EmailMessage>();
myEmails = [Select FirstOpenedDate, ActivityId from EmailMessage where FirstOpenedDate != null and ActivityId != null]; 



map<id,Datetime> myAMap = new map<id,Datetime>();
for ( EmailMessage a : myEmails ){
//putting  Id and date to map
myAMap.put(a.ActivityID, a.FirstOpenedDAte);
    } 
//for ( ID aID : myAMap.keySet() ){
//system.debug(loggingLevel.debug, myAMap.get(aID));
 //   }    


    for ( Task t : OpenedEMails)
     if(myAMap.containsKey(t.Id)) {
        
        t.Email_Opened_DT__c = myAMap.get(t.Id);
        TasktoUpdate.add(t);
}  

try {
    
    update TasktoUpdate;
    system.debug('made it to end'); 
    } 
catch(DmlException e) {
System.debug('The following exception has occurred: ' + e.getMessage());
}

}

    }