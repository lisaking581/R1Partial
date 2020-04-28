public class AddSolutionPortfolio {
@InvocableMethod

    public static void SPAssign(List<ID> ids) {
    
        
    List<Account> myAccs = [SELECT Id FROM Account where Id =:ids];
      system.debug('accounts selected were ' + myAccs.size());     
        //get a list of account ids 
        Set<Id> accIds = new Set<Id>();

    //create empty whitepsace list
           List<SolPort__c> SPList = new List<SolPort__c>();    
    
  //iterate thru list of valid accounts
            
for (Account a : myAccs){
                            
		
		//look for existing whitespace records for this account	 
		List<SolPort__c> solport = [
            SELECT SolutionID__c 
            FROM SolPort__c where account__c = :a.id
            ];
        system.debug('solutions portfolio list is' + solport.size());
        //get a list of solutions already exist for the account 

		Set<Id> UsedsolutionIds = new Set<Id>();
		
    	
    if(solport.size() != 0 ) { 
        for (SolPort__c c : solport){
		               
		UsedSolutionIds.add(c.SolutionID__c);
        }}
		
		system.debug('used ids are' + UsedSolutionIds.size());

//get solutions that don't already exist
		List<Solution_Master__c> sollist = [
            SELECT Id, Group_by__c, Solution__c
            FROM Solution_Master__c where id not in :UsedsolutionIds
            ];
        
        //create ws list record for each solution left in Sollist
			system.debug('valid solution count is' + sollist.size());
        
		for (Solution_Master__c sm: sollist){
		SolPort__c w = new SolPort__c();
           
        w.Account__c = a.Id;
		w.Group_By__c = sm.Group_by__c;
        w.Solution_Name__c = sm.Solution__c;
        w.SolutionID__c = sm.Id;
		SPlist.add(w);
       
        //new Whitespace__c(Vertical__c='IDN',Solution_Area__c='Business Office Solutions',Account__c=c.Id);
		}
       
            
       
                
            
               }
       

    
     // Bulk insert all ws records with one DML call
     // 
     // 
     try {
    
    	insert SPlist;
		} 
    catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
    }
    	system.debug('made it to end');
}
}