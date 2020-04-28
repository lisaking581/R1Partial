/**
 * @description Builder class for dealing with Contact records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public with sharing class OptimaContactTestData extends SObjectTestData {
    /**
     * @description Overridden method to set up the default
     * Contact state for OptimaContactTestData.
     * @return A map of Contact default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            Contact.FirstName => 'Jane',
            Contact.LastName => 'Smith',
            Contact.Contact_Type__c => 'Optima Predict Contact;Optima Live Contact;Optima Release Contact',
            Contact.MailingCountry => 'United States'
        };
    }

    /**
     * @description Returns the SObject type for OptimaContactTestData builder.
     * @return Contact.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    /* Create a "with" method for each property that can be set */

    /**
     * @description Sets the account on the contact.
     * @param accountId The id of the account that the contact will have.
     * @return The instance of ContactTestData.
     */
    public OptimaContactTestData withAccount(Id accountId) {
        return (OptimaContactTestData) withDynamicData(Contact.AccountId, accountId);
    }

    /**
     * @description Sets the first name on the contact.
     * @param firstName The first name that the contact will have.
     * @return The instance of OptimaContactTestData.
     */
    public OptimaContactTestData withFirstName(String firstName) {
        return (OptimaContactTestData) withDynamicData(Contact.FirstName, firstName);
    }

    /**
     * @description Sets the last name on the contact.
     * @param lastName The last name that the contact will have.
     * @return The instance of OptimaContactTestData.
     */
    public OptimaContactTestData withLastName(String lastName) {
        return (OptimaContactTestData) withDynamicData(Contact.LastName, lastName);
    }

    /**
     * @description Sets the functional role on the contact.
     * @param functionalRole The functional role that the contact will have.
     * @return The instance of ContactTestData.
     */
    public OptimaContactTestData withContactType(String contactType) {
        return (OptimaContactTestData) withDynamicData(Contact.Contact_Type__c, contactType);
    }

    /**
     * @description Sets the mailing country on the contact.
     * @param mailingCountry The mailing country that the contact will have.
     * @return The instance of OptimaContactTestData.
     */
    public OptimaContactTestData withMailingCountry(String mailingCountry) {
        return (OptimaContactTestData) withDynamicData(Contact.MailingCountry, mailingCountry);
    }

    /**
     * @description Builds the Contact object.
     * @return The created Contact object.
     */
    public Contact create() {
        return (Contact)super.buildWithReset();
    }

    /**
     * @description Inserts the built Contact object.
     * @return The inserted Contact object.
     */
    public Contact insertContact() {
        return (Contact)super.insertRecord();
    }

    /**
     * @description Gets an instance of OptimaContactTestData.
     * @return OptimaContactTestData instance.
     */
    private static OptimaContactTestData instancePriv = null;
    public static OptimaContactTestData Instance {
        get {
            if (instancePriv == null) {
                instancePriv = new OptimaContactTestData();
            }
            return instancePriv;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private OptimaContactTestData() {
        super();
    }
}