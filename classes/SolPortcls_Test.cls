@isTest
private class SolPortcls_Test{
  
  static testmethod void myTestData(){
   

    
    Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
    insert usa;
      
    Account a = new Account(Name = 'Penrod Health Care');
    a.BillingCountry = usa.ISO_Code__c;
    Insert a; 
    
    SolPort__c solport_Obj = new SolPort__c(Account__c = a.id, Opportunity__c = false, Not_a_Fit__c = false, Competitor__c = false, Target__c = false, Current__c = false, Former__c = false);
    Insert solport_Obj; 
      
    test.startTest();
      
    ApexPages.StandardController stdController = new ApexPages.StandardController(a);


    pagereference pageref = page.SolPortGroupedvfp;
    pageref.getParameters().put('id',a.id);
           
      
    Test.setCurrentPage(pageref);
    SolPortcls obj01 = new SolPortcls(stdcontroller);
    obj01.groupFieldName = 'Group_By__c';
    obj01.setSPId(solport_obj.id);
    obj01.SPList = new SolPort__c[1];
    obj01.groups = new List<SolPortcls.GroupWrapper>();
    obj01.setSPId('test data');
   
      
    obj01.EditSolPort();
      
       

    

      
    test.stopTest();
  }
}