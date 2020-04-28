/**
 * @description Builder class for dealing with IMX_Contract__c records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public with sharing class OptimaContractTestData extends SObjectTestData {

	//Get the record type ID we will be using        
    RecordType rtContract = [SELECT Id FROM RecordType WHERE SObjectType = 'IMX_Contract__c' AND DeveloperName = 'Optima_Contract'];

    /**
     * @description Overridden method to set up the default
     * Contract state for OptimaContractTestData.
     * @return A map of contract default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            IMX_Contract__c.Product__c => 'Predict',
            IMX_Contract__c.Status__c => 'Active',
            IMX_Contract__c.Currency__c => 'USD',
            IMX_Contract__c.Invoices__c => 1,
            IMX_Contract__c.Support_Start_Date__c => date.parse('01/01/2013'),
            IMX_Contract__c.Contract_Start_Date__c => date.parse('01/01/2013'),
            IMX_Contract__c.Latest_Annual_Fee_History_Amount__c => 100000,
            IMX_Contract__c.Latest_Hourly_Fee_History_Amount__c => 100,
            IMX_Contract__c.Latest_Annual_Fee_History_Date__c => date.parse('01/01/2013'),
            IMX_Contract__c.Latest_Hourly_Fee_History_Date__c => date.parse('01/01/2013'),
            IMX_Contract__c.Next_Invoice_Date__c => date.parse('01/01/2014'),
            IMX_Contract__c.Annual_Increase_Conditions__c => 'none',
            IMX_Contract__c.Hourly_Increase_Conditions__c => 'lots',
            IMX_Contract__c.PO_Status__c => 'Not required',
            IMX_Contract__c.Auto_Renew__c => True,
            IMX_Contract__c.RecordTypeId => rtContract.Id
        };
    }

    /**
     * @description Returns the SObject type for OptimaContractTestData builder.
     * @return IMX_Contract__c.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return IMX_Contract__c.SObjectType;
    }

    /* Create a "with" method for each property that can be set */

    /**
     * @description Sets the account on the contract.
     * @param accountID The accountId that the contract will have.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withAccountId(Id accountId) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Account__c, accountId);
    }
    
    /**
     * @description Sets the product on the contract.
     * @param product The product that the contract will have.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withProduct(String product) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Product__c, product);
    }

    /**
     * @description Sets the status on the contract.
     * @param status The status that the contract will have.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withStatus(String status) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Status__c, status);
    }

    /**
     * @description Sets the region on the contract.
     * @param region The region that the contract will have.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withRegion(String region) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Region__c, region);
    }

    /**
     * @description Sets the inflation country on the contract.
     * @param inflationCountry The code of the country that should be used for inflation for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withInflationCountry(String inflationCountry) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Inflation_Country__c, inflationCountry);
    }

    /**
     * @description Sets the contract start date on the contract.
     * @param contractDate The date the contract was signed.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withContractDate(Date contractDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Contract_Start_Date__c, contractDate);
    }

    /**
     * @description Sets the support start date on the contract.
     * @param supportDate The date support started for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withSupportDate(Date supportDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Support_Start_Date__c, supportDate);
    }

    /**
     * @description Sets the cancellation date on the contract.
     * @param cancelDate The date the contract was cancelled.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withCancelDate(Date cancelDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Cancel_Date__c, cancelDate);
    }

    /**
     * @description Sets the latest annual fee history date on the contract.
     * @param annualDate The date of the latest annual increase for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withLatestAnnualDate(Date latestAnnualDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Latest_Annual_Fee_History_Date__c, latestAnnualDate);
    }
    
    /**
     * @description Sets the latest annual fee history amount on the contract.
     * @param annualAmount The amount of the latest annual fee for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withLatestAnnualAmount(Integer latestAnnualAmount) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Latest_Annual_Fee_History_Amount__c, latestAnnualAmount);
    }
    
    /**
     * @description Sets the latest hourly fee history date on the contract.
     * @param hourlyDate The date of the latest hourly increase for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withLatestHourlyDate(Date latestHourlyDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Latest_Hourly_Fee_History_Date__c, latestHourlyDate);
    }

    /**
     * @description Sets the latest hourly fee history amount on the contract.
     * @param hourlyAmount The amount of the latest hourly fee for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withLatestHourlyAmount(Integer latestHourlyAmount) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Latest_Hourly_Fee_History_Amount__c, latestHourlyAmount);
    }
    
    /**
     * @description Sets the next invoice date on the contract.
     * @param invoiceDate The date of the next invoice for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withNextInvoiceDate(Date nextInvoiceDate) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Next_Invoice_Date__c, nextInvoiceDate);
    }

    /**
     * @description Sets the road tune frequency on the contract.
     * @param roadTunes The frequency of road tunes for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withRoadTunes(Integer roadTunes) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Road_Tunes_months__c, roadTunes);
    }

    /**
     * @description Sets the sim tune frequency on the contract.
     * @param simTunes The frequency of sim tunes for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withSimTunes(Integer simTunes) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Sim_Tunes_months__c, simTunes);
    }

    /**
     * @description Sets the retune conditions on the contract.
     * @param retuneConditions The conditions that apply to retunes for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withRetuneConditions(String retuneConditions) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Retune_Conditions__c, retuneConditions);
    }

    /**
     * @description Sets the annual increase conditions on the contract.
     * @param annualConditions The conditions that apply to annual fee increases for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withAnnualConditions(String annualConditions) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Annual_Increase_Conditions__c, annualConditions);
    }

    /**
     * @description Sets the hourly increase conditions on the contract.
     * @param hourlyConditions The conditions that apply to hourly fee increases for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withHourlyConditions(String hourlyConditions) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Hourly_Increase_Conditions__c, hourlyConditions);
    }

    /**
     * @description Sets the contract problems.
     * @param problems The problems that need to be resolved for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withContractProblems(String problems) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Contract_Problems__c, problems);
    }

    /**
     * @description Sets the purchase order status.
     * @param status The status of the purchase order for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withPOStatus(String status) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.PO_Status__c, status);
    }
            
    /**
     * @description Sets the purchase order expiry.
     * @param expiry The expiry date of the purchase order for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withPOExpiry(Date expiry) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.PO_Expiry__c, expiry);
    }
            
    /**
     * @description Sets the purchase order process.
     * @param process The process for getting a purchase order for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withPOProcess(String process) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.PO_Process__c, process);
    }
            
    /**
     * @description Sets the aauto renew flag for the contract.
     * @param auto The auto-renewal flag for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withAutoRenew(Boolean auto) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Auto_Renew__c, auto);
    }
            
    /**
     * @description Sets the contract renewal date.
     * @param renewal The renewal date for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withRenewalDate(Date renewal) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Renewal_Date__c, renewal);
    }
            
    /**
     * @description Sets the contract expiry date.
     * @param expiry The expiry date for this contract.
     * @return The instance of OptimaContractTestData.
     */
    public OptimaContractTestData withExpiryDate(Date expiry) {
        return (OptimaContractTestData) withDynamicData(IMX_Contract__c.Expiry_Date__c, expiry);
    }
                
    /**
     * @description Builds the IMX_Contract__c object.
     * @return The created IMX_Contract__c object.
     */
    public IMX_Contract__c create() {
        return (IMX_Contract__c)super.buildWithReset();
    }

    /**
     * @description Inserts the built IMX_Contract__c object.
     * @return The inserted IMX_Contract__c object.
     */
    public IMX_Contract__c insertContract() {
        return (IMX_Contract__c)super.insertRecord();
    }
    
    /**
     * @description Inserts a contract using only the default values.
     * @return The inserted contract.
     */
    public IMX_Contract__c insertDefaultContract() {
        return (IMX_Contract__c) insertDefaultRecord();
    }
    
    /**
     * @description Insert the specified number of contracts.
     * @param numberOfContractsToInsert The number of contracts to insert.
     * @return The contracts that were inserted.
     */
    public List<IMX_Contract__c> insertContracts(Integer numberOfContractsToInsert) {
        return (List<IMX_Contract__c>) insertRecords(numberOfContractsToInsert);
    }
    
    /**
     * @description Gets an instance of OptimaContractTestData.
     * @return OptimaContractTestData instance.
     */
    private static OptimaContractTestData instancePriv = null;
    public static OptimaContractTestData Instance {
        get {
            if (instancePriv == null) {
                instancePriv = new OptimaContractTestData();
            }
            return instancePriv;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private OptimaContractTestData() {
        super();
    }
}