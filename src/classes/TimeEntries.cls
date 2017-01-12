/*
    Domain class for time entry it handles all the specific function 
    related to time entry
*/
public with sharing class TimeEntries extends SObjectDomain
{
	  /**
	* @author Sneha
	* @date 12/1/2017
	* @description Initialize the parent
	* @return none
	*/
    public TimeEntries(List<Time_Entry__c> sObjectList)
    {
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }
    
   /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class : Method creates the Timer record for the newly inserted
	  time entry
	* @return none
	*/
    public override void onAfterInsert()
    {
        /*
            handle the action that we need to perform when trigger is fire after insert record
        */      
        //create the time tracker records for this we delegate the work the TimerService
        //delegate to the time log domain
        new TimerLogs(new List<Timer_Log__c>()).createTimer(new Map<Id,Time_Entry__c>((List<Time_Entry__c>) Records).keySet());              
    } 
   
   
   /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class : Method creates/updates the Timer record for the updated
	  time entry
	* @return none
	*/
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords)
    {    
    	//hold the record id for whic new timer record needs to be inserted           
        Set<Id> timeEntryId = new Set<Id>();
        
        //hold the record whose timer need to be stopped
        Set<Id> timeEntryIdToStop = new Set<Id>();     
        for(Time_Entry__c entry :(List<Time_Entry__c>) Records){
            if(entry.status__c ==TimeTrackerConstants.TIMER_STARTED && ((Time_Entry__c)existingRecords.get(entry.Id)).Status__c!=entry.status__c){
                timeEntryId.add(entry.Id);
            }
            if(entry.status__c ==TimeTrackerConstants.TIMER_STOPPED ){
                timeEntryIdToStop.add(entry.Id);
            }
        }

        //delegate this action to Time Log Domain class
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[] { Timer_Log__c.SObjectType });  
        
        if(timeEntryId.size()>0)new TimerLogs(new List<Timer_Log__c>()).createTimer(timeEntryId,uow);
        if(timeEntryIdToStop.size()>0)new TimerLogs(new TimerLogsSelector().selectTimerNotClosed(timeEntryIdToStop)).updateEndDate(uow); 
        uow.commitWork(); 
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class : This performs the action to populate the rate of task 
	  based on bill by field on project. This value is used for amount calculation
	* @return none
	*/
    public override void onBeforeInsert()
    {
        Set<Id> taskAssignmentId = new Set<Id> ();
        Set<Id> projectId = new Set<Id> ();
        
        //get the task assignment id to fetch the details of project rate,tasks rates
        for(Time_Entry__c entry :(List<Time_Entry__c>) Records){
            taskAssignmentId.add(entry.Task_Assignment__c); 
        }
        
        //get all the required details
        Map<Id,Task_Assignment__c> taskRecord = new Map<Id,Task_Assignment__c>(
                                                new TaskAssignmentsSelector().selectById(taskAssignmentId)
                                                );
        
        //init the project id as we need to get user rate from project team
        for(Task_Assignment__c record : taskRecord.values()){
            projectId.add(record.project__c);
        }
        
        //get the data
        List<Project_User_Assignment__c> userRates = new ProjectAssignmentsSelector ().selectByProject(projectId);
        
        //init the map with user/project rate                                             
        Map<String,Double> userRateMap = new Map<String,Double>();
        for(Project_User_Assignment__c assignment:userRates)
                userRateMap.put(assignment.project__c+'-'+assignment.user__c,assignment.Hourly_Rate__c);
        
        //finally update the rate in the record     
        for(Time_Entry__c entry :(List<Time_Entry__c>) Records){
            Double rate = taskRecord.get(entry.Task_Assignment__c).Project__r.Bill_by__c=='Project' ?
                          taskRecord.get(entry.Task_Assignment__c).Project__r.Hourly_Rate__c:
                          taskRecord.get(entry.Task_Assignment__c).Project__r.Bill_by__c=='Task' ?
                          taskRecord.get(entry.Task_Assignment__c).Hourly_Rate__c :
                          userRateMap.get(taskRecord.get(entry.Task_Assignment__c).Project__c+'-'+entry.user__c);
                        
            entry.Bill_By_Rate__c = rate;
        }   
        
    }
    
    public class Constructor implements SObjectDomain.IConstructable
    {
        public SObjectDomain construct(List<SObject> sObjectList)
        {
            return new TimeEntries(sObjectList);
        }
    }
}