/***********************************************************************************************
 * Name:
 * Optima Fee History Tester
 * 
 * Author:
 * Amanda Day
 * Optima
 * 
 * Description:
 * This test class uses a method called feeTest() to create test Account, IMX Contract,
 * Optima Invoice and Fee History data. It simulates the JavaScript button by calling the 
 * OptimaFeeHistory Global Class.  It then checks to make sure that the correct updates were 
 * made to the contract.
 * *********************************************************************************************/

@isTest

public class OptimaFeeHistoryTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }

    static testMethod void feeTest() {

        //Create Test Records
        
        //Insert Test Account
        Account a = OptimaAccountTestData.Instance.withOptimaCustomerCode('CUST1')
                                            	  .insertAccount();
        
        //Insert Test Contracts
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .insertContract();
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												  .insertContract();

        //Insert invoices and fee history. By default invoices will be created for $100,000 and dated tomorrow
        //1. All fields should be updated as expected
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withDate(system.today().addDays(-1))
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
            													  .insertInvoice();
        }
        {
        	Optima_Invoice__c inv = OptimaInvoiceTestData.Instance.withContract(con.Id)
                												  .withDate(system.today().addDays(10))
            													  .insertInvoice();
        }
        
        {
        	Fee_History__c fee = new Fee_History__c();
        	fee.Master_Contract__c = con.Id;
        	fee.Amount__c = 100000;
        	fee.Effective_Date__c = system.today().addDays(-1);
            fee.Fee_Type__c = 'Annual';
        	insert fee;
        }
        {
        	Fee_History__c fee = new Fee_History__c();
        	fee.Master_Contract__c = con.Id;
        	fee.Amount__c = 200000;
        	fee.Effective_Date__c = system.today().addMonths(1);
            fee.Fee_Type__c = 'Annual';
        	insert fee;
        }
        {
        	Fee_History__c fee = new Fee_History__c();
        	fee.Master_Contract__c = con.Id;
        	fee.Amount__c = 100;
        	fee.Effective_Date__c = system.today().addDays(-1);
            fee.Fee_Type__c = 'Hourly';
        	insert fee;
        }
        {
        	Fee_History__c fee = new Fee_History__c();
        	fee.Master_Contract__c = con.Id;
        	fee.Amount__c = 200;
        	fee.Effective_Date__c = system.today().addMonths(1);
            fee.Fee_Type__c = 'Hourly';
        	insert fee;
        }       

        //2. Check that fields are updated to null if required -
        //   no invoices or fee history for second contract
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaFeeHistory.updateHistory();
        
        Test.stopTest();
        
        //Initiate Verification Procedure - test 1
        con = [SELECT Latest_Annual_Fee_History_Date__c, Latest_Hourly_Fee_History_Date__c,
               Latest_Annual_Fee_History_Amount__c, Latest_Hourly_Fee_History_Amount__c, Next_Invoice_Date__c
               FROM IMX_Contract__c WHERE Id = :con.Id];

        //Assert that the correct values were calculated
        System.assertEquals(system.today().addMonths(1),con.Latest_Annual_Fee_History_Date__c);
        System.assertEquals(system.today().addMonths(1),con.Latest_Hourly_Fee_History_Date__c);
        System.assertEquals(200000,con.Latest_Annual_Fee_History_Amount__c);
        System.assertEquals(200,con.Latest_Hourly_Fee_History_Amount__c);
        System.assertEquals(system.today().addDays(1),con.Next_Invoice_Date__c);
        
        //Initiate Verification Procedure - test 2
        con2 = [SELECT Latest_Annual_Fee_History_Date__c, Latest_Hourly_Fee_History_Date__c,
               Latest_Annual_Fee_History_Amount__c, Latest_Hourly_Fee_History_Amount__c, Next_Invoice_Date__c
               FROM IMX_Contract__c WHERE Id = :con2.Id];

        //Assert that the correct values were calculated
        System.assertEquals(null,con2.Latest_Annual_Fee_History_Date__c);
        System.assertEquals(null,con2.Latest_Hourly_Fee_History_Date__c);
        System.assertEquals(null,con2.Latest_Annual_Fee_History_Amount__c);
        System.assertEquals(null,con2.Latest_Hourly_Fee_History_Amount__c);
        System.assertEquals(null,con2.Next_Invoice_Date__c);
        
    }
}