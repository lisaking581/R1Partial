trigger OpportunityTrigger on Opportunity (after insert, after update) {
    // -- If new we send all trigger.new
    if( trigger.isInsert) {
        OpportunityHandler.createOpportunityHistory(Trigger.New);
    }
    else if( trigger.isUpdate ) {
        // -- If update only send trigger.new where Stage or Milestone changed.
        for( Id oppId : Trigger.newMap.keySet() ) {
            List<Opportunity> changedOpps = new List<Opportunity>();
            if( Trigger.oldMap.get(oppId).StageName != Trigger.newMap.get(oppId).StageName) {
                changedOpps.Add(Trigger.newMap.get(oppId));
            }
            
            OpportunityHandler.createOpportunityHistory(changedOpps);
        }
    }
}