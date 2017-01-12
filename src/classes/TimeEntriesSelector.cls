public with sharing class TimeEntriesSelector extends SObjectSelector{
    
      /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class to defined  field of this object
	* @return List of SObject field
	*/
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Time_Entry__c.Id,
            Time_Entry__c.Bill_By_Rate__c,
            Time_Entry__c.Task_Assignment__c,
            Time_Entry__c.Status__c,
            Time_Entry__c.Timesheet__c,
            Time_Entry__c.User__c,
            Time_Entry__c.Task__c,
            Time_Entry__c.Project__c
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
        return Time_Entry__c.sObjectType;
    }
	
	/**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all Time_Entry__c records based on the id
 	* @param idSet  id of the Time_Entry__c records to be fetched
	* @return list Time_Entry__c records
	*/
    public List<Time_Entry__c> selectById(Set<ID> idSet)
    {
        return (List<Time_Entry__c>) selectSObjectsById(idSet);
    }
    
   /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all Time_Entry__c records for a user
 	* @param userIds  id of the Users for whome records are to be fetched
	* @return list Time_Entry__c records
	*/
    public  List<Time_Entry__c> selectCurrentDateTimerEntryByUser(Set<Id>  userIds){
        
        String query = String.format(
            'select {0} from {1} ' + 
            'where Date__c= TODAY AND  User__c in :userIds ' +
            ' order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    	system.debug(query);
        return (List<Time_Entry__c>) Database.query(query);
     
    }
    
    
    
}