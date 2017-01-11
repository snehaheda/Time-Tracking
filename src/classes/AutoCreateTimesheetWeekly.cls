/*
	@author : Sneha
	@date : 10/1/2017
	@purpose: This class is schedule every week on sunday to generate the timesheets so that user logs all the
			  timesheet entry under that time sheet for a week 
*/
public with sharing class AutoCreateTimesheetWeekly implements Schedulable{

   /*
   		@purpose: this method is exceuted to start the batch class to create timesheet records 
   		for each user for each project
   */
   public void execute(SchedulableContext SC) {
      
      //starting the batched process to ensure the sytem is can handle many projects 
      Database.executeBatch(new AutoCreateTimesheetWeeklyBatch());
      
      
   }
    
}