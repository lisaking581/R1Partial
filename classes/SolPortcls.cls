public class SolPortcls {

public String groupFieldName {get; set;}    
public SolPort__c[] SPList{get;set;}
public List<GroupWrapper> groups {get; set;}  
String SPId;


public void setSPId(String val)
{
this.SPId=val;
}
public String getSPId()
{
return this.SPId;
}
public PageReference EditSolPort()
    {

        String mySPId = getSpid();
        PageReference pageRef= new PageReference('/'+ mySPId +'/e');
		system.debug('editsolport was called');
        system.debug(mySPId);
        pageRef.setredirect(true);

        return pageRef;

    }
    
    

 
    


     
    public solportcls(ApexPages.standardController std){
        SPList=new Solport__c[]{};
        groupFieldName='Group_By__c';
         string AccountID=ApexPages.currentPage().getParameters().get('id');
        if(AccountID==NULL){
            system.debug('No Id available');
        }
        else{
            
            Account[] CWS=new Account[]{};
            CWS=[Select id,(select Group_By__c, Solution_Name__c, Indicator__c,  Opportunity_value__c, Solution_fit__c, competitor__c, CountAllCompetitors__c, Competitors__c, current__c, former__c from SolPort__r Order by Group_By__c, Solution_Name__c)  from Account where id =:AccountID ];
            for( Account c:CWS ){
                for(SolPort__c obj:c.Solport__r){
                    SPList.add(obj);
                }
                
                setupGrouping();
            }
        }
    }
    
    private void setupGrouping()
 {
  Map<String, List<SolPort__c>> groupedMap=new Map<String, List<SolPort__c>>();
  for (SolPort__c acc : spList)
  {
   String key=String.valueof(acc.get('Group_By__c'));
      system.debug(key);
   if ( (null==key) || (0==key.length()) )
   {
    key='Undefined';
   }
   List<SolPort__c> groupedAccs=groupedMap.get(key);
   if (null==groupedAccs)
   {
    groupedAccs=new List<SolPort__c>();
    groupedMap.put(key, groupedAccs);
   }
    
   groupedAccs.add(acc);
     system.debug('grouped accs' + key + 'size is' + groupedaccs.size());                                
  }
     
   
  groups=new List<GroupWrapper>();
  for (String key : groupedMap.keySet())
  {
   GroupWrapper gr=new GroupWrapper();
   groups.add(gr);
   gr.accs=groupedMap.get(key);
   gr.groupedVal=key;
  }
 }
    
    
    
    public class GroupWrapper
{
 	public List<SolPort__c> accs {get; set;}
 	public String groupedVal {get; set;}
 	
}
}