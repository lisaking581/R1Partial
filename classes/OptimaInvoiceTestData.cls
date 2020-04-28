/**
 * @description Builder class for dealing with Optima_Invoice__c records.
 * Solely used for testing, NOT a data factory.
 **/
@isTest
public with sharing class OptimaInvoiceTestData extends SObjectTestData {
    /**
     * @description Overridden method to set up the default
     * Invoice state for OptimaInvoiceTestData.
     * @return A map of Invoice default fields.
     */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
        	Optima_Invoice__c.Invoice_Date__c => system.today().addDays(1),
        	Optima_Invoice__c.Amount__c => 100000
        };
    }

    /**
     * @description Returns the SObject type for OptimaInvoiceTestData builder.
     * @return Optima_Invoice__c.SObjectType.
     */
    protected override Schema.SObjectType getSObjectType() {
        return Optima_Invoice__c.SObjectType;
    }

    /* Create a "with" method for each property that can be set */

    /**
     * @description Sets the account on the Invoice.
     * @param accountId The id of the account that the Invoice will have.
     * @return The instance of InvoiceTestData.
     */
    public OptimaInvoiceTestData withContract(Id contractId) {
        return (OptimaInvoiceTestData) withDynamicData(Optima_Invoice__c.Master_Contract__c, contractId);
    }

    /**
     * @description Sets the date of the invoice.
     * @param invoiceDate The date the invoice is due.
     * @return The instance of OptimaInvoiceTestData.
     */
    public OptimaInvoiceTestData withDate(Date invoiceDate) {
        return (OptimaInvoiceTestData) withDynamicData(Optima_Invoice__c.Invoice_Date__c, invoiceDate);
    }

    /**
     * @description Sets the invoice amount.
     * @param amount The amount of the invoice.
     * @return The instance of OptimaInvoiceTestData.
     */
    public OptimaInvoiceTestData withAmount(Integer amount) {
        return (OptimaInvoiceTestData) withDynamicData(Optima_Invoice__c.Amount__c, amount);
    }

    /**
     * @description Sets the invoice number.
     * @param num The number of the invoice.
     * @return The instance of OptimaInvoiceTestData.
     */
    public OptimaInvoiceTestData withNumber(String num) {
        return (OptimaInvoiceTestData) withDynamicData(Optima_Invoice__c.Invoice_Number__c, num);
    }

    /**
     * @description Builds the Invoice object.
     * @return The created Invoice object.
     */
    public Optima_Invoice__c create() {
        return (Optima_Invoice__c)super.buildWithReset();
    }

    /**
     * @description Inserts the built Optima_Invoice__c object.
     * @return The inserted Optima_Invoice__c object.
     */
    public Optima_Invoice__c insertInvoice() {
        return (Optima_Invoice__c)super.insertRecord();
    }

    /**
     * @description Gets an instance of OptimaInvoiceTestData.
     * @return OptimaInvoiceTestData instance.
     */
    private static OptimaInvoiceTestData instancePriv = null;
    public static OptimaInvoiceTestData Instance {
        get {
            if (instancePriv == null) {
                instancePriv = new OptimaInvoiceTestData();
            }
            return instancePriv;
        }
    }

    /**
     * @description Private constructor for singleton.
     */
    private OptimaInvoiceTestData() {
        super();
    }
}