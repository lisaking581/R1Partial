<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cancel_Sprint_Notification</fullName>
        <description>Cancel Sprint Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>lking1@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlippman@r1rcm.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cancel_Sprint</template>
    </alerts>
</Workflow>
