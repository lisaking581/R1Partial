/***********************************************************************************************
 * Name:
 * Optima Release Check Tester
 * 
 * Author:
 * Amanda Day | Optima
 * 
 * Description:
 * This test class uses methods called ruleTestX() to create test Releases
 * It simulates the JavaScript button by calling the OptimaReleaseCheck Global Class.  
 * It then checks to make sure that the correct Rule Checks have been created.
 * *********************************************************************************************/

@isTest

private class OptimaReleaseCheckTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }

    //============================================================================================
    static testMethod void ruleTest1() {
    //============================================================================================
        //Check individual release rules
        
        //Get the record type ID we will be using        
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Create Test Records

		//Insert Internal Releases				
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.2';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addMonths(3);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.2';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addMonths(3);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.9';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(5);
            intl.Last_Release_Date__c = system.today().addMonths(8);
            insert intl;
        }
            
        //Insert Test Accounts and IMX Contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Predict')
            												 .insertContract();
        IMX_Contract__c con1 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .withProduct('Live')
            												  .withStatus('Cancelled')
            												  .withCancelDate(date.parse('01/01/2013'))
            												  .insertContract();

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Live')
            												  .withStatus('Implementing')
            												  .withSupportDate(null)
            												  .insertContract();
        
        //Insert Test Releases
        //1. Projected release within two months -> rule check should be created
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.2')
                										   .withStatus('Projected')
                										   .withTestDate(system.today())
            											   .withReleaseDate(system.today().addMonths(1))
            											   .insertRelease();
        }
        
        //2. Future release on cancelled contract -> rule check should be created
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('1.2')
                										   .withStatus('Projected')
                										   .withTestDate(system.today())
            											   .withReleaseDate(system.today().addMonths(1))
            											   .insertRelease();
        }

        //3. In Production release for cancelled customer -> rule check should be created
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
                										   .with64BitServices(True)
            											   .insertRelease();
        }
        
        //4. Multiple releases with same version number -> rule check should be created
        //   Missing patch flag -> rule check should be created
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('Planned')
                										   .withTestDate(system.today().addMonths(-13))
            											   .withReleaseDate(system.today().addMonths(-12))
                										   .with64BitServices(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('Planned')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
                										   .with64BitServices(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.1')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(5))
            											   .withReleaseDate(system.today().addMonths(6))
            											   .insertRelease();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaReleaseCheck.checkReleases();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Version__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];

        //Assert that there should be 5 records
        System.assertEquals(5, rules.size());
        
        //Assert that the records are for the correct customer
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[4].Optima_Customer_Code__c);

        //Assert that the records are for the correct product
        System.assertEquals('Live', rules[0].Product__c);
        System.assertEquals('Live', rules[1].Product__c);
        System.assertEquals('Predict', rules[2].Product__c);
        System.assertEquals('Live', rules[3].Product__c);
        System.assertEquals('Live', rules[4].Product__c);
        
        //Assert that the records are for the correct version
        System.assertEquals('1.2', rules[0].Version__c);
        System.assertEquals('1.9.0', rules[1].Version__c);
        System.assertEquals('1.2', rules[2].Version__c);
        System.assertEquals('1.9.1', rules[3].Version__c);
        System.assertEquals('1.9.0', rules[4].Version__c);
        
        //Assert that the records have the correct message
        System.assertEquals('Future release for cancelled customer', rules[0].Message__c);
        System.assertEquals('In Production release for cancelled customer', rules[1].Message__c);
        System.assertEquals('Projected release less than two months from now', rules[2].Message__c);
        System.assertEquals('Missing patch flag', rules[3].Message__c);
        System.assertEquals('Multiple releases with the same version number', rules[4].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest2() {
    //============================================================================================
        //Check overall customer and product rules (release counts by status)
        
        //Get the record type ID we will be using        
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Create Test Records
        
    	//Insert Internal Releases				
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.2';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(4);
            intl.Last_Release_Date__c = system.today().addMonths(7);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.3';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(5);
            intl.Last_Release_Date__c = system.today().addMonths(8);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.2';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(12);
            intl.Last_Release_Date__c = system.today().addMonths(15);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.4';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addMonths(3);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.9';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addMonths(3);
            insert intl;
        }

        //Insert Test Accounts and IMX Contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Predict')
            												 .insertContract();

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Predict')
            												  .insertContract();       
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Live')
            												  .insertContract();

        //Insert Test Releases
        //1. Same product -> rule check should be created for multiple projected releases
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.2')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(4))
            											   .withReleaseDate(system.today().addMonths(5))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.3')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(5))
            											   .withReleaseDate(system.today().addMonths(6))
            											   .insertRelease();
        }

        //2. Same product -> rule check should be created for multiple releases in production
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.3.9')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-13))
            											   .withReleaseDate(system.today().addMonths(-12))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.4.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
            											   .insertRelease();
        }
        
        //3. Different products and non-projected status -> rule checks should not be created
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.2')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(12))
            											   .withReleaseDate(system.today().addMonths(13))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Not Predict')
                										   .withVersion('2.3')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(12))
            											   .withReleaseDate(system.today().addMonths(13))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.4')
                										   .withStatus('Tentative')
                										   .withTestDate(system.today())
            											   .withReleaseDate(system.today().addMonths(1))
            											   .insertRelease();
        }
        
        //4. No projected or tentative releases for product -> rule check should be created
        //(there must be a completed release for this rule check to be created)
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('Delivered')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .with64BitServices(True)
            											   .insertRelease();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaReleaseCheck.checkReleases();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Version__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 3 records
        System.assertEquals(3, rules.size());
        
        //Assert that the records are for the correct customer
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);

        //Assert that the records are for the correct product
        System.assertEquals('Predict', rules[0].Product__c);
        System.assertEquals('Predict', rules[1].Product__c);
        System.assertEquals('Live', rules[2].Product__c);
        
        //Assert that the records are for the correct version
        System.assertEquals(null, rules[0].Version__c);
        System.assertEquals(null, rules[1].Version__c);
        System.assertEquals(null, rules[2].Version__c);
        
        //Assert that the records have the correct message
        System.assertEquals('Multiple projected releases', rules[0].Message__c);
        System.assertEquals('Multiple releases in production', rules[1].Message__c);
        System.assertEquals('No projected or tentative releases', rules[2].Message__c);
    }
    
    //============================================================================================
    static testMethod void ruleTest3() {
    //============================================================================================
        //Check overall customer and product rules (time between releases)
        
        //Get the record type ID we will be using        
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Create Test Records

    	//Insert Internal Releases				
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.0';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addMonths(3);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.6';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(1);
            intl.Last_Release_Date__c = system.today().addMonths(4);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.7';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(4);
            intl.Last_Release_Date__c = system.today().addMonths(7);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.6';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(2);
            intl.Last_Release_Date__c = system.today().addMonths(5);
            insert intl;
        }
        
        //Insert Test Accounts and IMX Contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Predict')
            												 .insertContract();       
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .withProduct('Live')
            												  .insertContract();       

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Predict')
            												  .insertContract();       
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Live')
            												  .insertContract();       
        
        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST3')
            									   .insertAccount();
        IMX_Contract__c con5 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Predict')
                											  .withRoadTunes(4)
                											  .withSimTunes(6)
                											  .withRetuneConditions('all-inclusive')
            												  .insertContract();       

        //Insert Test Releases
        //1. Projected release more than 13 months after full -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-13))
            											   .withReleaseDate(system.today().addMonths(-12))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.0.1')
                										   .withStatus('Planned')
                										   .withTestDate(system.today())
            											   .withReleaseDate(system.today().addMonths(2))
                										   .withPatch(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(1))
            											   .withReleaseDate(system.today().addMonths(2))
            											   .insertRelease();
        }
               
        //2. Projected release less than 11 months after current -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
                										   .with64BitServices(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(3))
            											   .withReleaseDate(system.today().addMonths(4))
            											   .insertRelease();
        }

        //3. Projected release 12 months after current -> rule check should not be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.7')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(5))
            											   .withReleaseDate(system.today().addMonths(6))
            											   .insertRelease();
        }

        //4. Projected release less than 11 months after current with infrequent retunes -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-7))
            											   .withReleaseDate(system.today().addMonths(-6))
                										   .with64BitServices(True)
                										   .withRoadTune(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Live')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(3))
            											   .withReleaseDate(system.today().addMonths(4))
            											   .insertRelease();
        }

        //5. Projected release 3 months after current, 4 months required for frequent retunes -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a3.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a3.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(1))
            											   .withReleaseDate(system.today().addMonths(2))
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }

        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaReleaseCheck.checkReleases();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Version__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 4 records
        System.assertEquals(4, rules.size());
        
        //Assert that the records are for the correct customer
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);

        //Assert that the records are for the correct product
        System.assertEquals('Live', rules[0].Product__c);
        System.assertEquals('Predict', rules[1].Product__c);
        System.assertEquals('Live', rules[2].Product__c);
        System.assertEquals('Predict', rules[3].Product__c);
        
        //Assert that the records are for the correct version
        System.assertEquals(null, rules[0].Version__c);
        System.assertEquals(null, rules[1].Version__c);
        System.assertEquals(null, rules[2].Version__c);
        System.assertEquals(null, rules[3].Version__c);
        
        //Assert that the records have the correct message
        System.assertEquals('Less than 11 months projected between releases', rules[0].Message__c);
        System.assertEquals('More than 13 months projected between releases', rules[1].Message__c);
        System.assertEquals('Less than 11 months projected between releases', rules[2].Message__c);
        System.assertEquals('Less than 4 months projected between releases', rules[3].Message__c);
    }

    //============================================================================================
    static testMethod void ruleTest4() {
    //============================================================================================
        //Check overall customer and product rules (required retunes)
        
        //Get the record type ID we will be using        
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Create Test Records

    	//Insert Internal Releases				
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.6';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(10);
            intl.Last_Release_Date__c = system.today().addMonths(13);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '3.6';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today().addMonths(10);
            intl.Last_Release_Date__c = system.today().addMonths(13);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.6';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(10);
            intl.Last_Release_Date__c = system.today().addMonths(13);
            insert intl;
        }
        
        //Insert Test Accounts and IMX Contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Predict')
                											 .withRoadTunes(12)
                											 .withSimTunes(12)
                											 .withRetuneConditions('all-inclusive')
            												 .insertContract();       
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .withProduct('Live')
                											  .withRoadTunes(12)
            												  .insertContract();       

        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST2')
            									   .insertAccount();
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Predict')
                											  .withRoadTunes(6)
                											  .withSimTunes(6)
                											  .withRetuneConditions('all-inclusive')
            												  .insertContract();       

        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST3')
            									   .insertAccount();
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Predict')
                											  .withRoadTunes(12)
                											  .withSimTunes(12)
                											  .withRetuneConditions('all-inclusive')
            												  .insertContract();       
        
        //Insert Test Releases
        //1. Road tune missing from projected release -> rule check should be generated
        //   Sim tune missing from projected release -> rule check should not be generated for Live
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .with64BitServices(True)
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(10))
            											   .withReleaseDate(system.today().addMonths(11))
            											   .insertRelease();
        }

        //2. No historic road tune -> rule check should be generated        
		//   No historic sim tune -> rule check should be generated        
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Predict')
                										   .withVersion('3.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(10))
            											   .withReleaseDate(system.today().addMonths(11))
            											   .insertRelease();
        }

        //3. Too long between road tunes -> rule check should be generated
        //   Too long between sim tunes -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a2.Id)
            											   .withProduct('Predict')
                										   .withVersion('3.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(10))
            											   .withReleaseDate(system.today().addMonths(11))
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }

        //4. Sim tune missing from projected release -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a3.Id)
            											   .withProduct('Predict')
                										   .withVersion('1.9.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .withRoadTune(True)
                										   .withSimTune(True)
            											   .insertRelease();
        }
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a3.Id)
            											   .withProduct('Predict')
                										   .withVersion('2.6')
                										   .withStatus('Projected')
                										   .withTestDate(system.today().addMonths(10))
            											   .withReleaseDate(system.today().addMonths(11))
                										   .withRoadTune(True)
            											   .insertRelease();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaReleaseCheck.checkReleases();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Version__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 6 records
        System.assertEquals(6, rules.size());
        
        //Assert that the records are for the correct customer
        System.assertEquals(a.Optima_Customer_Code__c, rules[0].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a2.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);        
        System.assertEquals(a2.Optima_Customer_Code__c, rules[4].Optima_Customer_Code__c);
        System.assertEquals(a3.Optima_Customer_Code__c, rules[5].Optima_Customer_Code__c);
        
        //Assert that the records are for the correct product
        System.assertEquals('Live', rules[0].Product__c);
        System.assertEquals('Predict', rules[1].Product__c);
        System.assertEquals('Predict', rules[2].Product__c);
        System.assertEquals('Predict', rules[3].Product__c);
        System.assertEquals('Predict', rules[4].Product__c);
        System.assertEquals('Predict', rules[5].Product__c);
        
        //Assert that the records are for the correct version
        System.assertEquals(null, rules[0].Version__c);
        System.assertEquals(null, rules[1].Version__c);
        System.assertEquals(null, rules[2].Version__c);
        System.assertEquals(null, rules[3].Version__c);
        System.assertEquals(null, rules[4].Version__c);
        System.assertEquals(null, rules[5].Version__c);
        
        //Assert that the records have the correct message
        System.assertEquals('Required road retune missing from future release', rules[0].Message__c);
        System.assertEquals('No previous road tune found (contractual requirement)', rules[1].Message__c);
        System.assertEquals('No previous sim tune found (contractual requirement)', rules[2].Message__c);
        System.assertEquals('Too long between required road retunes', rules[3].Message__c);
        System.assertEquals('Too long between required sim retunes', rules[4].Message__c);
        System.assertEquals('Required sim retune missing from future release', rules[5].Message__c);
    }        

    //============================================================================================
    static testMethod void ruleTest5() {
    //============================================================================================
        //Check internal release rules
        
        //Get the record type ID we will be using        
        RecordType rtRule = [SELECT Id FROM RecordType WHERE SObjectType = 'Rule_Check__c' AND DeveloperName = 'Release'];

        //Create Test Records

    	//Insert Internal Releases
    	//Predict internal releases used to check internal-only rules		
        {
            //1. Internal release window too short -> rule check should be generated
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.0';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addDays(85);
            insert intl;
        }
        {
            //2. Internal release window correct -> rule check should not be generated
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.0';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addDays(90);
            insert intl;
        }
        {
         	//3. Internal release window too long -> rule check should be generated
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '3.0';
            intl.Product__c = 'Predict';
            intl.First_Release_Date__c = system.today();
            intl.Last_Release_Date__c = system.today().addDays(95);
            insert intl;
        }
        
        //Live internal releases used to check internal vs external rules
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '1.0';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(3);
            intl.Last_Release_Date__c = system.today().addMonths(6).addDays(-1);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '2.0';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(6);
            intl.Last_Release_Date__c = system.today().addMonths(9).addDays(-1);
            insert intl;
        }
        {
            Internal_Release__c intl = new Internal_Release__c();
            intl.Name = '3.0';
            intl.Product__c = 'Live';
            intl.First_Release_Date__c = system.today().addMonths(9);
            intl.Last_Release_Date__c = system.today().addMonths(12).addDays(-1);
            insert intl;
        }
        
        //Insert Test Accounts and IMX Contracts
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
            									  .insertAccount();
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Live')
            												 .insertContract();       
        
        //Insert Test Releases (internal release rules are only checked on full releases, so these can't be set up as patches)
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('0.1.0')
                										   .withStatus('In Production')
                										   .withTestDate(system.today().addMonths(-2))
            											   .withReleaseDate(system.today().addMonths(-1))
                										   .with64BitServices(True)
            											   .insertRelease();
        }

        //4. Customer release before internal release window -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('1.0.1')
                										   .withStatus('Tentative')
                										   .withTestDate(system.today().addMonths(1))
            											   .withReleaseDate(system.today().addMonths(2))
            											   .insertRelease();
        }

        //5. Customer release in internal release window -> rule check should not be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('2.0.2')
                										   .withStatus('Tentative')
                										   .withTestDate(system.today().addMonths(7))
            											   .withReleaseDate(system.today().addMonths(8))
            											   .insertRelease();
        }

        //6. Customer release after internal release window -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('3.0.3')
                										   .withStatus('Tentative')
                										   .withTestDate(system.today().addMonths(13))
            											   .withReleaseDate(system.today().addMonths(14))
            											   .insertRelease();
        }

        //7. Customer release missing from internal release schedule -> rule check should be generated
        {
        	Release__c rel = OptimaReleaseTestData.Instance.withAccountId(a.Id)
            											   .withProduct('Live')
                										   .withVersion('2.1')
                										   .withStatus('Tentative')
                										   .withTestDate(system.today().addMonths(10))
            											   .withReleaseDate(system.today().addMonths(12))
            											   .insertRelease();
        }
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaReleaseCheck.checkReleases();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Rule_Check__c> rules = [SELECT Id, Optima_Customer_Code__c, Product__c, Version__c, Message__c FROM Rule_Check__c 
                                     WHERE RecordTypeId = :rtRule.Id ORDER BY Id ASC];
        
        //Assert that there should be 5 records
        System.assertEquals(5, rules.size());
        
        //Assert that the records are for the correct customer
        System.assertEquals(null, rules[0].Optima_Customer_Code__c);
        System.assertEquals(null, rules[1].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[2].Optima_Customer_Code__c);
        System.assertEquals(a.Optima_Customer_Code__c, rules[3].Optima_Customer_Code__c);        
        System.assertEquals(a.Optima_Customer_Code__c, rules[4].Optima_Customer_Code__c);
        
        //Assert that the records are for the correct product
        System.assertEquals('Predict', rules[0].Product__c);
        System.assertEquals('Predict', rules[1].Product__c);
        System.assertEquals('Live', rules[2].Product__c);
        System.assertEquals('Live', rules[3].Product__c);
        System.assertEquals('Live', rules[4].Product__c);
        
        //Assert that the records are for the correct version
        System.assertEquals('1.0', rules[0].Version__c);
        System.assertEquals('3.0', rules[1].Version__c);
        System.assertEquals('3.0.3', rules[2].Version__c);
        System.assertEquals('2.1', rules[3].Version__c);
        System.assertEquals('1.0.1', rules[4].Version__c);
        
        //Assert that the records have the correct message
        System.assertEquals('Internal release window not three months long', rules[0].Message__c);
        System.assertEquals('Internal release window not three months long', rules[1].Message__c);
        System.assertEquals('Customer release scheduled outside internal release window', rules[2].Message__c);
        System.assertEquals('Customer release missing from internal release schedule', rules[3].Message__c);
        System.assertEquals('Customer release scheduled outside internal release window',rules[4].Message__c);
    }        
}