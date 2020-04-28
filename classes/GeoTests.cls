/* GeoTests - 2018-11-06
   by: Gary Triassi (gtriassi@trigon-group.com)
   
   Tests    Triggers:
            o AccountTriggerHandler
            o ContactTriggerHandler
            o LeadTriggerHandler
   
   			Classes:
            o AccountTriggerHandlerClass
            o ContactTriggerHandlerClass
            o LeadTriggerHandlerClass
            o CommonMethods
*/  
@isTest
private class GeoTests {

    static testMethod void geoTest() {
    	
        //-- insert Super Region
        Super_Region__c nam = new Super_Region__c(Name='NAM', Description__c='North America');
        insert nam;
        
        //-- insert Country      	
      	Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
      	insert usa;
        
        //-- insert State/Province
        insert new StateProvince__c(Name='New York', Value_to_Validate__c='NY', Country__c=usa.Id, Code__c='NY');
    		
   		//geo (Country and State) maps
    	map<String, Country__c> countriesMapByName = new map<String, Country__c>();
    	map<String, Country__c> countriesMapByISO2 = new map<String, Country__c>();
    	map<String, Country__c> countriesMapByISO3 = new map<String, Country__c>();
		map<String, StateProvince__c> statesMapByCode = new map<String, StateProvince__c>();
		map<String, StateProvince__c> statesMapByName = new map<String, StateProvince__c>();
		map<String, StateProvince__c> statesMapByAlt = new map<String, StateProvince__c>();
		set<String> countries2Check = new set<String>();    	
    	
   		//load geo (Country and State) maps
    	CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
		CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);	 
    	
    	//insert a new Account to test related trigger code
    	Account acct = new Account(Name='Trigon Corp', BillingCountry='USA', BillingState='New York', BillingStreet='819 Bay Road', BillingCity='Webster', 
    								BillingPostalCode='14580', Super_Region__c=nam.Id, AnnualRevenue=1000000, Website='www.trigon-corp.com');
    	insert acct;
    	
    	//call the geo validation method with both good and bad data
  		Boolean goodGeo = CommonMethods.geoFieldsValidation(0, acct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		Account badAcct = new Account(Name='Bad Account', BillingCountry=null, BillingState=null);
 		goodGeo = CommonMethods.geoFieldsValidation(0, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															
  		badAcct.BillingCountry = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  		
  		badAcct.BillingCountry = 'USA';
  		badAcct.BillingState = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															  		 															
 		goodGeo = CommonMethods.geoFieldsValidation(1, badAcct, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		
  		//update the Account to test related trigger code
  		Account updAcct = new Account(
  			Id=acct.Id, 
  			ShippingCountry = 'United States',
	    	ShippingState = 'NY',
	    	ShippingStreet = '819 Bay Road',
	    	ShippingCity = 'Webster',
	    	ShippingPostalCode = '14580-8675');
    	try{update updAcct;}
    	catch(Exception e){}
    	
    	//insert a new Contact to test related trigger code
    	Contact cont = new Contact(FirstName='Pete', LastName='Moss', AccountId=acct.Id, MailingCountry='USA', MailingState='NY', MailingStreet='819 Bay Road', MailingCity='Webster', 
    								MailingPostalCode='14580');
    	insert cont;
    	       
    	//call the geo validation method with both good and bad data
  		goodGeo = CommonMethods.geoFieldsValidation(0, cont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		Contact badCont = new Contact(FirstName='Bad', LastName='Contact', MailingCountry=null, MailingState=null);
 		goodGeo = CommonMethods.geoFieldsValidation(0, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															
  		badCont.MailingCountry = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  		
  		badCont.MailingCountry = 'USA';
  		badCont.MailingState = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															  		 															
 		goodGeo = CommonMethods.geoFieldsValidation(1, badCont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		
    	cont.MailingCountry = 'XX';
    	try{update cont;}
    	catch(Exception e){}
    	try{delete cont;}
    	catch(Exception e){}
    	try{delete acct;}
    	catch(Exception e){}
    	
    	//insert a new Lead to test related trigger code
    	Lead thisLead = new Lead(Company='Trigon Corp', FirstName='Pete', LastName='Moss', Country='USA', State='NY', Street='819 Bay Road', City='Webster', PostalCode='14580');
    	insert thisLead;
    	       
    	//call the geo validation method with both good and bad data
  		goodGeo = CommonMethods.geoFieldsValidation(0, thisLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		Lead badLead = new Lead(FirstName='Bad', LastName='Lead', Country=null, State=null);
 		goodGeo = CommonMethods.geoFieldsValidation(0, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															
  		badLead.Country = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
 		goodGeo = CommonMethods.geoFieldsValidation(1, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  		
  		badLead.Country = 'USA';
  		badLead.State = 'XYZZY';
 		goodGeo = CommonMethods.geoFieldsValidation(0, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);  															  		 															
 		goodGeo = CommonMethods.geoFieldsValidation(1, badLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
  															statesMapByName, statesMapByAlt, countries2Check, false);
  		
    	thisLead.Country = 'XX';
    	try{update thisLead;}
    	catch(Exception e){}
    	try{delete thisLead;}
    	catch(Exception e){}
  															
    }//end geoTest()
    
}//end GeoTests()