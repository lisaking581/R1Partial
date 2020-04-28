<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Add to Dist list</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.IncludeEmailDistList__c</field>
            <operation>equals</operation>
            <value>Included in DistList</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
