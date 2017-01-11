/*
	@author : Sneha
	@date : 10/1/2017
	@purpose: Batch class to create weekly timesheet for all the team memebers of the projects
*/
public with sharing class AutoCreateTimesheetWeeklyBatch implements Database.Batchable<sObject>{

   public AutoCreateTimesheetWeeklyBatch(){
   		
   }
	
   /*
   	@purpose : this method quesry the data that will be used in the process
   */
   public Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'Select User__c,Project__c,Is_Project_Manager__c,Project__r.OwnerId FROM Project_User_Assignment__c WHERE Is_Deactivated__c=false';
      return Database.getQueryLocator(query);
   }

	/*
		@description : this method process the record set and creates timesheet for each of the 
		active user in a project
   */
   public void execute(Database.BatchableContext BC, List<Project_User_Assignment__c> scope){
    	
    	List<Timesheet__c> timesheets = new List<Timesheet__c>();
    	for(Project_User_Assignment__c record :scope){
    		 Timesheet__c timeSheet = new Timesheet__c(Project__c=record.Project__c,User__c=record.User__c);
	         timeSheet.Start_Date__c = Date.today().addDays(1).toStartOfWeek();
	         timeSheet.End_Date__c = timeSheet.Start_Date__c.toStartOfWeek().addDays(7);
	         timeSheet.Approval_Manager__c =  record.Project__r.OwnerId;
	         timesheets.add(timeSheet);
    	}
    	
    	insert timesheets;   	
   }

   public void finish(Database.BatchableContext BC){
   }
	
    
}