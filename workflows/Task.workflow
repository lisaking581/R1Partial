<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_Queue_by_Email</fullName>
        <description>R1 Lead: Sales Call Requested Task Created by Hubspot- Alert Owner/Queue by Email</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <recipients>
            <field>MGR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maren.kiemen@intermedix.com.r1</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/LeadNotifyVF</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_contact</fullName>
        <description>R1 Lead: Sales Call Requested Task Created by Hubspot- Alert Owner Contact</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <recipients>
            <field>MGR_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadNotifyV_contact</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateEmail</fullName>
        <field>MGR_Email__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>UpdateEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_MGR_Email</fullName>
        <field>MGR_Email__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>Update MGR_Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>R1 Contact%3A %28SCR %29Sales Call Requested Task Created by Hubspot</fullName>
        <actions>
            <name>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Sales Call Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.WhoIDType__c</field>
            <operation>equals</operation>
            <value>Contact</value>
        </criteriaItems>
        <description>Hubspot User ID = 0052M000008Plfr</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>R1 Contact%3A %28SCR %29Sales Call Requested Task Owner Reassigned</fullName>
        <actions>
            <name>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Hubspot User ID = 0052M000008Plfr</description>
        <formula>AND(
ISCHANGED(OwnerId),
OwnerId != '0052M000008Plfr',
Subject = 'Sales Call Requested',
WhoIDType__c = 'Contact')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>R1 Lead %28SCR %29Sales Call Requested Task Created by Hubspot</fullName>
        <actions>
            <name>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_Queue_by_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Sales Call Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.WhoIDType__c</field>
            <operation>equals</operation>
            <value>Lead</value>
        </criteriaItems>
        <description>Hubspot User ID = 0052M000008Plfr</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>R1 Lead %28SCR %29Sales Call Requested Task Task Owner Reassigned</fullName>
        <actions>
            <name>R1_Lead_Sales_Call_Requested_Task_Created_by_Hubspot_Alert_Owner_Queue_by_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Hubspot User ID = 0052M000008Plfr</description>
        <formula>AND(
ISCHANGED(OwnerId),
OwnerId != '0052M000008PlfrQAC',
Subject = 'Sales Call Requested',
WhoIDType__c = 'Lead')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
