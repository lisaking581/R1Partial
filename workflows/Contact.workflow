<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Flag No Longer With Company</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.No_Longer_with_Company__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
