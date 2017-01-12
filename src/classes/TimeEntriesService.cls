public with sharing class TimeEntriesService {
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description method creates TimeEntry record under project for given timesheet
 	* @param taskAssignmentId  id of the Task & Project for which we are creating this entry
 	* @params timesheetId id of the timesheet record under which this record is created
 	* @param  userId : id of the user for whom this record is created
	* @return none
	*/
     public static void createTimeEntryForProjectTask(Set<Id> taskAssignmentId, String timesheetId,String userId)
    {
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);                        

        for(Task_Assignment__c selectedTask : new TaskAssignmentsSelector().selectById(taskAssignmentId))        
        {
             Time_Entry__c newEntry = new Time_Entry__c();
             newEntry.Task_Assignment__c =selectedTask.Id;
             newEntry.Date__c = Date.today();
             newEntry.Timer_Started_At__c = DateTime.Now();
             newEntry.timesheet__c = timesheetId;
             newEntry.Status__c = 'Started';
             newEntry.User__c=userId;
             uow.registerNew(newEntry); 
        }
        
        // Commit
        uow.commitWork();                                   
    }
    
     /**
	* @author Sneha
	* @date 12/1/2017
	* @description method updated TimeEntry record with the given status
 	* @param timeEntryId  id of the TimeEntry for which we are updating the status
 	* @params status status value which will be updated
	* @return none
	*/ 
    public static void updateStatus(Set<Id> timeEntryId,String status){
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);
        for(Time_Entry__c entry : new TimeEntriesSelector().selectById(timeEntryId)){
            entry.Status__c=status;
            uow.registerDirty(entry);
        }
        uow.commitWork();
    }

  
    // SObject's used by the logic in this service, listed in dependency order
    private static List<Schema.SObjectType> SERVICE_SOBJECTS = 
        new Schema.SObjectType[] { 
            Time_Entry__c.SObjectType
    };
   
}