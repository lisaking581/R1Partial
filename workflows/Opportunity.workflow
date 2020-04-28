<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Admin_Notice_of_Stage_Change</fullName>
        <description>Admin Notice of Stage Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/System_Admin_Notification</template>
    </alerts>
    <alerts>
        <fullName>Legal_Priority_1_Notification</fullName>
        <ccEmails>legal@r1rcm.com</ccEmails>
        <ccEmails>SRadcliffe@R1RCM.COM</ccEmails>
        <description>Legal Priority 1 Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rnicholls@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Legal_Priority_1_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Commit_Quarter_Change_Alert</fullName>
        <description>Send Commit Quarter Change Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Mgt</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>glong1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>prademacher@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commit_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Win_Notice</fullName>
        <ccEmails>DReyes@R1RCM.COM</ccEmails>
        <ccEmails>vkotte@r1rcm.com</ccEmails>
        <description>Send Win Notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>AN - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>AN - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>AS - CSM/Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Administrator</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>ED - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>ED - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>ED Executive</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>EMS - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>EMS - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>ERB - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>FE - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>IDN - Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>IDN - Enterprise Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>IDN - Modular Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Inside Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>OBB - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>OBPM - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>OBPM - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>OPT - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>OPT - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>PHY - Accounting Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>PHY - Practice Admin</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>PSR - CSM/Acct Mgr</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>PSR - Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Leadership</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales_Mgt</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>HB_Sales_Leadership</recipient>
            <type>roleSubordinates</type>
        </recipients>
        <recipients>
            <recipient>Modular_Sales_Leadership</recipient>
            <type>roleSubordinates</type>
        </recipients>
        <recipients>
            <recipient>OB_EMS_Sales_Leadership</recipient>
            <type>roleSubordinates</type>
        </recipients>
        <recipients>
            <recipient>bbabcock@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bgray3@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bstewart12@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cadams4@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ccallsen@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dpope@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eallegretti@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>glong1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jwillett@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ktucker@r1rcm.com</recipient>
            <type>user</type>
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
            <recipient>mnastov@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>prademacher@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rbritnell@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rlopezdelrincon@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>smcfadden1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tivery@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ttorrence@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_PS_Resource__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Professional_Services_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/R1_Closed_Won_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Short_Funnel_Push_Counter</fullName>
        <field>Push_Counter_Short_Funnel__c</field>
        <formula>IF( ISNULL( Push_Counter_Short_Funnel__c),
1,Push_Counter_Short_Funnel__c +1)</formula>
        <name>Increment Short Funnel Push Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Comments_Update_Date</fullName>
        <field>Sales_Comments_Update_Date__c</field>
        <formula>Today()</formula>
        <name>Sales Comments Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Actual_Close_Date</fullName>
        <field>Actual_Close_Date__c</field>
        <formula>Today()</formula>
        <name>Set Actual Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exec_Comments_Update_Date</fullName>
        <field>Exec_Comments_Last_Update__c</field>
        <formula>Today()</formula>
        <name>Set Exec Comments Update Date`</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Highest_Probability</fullName>
        <field>Highest_Probability__c</field>
        <formula>Probability</formula>
        <name>Set Highest Probability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Mgmt_Forecast_to_WON</fullName>
        <field>Mgmt_Forecast__c</field>
        <literalValue>WON</literalValue>
        <name>Set Mgmt Forecast to WON</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Change_To_Close_Date</fullName>
        <field>Stage_Change_To_Close_Date__c</field>
        <formula>Today()</formula>
        <name>Set Stage Change To Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Change_To_Execute_Date</fullName>
        <field>Stage_Change_To_Execute_Date__c</field>
        <formula>Today()</formula>
        <name>Set Stage Change To Execute Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Change_To_Propose_Date</fullName>
        <field>Stage_Change_To_Propose_Date__c</field>
        <formula>Today()</formula>
        <name>Set Stage Change To Propose Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Change_To_Qualify_Date</fullName>
        <field>Stage_Change_to_Qualify_Date__c</field>
        <formula>Today()</formula>
        <name>Set Stage Change To Qualify Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Change_to_Learn_Date</fullName>
        <field>Stage_Change_To_Learn_Date__c</field>
        <formula>Today()</formula>
        <name>Set Stage Change to Learn Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Commit Change Notification</fullName>
        <actions>
            <name>Send_Commit_Quarter_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
	ISCHANGED(CloseDate),
        OR (
        Mgt_Forecast__c ="Commit",
         EX_Mgt_FCST__c  = TRUE
        ),
	OR(
	YEAR( CloseDate ) 
	&lt;&gt;
	YEAR( PRIORVALUE(CloseDate)  ),
	CEILING(MONTH( CloseDate ) / 3 )
	&lt;&gt;
	CEILING(MONTH( PRIORVALUE(CloseDate)  ) / 3 )
	)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1

App Exchange had this "IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)"  changed per reviews to avoid moving a year ahead and then back.</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate )+29,  TRUE,  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter Short Funnel</fullName>
        <actions>
            <name>Increment_Short_Funnel_Push_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1

App Exchange had this "IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)"  changed per reviews to avoid moving a year ahead and then back.</description>
        <formula>IF(
OR(
ISPICKVAL(StageName,"3-Execute"),
ISPICKVAL(StageName,"4-Propose"),
ISPICKVAL(StageName,"5-Close")
),IF(  CloseDate &gt; PRIORVALUE( CloseDate )+29,  TRUE,  FALSE) ,  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Comments Update Date</fullName>
        <actions>
            <name>Sales_Comments_Update_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Manager_Comments__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Operations Opp Notices</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 ) AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Ex_SO_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.EX_Mgt_FCST__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Mgmt_Forecast__c</field>
            <operation>contains</operation>
            <value>Commit</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastName</field>
            <operation>equals</operation>
            <value>Lippman</value>
        </criteriaItems>
        <description>notify SO of any update to opps with the Ex_SO_Flag__c = True or if Commit</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Win Notice</fullName>
        <actions>
            <name>Send_Win_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Enterprise</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
            <value>Renewal,Administrative Adjustment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>49999</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>System Administrator,Optima Sales Leadership</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Actual Close Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Actual_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (IsClosed, ISCHANGED(StageName))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Exec Comments Update Date%60</fullName>
        <actions>
            <name>Set_Exec_Comments_Update_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Executive_Comments__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Highest Probability</fullName>
        <actions>
            <name>Set_Highest_Probability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (ISCHANGED( Probability ),   
OR(PRIORVALUE(Probability ) &lt; Probability, ISBLANK( PRIORVALUE(Highest_Probability__c )) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Change To Close Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Stage_Change_To_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND (ISCHANGED(StageName), ISPICKVAL(StageName,"Close"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Change To Execute Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Stage_Change_To_Execute_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND (ISCHANGED(StageName), ISPICKVAL(StageName,"Execute"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Change To Propose Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Stage_Change_To_Propose_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND (ISCHANGED(StageName), ISPICKVAL(StageName,"Propose"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Change To Qualify Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Stage_Change_To_Qualify_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND (ISCHANGED(StageName), ISPICKVAL(StageName,"Qualify"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Change to Learn%2FDiscover Date</fullName>
        <actions>
            <name>Admin_Notice_of_Stage_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Stage_Change_to_Learn_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( OR(ISPICKVAL( StageName ,"Learn"),ISPICKVAL( StageName ,"Discover")),ISCHANGED(StageName))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Mgt Forecast to WON</fullName>
        <actions>
            <name>Set_Mgmt_Forecast_to_WON</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if an item is sold, change the MGT forecast field to WON.  This supports the Forecasting Report</description>
        <formula>AND (IsWon, ISCHANGED(StageName))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
