/*	ContactTriggerHandlerClass
	2018-11-06 revisions: Gary Triassi (gtriassi@trigon-group.com)
	
	Called By:	ContactTriggerHandler.trigger
	
	Purpose:
	-	before delete:
		o	 
	-	before insert:
		o	Geographic field (Country, State, Super Region) validation and attribution
	- 	before update:
		o	Geographic field (Country, State, Super Region) validation and attribution
	-	after insert:
		o	
	-	after update:
		o	
*/
	
public class ContactTriggerHandlerClass {
	//public variables
    
    //private variables
    
   	//geo (Country and State) maps
    private map<String, Country__c> countriesMapByName = new map<String, Country__c>();
    private map<String, Country__c> countriesMapByISO2 = new map<String, Country__c>();
    private map<String, Country__c> countriesMapByISO3 = new map<String, Country__c>();
	private map<String, StateProvince__c> statesMapByCode = new map<String, StateProvince__c>();
	private map<String, StateProvince__c> statesMapByName = new map<String, StateProvince__c>();
	private map<String, StateProvince__c> statesMapByAlt = new map<String, StateProvince__c>();
	private set<String> countries2Check = new set<String>();
       
    public ContactTriggerHandlerClass(){
		      	
    }//end ContactTriggerHandlerClass()

    public void afterInsert(list<Contact> contList){      	 
	
    }//end afterInsert()
    
    public void afterUpdate(list<Contact> contList, map<Id, Contact> oldContMap){

  	}//end afterUpdate()
  	
  	public void beforeDelete(map<Id, Contact> oldContMap){

  	}//end beforeDelete  

    public void beforeInsert(list<Contact> contList){ 
      	//cycle inbound Contact records once in order to initialize collections
      	Boolean addressChange = false;
      	for (Contact cont:contList){
        	//check for Mailing Address related data
        	if(cont.MailingStreet!=null|| cont.MailingCity!=null || cont.MailingState!=null || cont.MailingPostalCode!=null || cont.MailingCountry!=null){
        		//identify that an address change has occurred for related geo map loads
        		addressChange = true;
        	}        
      	}//end initial inbound Contact cycle
       		
   		//load geo (Country and State) maps if necessary
   		if(addressChange){
	    	CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
			CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
   		}    	      	    	
    
    	//cycle inbound Contacts a second time updating data
      	for (Contact cont:contList){
      		Boolean goodGeo = false;
      		if(!addressChange){goodGeo=true;}
      		else{
      			goodGeo = CommonMethods.geoFieldsValidation(0, cont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
      														statesMapByName, statesMapByAlt, countries2Check, false);
      		}
      		if(goodGeo){
	        	 
      		}
      	}//end of second inbound Contact cycle     	
      	
    }//end beforeInsert()   

    public void beforeUpdate(map<Id, Contact> newContMap, map<Id, Contact> oldContMap){
      	//cycle inbound Contact records once in order to initialize collections
      	Boolean addressChange = false;
      	map<Id, Contact> contactMap = new map<Id, Contact>();
      	for (Contact cont:newContMap.values()){
      		Contact oldCont = oldContMap.get(cont.Id);
        	//check for Mailing Address related changes
        	if(cont.MailingStreet!=oldCont.MailingStreet || cont.MailingCity!=oldCont.MailingCity || cont.MailingState!=oldCont.MailingState || 
        		cont.MailingPostalCode!=oldCont.MailingPostalCode || cont.MailingCountry!=oldCont.MailingCountry){
        		//identify that an address change has occurred for related geo map loads
        		addressChange = true;
        	} 
      	}//end of 1st inbound Contact cycle
      	
   		//load geo (Country and State) maps if necessary
   		if(addressChange){
	    	CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
			CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
   		}
   		
      	//cycle inbound Contacts for a 2nd time updating data and triggering actions   	
      	for (Contact cont:newContMap.values()){
        	Contact oldCont = oldContMap.get(cont.Id);
      		Boolean goodGeo = false;
      		if(!addressChange){goodGeo=true;}
      		else{
      			goodGeo = CommonMethods.geoFieldsValidation(0, cont, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
      														statesMapByName, statesMapByAlt, countries2Check, false);
      		}
      		if(goodGeo){
	        	 
      		}//end good geo logic
        	
  		}//end of 2nd inbound Contact cycle
  		
    }//end beforeUpdate()
    
}//end ContactTriggerHandlerClass()