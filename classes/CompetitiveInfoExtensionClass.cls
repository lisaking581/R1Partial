public class CompetitiveInfoExtensionClass {


//public String groupFieldName {get; set;}    
//public SolPort__c[] SPList{get;set;}
public Competitive_Info__c[] CIList{get;set;}
public string AccountID {get; set;}  
//   public string accname {get; set;}
// String SolId;


//public void setSolId(String val)
//{
//this.SolId=val;
//}
//public String getSolId()
//{
//return this.SolId;
//}

    



     
    public CompetitiveInfoExtensionClass(ApexPages.standardController std){
        CIList=new Competitive_Info__c[]{};
        
      	
        string AccountID=ApexPages.currentPage().getParameters().get('id');
        string mySolution=ApexPages.currentPage().getParameters().get('solution');	

        
        if(AccountID==NULL){
            system.debug('No Id available');
        }
        else{
            
     
            Competitive_Info__c[] CI = new Competitive_Info__c[]{};
           
            CI=[Select Id, name, Related_To__c, Competitor_Name__c, Solution_Covered__c, Status__c, Strengths__c, weaknesses__c, Contract_Thru_Date__c from Competitive_Info__c where Related_To__c =:AccountID and Solution_covered__c =:mySolution order by Status__c ];
            
            for( Competitive_Info__c c:CI){
           
                    CIList.add(c);
                }
            
            
               
            system.debug(cilist.size());
              
            }
        }
    
       // public pageReference newCompetitor(){  
		//not being used - it is the code to open up the new competitor windo
        //pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/a2A/e?&retURL=' + Competitive_Info__c.id);  

        //return pageRef; 

   // } 
    

    
    //public pageReference newCompetitive(){  
		//string AccountID=ApexPages.currentPage().getParameters().get('id');
        //Account acclist = new Account();
        //acclist = [Select Id, Name  from Account where id =:AccountID Limit 1];
      
     	//string accname = acclist.name;
        
        		
        //PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CompetInfoNew?AccountID=' + AccountId);
        
    
		//system.debug(AccountId);
        //return pageRef; 

  //  } 

 
    }