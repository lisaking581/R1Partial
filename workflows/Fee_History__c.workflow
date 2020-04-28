<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Contract_Annual_Fee_History_Amount</fullName>
        <field>Latest_Annual_Fee_History_Amount__c</field>
        <formula>Amount__c</formula>
        <name>Set Contract Annual Fee History Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Master_Contract__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Annual_Fee_History_Date</fullName>
        <field>Latest_Annual_Fee_History_Date__c</field>
        <formula>Effective_Date__c</formula>
        <name>Set Contract Annual Fee History Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Master_Contract__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Hourly_Fee_History_Amount</fullName>
        <field>Latest_Hourly_Fee_History_Amount__c</field>
        <formula>Amount__c</formula>
        <name>Set Contract Hourly Fee History Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Master_Contract__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Hourly_Fee_History_Date</fullName>
        <field>Latest_Hourly_Fee_History_Date__c</field>
        <formula>Effective_Date__c</formula>
        <name>Set Contract Hourly Fee History Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Master_Contract__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Latest Annual Fee History</fullName>
        <actions>
            <name>Set_Contract_Annual_Fee_History_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contract_Annual_Fee_History_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the latest annual fee history date and amount on the contract when the fee history is changed</description>
        <formula>and ( ISPICKVAL( Fee_Type__c , "Annual") , or ( ISBLANK(Master_Contract__r.Latest_Annual_Fee_History_Date__c), Effective_Date__c &gt; Master_Contract__r.Latest_Annual_Fee_History_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Latest Hourly Fee History</fullName>
        <actions>
            <name>Set_Contract_Hourly_Fee_History_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contract_Hourly_Fee_History_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the latest hourly fee history date and amount on the contract when the fee history is changed</description>
        <formula>and ( ISPICKVAL( Fee_Type__c , "Hourly") , or ( ISBLANK(Master_Contract__r.Latest_Hourly_Fee_History_Date__c), Effective_Date__c &gt; Master_Contract__r.Latest_Hourly_Fee_History_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
