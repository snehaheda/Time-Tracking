public with sharing class TimeEntriesService {
    
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