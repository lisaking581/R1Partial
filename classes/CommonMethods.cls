public class CommonMethods {
    
	//Address checking - Account, Contact, Lead
   	// 'callerType':	 0 = Method called by a trigger - exception will cause an 'addError'
   	//				 	 1 = Method called by UI based Apex - exception will cause an 'addMessage' 
   	//					-1 = Exception will trigger offending field to be nulled/cleared
   	//					any other valid integer = Exception will not trigger any action - i.e. it will be quiet (nothing will be changed)
    public static Boolean geoFieldsValidation(Integer callerType, SObject obj, map<String, Country__c> countriesMapByName, 
    											map<String, Country__c> countriesMapByISO2, map<String, Country__c> countriesMapByISO3,
    											map<String, StateProvince__c> statesMapByCode, map<String, StateProvince__c> statesMapByName, 
    											map<String, StateProvince__c> statesMapByAlt, set<String> countries2Check, Boolean checkPostal){
		//determine SObject passed and initialize local variables
		Account acctRec = new Account();
		Contact contRec = null;
		Lead leadRec = null;
		if(obj.getsObjectType() == Account.sObjectType){ 
			acctRec = (Account) obj;
			//if Billing Country is null - clear related fields and return
	        if(acctRec.BillingCountry==null){
		    	acctRec.Super_Region__c = null;
		    	acctRec.ISO_3166_Country__c = null;
		    	return true;
	      	}
		}       
        else if(obj.getsObjectType() == Contact.sObjectType){
        	contRec = (Contact) obj;
			//if Mailing Country is null - clear related fields and return
	        if(contRec.MailingCountry==null){
		    	contRec.Super_Region__c = null;
		    	return true;
	      	}
        	acctRec.BillingState = contRec.MailingState;
        	acctRec.BillingPostalCode = contRec.MailingPostalCode;
        	acctRec.BillingCountry = contRec.MailingCountry;
        }       
        else if(obj.getsObjectType() == Lead.sObjectType){
        	leadRec = (Lead) obj;
			//if Country is null - clear related fields and return
	        if(leadRec.Country==null){
		    	leadRec.Super_Region__c = null;
		    	return true;
	      	}
        	acctRec.BillingState = leadRec.State;
        	acctRec.BillingPostalCode = leadRec.PostalCode;
        	acctRec.BillingCountry = leadRec.Country;
        }
        //validate Country
        Country__c thisCountry = null;
        thisCountry = CommonMethods.getCountry(acctRec, countriesMapByName, countriesMapByISO2, countriesMapByISO3);
        if(thisCountry!=null){
        	acctRec.Super_Region__c = thisCountry.Super_Region__c;
        	acctRec.ISO_3166_Country__c = thisCountry.Id;
        }
        else{
        	//trigger based caller
        	if(callerType==0){
				if(obj.getsObjectType() == Account.sObjectType){
        			acctRec.BillingCountry.addError('Invalid Country value [' + acctRec.BillingCountry + ']');
				}       
		        else if(obj.getsObjectType() == Contact.sObjectType){
        			contRec.MailingCountry.addError('Invalid Country value [' + acctRec.BillingCountry + ']');
		        }       
		        else if(obj.getsObjectType() == Lead.sObjectType){
        			leadRec.Country.addError('Invalid Country value [' + acctRec.BillingCountry + ']');
		        }
        	}
        	//UI based caller
        	else if(callerType==1){
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Country value [' + acctRec.BillingCountry + ']'));
        	}
        	//unknown caller - clear offending field
        	else if(callerType==-1){
				acctRec.BillingCountry = null;
        	}
        	return false;
        }                            
        //validate State
        if(acctRec.BillingState==null){acctRec.State_Province__c = null;}             
        else if(acctRec.BillingCountry!=null && countries2Check.contains(acctRec.BillingCountry.toUpperCase())){       	
        	//validate State value
            StateProvince__c sp = CommonMethods.getState(acctRec, statesMapByName, statesMapByAlt, statesMapByCode);
            //invalid State/Province/County error           
            if(sp==null){
	        	//trigger based caller
	        	if(callerType==0){
					if(obj.getsObjectType() == Account.sObjectType){
	        			acctRec.BillingState.addError('Invalid State/Province value [' + acctRec.BillingState + '] for this Country [' + acctRec.BillingCountry +']');
					}       
			        else if(obj.getsObjectType() == Contact.sObjectType){
	        			contRec.MailingState.addError('Invalid State/Province value [' + acctRec.BillingState + '] for this Country [' + acctRec.BillingCountry +']');
			        }       
			        else if(obj.getsObjectType() == Lead.sObjectType){
	        			leadRec.State.addError('Invalid State/Province value [' + acctRec.BillingState + '] for this Country [' + acctRec.BillingCountry +']');
			        }
	        	}
	        	//UI based caller
	        	else if(callerType==1){
	        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid State/Province value [' + acctRec.BillingState + 
	        														'] for this Country [' + acctRec.BillingCountry +']'));
	        	}
	        	//unknown caller - clear offending field
	        	else if(callerType==-1){
	        		acctRec.BillingState=null;
	        	}													
				return false;                	
          	}
          	//valid State/Province/County assignment
			acctRec.State_Province__c = sp.Id;          	              
        }
        //validate Postal Code (minimum length check only)
        if(checkPostal && thisCountry!=null && thisCountry.Minimum_Postal_Code__c!=null && thisCountry.Minimum_Postal_Code__c!=0 && 
        	(acctRec.BillingPostalCode==null || acctRec.BillingPostalCode.length()<thisCountry.Minimum_Postal_Code__c)){
        	//trigger based caller
        	if(callerType==0){
				if(obj.getsObjectType() == Account.sObjectType){
	    			acctRec.BillingPostalCode.addError('Postal Code is required and must contain a minimum of ' + thisCountry.Minimum_Postal_Code__c + ' characters');
				}       
		        else if(obj.getsObjectType() == Contact.sObjectType){
	    			contRec.MailingPostalCode.addError('Postal Code is required and must contain a minimum of ' + thisCountry.Minimum_Postal_Code__c + ' characters');
		        }       
		        else if(obj.getsObjectType() == Lead.sObjectType){
	    			leadRec.PostalCode.addError('Postal Code is required and must contain a minimum of ' + thisCountry.Minimum_Postal_Code__c + ' characters');
		        }
        	}
        	//UI based caller
        	else if(callerType==1){
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Postal Code is required and must contain a minimum of ' + thisCountry.Minimum_Postal_Code__c + 
    																					' characters'));
        	}
        	//unknown caller - clear offending field
        	else if(callerType==-1){
        		acctRec.BillingPostalCode=null;
        	}
	     	return false;
        }
        //if necessary save updated field data back into calling object
		if(obj.getsObjectType() == Contact.sObjectType){
        	contRec.MailingState = acctRec.BillingState;
        	contRec.MailingPostalCode = acctRec.BillingPostalCode;
        	contRec.MailingCountry = acctRec.BillingCountry;
        	contRec.Super_Region__c = acctRec.Super_Region__c;
        	contRec.ISO_3166_Country__c = acctRec.ISO_3166_Country__c; 
        	contRec.State_Province__c = acctRec.State_Province__c; 	
        }       
        else if(obj.getsObjectType() == Lead.sObjectType){
        	leadRec.State = acctRec.BillingState;
        	leadRec.PostalCode = acctRec.BillingPostalCode;
        	leadRec.Country = acctRec.BillingCountry;
        	leadRec.Super_Region__c = acctRec.Super_Region__c;
        	leadRec.ISO_3166_Country__c = acctRec.ISO_3166_Country__c; 
        	leadRec.State_Province__c = acctRec.State_Province__c;
        }
    	return true;
    }//end geoFieldsValidation()    
    
    public static Country__c getCountry(Account acctRec, map<String, Country__c> countriesMapByName, 
    												map<String, Country__c> countriesMapByISO2, map<String, Country__c> countriesMapByISO3){
    	//attempt to retreive ISO 3166 record by Name
    	Country__c iso3166 = countriesMapByName.get(acctRec.BillingCountry.toUpperCase());
    	//if not found - try by ISO-2 Code
    	if(iso3166==null){
    		iso3166 = countriesMapByISO2.get(acctRec.BillingCountry.toUpperCase());
	    	//if found - update Billing Country to full name
	    	if(iso3166!=null){acctRec.BillingCountry=iso3166.Name;}
	    	//if not found - try by ISO-3 Code
	    	else{
	    		iso3166 = countriesMapByISO3.get(acctRec.BillingCountry.toUpperCase());
		    	//if found - update Billing Country to full name
		    	if(iso3166!=null){acctRec.BillingCountry=iso3166.Name;}
	    	}
    	}    	
    	return iso3166;    	
    }//end getCountry()   
    
    public static StateProvince__c getState(Account acct, map<String, StateProvince__c> statesMapByName, map<String, StateProvince__c> statesMapByAlt, 
    										map<String, StateProvince__c> statesMapByCode){     	
    	String key = acct.BillingCountry.toUpperCase() + ':' + acct.BillingState.toUpperCase();
    	//attempt to validate State value by Code
    	StateProvince__c sp = statesMapByCode.get(key);
    	//if not found - try by Name
    	if(sp==null){sp=statesMapByName.get(key);}
	    //if not found - try by Name_Alt
	    if(sp==null){sp=statesMapByAlt.get(key);}
    	//if found - update Billing State to specified Value to Validate
    	if(sp!=null){acct.BillingState=sp.Value_to_Validate__c;}    	    	    	
    	return sp;    	
    }//end getState()
    
    public static void loadCountryMaps(map<String, Country__c> countriesMapByName, map<String, Country__c> countriesMapByISO2, 
    										map<String, Country__c> countriesMapByISO3){
	    //create map for Billing Country related actions
	    list<Country__c> countries = [Select Id, ISO_Code__c, ISO3_Code__c, Minimum_Postal_Code__c, Name, Super_Region__c from Country__c];
	    for(Country__c c:countries){
	        if(!countriesMapByName.containsKey(c.Name)){countriesMapByName.put(c.Name.toUpperCase(), c);}
	        if(c.ISO_Code__c!=null && !countriesMapByISO2.containsKey(c.ISO_Code__c)){countriesMapByISO2.put(c.ISO_Code__c.toUpperCase(), c);}
	        if(c.ISO3_Code__c!=null && !countriesMapByISO3.containsKey(c.ISO3_Code__c)){countriesMapByISO3.put(c.ISO3_Code__c.toUpperCase(), c);}
	    }
	    return;
    }//end loadCountriesMaps()        
    
    public static void loadStatesMaps(map<String, StateProvince__c> statesMapByCode, map<String, StateProvince__c> statesMapByName,
    									map<String, StateProvince__c> statesMapByAlt, set<String> countries2Check){
	    //create maps for State Province related validations
	    list<StateProvince__c> stateProvs = [Select Id, Code__c, Country_Name__c, Name, Name_Alt__c, Value_to_Validate__c from StateProvince__c];
	    for(StateProvince__c sp:stateProvs){
	        if(sp.Country_Name__c!=null){
	        	//load list of Countries to validate State against
	        	if(!countries2Check.contains(sp.Country_Name__c)){countries2Check.add(sp.Country_Name__c.toUpperCase());}	        	
	        	//load States by Code
	        	if(sp.Code__c!=null){
		            String key = sp.Country_Name__c.toUpperCase() + ':' + sp.Code__c.toUpperCase();
		            if(!statesMapByCode.containsKey(key)){statesMapByCode.put(key, sp);}
	        	}
	        	//load States by Name field
	        	if(sp.Name!=null){
		            String key = sp.Country_Name__c.toUpperCase() + ':' + sp.Name.toUpperCase();
		            if(!statesMapByName.containsKey(key)){statesMapByName.put(key, sp);}
	        	}
	        	//load States by Alternate Name field
	        	if(sp.Name_Alt__c!=null){
		            String key = sp.Country_Name__c.toUpperCase() + ':' + sp.Name_Alt__c.toUpperCase();
		            if(!statesMapByAlt.containsKey(key)){statesMapByAlt.put(key, sp);}
	        	}	        	
	        } 	        
	    }
	    return;
    }//end loadStatesMaps()
    
}//end CommonMethods