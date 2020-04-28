public class CandidateContactExtension {


    private final Contact webCandidate;
    private final RecordType RT;
    

    public CandidateContactExtension(ApexPages.StandardController
                                stdController) {
       webCandidate = (Contact)stdController.getRecord();
       RecordType RT = [SELECT id,DeveloperName FROM RecordType WHERE SobjectType = 'Contact' and DeveloperName = 'Recruiting_Candidate'];
       webCandidate.RecordTypeId = RT.Id;                            
    }

     public PageReference saveCandidate() {
       try {
       insert(webCandidate);
       }
       catch(System.DMLException e) {
           ApexPages.addMessages(e);
           return null;
       }
      
        return page.CandidateThankyou;
         
         
     
         
     }
    
}