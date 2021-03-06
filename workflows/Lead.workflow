<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>R1_Lead_3_Days_Old_Lead_Status_New_Awaiting_Qualification_AND_Outcome_status_Awa</fullName>
        <description>R1 Lead- 3 Days Old: Lead Status = New – Awaiting Qualification AND Outcome status = Awaiting Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_owner_s_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Alert_Inactive_three_days_since_create_Lead_Name</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_7_Days_Old_Lead_Status_New_Awaiting_Qualification_AND_Outcome_status_Awa</fullName>
        <description>R1 Lead- 7 Days Old: Lead Status = New AND Outcome status = Awaiting Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_owner_s_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Alert_Inactive_seven_days_since_create_Lead_Name</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_Inactive_for_3_Days_meeting_specific_criteria</fullName>
        <description>R1 Lead: Inactive for 3 Days meeting specific criteria</description>
        <protected>false</protected>
        <recipients>
            <recipient>annette@ablecloudadvisors.com.r1prod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Alert_Inactive_three_days_since_create_Lead_Name</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_Status_Nurture_Return_to_Marketing</fullName>
        <description>R1 Lead Status = Nurture, Return to Marketing</description>
        <protected>false</protected>
        <recipients>
            <recipient>Marketing_Lead_Queue</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Status_Return_to_Marketing</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_Status_Rejected</fullName>
        <description>R1 Lead Status = Rejected &amp; NOT Incorrect Assignment</description>
        <protected>false</protected>
        <recipients>
            <recipient>Rejected_Lead_Queue</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>R1_Lead_Status_Rejected_IS_Incorrect_Assignment</fullName>
        <description>R1 Lead Status = Rejected &amp; IS Incorrect Assignment</description>
        <protected>false</protected>
        <recipients>
            <recipient>System_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Lead_owner_s_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Lead_Status_Rejected_IA</template>
    </alerts>
    <alerts>
        <fullName>R1_MQL_Lead_Email_Alert</fullName>
        <description>R1 MQL Lead Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maren.kiemen@intermedix.com.r1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_owner_s_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_MQL_Alert_no_reassignment</template>
    </alerts>
    <alerts>
        <fullName>R1_New_Lead_Owner</fullName>
        <description>R1: New Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maren.kiemen@intermedix.com.r1</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>SysAdminOnly_notify_SCR_was_reassigned_by_PB</fullName>
        <description>SysAdminOnly-notify SCR was reassigned by PB</description>
        <protected>false</protected>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/PB_reassigned_owner</template>
    </alerts>
    <rules>
        <fullName>R1 Lead Alert %E2%80%93 Inactive 3 %26 7 days since create %5BLead Name%5D</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>1/28/2019</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Funnel_Stage__c</field>
            <operation>equals</operation>
            <value>Qualified Lead (QL)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Outcome_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Contact</value>
        </criteriaItems>
        <description>3 days: Rule: If Lead Status = New – Awaiting Qualification AND Outcome status = Awaiting Contact at 3 days after Lead Created date, alert the owner of the lead with the following message
7 days: Rule: Same but 7 days, no update to Lead</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>R1_Lead_3_Days_Old_Lead_Status_New_Awaiting_Qualification_AND_Outcome_status_Awa</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>R1_Lead_7_Days_Old_Lead_Status_New_Awaiting_Qualification_AND_Outcome_status_Awa</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
