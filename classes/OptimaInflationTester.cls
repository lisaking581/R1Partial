/***********************************************************************************************
 * Name:
 * Optima Inflation Tester
 * 
 * Author:
 * Jeff Arwady | Senior Consultant
 * akaCRM
 * and
 * Amanda Day | Operations Manager
 * Optima
 * 
 * Description:
 * This test class uses a method called inflTest() to create a test Account, IMX Contract,
 * and Inflation data. It simulates the JavaScript button by calling the OptimaInflation Global 
 * Class.  It then checks to make sure that the correct inflation calculations were done
 * *********************************************************************************************/

@isTest

private class OptimaInflationTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }

    //============================================================================================
    static testMethod void inflTest1() {
    //============================================================================================
	//Check that the correct inflation values are used in the calculation
        
        List<Inflation__c> inflation = new List<Inflation__c>();    
        
		//Get record type to use below        
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];

        //Create Test Records
        
        //Insert Test Account
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
	                                              .insertAccount();
        
        //Insert Test IMX Contract
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withInflationCountry('XX')
            												 .withLatestAnnualDate(date.parse('01/01/2013'))
            												 .withLatestHourlyDate(date.parse('01/01/2011'))
            												 .insertContract();

        //Insert inflation data
        
        //1. Too early - should not be used in any calculations
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2010;
        infl.Percentage__c = 1.1;
        inflation.add(infl);
        }    

        //2. Should only be used in hourly calculation
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2011;
        infl.Percentage__c = 2.2;
        inflation.add(infl);
        }
        
        //3. Should only be used in hourly calculation
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2012;
        infl.Percentage__c = 3.3;
        inflation.add(infl);
        }
        
        //4. Should be used in annual and hourly calculations
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2013;
        infl.Percentage__c = 4.4;
        inflation.add(infl);
        }
        
        //5. Should be used in annual and hourly calculations
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2014;
        infl.Percentage__c = 5.5;
        inflation.add(infl);
        }
        
        //6. Wrong country - should not be used in any calculations
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'AA';
        infl.Year__c = 2014;
        infl.Percentage__c = 9.9;
        inflation.add(infl);
        }
        
        insert inflation;
            
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaInflation.inflation();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        con = [SELECT Id, Inflation_Since_Annual_Increase__c, Inflation_Since_Hourly_Increase__c 
               FROM IMX_Contract__c WHERE Id = :con.Id];

        //Assert that the correct values were calculated
        System.assertEquals(10.1, con.Inflation_Since_Annual_Increase__c);
        System.assertEquals(16.3, con.Inflation_Since_Hourly_Increase__c);        
    }
    
    //============================================================================================   
    static testMethod void inflTest2() {
    //============================================================================================
	//Check that inflation is set to null if there is no fee history
        
        List<Inflation__c> inflation = new List<Inflation__c>();    
        
		//Get record type to use below        
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];

        //Create Test Records
        
        //Insert Test Account
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
	                                              .insertAccount();
        
        //Insert Test IMX Contract with no fee history
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withInflationCountry('XX')
            												 .withLatestAnnualDate(null)
            												 .withLatestHourlyDate(null)
            												 .insertContract();
        
        //Insert inflation data
        {
        Inflation__c infl = new Inflation__c();
        infl.Country__c = 'XX';
        infl.Year__c = 2014;
        infl.Percentage__c = 1.1;
        inflation.add(infl);
        }    
        
        insert inflation;
            
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaInflation.inflation();
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        con = [SELECT Id, Inflation_Since_Annual_Increase__c, Inflation_Since_Hourly_Increase__c 
               FROM IMX_Contract__c WHERE Id = :con.Id];

        //Assert that the correct values were calculated
        System.assertEquals(null, con.Inflation_Since_Annual_Increase__c);
        System.assertEquals(null, con.Inflation_Since_Hourly_Increase__c);        
    }
}