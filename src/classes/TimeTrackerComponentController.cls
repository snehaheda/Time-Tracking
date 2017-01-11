/**
* @author Sneha
* @date 7/01/2017
* @description Controller class that communicates with ligntning component
*/
public with sharing class TimeTrackerComponentController{
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description It returns all the task that are available for user on a project he is on currently
    */
    
    @AuraEnabled
    public static List<Task_Assignment__c> getTaskForProject(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List<Task_Assignment__c> availableTasks = 
                [SELECT Id, Task__c, Project__c, Task__r.description__c,Task__r.Name  FROM Task_Assignment__c WHERE  Task__r.Name LIKE: searchKey AND Project__c IN (Select Project__c FROM Project_User_Assignment__c WHERE User__c =:UserInfo.getUserId())];
		system.debug(availableTasks);
        return availableTasks;
    }
    
   
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description this will return list of time entry that has been created today 
    */
    @AuraEnabled
    public static List<Time_Entry__c> getTodayTimerEntry() {
        List<Time_Entry__c> currentTimeEntry = 
             [SELECT Id, Task__c,Project__c, Timer_Started_At__c,Status__c FROM Time_Entry__c WHERE Date__c = TODAY AND  User__c =:UserInfo.getUserId()];
        return currentTimeEntry;
    }
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description this method will start a new timer record  called from lightning component
    */
    @AuraEnabled
    public static void startTimer(Task_Assignment__c selectedTask) {
     	 
     	 //first fetch the time sheet record for this week if not found create one:-
     	 List<Timesheet__c> thisWeekTimesheetList = [Select Id FROM Timesheet__c WHERE Start_Date__c = THIS_WEEK AND User__c=:UserInfo.getUserId()];
     	 Timesheet__c thisWeekTimesheet;
     	 if(thisWeekTimesheetList.size()==0){
     	 	//create one for this week
     	 	thisWeekTimesheet=createTimesheet(selectedTask.project__c);	
     	 }else{
     	 	thisWeekTimesheet = thisWeekTimesheetList[0];
     	 }
     	      	 
     	 Time_Entry__c newEntry = new Time_Entry__c();
     	 newEntry.Task_Assignment__c =selectedTask.Id;
     	 newEntry.Date__c = Date.today();
     	 newEntry.Timer_Started_At__c = DateTime.Now();
     	 newEntry.timesheet__c = thisWeekTimesheet.Id;
     	 newEntry.Status__c = 'Started';
     	 newEntry.User__c=UserInfo.getUserId();
     	 insert newEntry;
    }
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description method to stop the timer record called from lightning component
    */
    @AuraEnabled
    public static void stopTimerRecord(Time_Entry__c timeEntry) {
     	
     	timeEntry.status__c='Stopped';
     	update  timeEntry;
     	 
    }
    
     /**
    * @author Sneha
    * @date 8/01/2017
    * @description method to stop the timer record called from lightning component
    */
    @AuraEnabled
    public static void resumeTimerRecord(Time_Entry__c timeEntry) {
     	
     	timeEntry.status__c='Started';
     	update  timeEntry;
     	 
    }
    
   
    /**
    * @author Sneha
    * @date 9/01/2017
    * @description : helper method that will create a timesheet if not found
    * @params : id of the project for which we are creating the timesheet
    */
     public static Timesheet__c createTimesheet(String projectId) {
     	 
     	 List<Project_User_Assignment__c> manager = [Select User__c FROM Project_User_Assignment__c WHERE Project__c=:projectId AND Is_Project_Manager__c=true];
     	 
     	 Timesheet__c timeSheet = new Timesheet__c(Project__c=projectId,User__c=UserInfo.getUserId());
     	 timeSheet.Start_Date__c = Date.today().toStartOfWeek();
     	 timeSheet.End_Date__c = Date.today().toStartOfWeek().addDays(7);
     	 if(manager.size()>0)
     	 	timeSheet.Approval_Manager__c =  manager[0].User__c;
     	 	
     	 insert timeSheet;
     	 return timeSheet;
     }
    
}