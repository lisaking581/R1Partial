<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_invoiced</fullName>
        <description>Sets the invoiced flag</description>
        <field>Invoiced__c</field>
        <literalValue>1</literalValue>
        <name>Set invoiced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_uninvoiced</fullName>
        <description>Unsets the invoiced flag</description>
        <field>Invoiced__c</field>
        <literalValue>0</literalValue>
        <name>Set uninvoiced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set invoiced when number is entered</fullName>
        <actions>
            <name>Set_invoiced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the invoiced flag when the invoice number is not null</description>
        <formula>Invoice_Number__c &lt;&gt; NULL</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set uninvoiced when number is removed</fullName>
        <actions>
            <name>Set_uninvoiced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears the invoiced flag when the invoice number is null</description>
        <formula>Invoice_Number__c = NULL</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
