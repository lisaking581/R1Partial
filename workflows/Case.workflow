<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alerting_case_has_been_assigned</fullName>
        <description>Email alerting case has been assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>mlippman@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Alerts/SUPPORT_Internal_Case_Assignment_Alert</template>
    </alerts>
    <alerts>
        <fullName>Integration_Project_Case</fullName>
        <description>Integration Project Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>X18_Integration_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Internal_Case_Created_Assigned</fullName>
        <description>Internal Case Created &amp; Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Alerts/SUPPORTWebtoCaseemailresponseSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>debug_email</fullName>
        <description>debug email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Alerts/SUPPORTWebtoCaseemailresponseSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>SetRecordTypetoAssigned</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Internal_Case_No_reassignment_rules</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SetRecordTypetoAssigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_debug</fullName>
        <field>debug_info__c</field>
        <formula>"workflow fired"</formula>
        <name>Update_debug</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Integration Project Case</fullName>
        <actions>
            <name>Integration_Project_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>10/1/2018 1:00 AM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Project Case</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Internal Case</fullName>
        <actions>
            <name>SetRecordTypetoAssigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_debug</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>0052M000008PlBrQAK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal Case</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
