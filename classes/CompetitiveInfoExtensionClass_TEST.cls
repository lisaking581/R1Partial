@isTest
private class CompetitiveInfoExtensionClass_TEST{
  
  static testmethod void myTestData(){
   

    
    Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
    insert usa;
      
    Account a = new Account(Name = 'Penrod Health Care');
    a.BillingCountry = usa.ISO_Code__c;
    Insert a; 
      
    Competitor__c comp = new Competitor__c(name= 'Testcomp');
    insert comp;
    
   
    
    Competitive_Info__c obj = new Competitive_Info__c( Related_To__c = a.id, Competitor_name__c = comp.id, Solution_Covered__c = 'Triptix', Status__c='Active');
    insert obj;   
                                                      
      
      
    test.startTest();
      
    ApexPages.StandardController stdController = new ApexPages.StandardController(a);


    pagereference pageref = page.ComptInvoVFP2;
    pageref.getParameters().put('id',a.id);
    pageref.getParameters().put('Solution',obj.solution_covered__c);      
      
    Test.setCurrentPage(pageref);
      
      
      
      
      
    CompetitiveInfoExtensionClass obj01 = new CompetitiveInfoExtensionClass(stdcontroller);
    
     obj01.AccountID = a.ID;
     
      
    test.stopTest();
  }
}