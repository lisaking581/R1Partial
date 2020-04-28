<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ContractExpireDate</fullName>
        <field>Current_Contract_Expiration_Date__c</field>
        <formula>if(not(ISBLANK(Rollover_End_Date__c)),Rollover_End_Date__c,Contract_End_Date_calc__c)</formula>
        <name>ContractExpireDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
