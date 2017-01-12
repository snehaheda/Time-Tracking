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
       
        //first get all the project assignment that the logged in user belongs
        List<Project_User_Assignment__c> userProjects = 
        new ProjectAssignmentsSelector().projectsAssignedToUser(new Set<Id>{ UserInfo.getUserId() });
        
        Set<Id> projectIds = new Set<Id>();
        for(Project_User_Assignment__c assignment : userProjects)
        	projectIds.add(assignment.Project__c);
        
        TaskAssignmentsSelector selector = new TaskAssignmentsSelector();
        return selector.searchByTaskProjectId(searchKeyWord,projectIds);
    }
    
    
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description this will return list of time entry that has been created today 
    */
    @AuraEnabled
    public static List<Time_Entry__c> getTodayTimerEntry() {
        return new TimeEntriesSelector().selectCurrentDateTimerEntryByUser( new Set<Id>{ UserInfo.getUserId() } ); 
    }
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description this method will start a new timer record  called from lightning component
    */
    @AuraEnabled
    public static void startTimer(Task_Assignment__c selectedTask) {
     	 
     	 //first fetch the time sheet record for this week if not found create one:-
     	 List<Timesheet__c> thisWeekTimesheetList = new TimesheetsSelector().getCurrentWeekTimesheetForUser(new Set<Id>{UserInfo.getUserId()});
     	 
     	 String timesheetId; 
     	 if(thisWeekTimesheetList.size()==0){
     	 	//create one for this week
     	 	Map<Id,Project_User_Assignment__c> projAssignmentId=new Map<Id,Project_User_Assignment__c>(
     	 		new ProjectAssignmentsSelector().selectAssignmentByProjectByUser(new Set<Id>{selectedTask.project__c},new Set<Id>{UserInfo.getUserId()})
     	 	);
     	 	thisWeekTimesheetList =  TimesheetsService.createThisWeekTimesheet(projAssignmentId.keySet());     	 		
     	 }
     	   
     	 TimeEntriesService.createTimeEntryForProjectTask(new Set<Id>{selectedTask.Id},thisWeekTimesheetList[0].Id,UserInfo.getUserId());     	 
     	
    } 
    
    /**
    * @author Sneha
    * @date 8/01/2017
    * @description method to stop the timer record called from lightning component
    */
    @AuraEnabled
    public static void stopTimerRecord(Time_Entry__c timeEntry) {
     	TimeEntriesService.updateStatus(new Set<Id>{timeEntry.Id},TimeTrackerConstants.TIMER_STOPPED);
    } 
    
     /**
    * @author Sneha
    * @date 8/01/2017
    * @description method to stop the timer record called from lightning component
    */
    @AuraEnabled
    public static void resumeTimerRecord(Time_Entry__c timeEntry) {
     	TimeEntriesService.updateStatus(new Set<Id>{timeEntry.Id},TimeTrackerConstants.TIMER_STARTED);
     	 
    }
    
   
    
}