<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>email date open update</fullName>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.FirstOpenedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/2019</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
