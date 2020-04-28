@isTest
        private class EmailOpen2Test {
            // Dummy CRON expression: midnight on March 15.
            // Because this is a test, job executes
            // immediately after Test.stopTest().
            public static String CRON_EXP = '0 0 0 15 3 ? 2022';
            static testmethod void testScheduledJob() {
                // Create some lead records with no LeadSource
                List<Task> mytasks = new List<Task>();
                List<EmailMessage> myemail = new List<EmailMessage>();
               
                Integer count=0;
        
                for (Integer i=0; i<200; i++) {
                    Task tsk= new Task(
                        Subject = 'sample task ' + i,
                       
                        Status = 'Open');
                    mytasks.add(tsk);
                }

                for (Task tks : mytasks){
                        EmailMessage me= new EmailMessage(
                            FirstOpenedDate = System.now(),
                            ActivityId = tks.Id);
                           
                        myemail.add(me);
                }
                insert mytasks;
                
                // Get the IDs of the tasks we just inserted
                Map<Id, Task> taskMap = new Map<Id, Task>(mytasks);
                List<Id> TaskIds = new List<Id>(taskMap.keySet());
                Test.startTest();
                // Schedule the test job
                String jobId = System.schedule('ScheduledApexTest',
                    CRON_EXP,
                    new EmailOpen2());         
                // Verify the scheduled job has not run yet.
                List<Task> lt = [SELECT Id, Subject, Email_Opened_DT__c
                   FROM Task 
                    WHERE Id IN :taskIds and Email_Opened_DT__c != null];
                System.assertEquals(0, lt.size(), 'before job has run');
                // Stopping the test will run the job synchronously
                Test.stopTest();
                
                // Now that the scheduled job has executed,
                // check that our leads  were created
                lt = [SELECT Id 
                    FROM Task
                    WHERE Id IN :taskIds and Status = 'Open'];
                System.assertEquals(TaskIds.size(), 
                    lt.size(), 
                    'Tasks were not updated');
            }
        }