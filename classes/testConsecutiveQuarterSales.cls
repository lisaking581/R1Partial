@isTEst
        private class testConsecutiveQuarterSales {
        
            @testSetup
            static void setup() {
                List<Opportunity> myOpp = new List<Opportunity>();
                Period per = new Period(StartDate = Date.newInstance(2020,1,1), EndDate = Date.newInstance(2020,3,31), Type = 'Quarter');
               
                Country__c usa = new Country__c(Name='United States', ISO_Code__c='US', ISO3_Code__c='USA');
                insert usa;
        
                User u = new User(FirstName = 'Test User', LastName = 'Tester', Team__c = 'HB',
                Username = '123@123646464646546546.com', Email = '123@gmail.com', Alias = 'Test', TimeZoneSidKey = 'GMT', 
                LocaleSidKey = 'en_US', EmailEncodingKey='ISO-8859-1',conqtr__c = 0,
                ProfileId ='00e41000001e0HOAAY', LanguageLocaleKey= 'en_US');
                insert u;
                
                Account a = new Account(Name = 'Penrod Health Care');
                a.BillingCountry = usa.ISO_Code__c;
                insert a;
                system.debug(a.name);
                Opportunity o1 = new Opportunity( Name = 'Penrod Health - E2E',
                                                 AccountId = a.Id,
                                                 StageName = 'Closed Won',
                                                 Amount = 20,
                                                 CloseDate = Date.newInstance(2020,2,1),
                                                 Vertical__c = 'IDN Solutions',
                                                 Target_Market__c = 'Hospitals and Health Systems',
                                                 Solution__c = 'Revenue Integrity Solutions ',
                                                 Duration__c = 60,
                                                 Type = 'New Business',
                                                 OwnerId = u.id,
                                                 Start_Date__c = Date.today());
                                                       
                   system.debug(o1.name);
                
                    myOpp.add(o1);
                    Opportunity o2 = new Opportunity( Name = 'Penrod Health - E2E',
                                                 AccountId = a.Id,
                                                 StageName = '1-Discover',
                                                 Amount = 10,
                                                 CloseDate = Date.newInstance(2020,3,1),
                                                 Vertical__c = 'IDN Solutions',
                                                 Target_Market__c = 'Hospitals and Health Systems',
                                                 Solution__c = 'Revenue Integrity Solutions ',
                                                 Duration__c = 60,
                                                 Type = 'New Business',
                                                 OwnerId=u.id,
                                                 
                                                 Start_Date__c = Date.today());
        
        
                        myOpp.add(o2);

                        insert myOpp;
                        system.debug('opps inserted =' +  myOpp.size());
                
            
                
            }
        
            @isTest
            static void validateClosed() {
               
           
                List<Opportunity> ClosedOpps = new List<Opportunity>();
                ClosedOpps =  [Select id from Opportunity where isclosed = true];
                System.assertEquals(1, closedopps.size(), 'There should only be 1 closed opportunity on insert.');
            
                
                
            }
            @isTest
            static void test2(){
                
           SchedulableContext sc = null;
     
         
            ConsecutiveQuarterSales ext = new ConsecutiveQuarterSales(); 
             ext.execute(sc);

         /*List<Period> recentQuarters = [
    SELECT quarterlabel, StartDate, EndDate 
    FROM Period
    WHERE endDate < today and Type = 'Quarter' 
    ORDER BY StartDate DESC limit 8];

                system.assertequals(8, recentquarters.size(),'how many qtrs');*/

            List<User> SalesUsers = new List<User>();
            SalesUsers =  [Select id, name from User where Team__c = 'HB' and conqtr__c = 1];
            
          

            for (user u : SalesUsers){
                system.debug(u.name);
            }
        
            system.assertEquals(1,SalesUsers.size(),'there should have been user with consec qtrs');
        
                    
            }
        }