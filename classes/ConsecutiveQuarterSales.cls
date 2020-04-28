global class ConsecutiveQuarterSales implements Schedulable{
    global void execute (SchedulableContext ctx){
   
        
        //public void execute ConsecutiveQuarterSales(){

	List<Period> recentQuarters = [
    SELECT quarterlabel, StartDate, EndDate 
    FROM Period
    WHERE endDate < today and Type = 'Quarter' 
    ORDER BY StartDate DESC
    Limit 8];
	system.debug(recentquarters[0]);
        
    List<User> SalesUsers = new List<User>();
    SalesUsers = [Select Id from User where Team__c != null]; 
    
   
    for (User b : Salesusers){
    b.conqtr__c = 0;
     
    }
        
        
    update SalesUsers;
    system.debug('users reset to zero ' + SalesUsers.size());   
        
        
        
        
        
    List<Opportunity> closedOpps = new List<Opportunity>();
        
    //Select ownerid, id, name, CloseDate, isclosed, stagename from Opportunity where isclosed = true and  closedate = last_quarter and stagename = 'Closed Won'        
    //Select ownerid, id, name, CloseDate, isclosed, stagename from Opportunity where isclosed = true and  closedate = Last_n_quarters:2 and stagename = 'Closed Won'  and closedate < last_quarter  
   //Select ownerid, id, name, CloseDate, isclosed, stagename from Opportunity where isclosed = true and  closedate = Last_n_quarters:2 and stagename = 'Closed Won'  and closedate < Last_n_quarters:1
        
        
        //starting point - users with sales in prior quarter
   
        for (period p: recentQuarters){
        system.debug(p.startdate);
            
        closedOpps = [Select Ownerid from Opportunity where isclosed = true and  closedate  <= :p.Enddate and closedate >= :p.startdate and Type != 'Administrative Adjustment' and stagename = 'Closed Won' and OwnerId in :Salesusers];
    	system.debug('closed opps - ' + closedOpps.size());
    	
   		Set<Id> userlist = new Set<id>();
    
        for (opportunity a : closedOpps){
           userlist.add(a.Ownerid) ;
            
        }
    
            
         SalesUsers = [Select Id, conqtr__c from User where id in :userlist];
       system.debug('user count to update ' + SalesUsers.size());
    
    for (User u : Salesusers){
            u.conqtr__c = u.conqtr__c + 1;
    }
      
	update Salesusers;
            
        
        }

        
    }
    
    }