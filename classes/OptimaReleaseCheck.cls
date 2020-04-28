/*********************************************************************************************
 * Name:
 * Optima Release Check Class
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This class is activated via an On-Click JavaScipt Custom Button located on the 
 * Release Object. It checks various rules on the release and related objects, and 
 * populates the Rule Check object with any violations. These rules are too complex to
 * be checked by validation rules
 * *******************************************************************************************/

global class OptimaReleaseCheck {

    @AuraEnabled
    webservice static void checkReleases() {
    
        //Declare Variables
        List<Release__c> releases = new List<Release__c>();
        List<Rule_Check__c> rules = new List<Rule_Check__c>();
        List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        List<Internal_Release__c> internals = new List<Internal_Release__c>();
        Set<String> activePredictCustomers = new Set<String>();
        Set<String> activeLiveCustomers = new Set<String>();
        Set<String> implPredictCustomers = new Set<String>();
        Set<String> implLiveCustomers = new Set<String>();
        Map<String,Internal_Release__c> predictInternals = new Map<String,Internal_Release__c>();
        Map<String,Internal_Release__c> liveInternals = new Map<String,Internal_Release__c>();

        //Get the record type IDs we will be using        
        RecordType rtContract = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Delete all existing rule violations for this record type
        rules = [SELECT Id FROM Rule_Check__c WHERE RecordTypeId = :rtRule.Id];
        delete rules;
        rules.clear();
        
        //=======================================================================================
        //Extract data
        //=======================================================================================
        //Get recent release data for all Active contracts for the two products we are interested 
        //in checking, Predict and Live. Since SOQL doesn't allow you to join tables that don't 
        //have a hierarchical relationship, we have to find a way around joining release and 
        //contract. 
        
        //Get all of the releases for predict and live in the last two years. If the customer 
        //has regular retunes in their agreement then we need to extract more data to make sure 
        //we are complying with the agreement requirements.
        //Note that retune requirements are attached to a contract, but releases are attached 
        //to an account. Usually they are pretty much the same thing, but in some cases 
        //there are multiple contracts and only one includes retunes. For the purposes of these 
        //rulechecks we have to assume that all contracts require the same retunes
        Date dtStart = system.today().addYears(-2);
        Date dtStartTune = system.today().addYears(-4);
        releases = [SELECT Optima_Customer_Code__c, Product__c, Version__c, Status__c, 
                    Release_Date__c, Patch__c, Road_Tune__c, Sim_Tune__c, 
                    Cust_Road_Tune_Freq__c, Cust_Sim_Tune_Freq__c
                    FROM Release__c 
                    WHERE Product__c IN ('Predict','Live') AND
                    (Release_Date__c >= :dtStart OR 
                        (Release_Date__c >= :dtStartTune AND 
                            (Cust_Road_Tune_Freq__c > 0 OR Cust_Sim_Tune_Freq__c > 0)))
                    ORDER BY Optima_Customer_Code__c ASC, Product__c ASC, Release_Date__c DESC];
        
        //Get all of the active and implementing predict and live customers 
        //(most, but not all, rules are checked for customers who are still implementing)
        contracts = [SELECT Optima_Customer_Code__c, Product__c, Status__c FROM IMX_Contract__c 
                     WHERE RecordTypeId = :rtContract.Id 
                     AND (Status__c = 'Active' OR Status__c = 'Implementing')
                     AND Product__c IN ('Predict','Live')];
        
        //Make sets of active/implementing predict and live customers 
        //(you can't do select distinct in SOQL, so the set of contracts could contain duplicates)
        for(IMX_Contract__c con :contracts) {
            if(con.Product__c == 'Predict' && con.Status__c == 'Active' &&
               !activePredictCustomers.contains(con.Optima_Customer_Code__c)) {
                activePredictCustomers.add(con.Optima_Customer_Code__c);
            }
            if(con.Product__c == 'Live' && con.Status__c == 'Active' && 
               !activeLiveCustomers.contains(con.Optima_Customer_Code__c)) {
                activeLiveCustomers.add(con.Optima_Customer_Code__c);
            }
            if(con.Product__c == 'Predict' && con.Status__c == 'Implementing' &&
               !implPredictCustomers.contains(con.Optima_Customer_Code__c)) {
                implPredictCustomers.add(con.Optima_Customer_Code__c);
            }
            if(con.Product__c == 'Live' && con.Status__c == 'Implementing' && 
               !implLiveCustomers.contains(con.Optima_Customer_Code__c)) {
                implLiveCustomers.add(con.Optima_Customer_Code__c);
            }
        }
        
        //Get all of the predict and live internal releases
        internals = [SELECT Name, Product__c, First_Release_Date__c, Last_Release_Date__c 
                     FROM Internal_Release__c WHERE Product__c IN ('Predict','Live')];
        
        //Make a map of predict internal releases and another one of live internal releases, 
        //indexed by version number	(= Name)
        for(Internal_Release__c intl :internals) {
            //Check that the release is the correct length
	        Integer days = intl.First_Release_Date__c.daysBetween(intl.Last_Release_Date__c);
            if(days < 88 || days > 93) {
                //There are a few hard-coded exceptions to this rule
                if((intl.Product__c == 'Predict' && (intl.Name == '3.20' || intl.Name == '3.21' ||
                    intl.Name == '3.35')) ||
                   (intl.Product__c == 'Live' && (intl.Name == '2.12' || intl.Name == '2.13' ||
                    intl.Name == '2.20' || intl.Name == '2.21' || intl.Name == '2.35'))) {
                }
                else {   
            		createRuleCheck(null,intl.Product__c,intl.Name,'Internal release window not three months long',rtRule.Id,rules);                                                            
                }
            }
            if(intl.Product__c == 'Predict') {
                predictInternals.put(intl.Name,intl);
            }
            if(intl.Product__c == 'Live') {
                liveInternals.put(intl.Name,intl);
            }
        }
        
        //=======================================================================================
        //Main release loop
        //=======================================================================================               
        //Loop through all of the releases, processing each customer and product as a separate block 
        //NB: the first release is the most recent one
        Date dtMinProjected = system.today().addMonths(2);
        
        Integer numProjected = 0;
        Integer numTentative = 0;
        Integer numInProduction = 0;
        Integer numCompleted = 0;
        String previousVersion = null;
        Boolean previousPatch = false;
        Date dtCurrent = null;
        Date dtProjected = null;
        Date dtFull = null;
        Date dtProjectedRoad = null;
        Date dtProjectedSim = null;
        Date dtRoad = null;
        Date dtSim = null;
        
        Boolean nextCustomer = true;   
        Integer i = 0;
        while(i < releases.size()) {
            String customer = releases[i].Optima_Customer_Code__c;
            String product = releases[i].Product__c;
            String version = releases[i].Version__c;
            Date relDate = releases[i].Release_Date__c;
            
            Boolean processRecord = false;
            Boolean implementing = false;
            
            if(nextCustomer) {
                //Initialise counters
                numProjected = 0;
                numTentative = 0;
                numInProduction = 0;
                numCompleted = 0;
                previousVersion = null;
                previousPatch = false;
                dtCurrent = null;
                dtProjected = null;
                dtFull = null;  
                dtProjectedRoad = null;
                dtProjectedSim = null;
                dtRoad = null;
                dtSim = null;
                
                //Check whether we are interested in this customer and product
                if((product == 'Predict' && activePredictCustomers.contains(customer)) ||
                   (product == 'Live' && activeLiveCustomers.contains(customer))) {
                        processRecord = true;
                }
                if((product == 'Predict' && implPredictCustomers.contains(customer)) ||
                   (product == 'Live' && implLiveCustomers.contains(customer))) {
                       processRecord = true;
                       implementing = true;
                   }
            }
            else {
                //It's the same customer and product as the previous release, so we're definitely interested
                processRecord = true;
            }
                        
            if(processRecord) {
                
                //Accumulate data for this release
                if(releases[i].Status__c == 'Projected') {
                    numProjected++;
                    //Occasionally customers may have multiple projected releases (most likely if we have to do 
                    //a data-only road network release mid-year). In this case we want the earliest of the projected 
                    //releases, and we are processing the releases in decreasing order of date, so every time we 
                    //find a new projected release we need to overwrite any previous date

                    //Store the date of the customer's projected release
                    dtProjected = relDate;

                    //Check whether we are projecting a road and/or sim retune
                    if(releases[i].Road_Tune__c) {
                        dtProjectedRoad = relDate;
                    }
                    if(releases[i].Sim_Tune__c) {
                        dtProjectedSim = relDate;
                    }
                }
                else {
                    if(dtCurrent == null) {
                        //The most recent non-projected release is their "current" release
                        dtCurrent = relDate;
                    }
                    if(dtFull == null && !releases[i].Patch__c) {
                        //...and if it's not a patch, it's also their latest full release
                        dtFull = relDate;
                    }
                    //Record the date of the last road and sim retune
                    if(dtRoad == null && releases[i].Road_Tune__c) {
                        dtRoad = relDate;
                    }
                    if(dtSim == null && releases[i].Sim_Tune__c) {
                        dtSim = relDate;
                    }
                }
                if(releases[i].Status__c == 'Tentative') {
                    numTentative++;
                }
                if(releases[i].Status__c == 'In Production') {
                    numInProduction++;
                }
                if(relDate < system.today()) {
                    numCompleted++;
                }

                //=============================================================================
                //Check individual release rules                
                //=============================================================================
                                
                //Projected release less than two months from now
                //(The status needs to be updated, or the date pushed out, on these releases)
                if(releases[i].Status__c == 'Projected' && relDate < dtMinProjected) {
                    createRuleCheck(customer,product,version,'Projected release less than two months from now',rtRule.Id,rules);                               
                }
                
                //Multiple releases with the same version number
                //(This will only find consecutive releases)
                if(previousVersion == version) {
                    createRuleCheck(customer,product,version,'Multiple releases with the same version number',rtRule.Id,rules);                    
                }
                
                //Missing patch flag
                //If the customer has two releases with the same main version number (everything up to the second '.'), 
                //the more recent of the two releases must be marked as a patch. If there aren't two '.'s, we don't have 
                //a full version number yet so we don't need to generate an error.
                //We are looping through the releases in reverse order, so the "previous" version and patch flag are 
                //for the more recent release
                if(previousVersion != null && !previousPatch) {
                    if(previousVersion != version && version.indexOf('.') != version.lastIndexOf('.') &&
                       previousVersion.substringBeforeLast('.') == version.substringBeforeLast('.')) {
                        createRuleCheck(customer,product,previousVersion,'Missing patch flag',rtRule.Id,rules);                                            
                    }
                }
                
                //Future full releases must be in the correct date range for their internal release
                //(Patch releases will often be scheduled outside the internal release window, so we don't give an error for them)
                if(relDate > system.today() && !releases[i].Patch__c) {
                    //Only the "main" version number (up to but excluding the second '.') will be in the 
                    //internal release schedule
                    String mainVersion = version;
                    if(version.indexOf('.') != version.lastIndexOf('.')) {
                        mainVersion = version.substringBeforeLast('.');
                    }
                    
                    Internal_Release__c intl;
                    if(product == 'Predict') {
                		intl = predictInternals.get(mainVersion);                        
                    }
                    if(product == 'Live') {
                		intl = liveInternals.get(mainVersion);                        
                    }
                    
                    if(intl == null) {
                    	createRuleCheck(customer,product,version,'Customer release missing from internal release schedule',rtRule.Id,rules);                     				                       
                    }
                    else {
                        if(relDate < intl.First_Release_Date__c || relDate > intl.Last_Release_Date__c) {
                    		createRuleCheck(customer,product,version,'Customer release scheduled outside internal release window',rtRule.Id,rules);                     				                                                      
                        }
                    }
                }
                
                nextCustomer = false;
                //Peek ahead and see whether the next release is for the same customer 
                //and product. If not, check the main rules for this customer and product now
                //(also check the rules if we have reached the end of the list)
                if(i + 1 == releases.size() ||
                    releases[i+1].Optima_Customer_Code__c != customer ||
                    releases[i+1].Product__c != product) {
                    nextCustomer = true;

                    //=========================================================================
                    //Check overall customer and product rules
                    //=========================================================================
                        
                    //Multiple projected releases
                    if(numProjected > 1) {
                        createRuleCheck(customer,product,null,'Multiple projected releases',rtRule.Id,rules);
                    }                   
                   
                    //No projected or tentative releases
                    //This is checked for implementing customers, as long as they have had at least one release,
                    //because it's important that we keep them reasonably up-to-date if the implementation drags on
                    //(we are assuming any active customer will have had at least one release)
                    if(numProjected + numTentative == 0 && numCompleted > 0) {
                        createRuleCheck(customer,product,null,'No projected or tentative releases',rtRule.Id,rules);
                    }
                    //Multiple releases in production
                    if(numInProduction > 1) {
                        createRuleCheck(customer,product,null,'Multiple releases in production',rtRule.Id,rules);
                    }
                        
                    //Time between full and projected release
                    if(dtProjected != null && dtFull != null) {
                        Integer months = dtFull.monthsBetween(dtProjected);
                        if(months > 13) {
                            createRuleCheck(customer,product,null,'More than 13 months projected between releases',rtRule.Id,rules);                            
                        }
                        if(months < 11) {
                            //If the customer requires frequent retunes then check against a different limit
                            if(releases[i].Cust_Road_Tune_Freq__c > 0 || releases[i].Cust_Sim_Tune_Freq__c > 0) {
                                //Find the smaller of the two frequencies, excluding zeros
                                Decimal freq = releases[i].Cust_Road_Tune_Freq__c;
                                if(releases[i].Cust_Sim_Tune_Freq__c > 0 && releases[i].Cust_Sim_Tune_Freq__c < freq
                                  && product == 'Predict') {
                                    freq = releases[i].Cust_Sim_Tune_Freq__c;
                                }
                                if(months < freq) {
                                	if(freq >= 12) {
                                        //Regardless of the retune frequency, the error message should never mention more than 11 months
                                        freq = 11;
                                    }
                                    createRuleCheck(customer,product,null,'Less than ' + freq + ' months projected between releases',rtRule.Id,rules);
                                }
                            }
                            else {
                                createRuleCheck(customer,product,null,'Less than 11 months projected between releases',rtRule.Id,rules);                            
                            }
                        }
                    }
                    
                    //Required road retunes
                    //This isn't checked for implementing customers, because they might not have had their first tune yet
                    if(releases[i].Cust_Road_Tune_Freq__c > 0 && !implementing) {
                        
                        //a) There must be a historic road tune for these customers
                        if(dtRoad == null) {
                            createRuleCheck(customer,product,null,'No previous road tune found (contractual requirement)',rtRule.Id,rules);                            
                        }
                        
                        //b) If the projected release is close to the required retune frequency, 
                        //it must contain a road tune
                        if(dtProjectedRoad == null && dtProjected != null && dtRoad != null) {
                            Integer months = dtRoad.monthsBetween(dtProjected);
                            if(months >= releases[i].Cust_Road_Tune_Freq__c - 2) {
                                createRuleCheck(customer,product,null,'Required road retune missing from future release',rtRule.Id,rules);                                                            
                            }
                        }
                        
                        //c) If the projected release contains a road tune, it must be close enough 
                        //to the last tune
                        if(dtProjectedRoad != null && dtRoad != null) {
                            Integer months = dtRoad.monthsBetween(dtProjectedRoad);
                            if(months > releases[i].Cust_Road_Tune_Freq__c + 1) {
                                createRuleCheck(customer,product,null,'Too long between required road retunes',rtRule.Id,rules);                                                            
                            }
                        }
                    }

                    //Required sim retunes (Predict only)
                    //This isn't checked for implementing customers, because they might not have had their first tune yet
                    if(releases[i].Cust_Sim_Tune_Freq__c > 0 && !implementing && product == 'Predict') {
                        
                        //a) There must be a historic sim tune for these customers
                        if(dtSim == null) {
                            createRuleCheck(customer,product,null,'No previous sim tune found (contractual requirement)',rtRule.Id,rules);                            
                        }
                        
                        //b) If the projected release is close to the required retune frequency, 
                        //it must contain a sim tune
                        if(dtProjectedSim == null && dtProjected != null && dtSim != null) {
                            Integer months = dtSim.monthsBetween(dtProjected);
                            if(months >= releases[i].Cust_Sim_Tune_Freq__c - 2) {
                                createRuleCheck(customer,product,null,'Required sim retune missing from future release',rtRule.Id,rules);                                                            
                            }
                        }
                        
                        //c) If the projected release contains a sim tune, it must be close enough 
                        //to the last tune
                        if(dtProjectedSim != null && dtSim != null) {
                            Integer months = dtSim.monthsBetween(dtProjectedSim);
                            if(months > releases[i].Cust_Sim_Tune_Freq__c + 1) {
                                createRuleCheck(customer,product,null,'Too long between required sim retunes',rtRule.Id,rules);                                                            
                            }
                        }
                    }

                }
            }
            
            else {
                //We're not processing this record, skip ahead to the next customer or product
                while(i < releases.size() &&
                     releases[i].Optima_Customer_Code__c == customer &&
                     releases[i].Product__c == product) {

                     //=========================================================================
                     //Check rules for non-processed records
                     //=========================================================================
                     //These are releases for customers with cancelled (or non-existent) contracts
                        
                     //Future release for cancelled customer
                     if(releases[i].Release_Date__c > system.today()) {
                        createRuleCheck(customer,product,releases[i].Version__c,'Future release for cancelled customer',rtRule.Id,rules);                               
                     }
                         
                     //In Production release for cancelled customer
                     if(releases[i].Status__c == 'In Production') {
                        createRuleCheck(customer,product,releases[i].Version__c,'In Production release for cancelled customer',rtRule.Id,rules);                               
                     }
                                              
                     i++;
                }
                //Subtract one from the counter, because we're about to increment it
                i--;
                nextCustomer = true;
            }
            
            previousVersion = version;
            previousPatch = releases[i].Patch__c;
            
            //Increment release counter
            i++;
        }       
            
        //Commit the new rules to the database
        if(rules.size() > 0) {
            insert rules;
        }    
    }
    
    private static void createRuleCheck(String customer, String product, String version, String message, 
                                        String recordTypeId, List<Rule_Check__c> rules) {
        //Create a Rule Check
        Rule_Check__c rc = new Rule_Check__c();
        rc.Optima_Customer_Code__c = customer;
        rc.Product__c = product;
        rc.Version__c = version;
        rc.Message__c = message;
        rc.RecordTypeId = recordTypeId;        
        rules.add(rc);   
    }                                             
}