/***********************************************************************************************
 * Name:
 * Optima Update Account Tunes Tester
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This test class uses methods called triggerTestX() to create test accounts and contracts, 
 * and makes sure that the correct changes are made to the road and sim tune fields on the 
 * account by the OptimaUpdateAccountTunes trigger
 * *********************************************************************************************/

@isTest

private class OptimaUpdateAccountTunesTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }

    //============================================================================================
    static testMethod void triggerTest1() {
    //============================================================================================
    //Test that the trigger behaves correctly on insert of a contract

        //Insert test accounts and existing contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        
        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(4)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST3')
            									   .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(4)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        //Initiate Testing Procedure
        Test.startTest();

        //1. Insert the account's first contract - the account should be updated with both values from the contract
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(3)
            													 .withSimTunes(9)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }
        
		//2. Insert an additional contract with a null value - the existing account fields shouldn't be updated
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
            													 .withStatus('Active')
            													 .insertContract();
        }
		
        //3. Insert an additional contract with positive values. The account should only be updated where the new value 
        //is lower than the existing one
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(2)
            													 .withSimTunes(6)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }
        
        Test.stopTest();
        
        //Initiate Verification Procedure
	    List<Account> accounts = new List<Account>();
    	accounts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
        		    FROM Account WHERE Id IN (:a.Id,:a2.Id,:a3.Id)
                    ORDER BY Optima_Customer_Code__c];
        
        //Check that the account fields have been updated correctly
        System.assertEquals(3, accounts[0].Road_Tunes_months__c);
        System.assertEquals(9, accounts[0].Sim_Tunes_months__c);
        System.assertEquals(4, accounts[1].Road_Tunes_months__c);
        System.assertEquals(4, accounts[1].Sim_Tunes_months__c);
        System.assertEquals(2, accounts[2].Road_Tunes_months__c);
        System.assertEquals(4, accounts[2].Sim_Tunes_months__c);
    }

    //============================================================================================
    static testMethod void triggerTest2() {
    //============================================================================================
    //Test that the trigger behaves correctly on update of a contract
    
        //Insert test accounts and existing contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(4)
            													 .insertContract();
        }

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
            													 .withStatus('Active')
            													 .withRoadTunes(4)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST3')
            									   .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
                												 .withRegion('Region 1')
            													 .withStatus('Cancelled')
                												 .withCancelDate(date.parse('01/01/2013'))
            													 .withRoadTunes(2)
            													 .withSimTunes(2)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
                												 .withRegion('Region 2')
            													 .withRoadTunes(4)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
                												 .withRegion('Region 3')
            													 .withRoadTunes(6)
            													 .withSimTunes(6)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        //Initiate Testing Procedure
        Test.startTest();

      	List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        
        //1. Update a single-contract account. Update sim tunes from null
        contracts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
      		    	FROM IMX_Contract__c WHERE Account__c = :a.Id];
        for(IMX_Contract__c con :contracts) {
            con.Sim_Tunes_months__c = 6;
            con.Retune_Conditions__c = 'all-inclusive';
        }
        update contracts;
        
        //2. Update a single-contract account. Decrease one value only (it should flow through
        //to the account, since it only has one contract) 
        contracts.clear();
        contracts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
      		    	FROM IMX_Contract__c WHERE Account__c = :a2.Id];
        for(IMX_Contract__c con :contracts) {
            con.Road_Tunes_months__c = 2;
        }
        update contracts;
		        
		//3. Update a multi-contract account. Increase one value only. Since there are existing 
		//lower values the new value shouldn't flow through to the account. The existing cancelled 
		//contract should not be included in the calculation
        contracts.clear();
        contracts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
      		    	FROM IMX_Contract__c WHERE Account__c = :a3.Id
                    AND Region__c = 'Region 2'];
        for(IMX_Contract__c con :contracts) {
            con.Sim_Tunes_months__c = 8;
        }
        update contracts;
        
        Test.stopTest();
        
        //Initiate Verification Procedure
	    List<Account> accounts = new List<Account>();
    	accounts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
        		    FROM Account WHERE Id IN (:a.Id,:a2.Id,:a3.Id)
                    ORDER BY Optima_Customer_Code__c];
        
        //Check that the account fields have been updated correctly
        System.assertEquals(4, accounts[0].Road_Tunes_months__c);
        System.assertEquals(6, accounts[0].Sim_Tunes_months__c);
        System.assertEquals(2, accounts[1].Road_Tunes_months__c);
        System.assertEquals(4, accounts[1].Sim_Tunes_months__c);
        System.assertEquals(4, accounts[2].Road_Tunes_months__c);
        System.assertEquals(6, accounts[2].Sim_Tunes_months__c);
    }

    //============================================================================================
    static testMethod void triggerTest3() {
    //============================================================================================
    //Test that the trigger behaves correctly on delete of a contract
    
        //Insert test accounts and existing contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            													 .withRoadTunes(2)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
                												 .withRegion('Region 1')
            													 .withRoadTunes(4)
            													 .withSimTunes(4)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }
        {
        	IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
                												 .withRegion('Region 2')
            													 .withRoadTunes(2)
            													 .withSimTunes(6)
            													 .withRetuneConditions('all-inclusive')
            													 .insertContract();
        }

        //Initiate Testing Procedure
        Test.startTest();

      	List<IMX_Contract__c> contracts = new List<IMX_Contract__c>();
        
        //1. Delete from a single-contract account. Both account values should be set to null
        contracts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
      		    	FROM IMX_Contract__c WHERE Account__c = :a.Id];
        delete contracts;
        
		//2. Delete from a multi-contract account. The values from the other contract 
		//should both flow through to the account, although one is higher than the deleted 
		//value and the other is lower
        contracts.clear();
        contracts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
      		    	FROM IMX_Contract__c WHERE Account__c = :a2.Id
                    AND Region__c = 'Region 1'];
        delete contracts;
        
        Test.stopTest();
        
        //Initiate Verification Procedure
	    List<Account> accounts = new List<Account>();
    	accounts = [SELECT Id, Road_Tunes_months__c, Sim_Tunes_months__c
        		    FROM Account WHERE Id IN (:a.Id,:a2.Id)
                    ORDER BY Optima_Customer_Code__c];
        
        //Check that the account fields have been updated correctly
        System.assertEquals(NULL, accounts[0].Road_Tunes_months__c);
        System.assertEquals(NULL, accounts[0].Sim_Tunes_months__c);
        System.assertEquals(2, accounts[1].Road_Tunes_months__c);
        System.assertEquals(6, accounts[1].Sim_Tunes_months__c);
    }
}