@istest
public class SolPortUpdateController_TEST {
static testmethod void myTestData(){
    
     Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
    insert usa;
      
    Account a = new Account(Name = 'Penrod Health Care');
    a.BillingCountry = usa.ISO_Code__c;
    a.Asset_List__c = true;
    Insert a; 
    
    Account b = new Account(Name = 'Test Health Care');
    b.BillingCountry = usa.ISO_Code__c;
    b.Asset_List__c = true;
    Insert b; 
    
    SolPort__c solport_Obj = new SolPort__c(Account__c = a.id, Opportunity__c = false, Not_a_Fit__c = false, Competitor__c = false, Target__c = false, Current__c = false, Former__c = false);
    Insert solport_Obj; 
    
    Solution_Master__c solmast_Obj = new Solution_Master__c( Group_By__c = 'OPT', Solution__c ='TripTix');
    Insert solmast_Obj;
    Solution_Master__c solmast_Obj2 = new Solution_Master__c( Group_By__c = 'OPT', Solution__c ='Optima Live');
    Insert solmast_Obj2;
    
    test.startTest();



    pagereference pageref = page.LaunchSPPopulate;
   
      
    Test.setCurrentPage(pageref);
    SolPortUpdateController ext = new SolPortUpdateController();
    
    
    ext.runQuery();

    
    //system.assertequals(ext.debugsoql,'select name, asset_List__c, countsolport__c  from account where asset_List__c = true');
    system.assertnotequals(ext.debugsoql.length(),0 );
    
    

        
    ext.SolPortUpdate2();
    
    
    

    
    ext.runQuery();
    
    //delete a;
    //delete b;
    
    
   
	//ext.debugsoql='123' ;
    //ext.runQuery();
    
    
    
    //try to trigger catch exception

   
  
  
    
  
  
    

        
    
    
    
   
    
    
    
    

}
}