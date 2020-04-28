/**
 * @description Builder class for dealing with Account records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public class AccountTestData extends SObjectTestData {

    /**
     * @description Overridden method to set up the default
     * Account state for AccountTestData.
     * @return A map of Account default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            Account.Name => 'Test Name',
            Account.Optima_Customer_Code__c => 'Test Code 1',
            Account.Site => 'Timbuctu',
            Account.Type => 'Test Type',
            Account.Vertical__c => 'Test Vertical',
            Account.Optima_Support_Meeting__c => 'Run from NZ',
            Account.Timezone__c => 'UTC+12 (New Zealand)',
            Account.Optima_Mtc_Processes_Version__c => '1.0',
            Account.Optima_Mtc_Processes_Date__c => date.parse('01/01/2013'),
            Account.Optima_Predict_Tech_Version__c => '1.0',
            Account.Optima_Predict_Tech_Date__c => date.parse('01/01/2013'),
            Account.Optima_Live_Tech_Version__c => '1.0',
            Account.Optima_Live_Tech_Date__c => date.parse('01/01/2013'),
            Account.BillingCountry => 'United States'
        };
    }

    /**
     * @description Returns the SObject type for AccountTestData builder.
     * @return Account.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    /**
     * @description Sets the name on the account.
     * @param name The name that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withName(String name) {
        return (AccountTestData) withDynamicData(Account.Name, name);
    }
    
    /**
     * @description Sets the billing state on the account.
     * @param billingState The billing state that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withBillingState(String billingState) {
        return (AccountTestData) withDynamicData(Account.BillingState, billingState);
    }

    /**
     * @description Sets the optima customer code on the account.
     * @param optimaCustomerCode The optima customer code that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withOptimaCustomerCode(String optimaCustomerCode) {
        return (AccountTestData) withDynamicData(Account.Optima_Customer_Code__c, optimaCustomerCode);
    }

    /**
     * @description Sets the site on the account.
     * @param site The site that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withSite(String site) {
        return (AccountTestData) withDynamicData(Account.Site, site);
    }

    /**
     * @description Sets the type on the account.
     * @param type The type that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withType(String type) {
        return (AccountTestData) withDynamicData(Account.Type, type);
    }

    /**
     * @description Sets the vertical on the account.
     * @param vertical The vertical that the account will have.
     * @return The instance of AccountTestData.
     */
    public AccountTestData withVertical(String vertical) {
        return (AccountTestData) withDynamicData(Account.Vertical__c, vertical);
    }


    /* Create a "with" method for each property that can be set */
    
    /**
     * @description Builds the Account object.
     * @return The created Account object.
     */
    public Account create() {
        return (Account)super.buildWithReset();
    }

    /**
     * @description Inserts the built Account object.
     * @return The inserted Account object.
     */
    public Account insertAccount() {
        return (Account)super.insertRecord();
    }
    
    /**
     * @description Inserts an account using only the default values.
     * @return The inserted account.
     */
    public Account insertDefaultAccount() {
        return (Account) insertDefaultRecord();
    }
    
    /**
     * @description Insert the specified number of accounts.
     * @param numberOfAccountsToInsert The number of accounts to insert.
     * @return The accounts that were inserted.
     */
    public List<Account> insertAccounts(Integer numberOfAccountsToInsert) {
        return (List<Account>) insertRecords(numberOfAccountsToInsert);
    }
    
    /**
     * @description Gets an instance of AccountTestData.
     * @return AccountTestData instance.
     */
    public static AccountTestData Instance {
        get {
            if (Instance == null) {
                Instance = new AccountTestData();
            }
            return Instance;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private AccountTestData() {
        super();
    }
}