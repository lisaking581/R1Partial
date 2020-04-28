public with sharing class TaskLeadController3 {

	public String ApexLeadID {
		get {
			if (ApexLeadID == null) {
				ApexLeadID = ApexPages.currentPage().getParameters().get('LeadID');
			}
			return ApexLeadID;
		}
		set;
	}
	public Lead c {
		get {
			if (c == null) {
				c = [SELECT ID, Name, Company, Phone, Email, LeadSource, Lead_Source_Detail__c FROM Lead WHERE id = :ApexLeadID];
			}
			return c; 
		}
		set;
	}
}