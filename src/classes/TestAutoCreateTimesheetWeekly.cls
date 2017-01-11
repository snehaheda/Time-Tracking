/**
	@author:SNeha
	@date : 10/1/2017
	@purpose : this class contains the unit testmethod for the scheduler & batch
 */
@isTest
private class TestAutoCreateTimesheetWeekly {
	
	static String CRON_EXP = '0 0 0 3 9 ? 2022';
	
	/*
		@purpose : unit test method for scheduled class
	*/
    static testMethod void testAutoCreateTimesheetWeeklyScheduledClass() {
        //setup the data
        Project__c project = TestDataHelper.setupProject();
        
        Test.startTest();
        	 String jobId = System.schedule('testAutoCreateTimesheetWeekly',CRON_EXP, new AutoCreateTimesheetWeekly());  
        Test.stopTest();
      
    }
    
    /*
		@purpose : unit test method for batch  class
	*/
    static testMethod void testAutoCreateTimesheetWeeklyBatchClass() {
        //setup the data
        Project__c project = TestDataHelper.setupProject();
        
        Test.startTest();
        	Database.executeBatch(new AutoCreateTimesheetWeeklyBatch());
        Test.stopTest();
        
        //time sheet should be there:-
        List<TimeSheet__c> timesheet = new List<TimeSheet__c>();
        timesheet =[Select Id FROM TimeSheet__c WHERE Project__c=:project.Id];
        system.assert(timesheet.size()>0);
    }
}