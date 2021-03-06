/**
	* @author Sneha
	* @date 12/1/2017
	* @description Service layer for timesheet
	*/
public with sharing class TimesheetsService {
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description method creates Timesheet record under project for current week
 	* @param projectAssignmentId  id of project & user for which the time sheet need to be created
	* @return List<Timesheet__c> newly created timesheet record
	*/
    public static List<Timesheet__c> createThisWeekTimesheet(Set<Id> projectAssignmentId){ 
    	
    	 List<Project_User_Assignment__c> projectUsers = new ProjectAssignmentsSelector().selectById(projectAssignmentId);
    	 
    	 SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[] { TimeSheet__c.SObjectType });  
    	 
    	 List<Timesheet__c> newTimesheets = new List<Timesheet__c>();
    	 for(Project_User_Assignment__c projUser : projectUsers) {
    	 	Timesheet__c timeSheet = new Timesheet__c(Project__c=projUser.Project__c,User__c=projUser.User__c);	
    	 	timeSheet.Start_Date__c = Date.today().toStartOfWeek();
    	 	timeSheet.End_Date__c = Date.today().toStartOfWeek().addDays(6);
    	 	timeSheet.Approval_Manager__c =  projUser.Project__r.OwnerId; 
    	 	
    	 	uow.registerNew(timeSheet);
    	 	newTimesheets.add(timeSheet);
    	 }
     	 uow.commitWork();  
     	 
     	 return newTimesheets;
    }
    
    
}