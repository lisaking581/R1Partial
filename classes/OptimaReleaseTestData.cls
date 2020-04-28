/**
 * @description Builder class for dealing with Release records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public with sharing class OptimaReleaseTestData extends SObjectTestData {

	//Get a random user ID, which will be required for some of the release records
    List<User> users = [SELECT Id FROM User LIMIT 1];
    String userId = users[0].Id;

    /**
     * @description Overridden method to set up the default
     * Release state for OptimaReleaseTestData.
     * @return A map of Release default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            Release__c.Product__c => 'Live',
            Release__c.Version__c => '1.2.3',
            Release__c.Status__c => 'Planned',
            Release__c.Test_Date__c => system.today().addMonths(1),
            Release__c.Release_Date__c => system.today().addMonths(2),
            Release__c.Executable__c => True,
            Release__c.X64_bit__c => True,
            Release__c.Business_Analyst__c => userId,
            Release__c.Developer__c => userId,
            Release__c.Tester__c => userId,
            Release__c.Revision__c => 9999,
            Release__c.Jira_Ticket__c => 'OPSC-1234'
        };
    }

    /**
     * @description Returns the SObject type for OptimaReleaseTestData builder.
     * @return Release__c.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return Release__c.SObjectType;
    }

    /* Create a "with" method for each property that can be set */
    
    /**
     * @description Sets the account on the Release.
     * @param accountID The accountId that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withAccountId(Id accountId) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Account__c, accountId);
    }
    
    /**
     * @description Sets the product on the Release.
     * @param product The product that the Release is for.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withProduct(String product) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Product__c, product);
    }

    /**
     * @description Sets the version on the Release.
     * @param version The version that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withVersion(String version) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Version__c, version);
    }

    /**
     * @description Sets the status on the Release.
     * @param status The status that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withStatus(String status) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Status__c, status);
    }

    /**
     * @description Sets the test date on the Release.
     * @param testDate The date that the Release will go to test.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withTestDate(Date testDate) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Test_Date__c, testDate);
    }

    /**
     * @description Sets the release date on the Release.
     * @param releaseDate The date that the Release will be delivered.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withReleaseDate(Date releaseDate) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Release_Date__c, releaseDate);
    }

    /**
     * @description Sets the road tune flag on the Release.
     * @param roadTune The road tune flag that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withRoadTune(Boolean roadTune) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Road_Tune__c, roadTune);
    }

     /**
     * @description Sets the sim tune flag on the Release.
     * @param simTune The sim tune flag that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withSimTune(Boolean simTune) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Sim_Tune__c, simTune);
    }

     /**
     * @description Sets the patch flag on the Release.
     * @param patch The patch flag that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     */
    public OptimaReleaseTestData withPatch(Boolean patch) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.Patch__c, patch);
    }

    /**
     * @description Sets the 64-bit services flag on the Release.
     * @param X64 The 64-bit services flag that the Release will have.
     * @return The instance of OptimaReleaseTestData.
     * Unfortunately this field is required for Live releases (unless they are projected or tentative) 
     * but it's not allowed for other products, so we can't set it by default but have to set it manually for 
     * most Live releases
     */
    public OptimaReleaseTestData with64BitServices(Boolean X64) {
        return (OptimaReleaseTestData) withDynamicData(Release__c.X64_bit_Services__c, X64);
    }

    
    /**
     * @description Builds the Release object.
     * @return The created Release object.
     */
    public Release__c create() {
        return (Release__c)super.buildWithReset();
    }

    /**
     * @description Inserts the built Release object.
     * @return The inserted Release object.
     */
    public Release__c insertRelease() {
        return (Release__c)super.insertRecord();
    }

    /**
     * @description Gets an instance of OptimaReleaseTestData.
     * @return OptimaReleaseTestData instance.
     */
    private static OptimaReleaseTestData instancePriv = null;
    public static OptimaReleaseTestData Instance {
        get {
            if (instancePriv == null) {
                instancePriv = new OptimaReleaseTestData();
            }
            return instancePriv;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private OptimaReleaseTestData() {
        super();
    }
}