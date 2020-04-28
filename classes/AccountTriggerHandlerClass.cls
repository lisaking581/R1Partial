/*  AccountTriggerHandlerClass
    2018-11-06 revisions: Gary Triassi (gtriassi@trigon-group.com)
    
    Called By:  AccountTriggerHandler.trigger
    
    Purpose:
    -   before delete:
        o    
    -   before insert:
        o   Geographic field (Country, State, Super Region) validation and attribution
    -   before update:
        o   Geographic field (Country, State, Super Region) validation and attribution
    -   after insert:
        o   
    -   after update:
        o   
*/
    
public class AccountTriggerHandlerClass {
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
       
    public AccountTriggerHandlerClass(){
                
    }//end AccountTriggerHandlerClass()

    public void afterInsert(list<Account> acctsIn){
            
    }//end afterInsert()
    
    public void afterUpdate(list<Account> acctList, map<Id, Account> oldMap){

    }//end afterUpdate()
    
    public void beforeDelete(map<Id, Account> oldAcctMap){

    }//end beforeDelete  

    public void beforeInsert(list<Account> acc){ 
        //cycle inbound Account records once in order to initialize collections
        Boolean addressChange = false;
        for (Account ac:acc){
            //check for Billing Address related data
            if(ac.BillingStreet!=null|| ac.BillingCity!=null || ac.BillingState!=null || ac.BillingPostalCode!=null || ac.BillingCountry!=null){
                //identify that an address change has occurred for related geo map loads
                addressChange = true;
            }
            else if(ac.ShippingStreet!=null|| ac.ShippingCity!=null || ac.ShippingState!=null || ac.ShippingPostalCode!=null || ac.ShippingCountry!=null){
                //identify that an address change has occurred for related geo map loads
                addressChange = true;
            }        
        }//end initial inbound Account cycle
            
        //load geo (Country and State) maps if necessary
        if(addressChange){
            CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
            CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
        }                       
    
        //cycle inbound Accounts a second time updating data
        for (Account ac:acc){
            Boolean goodGeo = false;
            if(!addressChange){goodGeo=true;}
            else{
                goodGeo = CommonMethods.geoFieldsValidation(0, ac, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
                                                            statesMapByName, statesMapByAlt, countries2Check, false);
            }
            if(goodGeo){
                //copy the Billing Address into the Shipping Address
                copyBill2Ship(ac);
            }//end good geo logic
        }//end of second inbound Account cycle      
        
    }//end beforeInsert()   

    public void beforeUpdate(map<Id, Account> newAcctMap, map<Id, Account> oldAcctMap){
        //cycle inbound Account records once in order to initialize collections
        Boolean addressChange = false;
        for (Account ac:newAcctMap.values()){
            Account oldAcc = oldAcctMap.get(ac.Id);
            //check for Billing Address related changes
            if(ac.BillingStreet!=oldAcc.BillingStreet || ac.BillingCity!=oldAcc.BillingCity || ac.BillingState!=oldAcc.BillingState || 
                ac.BillingPostalCode!=oldAcc.BillingPostalCode || ac.BillingCountry!=oldAcc.BillingCountry){
                //identify that an address change has occurred for related geo map loads
                addressChange = true;
            }
        }//end of 1st inbound Account cycle
        
        //load geo (Country and State) maps if necessary
        if(addressChange){
            CommonMethods.loadCountryMaps(countriesMapByName, countriesMapByISO2, countriesMapByISO3);
            CommonMethods.loadStatesMaps(statesMapByCode, statesMapByName, statesMapByAlt, countries2Check);
        }
        
        //cycle inbound Accounts for a 2nd time updating data and triggering actions    
        for (Account ac:newAcctMap.values()){
            Account oldAcct = oldAcctMap.get(ac.Id);
            Boolean goodGeo = false;
            if(!addressChange){goodGeo=true;}
            else{
                goodGeo = CommonMethods.geoFieldsValidation(0, ac, countriesMapByName, countriesMapByISO2, countriesMapByISO3, statesMapByCode, 
                                                            statesMapByName, statesMapByAlt, countries2Check, false);
            }
            if(goodGeo){
                //copy the Billing Address into the Shipping Address for Data.com purposes
                copyBill2Ship(ac);
            }//end good geo logic
            
        }//end of 2nd inbound Account cycle
        
    }//end beforeUpdate()

    private Account copyBill2Ship(Account acct){
        acct.ShippingStreet = acct.BillingStreet;
        acct.ShippingCity = acct.BillingCity;
        acct.ShippingState = acct.BillingState;
        acct.ShippingPostalCode = acct.BillingPostalCode;
        acct.ShippingCountry = acct.BillingCountry;
        return acct;
    }//end copyBill2Ship 
    
}//end AccountTriggerHandlerClass()