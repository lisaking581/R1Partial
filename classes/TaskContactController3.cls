public with sharing class TaskContactController3 {

	public String ApexContactID {
		get {
			if (ApexContactID == null) {
				ApexContactID = ApexPages.currentPage().getParameters().get('WhoID');
			}
			return ApexContactID;
		}
		set;
	}
	public Contact c {
		get {
			if (c == null) {
				c = [SELECT ID, Name, AccountText__c, Phone, Email, LeadSource, Lead_Source_Detail__c FROM Contact WHERE id = :ApexContactID];
			}
			return c; 
		}
		set;
	}
}