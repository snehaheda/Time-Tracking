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
    	
    	TimesheetsService.createThisWeekTimesheet(new Map<Id,Project_User_Assignment__c>(scope).keySet()); 	
   }

   public void finish(Database.BatchableContext BC){
   }
	
    
}