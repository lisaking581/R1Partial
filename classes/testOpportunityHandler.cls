@isTEst
private class testOpportunityHandler {

    @testSetup
    static void setup() {
        Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
        insert usa;
        
        Account a = new Account(Name = 'Penrod Health Care');
        a.BillingCountry = usa.ISO_Code__c;
        insert a;
        
        Opportunity o = new Opportunity( Name = 'Penrod Health - E2E',
                                         AccountId = a.Id,
                                         StageName = '1-Discover',
                                         Amount = 1000000,
                                         CloseDate = Date.today(),
                                         Vertical__c = 'IDN Solutions',
                                         Target_Market__c = 'Hospitals and Health Systems',
                                         Solution__c = 'Revenue Integrity Solutions ',
                                         Duration__c = 60,
                                         Type = 'New Business',
                                         Start_Date__c = Date.today());
                                               
        insert o;
        system.debug('record type id is ' +(o.RecordTypeId));
    }

    @isTest
    static void validateNewHistory() {
        Opportunity o = getDefaultOpportunity();

        List<Opportunity_History__c> histories = getOpportunityHistoriesByOpportunityId(o.Id);
        
        System.assertEquals(1, histories.size(), 'There should only be 1 opportunity history on insert.');
        system.assertEquals(null, histories[0].Exit_Date__c, 'The exit date should be blank.');
        system.assertEquals(null, histories[0].Exit_DateTime__c, 'The exit datetime should be blank.');
        system.assertEquals(true, histories[0].Stage_change__c, 'The stage change checkbox should be true.');
        
        
    }
    @isTest
    static void opportunityUpdated_stageHistoryChanged_expectNoNewOpportunityHistoryRecordsTest() {
        Opportunity o = getDefaultOpportunity();

        
        List<Opportunity_History__c> histories = getOpportunityHistoriesByOpportunityId(o.Id);
        Integer historiesCountBeforeSalesMilestoneChange = histories.size();
       
        o.Sales_Milestone__c = 'Interest Generated';
        update o;
        
        histories = getOpportunityHistoriesByOpportunityId(o.Id);
        
        System.assertEquals(historiesCountBeforeSalesMilestoneChange, histories.size(), 'No new opportunity history records should be creatd when the sales milestone changes.');
    }
    @isTest
    static void validateUpdatedHistory() {
        Opportunity o = getDefaultOpportunity();

        o.StageName = '2-Qualify';
        
     
        update o;
        List<Opportunity_History__c> histories = getOpportunityHistoriesByOpportunityId(o.Id);
        
        System.assertEquals(2, histories.size(), 'There should be 2 opportunity histories when the stage name changes. One from the original insert and one from the stage change.');
        
        Opportunity_History__c firstHistory = histories[0];
        system.assertEquals(Date.Today(), firstHistory.Exit_Date__c, 'The exit date was not set on the original open opportunity history.');
       
    }

  
    
    static Opportunity getDefaultOpportunity() {
        return
        [SELECT Id,
                Name,
                AccountId,
                StageName,
                Sales_Milestone__c,
                Amount,
                CloseDate
           FROM Opportunity];
    }

    static List<Opportunity_History__c> getOpportunityHistoriesByOpportunityId(Id opportunityId) {
        return
        [SELECT Id,
                Name,
                Enter_Date__c,
                Exit_Date__c,
                Milestone__c,
                Stage_History__c,
                Exit_DateTime__c,
                Enter_DateTime__c,
                Stage_change__c,
                Amount__c
           FROM Opportunity_History__c
          WHERE Opportunity__c = :opportunityId
          ORDER By Name];
    }
}