@isTest(SeeAllData=true)
public class LH_TEST_Lead {
   static testMethod void LH_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
           FROM Lead LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Lead()
            );
        }
       Database.upsert(sourceList);
    }
}