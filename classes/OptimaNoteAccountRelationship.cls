/*********************************************************************************************
 * Name:
 * Optima Note - Account Relationship Class
 * 
 * Author:
 * Jeff Arwady | Senior Consultant
 * akaCRM
 * 
 * Description:
 * This class is activated via an On-Click JavaScipt Custom Button located on the 
 * Optima Note Object. It finds all the Account Records that have the same
 * product as the Optima Note as Identified by the IMX Contract Object that is
 * related to the Account Object.  Cancelled contracts are excluded.
 * The use of a Stop Code checkbox prevents repeated use.
 * *******************************************************************************************/

global class OptimaNoteAccountRelationship {

    @AuraEnabled
    webservice static void accountRelationship(Id optimaNoteId) {
    	
        //Declare Variables
        Optima_Note__c optimaNote = [SELECT Id, Product__c, Stop_Code__c FROM Optima_Note__c WHERE Id = :optimaNoteId];
        List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        String accountId = NULL;
        List<Account_Note__c> notes = new List<Account_Note__c>();
        String optimaNoteProduct = optimaNote.Product__c;
        
        //Prevent repeated use of this logic on the same record
        if(optimaNote.Stop_Code__c == FALSE) {
        
            //Query the database for IMX Contracts that share their product with the originating Optima Note and are not Cancelled
            contracts = [SELECT Id, Account__c, Account__r.Name FROM IMX_Contract__c 
                         WHERE Product__c = :optimaNoteProduct AND Status__c != 'Cancelled' 
                         ORDER BY Account__r.Name];
        
            //Create an Account Note for each IMX Contract queried
            for(IMX_Contract__c imx :contracts) {
 
                if(imx.Account__c != accountId) {
            
                    Account_Note__c an = new Account_Note__c();
            
                    an.Account__c = imx.Account__c;
                    an.Optima_Note__c = optimaNoteId;
                
                    accountId = imx.Account__c;
            
                    notes.add(an);
                }
            }
            
            optimaNote.Stop_Code__c = TRUE;
            update optimaNote;   
        }
        
        //Commit the New Tables to the Database
        if(notes.size() > 0) { 
            insert notes;
        }
    }
}