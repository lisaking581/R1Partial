public class OpportunityHandler {
    // Luke Freeland: There's a Salesforce bug where if a workflow rule updates the opportunity again,
    // it causes the trigger to fire again with the same OLD and NEW values so that was causing
    // duplicate Opportunity History records. To fix that, this cache was added to ensure
    // duplicates wouldn't be created.
    private static Map<Id, String> previousOpportunityStages = new Map<Id, String>();
    
    public static void createOpportunityHistory(List<Opportunity> changed)
    {
        // -- Find all opportunities where the stage changed and also pre create the
        // --   new histories to keep it at one loop.
        Set<Id> oppsIds = new Set<Id>();
        List<Opportunity_History__c> newHistories = new List<Opportunity_History__c>();
        for(Opportunity o : changed) {
            String previousStageName = previousOpportunityStages.get(o.Id);
            
            if (String.isBlank(previousStageName) ||
                o.StageName != previousStageName) {
            
                oppsIds.add(o.Id);
                
                Opportunity_History__c history = new Opportunity_History__c();
                history.Enter_Date__c = Date.today();
                history.Enter_DateTime__c = Datetime.now();
                history.Opportunity__c = o.Id;
                history.Amount__c = o.Amount;
                history.Stage_History__c = o.StageName;
                history.Milestone__c = o.Sales_Milestone__c;
                history.Stage_change__c = true;
                                
                newHistories.Add(history);
                previousOpportunityStages.put(o.Id, o.StageName);
            }
        }
        
        if (oppsIds.isEmpty()) {
            return;
        }
        
        // -- Retrieve all the opportunity histories for these that are open (no end date) 
        // --   and close them out.
        List<Opportunity_History__c> histories = [SELECT Id, Exit_Date__c, Exit_DateTime__c, Stage_change__c 
                                                  FROM Opportunity_History__c
                                                  WHERE Exit_DateTime__c = null AND Stage_change__c = TRUE AND Opportunity__c IN :oppsIds];
        
        for(Opportunity_History__c h : histories) {
            h.Exit_Date__c = Date.today();
            h.Exit_DateTime__c = Datetime.now();
        }
        
        update histories;
        
        // -- Create new opportunity histories with the new stage and milestone.        
        insert newHistories; 
    }
}