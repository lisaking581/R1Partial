/*********************************************************************************************
 * Name:
 * Optima Inflation Class
 * 
 * Authors:
 * Jeff Arwady | Senior Consultant
 * akaCRM
 * and
 * Amanda Day | Operations Manager
 * Optima
 *  
 * Description:
 * This class is activated via an On-Click JavaScipt Custom Button located on the 
 * IMX Contract Object. It updates the Inflation_Since_Annual_Increase__c and 
 * Inflation_Since_Hourly_Increase__c fields on the IMX Contract object for contracts with 
 * record type Optima Contract, using information from the Inflation object.
 * *******************************************************************************************/

global class OptimaInflation {

    @AuraEnabled
    webservice static void inflation() {
    
        //Declare Variables
        List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        List<Inflation__c> inflationData = new List<Inflation__c>();
        Decimal annualInflation = 0;
        Decimal hourlyInflation = 0;
        
        //Get the record type ID from the database
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];
        
        //Query the Database for IMX Contracts with Record Type Optima Contract
        contracts = [SELECT Id, Inflation_Country__c, Latest_Annual_Fee_History_Date__c, Latest_Hourly_Fee_History_Date__c 
                     FROM IMX_Contract__c WHERE RecordTypeId = :rt.Id];
        //Extract all of the Inflation data from the database 
        inflationData = [SELECT Country__c, Year__c, Percentage__c FROM Inflation__c ORDER BY Country__c ASC, Year__c ASC];
            
        //Calculate the two inflation figures for each contract (one for the amount of inflation since 
        //the last increase in the annual fee, and one since the last increase in the hourly fee). 
        //Use the correct country for each contract
        for(IMX_Contract__c imx :contracts) {
            annualInflation = 0;
            hourlyInflation = 0;
            
            for(Inflation__c infl :inflationData) {
                //This loop is more efficient than it looks, because there are very few inflation countries
                if(infl.Country__c == imx.Inflation_Country__c) {

					//The inflation data is stored as a percentage e.g. 5.2 = 5.2% inflation, 
					//so we need to convert it to a decimal (0.052) for the calculation. 
					//To calculate inflation across multiple years, we multiply (1 + inflation) 
					//(1.052 for this example) for each year and then subtract 1 at the end.
					//We assume the fee history is up-to-date, so if it is null then there is 
					//no fee history and we shouldn't calculate inflation
                    if(imx.Latest_Annual_Fee_History_Date__c != null &&
                       infl.Year__c >= imx.Latest_Annual_Fee_History_Date__c.year()) {
                           if(annualInflation == 0) {
                               annualInflation = 1 + infl.Percentage__c/100;
                           }
                           else {
                       			annualInflation *= (1 + infl.Percentage__c/100);
                           }
                    }

                	if(imx.Latest_Hourly_Fee_History_Date__c != null &&
                       infl.Year__c >= imx.Latest_Hourly_Fee_History_Date__c.year()) {
                           if(hourlyInflation == 0) {
                               hourlyInflation = (1 + infl.Percentage__c/100);
                           }
                           else {
                       			hourlyInflation *= (1 + infl.Percentage__c/100);
                           }
                    }
                    
                }
            }
            
            //Subtract one to get the total inflation, and multiply by 100 to get a percentage
            if(annualInflation != 0) {
            	annualInflation = (annualInflation - 1) * 100;
        	}
            if(hourlyInflation != 0) {
            	hourlyInflation = (hourlyInflation - 1) * 100;
            }    
            
            //Store the values we have calculated on the object, rounding to one decimal place.
            //If there is no fee history, store null
            if(imx.Latest_Annual_Fee_History_Date__c == null) {
                imx.Inflation_Since_Annual_Increase__c = null;
            }
            else {
            	imx.Inflation_Since_Annual_Increase__c = annualInflation.setScale(1);
            }
            if(imx.Latest_Hourly_Fee_History_Date__c == null) {
                imx.Inflation_Since_Hourly_Increase__c = null;
            }
            else {
                imx.Inflation_Since_Hourly_Increase__c = hourlyInflation.setScale(1);
            }
        }
        
        //Commit the updates to the database
        update contracts;
    }
}