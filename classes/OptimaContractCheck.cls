/*********************************************************************************************
 * Name:
 * Optima Contract Check Class
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This class is activated via an On-Click JavaScipt Custom Button located on the 
 * IMX Contract Object. It checks various rules on the contract and related objects, and 
 * populates the Rule Check object with any violations. Some of these rules look like they 
 * should be checked by validation rules, but they can't be used because the rules are not 
 * strictly enforceable i.e. it's a warning rather than an error
 * 
 * Some of these checks are on accounts rather than contracts, because it's easier to have 
 * them all in one place rather than creating a separate account checker
 * *******************************************************************************************/

global class OptimaContractCheck {

    @AuraEnabled 
    webservice static void checkContracts() {
    
        //Declare Variables
        List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        List<Rule_Check__c> rules = new List<Rule_Check__c>();
        List<Account> accounts = new List<Account>();
        List<AggregateResult> aggregates = new List<AggregateResult>();
    	List<Optima_Invoice__c> invoices = new List<Optima_Invoice__c>();       
        Set<Id> contractIds = new Set<Id>();
        Set<Id> missingContractIds = new Set<Id>();
        Map<Id,Decimal> invoiceTotals = new Map<Id,Decimal>();
        Set<String> customers = new Set<String>();
        String prevCustomer = null;
        Decimal prevTune = 999; //this has to be initialised to a value that would never actually be used for a retune
        Integer targetCount = 0;
        Date endDate = null;

        //Get the record type IDs we will be using        
        RecordType rtContract = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Delete all existing rule violations for this record type
        rules = [SELECT Id FROM Rule_Check__c WHERE RecordTypeId = :rtRule.Id];
        delete rules;
        rules.clear();
        
        //1. Query for missing contract start date
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c = 'Active' AND Contract_Start_Date__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing contract start date', rtRule.Id);
        contracts.clear();
        
        //2. Query for missing annual increase conditions
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Annual_Increase_Conditions__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing annual increase conditions', rtRule.Id);
        contracts.clear();
        
        //3. Query for missing hourly increase conditions
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Hourly_Increase_Conditions__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing hourly increase conditions', rtRule.Id);
        contracts.clear();
        
        //4. Query for missing annual fee history
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Latest_Annual_Fee_History_Amount__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing annual fee history', rtRule.Id);
        contracts.clear();
        
        //5. Query for missing hourly fee history
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Latest_Hourly_Fee_History_Amount__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing hourly fee history', rtRule.Id);
        contracts.clear();
        
        //6. Query for contract problems
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c, Contract_Problems__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Contract_Problems__c != null];
        
        //Create a Rule Check for each violation found. We can't use the standard code for this, because the 
        //messages are all different
        for(IMX_Contract__c con :contracts) {
 
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = 'Contract problems: ' + con.Contract_Problems__c;
            rc.RecordTypeId = rtRule.Id;
            
            rules.add(rc);   
        }
        contracts.clear();

        //7. Query for accounts with no contract
        accounts = [SELECT Optima_Customer_Code__c FROM Account WHERE Optima_Customer_Code__c != null
                    AND Id NOT IN (SELECT Account__c FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id)];
        
        //We can't use the standard function here, because we're querying accounts not contracts
        for(Account acc :accounts) {
 
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = acc.Optima_Customer_Code__c;
            rc.Message__c = 'Account with no contracts';
            rc.RecordTypeId = rtRule.Id;
            
            rules.add(rc);   
        }
        
        //8a. Query for contracts with no invoices
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Id NOT IN (
                     SELECT Master_Contract__c FROM Optima_Invoice__c)];

        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Contract with no invoices', rtRule.Id);
        contracts.clear();
        
        //8b. ...and cancelled contracts with unissued invoices
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c = 'Cancelled' AND Id IN (
                     SELECT Master_Contract__c FROM Optima_Invoice__c
                     WHERE Invoiced__c = FALSE)];

        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Cancelled contract with unissued invoices', rtRule.Id);
        contracts.clear();        
        
        //9. Query for contracts with missing predict contacts
        //This has to be done separately for predict and live, because SOQL doesn't let you match 
        //the contract product with the contact type. These queries will produce duplicate 
        //errors for customers who have multiple contracts for the same product, but I've decided that 
        //that's better than writing 10 times as much SOQL and code to achieve the same result

        //9a. Query for contracts with no contacts
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE Status__c != 'Cancelled' AND Product__c = 'Predict'
                     AND Account__c NOT IN (
                         SELECT AccountId FROM Contact WHERE Contact_Type__c includes ('Optima Predict Contact'))];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Contract with no contacts', rtRule.Id);
        
        //Also make a set of the contract IDs so we can exclude them from the remaining contact queries 
        //(there's no point in reporting on specific types of missing contact if there are no contacts 
        //for the contract at all)
        for(IMX_Contract__c con :contracts) {
        contractIds.add(con.Id);
        }                
        contracts.clear();
        
        //9b. Query for contracts with some contacts but no release contacts
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE Status__c != 'Cancelled' AND Product__c = 'Predict'
                     AND Id NOT IN :contractIds AND Account__c NOT IN (
                         SELECT AccountId FROM Contact WHERE Contact_Type__c includes 
                         ('Optima Predict Contact;Optima Release Contact'))];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing release contacts', rtRule.Id);
        contracts.clear();
        contractIds.clear();
               
        //10. Query for contracts with missing live contacts
        //Rule 10 is a duplicate of rule 9, but for live. See additional comments under rule 9
        
        //10a. Query for contracts with no contacts
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE Status__c != 'Cancelled' AND Product__c = 'Live'
                     AND Account__c NOT IN (
                         SELECT AccountId FROM Contact WHERE Contact_Type__c includes ('Optima Live Contact'))];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Contract with no contacts', rtRule.Id);
        
        //Also make a set of the contract IDs so we can exclude them from the remaining contact queries 
        for(IMX_Contract__c con :contracts) {
        contractIds.add(con.Id);
        }                
        contracts.clear();
        
        //10b. Query for contracts with some contacts but no release contacts
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE Status__c != 'Cancelled' AND Product__c = 'Live'
                     AND Id NOT IN :contractIds AND Account__c NOT IN (
                         SELECT AccountId FROM Contact WHERE Contact_Type__c includes 
                         ('Optima Live Contact;Optima Release Contact'))];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing release contacts', rtRule.Id);
        contracts.clear();
        contractIds.clear();

        //11. Query for missing inflation data
        //For every country that appears in the Inflation object, we expect to find a record 
        //for each year between 2009 and last year (inflation figures are only available for 
        //years that have been completed)
        targetCount = system.today().year() - 2009;
        aggregates = [SELECT Country__c FROM Inflation__c WHERE Year__c >= 2009
                     GROUP BY Country__c HAVING Count(Id) != :targetCount];
        
        //We can't use the standard function here, because we're querying "aggregate results" not contracts
        for(AggregateResult agg :aggregates) {
 
            Rule_Check__c rc = new Rule_Check__c();
            rc.Message__c = 'Missing inflation data for country ' + agg.get('Country__c') + 
                '. Expected ' + targetCount + ' values since 2009';
            rc.RecordTypeId = rtRule.Id;
            
            rules.add(rc);   
        }
        
        //12. Query for a mismatch between fee history and invoices planned for the next 12 months.
        //SOQL doesn't allow you to compare the invoice total with the expected amount in a having 
        //clause, so this is a lot more work than it should be!
        //...and it also doesn't let you extract the IDs from aggregate results, so I have to sum 
        //the invoices in my code as well
        endDate = system.today().addMonths(12);
        invoices = [SELECT Master_Contract__c, Amount__c FROM Optima_Invoice__c 
                    WHERE Master_Contract__r.Status__c != 'Cancelled' 
                    AND Invoice_Date__c > TODAY AND Invoice_Date__c < :endDate
                    ORDER BY Master_Contract__c ASC];
  
        //Make a set of the contract IDs for use in the next query, accumulate 
        //the total for each contract and store it in a map so we can find it later
        Id prevId = null;
        Decimal total = 0;
        for(Optima_Invoice__c inv :invoices) {
       		contractIds.add(inv.Master_Contract__c);
            
            if(inv.Master_Contract__c != prevId) {
                total = 0;
            }
            total += inv.Amount__c;
          	invoiceTotals.put(inv.Master_Contract__c,total);
            prevId = inv.Master_Contract__c;
        }
        
        //If a contract has no invoices within the next 12 months, it won't be picked up by the code above
        //If it has no invoices at all or no fee history it will be covered by a previous check
        //Add any missing contracts to the list and give them an invoice total of 0
        contracts = [SELECT Id FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Latest_Annual_Fee_History_Amount__c != null AND
                     Id IN (SELECT Master_Contract__c FROM Optima_Invoice__c)];
        
        for(IMX_Contract__c con :contracts) {
            if (!invoiceTotals.containsKey(con.Id)) {
                contractIds.add(con.Id);
                invoiceTotals.put(con.Id,0);
            }
        }

        //Get the contract details for each contract we are interested in
        contracts = [SELECT Id, Optima_Customer_Code__c, Product__c, Region__c, Status__c,
                     Latest_Annual_Fee_History_Amount__c,Invoices__c
                     FROM IMX_Contract__c WHERE Id IN :contractIds];
        
        //Now we have to go through the contracts and create a rule check if we find a mismatch.
        //Some contracts are invoiced monthly and rounded down to the nearest dollar, so a small amount 
        //of error in the customer's favour is fine (up to $1 or other currency unit per invoice)
        for(IMX_Contract__c con :contracts) {
            if(invoiceTotals.get(con.Id) < con.Latest_Annual_Fee_History_Amount__c - con.Invoices__c ||
              invoiceTotals.get(con.Id) > con.Latest_Annual_Fee_History_Amount__c) {
                
              Rule_Check__c rc = new Rule_Check__c();
              rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
              rc.Product__c = con.Product__c;
              rc.Region__c = con.Region__c;
              rc.Status__c = con.Status__c;
              rc.Message__c = 'Mismatch between fee history and invoices planned for next 12 months.' +
                  ' Expected ' + con.Latest_Annual_Fee_History_Amount__c + ' found ' + invoiceTotals.get(con.Id);
              rc.RecordTypeId = rtRule.Id;
              rules.add(rc);   
            }
        }
        contracts.clear();
        contractIds.clear();

        //13. Query for inconsistent road network tune data
        //Usually the road retune frequency would be the same all active contracts for a customer, 
        //so report if it isn't (unfortunately we can't use count_distinct because it ignores nulls).
        //For a completely unknown reason it's also not allowed to group on the customer code or 
        //retune frequency, which makes things much messier. 
        //Only Predict and Live contracts can have road tunes, so exclude other types (especially 
        //embedded resource) to avoid false errors
        contracts = [SELECT Optima_Customer_Code__c, Road_Tunes_months__c
                     FROM IMX_Contract__c 
                     WHERE RecordTypeId = :rtContract.Id AND Status__c != 'Cancelled'
                     AND Product__c IN ('Predict','Live')
                     ORDER BY Optima_Customer_Code__c, Road_Tunes_months__c];
        
        //Ugghhh - now I have to go through all the results and look for multiple different records 
        //for the same customer, which means their data is inconsistent
        for(IMX_Contract__c con :contracts) {
            if (con.Optima_Customer_Code__c == prevCustomer &&
                con.Road_Tunes_months__c != prevTune) {
                //The customer has inconsistent values
                if (!customers.contains(con.Optima_Customer_Code__c)) {
                    //We haven't already identified this customer as a problem
                    customers.add(con.Optima_Customer_Code__c);
                }
            }
            prevCustomer = con.Optima_Customer_Code__c;
            prevTune = con.Road_Tunes_months__c;
        }
 
        //Create a rule check for each identified customer
      	//We can't use the standard function here, because we only have a customer code
        for (String c :customers) {
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = c;
            rc.Message__c = 'Inconsistent road retune frequency across active contracts';
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        customers.clear();
        contracts.clear();
        
        //14. Query for inconsistent sim tune data
        prevCustomer = null;
        prevTune = 999;
        //This code is almost identical to the previous rule - see comments above
        //Apart from referring to a different field, the only difference is that sim tunes only apply for predict
        contracts = [SELECT Optima_Customer_Code__c, Sim_Tunes_months__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Product__c = 'Predict'
                     ORDER BY Optima_Customer_Code__c, Sim_Tunes_months__c];
        
        for(IMX_Contract__c con :contracts) {
            if (con.Optima_Customer_Code__c == prevCustomer &&
                con.Sim_Tunes_months__c != prevTune) {
                if (!customers.contains(con.Optima_Customer_Code__c)) {
                    customers.add(con.Optima_Customer_Code__c);
                }
            }
            prevCustomer = con.Optima_Customer_Code__c;
            prevTune = con.Sim_Tunes_months__c;
        }
 
        for (String c :customers) {
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = c;
            rc.Message__c = 'Inconsistent sim retune frequency across active predict contracts';
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        customers.clear();
        contracts.clear();
            
        //15. Query for "To be confirmed" or missing purchase order status
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND (PO_Status__c = null OR PO_Status__c = 'To be confirmed')];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Unconfirmed purchase order status', rtRule.Id);
        contracts.clear();
            
        //16. Query for upcoming purchase order expiry
        Date dtPO = system.today().addMonths(3);
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c, PO_Expiry__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND PO_Expiry__c != null AND
                     PO_Expiry__c <= :dtPO];
        
        //Create a Rule Check for each violation found
      	//Don't use the standard function here, because we want to add the expiry date to the message
        for (IMX_Contract__c con :contracts) {
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = 'Purchase order expiry date within three months: ' + con.PO_Expiry__c.format();
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        contracts.clear();

        //17. Query for expired contracts (including renewal)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c, Renewal_Date__c, Expiry_Date__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND 
                     ((Renewal_Date__c != null AND Renewal_Date__c <= TODAY) OR
                     (Expiry_Date__c != null AND Expiry_Date__c <= TODAY))];
        
        //Create a Rule Check for each violation found
      	//Don't use the standard function here, because we want to add the expiry date to the message
        for (IMX_Contract__c con :contracts) {
            Date dtMin = date.parse('01/01/2200');
            if (con.Renewal_Date__c != NULL && con.Renewal_Date__c < dtMin) {
            	dtMin = con.Renewal_Date__c;
            }
            if (con.Expiry_Date__c != NULL && con.Expiry_Date__c < dtMin) {
            	dtMin = con.Expiry_Date__c;
            }
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = 'No contract in place since ' + dtMin.format() + '. Renewal or new agreement required';
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        contracts.clear();

        //18. Query for upcoming contract renewal. Occasionally agreements have to be renewed 3 months prior,
        //so start reporting this 6 months out
        Date dtRenew = system.today().addMonths(6);
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c, Renewal_Date__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Renewal_Date__c != null AND
                     Renewal_Date__c <= :dtRenew AND Renewal_Date__c > TODAY];
        
        //Create a Rule Check for each violation found
      	//Don't use the standard function here, because we want to add the renewal date to the message
        for (IMX_Contract__c con :contracts) {
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = 'Physical contract renewal required within six months: ' + con.Renewal_Date__c.format();
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        contracts.clear();

        //19. Query for upcoming contract expiry. A whole new agreement is required, so start reporting this 6 months out
        Date dtExpiry = system.today().addMonths(6);
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c, Expiry_Date__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Expiry_Date__c != null AND
                     Expiry_Date__c <= :dtExpiry AND Expiry_Date__c > TODAY];
        
        //Create a Rule Check for each violation found
      	//Don't use the standard function here, because we want to add the expiry date to the message
        for (IMX_Contract__c con :contracts) {
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = 'New contract required within six months: ' + con.Expiry_Date__c.format();
            rc.RecordTypeId = rtRule.Id;
            rules.add(rc);   
        }
        contracts.clear();

        //20. Query for support meetings that haven't been organised yet (this is stored on the account)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c = 'Active' AND (Account__r.Optima_Support_Meeting__c = null  
                     OR Account__r.Optima_Support_Meeting__c = 'To be organised')];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Support meeting not organised', rtRule.Id);
        contracts.clear();
        
        //21. Query for missing timezones (this is stored on the account)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Account__r.Timezone__c = null];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'No timezone information', rtRule.Id);
        contracts.clear();

        //22. Query for missing processes document details (this is stored on the account)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Product__c != 'Theatre' AND
                     (Account__r.Optima_Mtc_Processes_Version__c = null  
                     OR Account__r.Optima_Mtc_Processes_Date__c = null)];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing maintenance processes document details', rtRule.Id);
        contracts.clear();

        //23. Query for missing predict technical requirements document details (this is stored on the account)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Product__c = 'Predict' AND
                     (Account__r.Optima_Predict_Tech_Version__c = null  
                     OR Account__r.Optima_Predict_Tech_Date__c = null)];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing predict technical requirements document details', rtRule.Id);
        contracts.clear();
        
        //24. Query for missing live technical requirements document details (this is stored on the account)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Region__c, Status__c
                     FROM IMX_Contract__c WHERE RecordTypeId = :rtContract.Id 
                     AND Status__c != 'Cancelled' AND Product__c = 'Live' AND
                     (Account__r.Optima_Live_Tech_Version__c = null  
                     OR Account__r.Optima_Live_Tech_Date__c = null)];
        
        //Create a Rule Check for each violation found
        createRuleChecks(contracts, rules, 'Missing live technical requirements document details', rtRule.Id);
        contracts.clear();

        
        //Commit the new rules to the database
        if(rules.size() > 0) {
            insert rules;
        }    
    }
    
    private static void createRuleChecks(List<IMX_Contract__c> contracts, List<Rule_Check__c> rules, 
                                                 String message, String recordTypeId) {
        //Create a Rule Check for each IMX Contract
        for(IMX_Contract__c con :contracts) {
 
            Rule_Check__c rc = new Rule_Check__c();
            rc.Optima_Customer_Code__c = con.Optima_Customer_Code__c;
            rc.Product__c = con.Product__c;
            rc.Region__c = con.Region__c;
            rc.Status__c = con.Status__c;
            rc.Message__c = message;
            rc.RecordTypeId = recordTypeId;
            
            rules.add(rc);   
        }

    }
}