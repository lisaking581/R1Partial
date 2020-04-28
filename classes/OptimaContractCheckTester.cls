/***********************************************************************************************
 * Name:
 * Optima Contract Check Tester
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This test class uses methods called ruleTestX() to create test Accounts and IMX Contracts
 * It simulates the JavaScript button by calling the OptimaContractCheck Global Class.  
 * It then checks to make sure that the correct Rule Checks have been created.
 * *********************************************************************************************/

@isTest

private class OptimaContractCheckTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }
    
    //============================================================================================
    static testMethod void ruleTest1() {
    //============================================================================================
        //Check rules 1-6 (missing contract data)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert Test Account and Contact
        Account a = OptimaAccountTestData.Instance.insertAccount();
        Contact c = OptimaContactTestData.Instance.withAccount(a.Id).insertContact();
        
        //Insert Test IMX Contracts
        //1. Active contract -> rule checks should be created
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withContractDate(null)
            												 .withLatestAnnualDate(null)
            												 .withLatestHourlyDate(null)
            												 .withLatestAnnualAmount(null)
            												 .withLatestHourlyAmount(null)
            												 .withAnnualConditions(null)
            												 .withHourlyConditions(null)
            												 .withNextInvoiceDate(null)
            												 .withContractProblems('Test problem')
            												 .insertContract();
        
        //2. Cancelled contract -> rule checks should not be created
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .withProduct('Live')
            												  .withStatus('Cancelled')
            												  .withCancelDate(date.parse('01/01/2013'))
            												  .withContractDate(null)
            												  .withLatestAnnualDate(null)
            												  .withLatestHourlyDate(null)
            												  .withLatestAnnualAmount(null)
            												  .withLatestHourlyAmount(null)
            												  .withAnnualConditions(null)
            												  .withHourlyConditions(null)
            												  .withNextInvoiceDate(null)
            												  .withContractProblems('Test problem')
            												  .insertContract();
        
        //3. Active contract with all data populated -> no rule checks should be created
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .insertContract();

    	//Insert an invoice for each contract
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withDate(system.today().addDays(-1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
                												  .withDate(system.today().addDays(-1))
                												  .withNumber('123') //This sets the invoiced flag
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
            													  .insertInvoice();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE Optima_Customer_Code__c = :a.Optima_Customer_Code__c
                                     AND RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 6 records
        System.assertEquals(6, rules.size());
        
        //Assert that each record is for the first product
        System.assertEquals(con.Product__c, rules[0].Product__c);
        System.assertEquals(con.Product__c, rules[1].Product__c);
        System.assertEquals(con.Product__c, rules[2].Product__c);
        System.assertEquals(con.Product__c, rules[3].Product__c);
        System.assertEquals(con.Product__c, rules[4].Product__c);
        System.assertEquals(con.Product__c, rules[5].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('Missing contract start date', rules[0].Message__c);
        System.assertEquals('Missing annual increase conditions', rules[1].Message__c);
        System.assertEquals('Missing hourly increase conditions', rules[2].Message__c);
        System.assertEquals('Missing annual fee history', rules[3].Message__c);
        System.assertEquals('Missing hourly fee history', rules[4].Message__c);
        System.assertEquals('Contract problems: ' + con.Contract_Problems__c, rules[5].Message__c);
    }

    //============================================================================================
    static testMethod void ruleTest2() {
    //============================================================================================
        //Check rules 7-10 (missing related records)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //1. No contract -> rule check should be created
        Account a = OptimaAccountTestData.Instance.insertAccount();
               
        //2. One contract with invoices and one without -> one rule check should be created
        //   No contacts for Predict or Live -> two rule checks should be created
        Account a2 = OptimaAccountTestData.Instance.withName('Test Name 2')
                                          		   .withOptimaCustomerCode('Test Code 2')
                                             	   .insertAccount();
        
        {
          Contact c = OptimaContactTestData.Instance.withAccount(a2.Id)
                            					    .withContactType('Billing Contact')
                                              		.insertContact();
        }

        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												 .withProduct('Predict')
            												 .insertContract();
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            													  .insertInvoice();
        }
        
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Live')
            												  .insertContract();
        

        //3. No release contacts for Predict or Live -> two rule checks should be created 
        //One contract with only a past invoice => one rule check should be created
        Account a3 = OptimaAccountTestData.Instance.withName('Test Name 3')
                           		                   .withOptimaCustomerCode('Test Code 3')
                                 		           .insertAccount();

        {   
          Contact c = OptimaContactTestData.Instance.withAccount(a3.Id)
                            	                    .withContactType('Optima Predict Contact;Optima Live Contact')
                                 	                .insertContact();
        }

        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Predict')
            												  .insertContract();
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
            													  .insertInvoice();
        }
        
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Live')
            												  .insertContract();       
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con4.Id)
            													  .insertInvoice();
        }

        //4. Cancelled contract with unissued invoice -> rule check should be created
        Account a4 = OptimaAccountTestData.Instance.withName('Test Name 4')
                           		                   .withOptimaCustomerCode('Test Code 4')
                                 		           .insertAccount();
        
        {
          Contact c = OptimaContactTestData.Instance.withAccount(a4.Id)
                            	                    .insertContact();
        }

        IMX_Contract__c con5 = OptimaContractTestData.Instance.withAccountId(a4.Id)
            												  .withProduct('Live')
            												  .withStatus('Cancelled')
            												  .withCancelDate(date.parse('01/01/2013'))            												  
            												  .insertContract();       
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con5.Id)
                												  .withDate(system.today().addDays(-1))
            													  .insertInvoice();
        }

        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 7 records
        System.assertEquals(7, rules.size());
        
        //Assert that each record is for the correct account
        //(Errors are generated in the order that the checks are done, which isn't exactly the same as 
        //the order the test records are inserted above)
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a4.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[4].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[5].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[6].Optima_Customer_Code__c);
        
        //Assert that each record is for the correct product
        System.assertEquals(null, rules[0].Product__c);
        System.assertEquals(con2.Product__c, rules[1].Product__c);
        System.assertEquals(con5.Product__c, rules[2].Product__c);
        System.assertEquals(con.Product__c, rules[3].Product__c);
        System.assertEquals(con3.Product__c, rules[4].Product__c);
        System.assertEquals(con2.Product__c, rules[5].Product__c);
        System.assertEquals(con4.Product__c, rules[6].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('Account with no contracts', rules[0].Message__c);
        System.assertEquals('Contract with no invoices', rules[1].Message__c);
        System.assertEquals('Cancelled contract with unissued invoices', rules[2].Message__c);
        System.assertEquals('Contract with no contacts', rules[3].Message__c);
        System.assertEquals('Missing release contacts', rules[4].Message__c);
        System.assertEquals('Contract with no contacts', rules[5].Message__c);
        System.assertEquals('Missing release contacts', rules[6].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest3() {
    //============================================================================================
        //Check rule 11 (missing inflation data)

        Integer targetCount = 0;
        Integer thisYear = 0;       
        List<Inflation__c> inflation = new List<Inflation__c>();    

    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert inflation data
        
        //We are expecting a record for every year from 2009 until last year 
        thisYear = system.today().year();
        targetCount = thisYear - 2009;

        for (Integer yr = 2008; yr < thisYear; yr++) {

            //1. Country XX has records for 2008-2009 and 2011 onwards -> a rule check should be created
            if(yr != 2010) {
            Inflation__c infl = new Inflation__c();    
            infl.Country__c = 'XX';
            infl.Year__c = yr;
            infl.Percentage__c = 1.1;
            inflation.add(infl);
            }        
       
        	//2. Country AB has records for 2009 onwards -> no rule check should be created
            if(yr != 2008) {
            Inflation__c infl = new Inflation__c();    
            infl.Country__c = 'AB';
            infl.Year__c = yr;
            infl.Percentage__c = 1.1;
             inflation.add(infl);
            }
        }        

        insert inflation;
       
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 1 record
        System.assertEquals(1, rules.size());
        
        //Assert that the record has the correct message
        System.assertEquals('Missing inflation data for country XX. Expected ' + targetCount + ' values since 2009', rules[0].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest4() {
    //============================================================================================
        //Check rule 12 (invoice total mismatch)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert Test Accounts, Contacts and Contracts
        Account a = OptimaAccountTestData.Instance.insertAccount();
        Contact c = OptimaContactTestData.Instance.withAccount(a.Id)
                          		                  .insertContact();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .insertContract();
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .insertContract();
        
        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('Test Code 2')
                                		           .insertAccount();
        Contact c2 = OptimaContactTestData.Instance.withAccount(a2.Id)
                           		                   .insertContact();
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .insertContract();

        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('Test Code 3')
                                	               .insertAccount();
        Contact c3 = OptimaContactTestData.Instance.withAccount(a3.Id)
                           		                   .insertContact();
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .insertContract();
        IMX_Contract__c con5 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .insertContract();
        IMX_Contract__c con6 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .insertContract();

        //Insert test invoices
        
        //1. Total matches latest fee history amount, excluding the past invoice and
        //the one that is more than a year away -> no rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withAmount(100000)
                												  .withDate(system.today().addDays(-1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withAmount(40000)
                												  .withDate(system.today().addDays(1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withAmount(40000)
                												  .withDate(system.today().addDays(2))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withAmount(20000)
                												  .withDate(system.today().addDays(3))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withAmount(100000)
                												  .withDate(system.today().addMonths(13))
            													  .insertInvoice();
        }
        
        //2. Total doesn't match latest fee history amount -> rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
                												  .withAmount(50000)
                												  .withDate(system.today().addDays(1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
                												  .withAmount(40000)
                												  .withDate(system.today().addDays(2))
            													  .insertInvoice();
        }

        //3. No invoices in next 12 months -> rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
                												  .withAmount(100000)
                												  .withDate(system.today().addDays(-1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
                												  .withAmount(100000)
                												  .withDate(system.today().addMonths(13))
            													  .insertInvoice();
        }
        
        //4. Invoice total slightly higher than expected -> rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con4.Id)
                												  .withAmount(90000)
                												  .withDate(system.today().addDays(1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con4.Id)
                												  .withAmount(10001)
                												  .withDate(system.today().addDays(2))
            													  .insertInvoice();
        }
        
        //5. Invoice total slightly lower than expected -> no rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con5.Id)
                												  .withAmount(90000)
                												  .withDate(system.today().addDays(1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con5.Id)
                												  .withAmount(9999)
                												  .withDate(system.today().addDays(2))
            													  .insertInvoice();
        }
        
        //6. Invoice total slightly lower than allowed -> rule check should be generated
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con6.Id)
                												  .withAmount(90000)
                												  .withDate(system.today().addDays(1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con6.Id)
                												  .withAmount(9997)
                												  .withDate(system.today().addDays(2))
            													  .insertInvoice();
        }

        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 2 records
        System.assertEquals(4, rules.size());
        
        //Assert that each record is for the correct account
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);
        
        //Assert that each record is for the correct product
        System.assertEquals(con2.Product__c, rules[0].Product__c);
        System.assertEquals(con3.Product__c, rules[1].Product__c);
        System.assertEquals(con4.Product__c, rules[2].Product__c);
        System.assertEquals(con6.Product__c, rules[3].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('Mismatch between fee history and invoices planned for next 12 months. Expected 100000.00 found 90000.00', rules[0].Message__c);
        System.assertEquals('Mismatch between fee history and invoices planned for next 12 months. Expected 100000.00 found 0', rules[1].Message__c);
        System.assertEquals('Mismatch between fee history and invoices planned for next 12 months. Expected 100000.00 found 100001.00', rules[2].Message__c);
        System.assertEquals('Mismatch between fee history and invoices planned for next 12 months. Expected 100000.00 found 99997.00', rules[3].Message__c);
    }

    //============================================================================================
    static testMethod void ruleTest5() {
    //============================================================================================
        //Check rules 13-14 (inconsistent retune frequency)
        //(testing for rule 14 is minimal because the code is almost identical to rule 13)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert Test Accounts and Contacts
        Account a = OptimaAccountTestData.Instance.insertAccount();
        Contact c = OptimaContactTestData.Instance.withAccount(a.Id)
                          		                  .insertContact();
                
        Account a2 = OptimaAccountTestData.Instance.withName('Test Name2')
                           		                   .withOptimaCustomerCode('Test Code 2')
                                 		           .insertAccount();
        Contact c2 = OptimaContactTestData.Instance.withAccount(a2.Id)
                           		                   .insertContact();
        
        Account a3 = OptimaAccountTestData.Instance.withName('Test Name3')
                           		                   .withOptimaCustomerCode('Test Code 3')
                                 		           .insertAccount();
        Contact c3 = OptimaContactTestData.Instance.withAccount(a3.Id)
                           		                   .insertContact();
        
        Account a4 = OptimaAccountTestData.Instance.withName('Test Name4')
                           		                   .withOptimaCustomerCode('Test Code 4')
                                 		           .insertAccount();
        Contact c4 = OptimaContactTestData.Instance.withAccount(a4.Id)
                           		                   .insertContact();
        
        Account a5 = OptimaAccountTestData.Instance.withName('Test Name5')
                           		                   .withOptimaCustomerCode('Test Code 5')
                                 		           .insertAccount();
        Contact c5 = OptimaContactTestData.Instance.withAccount(a5.Id)
                           		                   .insertContact();
        
        Account a6 = OptimaAccountTestData.Instance.withName('Test Name6')
                           		                   .withOptimaCustomerCode('Test Code 6')
                                 		           .insertAccount();
        Contact c6 = OptimaContactTestData.Instance.withAccount(a6.Id)
                           		                   .insertContact();
         
        //Insert Test IMX Contracts, and insert an invoice for each contract
        
        //1. (road) single-contract account, null retune value - no rulecheck should be generated
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
                												 .withProduct('Predict')
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        
        //2. (road) single-contract account, positive retune value - no rulecheck should be generated
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(4)
         	   												 	 .insertContract();
            Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        
        //3. (road) multi-contract account with one null retune value - rulecheck should be generated
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
                												 .withProduct('Predict')
         	   												 	 .insertContract();
       		Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a3.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(6)
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        
        //4. (road + sim) multi-contract account with different positive retune values - two rulechecks should be generated
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a4.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(2)
                												 .withSimTunes(6)
                												 .withRetuneConditions('all-inclusive')
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a4.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(3)
                												 .withSimTunes(12)
                												 .withRetuneConditions('all-inclusive')
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        
        //5. (road + sim) multi-contract account with matching positive retune values - no rulecheck should be generated
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a5.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(6)
                												 .withSimTunes(12)
                												 .withRetuneConditions('all-inclusive')
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a5.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(6)
                												 .withSimTunes(12)
                												 .withRetuneConditions('all-inclusive')
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        
        //6. (road) multi-contract account with different retune values - no rulecheck should be generated
        //because one contract is cancelled
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a6.Id)
                												 .withProduct('Predict')
                												 .withRoadTunes(6)
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        {
            IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a2.Id)
                												 .withProduct('Predict')
            												  	 .withStatus('Cancelled')
            												  	 .withCancelDate(date.parse('01/01/2013'))            												  
                												 .withRoadTunes(12)
         	   												 	 .insertContract();
       	  	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
              													  .withNumber('123') //This sets the invoiced flag
            												      .insertInvoice();
        }

        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 3 records
        System.assertEquals(3, rules.size());
        
        //Assert that each record is for the correct account
        System.assertEquals(a3.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a4.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a4.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
               
        //Assert that each record has the correct message
        System.assertEquals('Inconsistent road retune frequency across active contracts', rules[0].Message__c);
        System.assertEquals('Inconsistent road retune frequency across active contracts', rules[1].Message__c);
        System.assertEquals('Inconsistent sim retune frequency across active predict contracts', rules[2].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest6() {
    //============================================================================================
        //Check rules 15-16 (purchase orders)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert Test Account and Contact
        Account a = OptimaAccountTestData.Instance.insertAccount();       
        Contact c = OptimaContactTestData.Instance.withAccount(a.Id).insertContact();

        //Insert Test IMX Contracts
        //1. PO Status "To be confirmed" -> rule check should be created
        //   Future expiry -> rule check should not be created
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
              												 .withPOStatus('To be confirmed')
            												 .withPOExpiry(system.today().addMonths(4))
       	   												 	 .insertContract();

        //2. Upcoming expiry -> rule check should be created
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
              												  .withPOStatus('Required')
            												  .withPOProcess('Ask customer')
            												  .withPOExpiry(system.today().addDays(50))
       	   												 	  .insertContract();

        //3. Upcoming expiry on cancelled contract -> rule check should not be created
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a.Id)
           												  	  .withStatus('Cancelled')
           												  	  .withCancelDate(date.parse('01/01/2013'))            												  
              												  .withPOStatus('Required')
            												  .withPOProcess('Ask customer')
            												  .withPOExpiry(system.today().addMonths(1))
       	   												 	  .insertContract();

        //Insert an invoice for each contract
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
              													  .withNumber('123') //This sets the invoiced flag
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
              													  .withNumber('123')
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
              													  .withNumber('123')
            												      .insertInvoice();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE Optima_Customer_Code__c = :a.Optima_Customer_Code__c
                                     AND RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 2 records
        System.assertEquals(2, rules.size());
        
        //Assert that each record is for the correct product
        System.assertEquals(con.Product__c, rules[0].Product__c);
        System.assertEquals(con2.Product__c, rules[1].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('Unconfirmed purchase order status', rules[0].Message__c);
        System.assertEquals('Purchase order expiry date within three months: ' + con2.PO_Expiry__c.format(), rules[1].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest7() {
    //============================================================================================
        //Check rules 17-19 (renewals and expiries)
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records
        
        //Insert Test Account and Contact
        Account a = OptimaAccountTestData.Instance.insertAccount();       
        Contact c = OptimaContactTestData.Instance.withAccount(a.Id)
            									  .insertContact();

        //Insert Test IMX Contracts
        //1. Auto-renew -> no rule check should be created
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
              												 .withAutoRenew(True)
       	   												 	 .insertContract();

        //2. Upcoming renewal -> rule check should be created
        //   Upcoming expiry but more than 6 months away -> rule check should not be created
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
              												  .withAutoRenew(False)
            												  .withRenewalDate(system.today().addDays(100))
                                                              .withExpiryDate(system.today().addDays(200))
       	   												 	  .insertContract();

        //3. Upcoming expiry on cancelled contract -> rule check should not be created
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a.Id)
           												  	  .withStatus('Cancelled')
           												  	  .withCancelDate(date.parse('01/01/2013'))            												  
              												  .withAutoRenew(False)
                                                              .withExpiryDate(system.today().addDays(100))
       	   												 	  .insertContract();

        //4. Renewal in the past -> rule check should be created
        //   Upcoming expiry -> rule check should be created
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a.Id)
              												  .withAutoRenew(False)
            												  .withRenewalDate(system.today().addDays(-1))
                                                              .withExpiryDate(system.today().addDays(100))
       	   												 	  .insertContract();

        //Insert an invoice for each contract
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
              													  .withNumber('123') //This sets the invoiced flag
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
              													  .withNumber('123')
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
              													  .withNumber('123')
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con4.Id)
              													  .withNumber('123')
            												      .insertInvoice();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE Optima_Customer_Code__c = :a.Optima_Customer_Code__c
                                     AND RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 3 records
        System.assertEquals(3, rules.size());
        
        //Assert that each record is for the correct product
        System.assertEquals(con4.Product__c, rules[0].Product__c);
        System.assertEquals(con2.Product__c, rules[1].Product__c);
        System.assertEquals(con4.Product__c, rules[2].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('No contract in place since ' + system.today().addDays(-1).format() + '. Renewal or new agreement required', rules[0].Message__c);
        System.assertEquals('Physical contract renewal required within six months: ' + system.today().addDays(100).format(), rules[1].Message__c);
        System.assertEquals('New contract required within six months: ' + system.today().addDays(100).format(), rules[2].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest8() {
    //============================================================================================
        //Check rules 20-24 (missing account information)
        //All of the fields we are checking here are populated for the other tests in this class, 
        //so we don't need to explicitly check here that populated data doesn't produce any messages
        
    	//Get the record type ID we will be using        
    	RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Contract'];

        //Create Test Records. The accounts have to have a contract for the message to appear

    	//1. Missing support meeting, timezone, maintenance processes details and predict technical requirements details
    	//   -> four rule checks should be created for the active contract
    	//   -> no rule checks should be created for the cancelled contract
    	//   -> no rule checks should be created for the missing live technical requirements details, because there is no live contract
        
        //(not using OptimaAccountTestData here because it would require so many extra "with" functions to override the default
        //field values, and it's not worth setting them up just for this test)
        Account a = new Account();
        a.Name = 'Test Name';
        a.Optima_Customer_Code__c = 'Test Code 1';
        a.Site = 'Timbuctu';
        a.Type = 'Test Type';
        a.Vertical__c = 'Test Vertical';
        a.BillingCountry = 'United States';
        insert a;
        
        {
          Contact c = OptimaContactTestData.Instance.withAccount(a.Id)
                            		                .insertContact();
        }

        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Predict')
       	   												 	 .insertContract();
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .withProduct('Live')
           												  	  .withStatus('Cancelled')
           												  	  .withCancelDate(date.parse('01/01/2013'))            												  
       	   												 	  .insertContract();
               
    	//2. Some data populated
    	//   -> one rule check should be created for the "to be organised" meeting status (only for the active contract)
    	//   -> two rule checks should be created for the missing maintenance processes version (not for the theatre contract)
    	//   -> one rule check should be created for the missing live technical requirements date (only for the live contract)
    	//   -> one rule check should be created for the missing predict technical requirements date (only for the predict contract)
        Account a2 = new Account();
        a2.Name = 'Test Name2';
        a2.Optima_Customer_Code__c = 'Test Code 2';
        a2.Site = 'Timbuctu';
        a2.Type = 'Test Type';
        a2.Vertical__c = 'Test Vertical';        
        a2.Optima_Support_Meeting__c = 'To be organised';
        a2.Timezone__c = 'UTC+12 (New Zealand)';
        a2.Optima_Mtc_Processes_Date__c = date.parse('01/01/2013');
        a2.Optima_Live_Tech_Version__c = '1.0';
        a2.BillingCountry = 'United States';
        insert a2;
        
        {
          Contact c = OptimaContactTestData.Instance.withAccount(a2.Id)
                            	                    .insertContact();
        }

        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Theatre')
       	   												 	  .insertContract();
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Live')
            												  .withStatus('Implementing')
            												  .withSupportDate(null)
       	   												 	  .insertContract();
        IMX_Contract__c con5 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Predict')
            												  .withStatus('Implementing')
            												  .withSupportDate(null)
       	   												 	  .insertContract();

		//Insert an invoice for each contract
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con2.Id)
              													  .withNumber('123') //This sets the invoiced flag
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con3.Id)
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con4.Id)
            												      .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con5.Id)
            												      .insertInvoice();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaContractCheck.checkContracts();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Product__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Product__c, Message__c, Id];

        //Assert that there should be 9 records
        System.assertEquals(9, rules.size());
        
        //Assert that each record is for the correct product
        System.assertEquals(con4.Product__c, rules[0].Product__c);
        System.assertEquals(con4.Product__c, rules[1].Product__c);
        System.assertEquals(con.Product__c, rules[2].Product__c);
        System.assertEquals(con5.Product__c, rules[3].Product__c);
        System.assertEquals(con.Product__c, rules[4].Product__c);
        System.assertEquals(con5.Product__c, rules[5].Product__c);
        System.assertEquals(con.Product__c, rules[6].Product__c);
        System.assertEquals(con.Product__c, rules[7].Product__c);
        System.assertEquals(con3.Product__c, rules[8].Product__c);
        
        //Assert that each record has the correct message
        System.assertEquals('Missing live technical requirements document details', rules[0].Message__c);
        System.assertEquals('Missing maintenance processes document details', rules[1].Message__c);
        System.assertEquals('Missing maintenance processes document details', rules[2].Message__c);
        System.assertEquals('Missing maintenance processes document details', rules[3].Message__c);
        System.assertEquals('Missing predict technical requirements document details', rules[4].Message__c);
        System.assertEquals('Missing predict technical requirements document details', rules[5].Message__c);
        System.assertEquals('No timezone information', rules[6].Message__c);
        System.assertEquals('Support meeting not organised', rules[7].Message__c);
        System.assertEquals('Support meeting not organised', rules[8].Message__c);
    }

}