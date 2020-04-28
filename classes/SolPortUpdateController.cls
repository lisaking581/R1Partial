public with sharing class SolPortUpdateController {

// the soql string
  private String soql {get;set;}
  // the collection of accts to display
  public List<Account> accounts {get;set;}
  
  private integer countaccounts;
  public integer countsoql = 0;
    public integer countMaster = 0;
 
  
  // format the soql for display on the visualforce page
public String debugSoql {
  get { return soql ; }
   set;
 }

  // init the controller and display some sample data when the page loads
public SolPortUpdateController() {
    soql = 'select name, asset_list__c, countsolport__c from account where asset_List__c=true  and countsolport__c < ' +  countMaster() + ' limit 50';
    countsoql++;
        runQuery();
  }
  
public integer countMaster(){
    		List<Solution_Master__c> sollistcount = [
            SELECT Id
            FROM Solution_Master__c 
            ];
    
    		countMaster = sollistcount.size();
			system.debug('number of master solutions ' + countMaster);
    	return countMaster;

        
    } 
  
  // runs the actual query
public void runQuery() {
  	      
    try {
      accounts = Database.query(soql);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }
  
  //runs the search with parameters passed via Javascript
//public PageReference runSearch() {
  /*  
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String accountName = Apexpages.currentPage().getParameters().get('accountName');
   
    
    soql = 'select firstname, lastname, account.name from contact where account.name != null';
    if (!firstName.equals(''))
      soql += ' and firstname = ' + '\'' + String.escapeSingleQuotes(firstName)+ '\'' ;
    if (!lastName.equals(''))
      soql += ' and lastname =' +  '\'' + String.escapeSingleQuotes(lastName)+ '\'';
    if (!accountName.equals(''))
      soql += ' and account.name Like \'%' + accountname + '%\''; 

    // run the query again*/
 //   runQuery();

   // return null;
//  }
    

//public static void SolPortUpdate2 () 
public void SolPortUpdate2 () {
    
    
        List<Solution_Master__c> sollistall = [
            SELECT Id, Group_by__c, Solution__c
            FROM Solution_Master__c 
            ];

    system.debug('count master sols ' + countmaster());
  List<Account> myAccs = [SELECT Id, countsolport__c FROM Account where asset_list__c = true  and countsolport__c < :countmaster() limit 50]; 
//List<Account> myAccs = [SELECT Id, countsolport__c FROM Account where asset_list__c = true limit 50];
  countsoql = countsoql + 1;
    system.debug('first query - accounts selected were ' + myAccs.size()); 
	system.debug('soql = ' + countsoql);   
        //get a list of account ids 
        Set<Id> accIds = new Set<Id>();
countaccounts = myAccs.size();
    
//create empty whitepsace list
           List<SolPort__c> SPList = new List<SolPort__c>();    
    
//iterate thru list of valid accounts
            
for (Account a : myAccs){
                            
	if(a.CountSolPort__c != 0 ) { 
		//look for existing whitespace records for this account	 
		List<SolPort__c> solport = [
           SELECT SolutionID__c 
           FROM SolPort__c where account__c = :a.id
          ];
        countsoql++;
        
        //system.debug('solutions portfolio list is' + solport.size());
        //get a list of solutions already exist for the account 

		Set<Id> UsedsolutionIds = new Set<Id>();
		  
        for (SolPort__c c : solport){
		               
		UsedSolutionIds.add(c.SolutionID__c);
        
        }
		system.debug('used ids are' + UsedSolutionIds.size());
    
//get solutions that don't already exist
		List<Solution_Master__c> sollist = [
            SELECT Id, Group_by__c, Solution__c
            FROM Solution_Master__c where id not in :UsedsolutionIds
            ];
    	countsoql++;
    system.debug('soql count is ' + countsoql);
	
        
        //create ws list record for each solution left in Sollist
			system.debug('valid solution count is' + sollist.size());
        
		for (Solution_Master__c sm: sollist){
		SolPort__c w = new SolPort__c();
           
        w.Account__c = a.Id;
		w.Group_By__c = sm.Group_by__c;
        w.Solution_Name__c = sm.Solution__c;
        w.SolutionID__c = sm.Id;
		SPlist.add(w);
        }
       
       
        
    }else {
      //List<Solution_Master__c> sollist = [
      //     SELECT Id, Group_by__c, Solution__c
      //      FROM Solution_Master__c 
       //     ];
    	//countsoql++;  
        
        for (Solution_Master__c sm: sollistall){
		SolPort__c w = new SolPort__c();
           
        w.Account__c = a.Id;
		w.Group_By__c = sm.Group_by__c;
        w.Solution_Name__c = sm.Solution__c;
        w.SolutionID__c = sm.Id;
		SPlist.add(w);
        }
        
        
        
        
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