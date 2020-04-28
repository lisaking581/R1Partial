/***********************************************************************************************
 * Name:
 * Optima Note - Account Relationship Tester
 * 
 * Author:
 * Jeff Arwady | Senior Consultant
 * akaCRM
 * 
 * Description:
 * This test class uses a method called relTest() to create a test Account, IMX Contract,
 * and Optima Note that shares a Product with the IMX Contract. It simulates the 
 * JavaScript button by passing in the Optima Note Id and Optima Note Product into the
 * OptimaNoteAccountRelationship Global Class.  It then checks to make sure that an
 * Intersection Table is created that links the Account and the Optima Note together.
 * *********************************************************************************************/

@isTest

private class OptimaNoteAccRelTester {
    @testSetup
    static void testSetup() {
        OptimaCountryTestData.Instance.insertCountry();
    }

    static testMethod void relTest() {
        
        //Create Test Records
        
        //Insert Test Accounts
        Account a = OptimaAccountTestData.Instance.insertAccount();
        
        Account a2 = OptimaAccountTestData.Instance.withOptimaCustomerCode('Test Code 2')
                                             	   .insertAccount();
        
        Account a3 = OptimaAccountTestData.Instance.withOptimaCustomerCode('Test Code 3')
	                                               .insertAccount();

        //Insert Test IMX Contracts
        //1. Correct product and status -> relationship should be created
        IMX_Contract__c con = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Test Product')
            												 .withStatus('Active')
            												 .insertContract();
        
        //2. Correct product and status but duplicate for account -> relationship should not be created
        IMX_Contract__c con2 = OptimaContractTestData.Instance.withAccountId(a.Id)
            												 .withProduct('Test Product')
            												 .withStatus('Implementing')
            												 .withSupportDate(null)
            												 .insertContract();
        
        //3. Correct product and status -> relationship should be created
        IMX_Contract__c con3 = OptimaContractTestData.Instance.withAccountId(a2.Id)
            												  .withProduct('Test Product')
            												  .withStatus('Active')
            												  .insertContract();
        
        //4. Incorrect product -> relationship should not be created
        IMX_Contract__c con4 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Non-Test Product')
            												  .withStatus('Active')
            												  .insertContract();
        
        //5. Incorrect status -> relationship should not be created
        IMX_Contract__c con5 = OptimaContractTestData.Instance.withAccountId(a3.Id)
            												  .withProduct('Test Product')
            												  .withStatus('Cancelled')
            												  .withCancelDate(date.parse('01/01/2014'))
            												  .insertContract();
        
        //Insert Optima Note
        Optima_Note__c optimaNote = new Optima_Note__c();
            
        optimaNote.Title__c = 'Test Title';
        optimaNote.Product__c = 'Test Product';
        optimaNote.Detailed_Note__c = 'Test Detailed Note.';
        optimaNote.Stop_Code__c = FALSE;
            
        insert optimaNote;
        
        //Initiate Testing Procedure
        Test.startTest();
        
        OptimaNoteAccountRelationship.accountRelationship(optimaNote.Id);
        
        Test.stopTest();
        
        //Initiate Verification Procedure
        List<Account_Note__c> notes = [SELECT Id, Account__c, Optima_Note__c FROM Account_Note__c WHERE Optima_Note__c = :optimaNote.Id];
        
        //Assert that there should be 2 records instead of 5
        System.assertEquals(2, notes.size());
        
        //Assert that the first Contract was linked to the first Account
        System.assertEquals(a.Id, notes[0].Account__c);
        System.assertEquals(optimaNote.Id, notes[0].Optima_Note__c);
        
        //Assert that the third Contract was linked to the second Account
        System.assertEquals(a2.Id, notes[1].Account__c);
        System.assertEquals(optimaNote.Id, notes[1].Optima_Note__c);
        
        //Assert that we have recorded we have already created relationships for this note
        optimaNote = [SELECT Id, Stop_Code__c FROM Optima_Note__c WHERE Id = :optimaNote.Id];
        System.assertEquals(TRUE, optimaNote.Stop_Code__c);
    }
}