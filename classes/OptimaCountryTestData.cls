/**
 * @description Builder class for dealing with Country__c records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public with sharing class OptimaCountryTestData extends SObjectTestData {
    /**
     * @description Overridden method to set up the default
     * Country state for OptimaCountryTestData.
     * @return A map of Country__c default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            Country__c.Name => 'United States',
            Country__c.ISO_Code__c => 'US',
            Country__c.ISO3_Code__c => 'USA'
        };
    }

    /**
     * @description Returns the SObject type for OptimaCountryTestData builder.
     * @return Country__c.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return Country__c.SObjectType;
    }

    /* Create a "with" method for each property that can be set */
    
    /**
     * @description Sets the name on the country.
     * @param name The name that the country will have.
     * @return The instance of OptimaCountryTestData.
     */
    public OptimaCountryTestData withName(String name) {
        return (OptimaCountryTestData) withDynamicData(Country__c.Name, name);
    }

    /**
     * @description Sets the ISO 3 Code on the country.
     * @param iso3Code The ISO 3 Code that the country will have.
     * @return The instance of OptimaCountryTestData.
     */
    public OptimaCountryTestData withISO3Code(String iso3Code) {
        return (OptimaCountryTestData) withDynamicData(Country__c.ISO3_Code__c, iso3Code);
    }

    /**
     * @description Sets the ISO Code on the country.
     * @param isoCode The ISO Code that the country will have.
     * @return The instance of OptimaCountryTestData.
     */
    public OptimaCountryTestData withISOCode(String isoCode) {
        return (OptimaCountryTestData) withDynamicData(Country__c.ISO_Code__c, isoCode);
    }
    
    /**
     * @description Builds the Country__c object.
     * @return The created Country__c object.
     */
    public Country__c create() {
        return (Country__c)super.buildWithReset();
    }

    /**
     * @description Inserts the built Country__c object.
     * @return The inserted Country__c object.
     */
    public Country__c insertCountry() {
        return (Country__c)super.insertRecord();
    }

    /**
     * @description Gets an instance of OptimaCountryTestData.
     * @return OptimaCountryTestData instance.
     */
    private static OptimaCountryTestData instancePriv = null;
    public static OptimaCountryTestData Instance {
        get {
            if (instancePriv == null) {
                instancePriv = new OptimaCountryTestData();
            }
            return instancePriv;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private OptimaCountryTestData() {
        super();
    }
}