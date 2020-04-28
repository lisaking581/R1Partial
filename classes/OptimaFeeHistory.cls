/*********************************************************************************************
 * Name:
 * Optima Fee History Class
 * 
 * Author:
 * Amanda Day | Operations Manager
 * Optima
 *  
 * Description:
 * This class is activated via an On-Click JavaScipt Custom Button located on the 
 * IMX Contract Object. It updates the fee history summary fields on the IMX Contract object for 
 * contracts with record type Optima Contract, using information from the Fee History and 
 * Optima Invoice objects.
 * Note that most of these fields (all of the fee history ones) are also updated by workflow rules, 
 * but there are some situations that can't be captured by the rules so they are also calculated here
 * *******************************************************************************************/

global class OptimaFeeHistory {

    @AuraEnabled
    webservice static void updateHistory() {
    
        //Declare Variables
        List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
		List<Optima_Invoice__c> invoices = new List<Optima_Invoice__c>();     	
		Map<Id,Optima_Invoice__c> invoiceMap = new Map<Id,Optima_Invoice__c>();     	
		List<Fee_History__c> fees = new List<Fee_History__c>();     	
		Map<Id,Fee_History__c> annualFeeMap = new Map<Id,Fee_History__c>();     	
		Map<Id,Fee_History__c> hourlyFeeMap = new Map<Id,Fee_History__c>();     	
        
        //Get the record type ID from the database
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];
        
        //Query the Database for IMX Contracts with Record Type Optima Contract
        contracts = [SELECT Id, Latest_Annual_Fee_History_Date__c, Latest_Hourly_Fee_History_Date__c,
                     Latest_Annual_Fee_History_Amount__c, Latest_Hourly_Fee_History_Amount__c,
                     Next_Invoice_Date__c FROM IMX_Contract__c WHERE RecordTypeId = :rt.Id];

        //We are only interested in one invoice and two fee history records per contract, but SOQL 
        //can't cope with just getting the ones we want, so we have to get them all
        invoices = [SELECT Master_Contract__c, Invoice_Date__c FROM Optima_Invoice__c 
                    WHERE Master_Contract__r.RecordTypeId = :rt.Id
                    AND Invoice_Date__c > TODAY
                    ORDER BY Master_Contract__c ASC, Invoice_Date__c ASC];

        fees = [SELECT Master_Contract__c, Fee_Type__c, Effective_Date__c, Amount__c FROM Fee_History__c 
                WHERE Master_Contract__r.RecordTypeId = :rt.Id
                ORDER BY Master_Contract__c ASC, Fee_Type__c ASC, Effective_Date__c DESC];
        
        //Make a map between the contract IDs and the invoice and fee history records, so we can find the ones we want
        for(Optima_Invoice__c inv :invoices) {
            if(invoiceMap.get(inv.Master_Contract__c) == null) {
                //We only want the first invoice we find for each contract, which will be
                //the first invoice after today
        		invoiceMap.put(inv.Master_Contract__c,inv);
            }
        }
        for(Fee_History__c fee :fees) {
            //We only want the first fee history record of each type that we find for each contract,
            //which will have the latest effective date
            if(fee.Fee_Type__c == 'Annual') {
            	if(annualFeeMap.get(fee.Master_Contract__c) == null) {
        			annualFeeMap.put(fee.Master_Contract__c,fee);
                }
            }
            if(fee.Fee_Type__c == 'Hourly') {
            	if(hourlyFeeMap.get(fee.Master_Contract__c) == null) {
        			hourlyFeeMap.put(fee.Master_Contract__c,fee);
                }
            }
        }
        
        for(IMX_Contract__c con :contracts) {
            //We have to explicitly manage nulls here, because if there is no applicable fee history or 
            //invoice record then we want to update the contract field to null
            if(annualFeeMap.get(con.Id) == null) {
				con.Latest_Annual_Fee_History_Amount__c = null;
				con.Latest_Annual_Fee_History_Date__c = null;                
            }
            else {
				con.Latest_Annual_Fee_History_Amount__c = annualFeeMap.get(con.Id).Amount__c;
				con.Latest_Annual_Fee_History_Date__c = annualFeeMap.get(con.Id).Effective_Date__c;
            }
            
            if(hourlyFeeMap.get(con.Id) == null) {
				con.Latest_Hourly_Fee_History_Amount__c = null;
				con.Latest_Hourly_Fee_History_Date__c = null;                
            }
            else {
				con.Latest_Hourly_Fee_History_Amount__c = hourlyFeeMap.get(con.Id).Amount__c;
				con.Latest_Hourly_Fee_History_Date__c = hourlyFeeMap.get(con.Id).Effective_Date__c;
            }
            
            if(invoiceMap.get(con.Id) == null) {
            	con.Next_Invoice_Date__c = null;
            }
            else {
            	con.Next_Invoice_Date__c = invoiceMap.get(con.Id).Invoice_Date__c;
            }
        }
        
        //Commit the updates to the database
        update contracts;
    }
}