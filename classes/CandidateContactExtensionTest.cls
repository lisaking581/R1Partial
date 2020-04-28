@isTest
private class CandidateContactExtensionTest{
   static testmethod void myTestData(){
   
      
      Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
        insert usa;
        
        Account a = new Account(Name = 'Penrod Health Care');
        a.BillingCountry = usa.ISO_Code__c;
        insert a;
    
 
    Contact contact_Obj = new Contact(AccountId = a.id, LastName = 'LastName291', FirstName = 'First683', Salutation = 'Mr.', RecordTypeId = '01241000001QHOqAAO',MailingStreet = 'PratapNagar', MailingCity = 'Jaipur', MailingState = 'Raj', MailingPostalCode = '302022', MailingCountry = usa.ISO_Code__c, Phone = '54343-89064', Email = 'Email38@test.com', HasOptedOutOfEmail = false, HasOptedOutOfFax = false, DoNotCall = false, texcellency__DefHC_Is_Active__c = false, VIP__c = false, pi__Needs_Score_Synced__c = false, pi__pardot_hard_bounced__c = false, Event_Registered__c = false, Event_Attended__c = false, No_Longer_with_Company__c = false, Sales_Call_Requested__c = false, Marketing_qualified_lead__c = false);
    Insert contact_Obj; 
     test.startTest();
    ApexPages.StandardController stdController = new ApexPages.StandardController(contact_Obj);
	CandidateContactExtension ext = new CandidateContactExtension(stdController);
    ext.saveCandidate();
	
       
     
     PageReference pty = Page.CandidateThankyou;
     Test.setCurrentPage(pty);
     system.debug(pty.geturl());
     system.assertEquals(pty.geturl(),'/apex/candidatethankyou','pagenotfound');
       
       
     test.stopTest(); 

    
 
  }
}