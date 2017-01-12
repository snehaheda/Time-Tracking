public with sharing class TimerLogs extends SObjectDomain{
    
    
	  /**
	* @author Sneha
	* @date 12/1/2017
	* @description Initialize the parent
	* @return none
	*/
    public TimerLogs(List<Timer_Log__c> sObjectList)
    {
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }  
    

   /**
	* @author Sneha
	* @date 12/1/2017
	* @description method creates TimeEntry Timestamp record under time entry
 	* @param timeEntryId  id of the TimeEntry for which we are creating this entry
	* @return Set<Id> id of the newly created records
	*/
    public  Set<Id> createTimer(Set<ID> timeEntryId)
    {
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);                        
        // Create timer from the given entry
        List<Timer_Log__c> logs = new List<Timer_Log__c>();
        for(Id recordId : timeEntryId)      
        {
            Timer_Log__c log = new Timer_Log__c(Started_At__c=Datetime.now(),Time_Entry__c=recordId);
            logs.add(log);
            uow.registerNew(log);   
        }       
        // Commit
        uow.commitWork();                                   
        return new Map<Id,Timer_Log__c>(logs).keySet();
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description method creates TimeEntry Timestamp record under time entry
 	* @param timeEntryId  id of the TimeEntry for which we are creating this entry
 	* @param uow : sobject unit of work record
	* @return Set<Id> id of the newly created records
	*/
    public  void createTimer(Set<ID> timeEntryId,SObjectUnitOfWork uow)
    {
                            
        // Create timer from the given entry
        List<Timer_Log__c> logs = new List<Timer_Log__c>();
        for(Id recordId : timeEntryId)      
        {
            Timer_Log__c log = new Timer_Log__c(Started_At__c=Datetime.now(),Time_Entry__c=recordId);
            logs.add(log);
            uow.registerNew(log);   
        }       
        
    }
     /**
	* @author Sneha
	* @date 12/1/2017
	* @description method updated the end datetime of the timer
 	* @param uow : sobject unit of work record
	* @return none
	*/
    public  void updateEndDate(SObjectUnitOfWork uow)
    {
                            
        // Create timer from the given entry
        for(Timer_Log__c log : (List<Timer_Log__c>) Records)    
        {
            log.Ended_At__c = Datetime.Now();
            uow.registerDirty(log); 
        }       
        
    }
    
    // SObject's used by the logic in this service, listed in dependency order
    private static List<Schema.SObjectType> SERVICE_SOBJECTS = 
        new Schema.SObjectType[] { 
            Timer_Log__c.SObjectType
         };
    
    public class Constructor implements SObjectDomain.IConstructable
    {
        public SObjectDomain construct(List<SObject> sObjectList)
        {
            return new TimerLogs(sObjectList);
        }
        
    } 
}