/*	LeadTriggerHandlerClass
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
	
public class LeadTriggerHandlerClass {
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
       
    public LeadTriggerHandlerClass(){
		      	
    }//end LeadTriggerHandlerClass()

    public void afterInsert(list<Lead> leadList){      	 
	
    }//end afterInsert()
    
    public void afterUpdate(list<Lead> leadList, map<Id, Lead> oldLeadMap){

  	}//end afterUpdate()
  	
  	public void beforeDelete(map<Id, Lead> oldLeadMap){

  	}//end beforeDelete  

    public void beforeInsert(list<Lead> leadList){ 
      	//cycle inbound Lead records once in order to initialize collections
      	Boolean addressChange = false;
      	for (Lead thisLead:leadList){
        	//check for Address related data
        	if(thisLead.Street!=null|| thisLead.City!=null || thisLead.State!=null || thisLead.PostalCode!=null || thisLead.Country!=null){
        		//identify that an address change has occurred for related geo map loads
        		addressChange = true;
        	}        
      	}//end initial inbound Lead cycle
       		
   		//load geo (Country and State) if necessary
   		if(addressChange){
	    	CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
			CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
   		}    	      	    	
    
    	//cycle inbound Leads a second time updating data
      	for (Lead thisLead:leadList){
      		Boolean goodGeo = false;
      		if(!addressChange){goodGeo=true;}
      		else{
      			goodGeo = CommonMethods.geoFieldsValidation(0, thisLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
      														statesMapByName, statesMapByAlt, countries2Check, false);
      		}
      		if(goodGeo){
	        	 
      		}
      	}//end of second inbound Lead cycle
      	
      	copyProductOfInterestToTextField(leadList);   	
      	
    }//end beforeInsert()   

    public void beforeUpdate(map<Id, Lead> newContMap, map<Id, Lead> oldLeadMap){
      	//cycle inbound Lead records once in order to initialize collections
      	Boolean addressChange = false;
      	map<Id, Lead> contactMap = new map<Id, Lead>();
      	for (Lead thisLead:newContMap.values()){
      		Lead oldLead = oldLeadMap.get(thisLead.Id);
        	//check for Address related changes
        	if(thisLead.Street!=oldLead.Street || thisLead.City!=oldLead.City || thisLead.State!=oldLead.State || 
        		thisLead.PostalCode!=oldLead.PostalCode || thisLead.Country!=oldLead.Country){
        		//identify that an address change has occurred for related geo map loads
        		addressChange = true;
        	} 
      	}//end of 1st inbound Lead cycle
      	
   		//load geo (Country and State) maps if necessary
   		if(addressChange){
	    	CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
			CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
   		}
   		
      	//cycle inbound Leads for a 2nd time updating data and triggering actions   	
      	for (Lead thisLead:newContMap.values()){
        	Lead oldLead = oldLeadMap.get(thisLead.Id);
      		Boolean goodGeo = false;
      		if(!addressChange){goodGeo=true;}
      		else{
      			goodGeo = CommonMethods.geoFieldsValidation(0, thisLead, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
      														statesMapByName, statesMapByAlt, countries2Check, false);
      		}
      		if(goodGeo){
	        	 
      		}//end good geo logic
        	
  		}//end of 2nd inbound Lead cycle

  		copyProductOfInterestToTextField(newContMap.values());
  		
    }//end beforeUpdate()
    
    private void copyProductOfInterestToTextField(List<Lead> leads) {
        for (Lead l : leads) {
            l.POI_for_Opp_Conversion__c = l.Product_of_Interest_POI__c;
        }
    }
    
}//end LeadTriggerHandlerClass()