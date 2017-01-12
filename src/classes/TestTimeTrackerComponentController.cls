/**
	@author:SNeha
	@date : 10/1/2017
	@purpose : this class contains the unit testmethod for the time tracker controller & helper
 */
@isTest
private class TestTimeTrackerComponentController {

    static testMethod void testTodayTimerEntry() {
        //setup the data
        Project__c project = TestDataHelper.setupProject();
        
        List<Task_Assignment__c> tasks = TestDataHelper.createTaskUnderProject(project.Id);
        
        Test.startTest();
        	system.assert(TimeTrackerComponentController.getTodayTimerEntry().size()==0);
        	
        	//now create timer:-
        	TimeTrackerComponentController.startTimer(tasks[0]);
        	system.assert(TimeTrackerComponentController.getTodayTimerEntry().size()>0);
        Test.stopTest();
        
    }
    
    static testMethod void testGetTaskListOfProject() {
        //setup the data
        Project__c project = TestDataHelper.setupProject();
        
        List<Task_Assignment__c> tasks = TestDataHelper.createTaskUnderProject(project.Id);
        
        Test.startTest();
        	system.assert(TimeTrackerComponentController.getTaskForProject('Sa').size()==tasks.size());
        Test.stopTest();
        
    }
    
    static testMethod void testTimerFunctions() {
        //setup the data
        Project__c project = TestDataHelper.setupProject();
        
        List<Task_Assignment__c> tasks = TestDataHelper.createTaskUnderProject(project.Id);
        
        Test.startTest();
        	system.assert(TimeTrackerComponentController.getTodayTimerEntry().size()==0);
        	
        	//now create timer:-
        	TimeTrackerComponentController.startTimer(tasks[0]);
        	List<Time_Entry__c> entries = TimeTrackerComponentController.getTodayTimerEntry();
        	system.assert(entries.size()>0);
        	
        	//now stop the time:-
        	TimeTrackerComponentController.stopTimerRecord(entries[0]);
        	//check the entry record status
        	
        	Time_Entry__c t = [Select Id,Status__c,Bill_By_Rate__c FROM Time_Entry__c WHERE Id=:entries[0].Id];
        	system.assert(t.Status__c=='Stopped');
        	
        	system.assert(t.Bill_By_Rate__c==50);
        	
        	TimeTrackerComponentController.resumeTimerRecord(entries[0]);
        	t = [Select Id,Status__c FROM Time_Entry__c WHERE Id=:entries[0].Id];
        	system.assert(t.Status__c=='Started');
        Test.stopTest(); 
        
    }
    
    
    
}