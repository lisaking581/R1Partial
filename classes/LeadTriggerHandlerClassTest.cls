@isTest
public with sharing class LeadTriggerHandlerClassTest {
    private static final String USA_FULL_NAME = 'United States';
    
    @testSetup
    static void testSetup() {
        Country__c usa = new Country__c(Name = USA_FULL_NAME, ISO_Code__c='US', ISO3_Code__c='USA');
        insert usa;
    }
    
    @isTest
    static void newLead_productOfInterestEmpty_expectPOIForOpportunityEmptyTest() {
        Lead newLead = buildLead();
        newLead.Product_of_Interest_POI__c = null;

        insert newLead;

        assertPOIForOppConversionBlank(newLead.Id);
    }

    @isTest
    static void newLead_productOfInterestPopulated_expectPOIForOpportunityPopulatedTest() {
        Lead newLead = buildLead();
        
        String productOfInterest = getFirstValidProductOfInterestPicklistValue();
        newLead.Product_of_Interest_POI__c = productOfInterest;

        insert newLead;

        assertPOIForOppConversionContains(productOfInterest, newLead.Id);
    }
    
    @isTest
    static void updateLead_productOfInterestPopulated_expectPOIForOpportunityPopulatedTest() {
        Lead newLead = buildLead();
        insert newLead;
        
        assertPOIForOppConversionBlank(newLead.Id);

        String productOfInterest = getFirstValidProductOfInterestPicklistValue();
        newLead.Product_of_Interest_POI__c = productOfInterest;

        update newLead;

        assertPOIForOppConversionContains(productOfInterest, newLead.Id);
    }

    @isTest
    static void updateLead_productOfInterestEmptied_expectPOIForOpportunityEmptiedTest() {
        Lead newLead = buildLead();
        
        String productOfInterest = getFirstValidProductOfInterestPicklistValue();
        newLead.Product_of_Interest_POI__c = productOfInterest;
        
        insert newLead;
        
        assertPOIForOppConversionContains(productOfInterest, newLead.Id);

        newLead.Product_of_Interest_POI__c = null;
        update newLead;

        assertPOIForOppConversionBlank(newLead.Id);
    }
    
    static Lead buildLead() {
        Lead newLead = new Lead();

        newLead.LastName = 'Test';
        newLead.Country = USA_FULL_NAME;
        newLead.Company = 'Test Company';

        return newLead;
    }
    
    static Lead getLeadById(Id leadId) {
        return
        [SELECT Id,
                Name,
                Product_of_Interest_POI__c,
                POI_for_Opp_Conversion__c
           FROM Lead
          WHERE Id = :leadId];
    }
    
    static void assertPOIForOppConversionBlank(Id leadId) {
        Lead l = getLeadById(leadId);
        
        system.assert(String.isBlank(l.POI_for_Opp_Conversion__c), 'The POI for Opp Conversion is not blank. Value: ' + l.POI_for_Opp_Conversion__c);
    }
    
    static void assertPOIForOppConversionContains(String expectedProductOfInterest, Id leadId) {
        Lead l = getLeadById(leadId);
        
        system.assert(String.isNotBlank(l.POI_for_Opp_Conversion__c), 'The POI for Opp Conversion is blank and should not be.');
        system.assert(l.POI_for_Opp_Conversion__c.contains(expectedProductOfInterest), 'The POI for Opp Conversion does not contain "' + expectedProductOfInterest + '"');
    }
    
    static String getFirstValidProductOfInterestPicklistValue() {
        Schema.DescribeFieldResult fieldResult = Lead.Product_of_Interest_POI__c.getDescribe();
        List<Schema.PicklistEntry> ples = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry picklistVal : ples){
            if (picklistVal.isActive()) {
                return picklistVal.getValue();
            }
        }
        
        return '';
    }
}