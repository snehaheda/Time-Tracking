public with sharing class TimerLogsSelector extends SObjectSelector {
    
     /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class to defined  field of this object
	* @return List of SObject field
	*/
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Timer_Log__c.Id,
            Timer_Log__c.Time_Entry__c,
            Timer_Log__c.Ended_At__c,
            Timer_Log__c.Started_At__c
        };
    }
    
     /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class to return the type of sobject
	* @return Schema.SObjectType
	*/
    public override Schema.SObjectType getSObjectType()
    {
        return Timer_Log__c.sObjectType;
    }

   /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all timestamp  records for a given set of timer entry records
 	* @param timeEntryId  id of the Time_Entry__c for whom records are to be fetched
	* @return list Timer_Log__c records
	*/
    public List<Timer_Log__c> selectTimerNotClosed(Set<ID> timeEntryId)
    {
        String query = String.format(
            'select {0}  from {1} ' + 
            'where Time_Entry__c in :timeEntryId AND Ended_At__c=null ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Timer_Log__c>) Database.query(query);
    
    }
}