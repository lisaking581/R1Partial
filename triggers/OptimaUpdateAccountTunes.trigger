/*********************************************************************************************
 * Name:
 * Optima Update Account Tunes Trigger
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This trigger is activated by changes to the IMX contract. If the road or sim tunes field on the 
 * contract has changed, it finds the smallest non-zero road or sim tunes field across all current
 * contracts for the customer, and sets that number to be the account tune frequency. This is required 
 * for release reporting. Since the calculation isn't product- or contract-specific, the account field 
 * is a simplification of the contract data and shouldn't be used for any other purposes
 * *******************************************************************************************/

trigger OptimaUpdateAccountTunes on IMX_Contract__c (after insert,after update,after delete) {
    
    //1. Make a set of the account IDs which need to be recalculated
    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert) {
    	for(IMX_Contract__c con : Trigger.new) {    		
    		//We are not interested in insertion of zero values
            if(con.Road_Tunes_months__c > 0 || con.Sim_Tunes_months__c > 0) {
                //We need to recalculate the value for this customer
                accountIds.add(con.Account__c);
            }
        }      
    }
    
    if (Trigger.isUpdate) {
		//Map the contract IDs to the original retune value
		Map<Id,Decimal> oldRoadValue = new Map<Id,Decimal>();
		Map<Id,Decimal> oldSimValue = new Map<Id,Decimal>();
    	for(IMX_Contract__c con : Trigger.old) {    		
        	oldRoadValue.put(con.Id,con.Road_Tunes_months__c);
        	oldSimValue.put(con.Id,con.Sim_Tunes_months__c);
        }
        
        //Now check whether the new values are different
        //Any difference (including to or from zero) needs to be processed
    	for(IMX_Contract__c con : Trigger.new) {    		
            if(con.Road_Tunes_months__c <> oldRoadValue.get(con.Id) ||
              con.Sim_Tunes_months__c <> oldSimValue.get(con.Id)) {
                accountIds.add(con.Account__c);
            }
        }
    }

    if (Trigger.isDelete) {
    	for(IMX_Contract__c con : Trigger.old) {    		
    		//We are not interested in deletion of zero values
            if(con.Road_Tunes_months__c > 0 || con.Sim_Tunes_months__c > 0) {
                //We need to recalculate the value for this customer
                accountIds.add(con.Account__c);
            }
        }      
    }

    //2. Recalculate the values for the selected accounts
    List<AggregateResult> aggregates = new List<AggregateResult>();
	Map<Id,Decimal> newRoadValue = new Map<Id,Decimal>();
	Map<Id,Decimal> newSimValue = new Map<Id,Decimal>();
    
    //First road tunes
    {
    	aggregates = [SELECT Account__c, MIN(Road_Tunes_months__c) road
        	          FROM IMX_Contract__c WHERE Road_Tunes_months__c > 0
            	      AND Account__c IN :accountIds
                      AND Status__c IN ('Implementing','Active')
                	  GROUP BY Account__c];
        
        for(AggregateResult agg :aggregates) {
        	newRoadValue.put((Id)agg.get('Account__c'),(Decimal)agg.get('road'));
        }
    }

    //Now repeat for sim tunes
    {
    	aggregates = [SELECT Account__c, MIN(Sim_Tunes_months__c) sim
        	          FROM IMX_Contract__c WHERE Sim_Tunes_months__c > 0
            	      AND Account__c IN :accountIds
                      AND Status__c IN ('Implementing','Active')
                	  GROUP BY Account__c];
        
        for(AggregateResult agg :aggregates) {
        	newSimValue.put((Id)agg.get('Account__c'),(Decimal)agg.get('sim'));
        }
    }

    //3. Update the accounts with the new values
    //If we didn't find any positive records on the contracts, set the account value to 0
    List<Account> accounts = new List<Account>();
    accounts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
        	    FROM Account WHERE Id IN :accountIds];
    
    for(Account acc: accounts) {
        if(newRoadValue.containsKey(acc.Id)) {
        	acc.Road_Tunes_months__c = newRoadValue.get(acc.Id);
        }
        else {
            acc.Road_Tunes_months__c = NULL;
        }
        if(newSimValue.containsKey(acc.Id)) {
        	acc.Sim_Tunes_months__c = newSimValue.get(acc.Id);
        }
        else {
            acc.Sim_Tunes_months__c = NULL;
        }
    }

    //Commit the changes to the database
    update accounts;
}