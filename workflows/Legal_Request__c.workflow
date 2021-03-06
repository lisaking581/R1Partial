<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LR_Resend_Email_Other</fullName>
        <description>R1 LR Email to submit legal request For Other- Resend</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_Other</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_Other</fullName>
        <ccEmails>mlippman@r1rcm.com</ccEmails>
        <ccEmails>lking1@r1rcm.com</ccEmails>
        <description>R1 LR Email to submit legal request For Other</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_Other</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_BAA</fullName>
        <ccEmails>mlippman@r1rcm.com</ccEmails>
        <ccEmails>lking1@r1rcm.com</ccEmails>
        <description>R1 LR Email to submit legal request For BAA</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_BAA</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_BAA_resend</fullName>
        <description>R1 LR Email to submit legal request For BAA-resend</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_BAA</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_NDA</fullName>
        <ccEmails>mlippman@r1rcm.com</ccEmails>
        <ccEmails>lking1@r1rcm.com</ccEmails>
        <description>R1 LR Email to submit legal request For NDA</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_NDA</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_NDA_resend</fullName>
        <description>R1 LR Email to submit legal request For NDA-resend</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_NDA</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_existing</fullName>
        <ccEmails>mlippman@r1rcm.com</ccEmails>
        <ccEmails>lking1@r1rcm.com</ccEmails>
        <description>R1 LR Email to submit legal request For Existing</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_Existing</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_for_existing_resend</fullName>
        <description>R1 LR Email to submit legal request For Existing - Resend</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_Existing</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_new_cust_resend</fullName>
        <description>R1 LR Email to submit legal request For New Customer - Resend</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_NewCust</template>
    </alerts>
    <alerts>
        <fullName>R1_LR_Email_to_submit_legal_request_to_SmartSheet</fullName>
        <ccEmails>mlippman@r1rcm.com</ccEmails>
        <ccEmails>lking1@r1rcm.com</ccEmails>
        <description>R1 LR Email to submit legal request For New Customer</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfsupport@r1rcm.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Q2C_Emails/R1_Legal_Request_NewCust</template>
    </alerts>
    <fieldUpdates>
        <fullName>LR_uncheck_resend_email</fullName>
        <field>Resend_Email__c</field>
        <literalValue>0</literalValue>
        <name>Update LR uncheck resend email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLRCBM</fullName>
        <field>Date_to_CBM__c</field>
        <formula>now()</formula>
        <name>Update LR CBM Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LR_Complete</fullName>
        <field>Completed_Date__c</field>
        <formula>NOW()</formula>
        <name>Update LR Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LR_Funct_Review_Date</fullName>
        <field>Date_to_Functional_Review__c</field>
        <formula>now()</formula>
        <name>Update LR Funct Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LR_RTS_date</fullName>
        <field>Date_Returned_to_Sales__c</field>
        <formula>Now()</formula>
        <name>Update LR RTS date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LR_to_In_Progress</fullName>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Update LR to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Return_for_CA</fullName>
        <field>Status__c</field>
        <literalValue>Returned to Requester for Client Alignment</literalValue>
        <name>Update Return for CA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>GetStatusFromSS</fullName>
        <apiVersion>45.0</apiVersion>
        <endpointUrl>https://hooks.zapier.com/hooks/catch/5126397/ved2pq/</endpointUrl>
        <fields>Id</fields>
        <fields>SmartSheetRecordID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>lking1@r1rcm.com</integrationUser>
        <name>GetStatusFromSS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>SendNDAGeneratedRow</fullName>
        <apiVersion>46.0</apiVersion>
        <endpointUrl>https://hooks.zapier.com/hooks/catch/5126397/o328fiu/</endpointUrl>
        <fields>AccountName__c</fields>
        <fields>Account_City__c</fields>
        <fields>Account_State__c</fields>
        <fields>CreatedDate</fields>
        <fields>Customer_Category__c</fields>
        <fields>Id</fields>
        <fields>NDA_Type_Requested__c</fields>
        <fields>Name</fields>
        <fields>Owner_Email__c</fields>
        <fields>Owner_Name__c</fields>
        <fields>Request_Type__c</fields>
        <fields>State_of_Incorporation__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>lking1@r1rcm.com</integrationUser>
        <name>SendNDAGeneratedRow</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>GetUpdates</fullName>
        <actions>
            <name>GetStatusFromSS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Legal_Request__c.Get_Updates__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LR - CBM_Appproval</fullName>
        <actions>
            <name>UpdateLRCBM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Submit for CBM Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Date_to_CBM__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LR - Complete</fullName>
        <actions>
            <name>Update_LR_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Completed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LR - FunctionalReview</fullName>
        <actions>
            <name>Update_LR_Funct_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Submit for Functional Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Date_to_Functional_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LR - Returned_to_Sales</fullName>
        <actions>
            <name>Update_LR_RTS_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Returned to Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Date_Returned_to_Sales__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_to_SmartSheet</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_LR_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>New Customer</value>
        </criteriaItems>
        <description>for new customer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal - Resend</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_new_cust_resend</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Resend_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>New Customer</value>
        </criteriaItems>
        <description>for new customer</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal Exist</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_existing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_LR_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Existing Customer Modification</value>
        </criteriaItems>
        <description>for new existing</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal Exist_resend</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_existing_resend</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Resend_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Existing Customer Modification</value>
        </criteriaItems>
        <description>for new existing</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-BAA</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_BAA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_LR_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>contains</operation>
            <value>BAA</value>
        </criteriaItems>
        <description>for new BAA</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-BAA_resend</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_BAA_resend</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Resend_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>contains</operation>
            <value>BAA</value>
        </criteriaItems>
        <description>for new BAA</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-NDA</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_NDA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_LR_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>NDA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.NDA_Type_Requested__c</field>
            <operation>notContain</operation>
            <value>R1 Template NDA Request</value>
        </criteriaItems>
        <description>for NDA</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-NDA_resend</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_for_NDA_resend</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Resend_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>NDA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.NDA_Type_Requested__c</field>
            <operation>notEqual</operation>
            <value>R1 Template NDA Request</value>
        </criteriaItems>
        <description>for NDA</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-Other</fullName>
        <actions>
            <name>R1_LR_Email_to_submit_legal_request_Other</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_LR_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Other Request</value>
        </criteriaItems>
        <description>for  Other</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LR - Submit to Legal-Other-Resend</fullName>
        <actions>
            <name>LR_Resend_Email_Other</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LR_uncheck_resend_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Resend_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Other Request</value>
        </criteriaItems>
        <description>for  Other</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send NDA to SS</fullName>
        <actions>
            <name>Update_Return_for_CA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SendNDAGeneratedRow</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>NDA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.NDA_Type_Requested__c</field>
            <operation>equals</operation>
            <value>R1 Template NDA Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legal_Request__c.Create_in_SmartSheet__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Status Changed</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Legal_Request__c.Status__c</field>
            <operation>notEqual</operation>
            <value>New,Not Started</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
