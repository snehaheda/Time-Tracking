public with sharing class TaskAssignmentsSelector extends SObjectSelector{
    
     /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class to defined  field of this object
	* @return List of SObject field
	*/
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Task_Assignment__c.Id,
            Task_Assignment__c.Task__c,
            Task_Assignment__c.Project__c,
            Task_Assignment__c.Hourly_rate__c,
            Task_Assignment__c.Deactivated__c
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
        return Task_Assignment__c.sObjectType;
    }

	/**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all Task_Assignment__c records based on the id
 	* @param idSet  id of the Task_Assignment__c records to be fetched
	* @return list Task_Assignment__c records
	*/
    public List<Task_Assignment__c> selectById(Set<ID> idSet)
    {
        List<String> selectFields = 
        new List<String> {  
            'Id', 
            'Task__c', 
            'Project__c', 
            'Project__r.Name', 
            'Task__r.Name', 
            'Task__r.Description__c',
            'Project__r.Hourly_Rate__c',
            'Hourly_rate__c',
            'Project__r.Bill_by__c'
        };
        
        String query  = String.format('select {0} from {1} where Id in :idSet', 
                        new List<String> { String.join(selectFields, ','), getSObjectName() }
                        );
        
        return (List<Task_Assignment__c>) Database.query(query);    
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method searches task based on name for given project id
 	* @param idSet  id of the Project for whom records are to be fetched
  	* @param taskKeyword  text on which task are filtered
	* @return list Task_Assignment__c records
	*/
    public List<Task_Assignment__c> searchByTaskProjectId(String taskKeyword,Set<ID> idSet)
    {
        List<String> selectFields = 
        new List<String> {  
            'Id', 
            'Task__c', 
            'Project__c', 
            'Project__r.Name', 
            'Task__r.Name', 
            'Task__r.Description__c' };
        String searchKey = taskKeyword+'%';
        String query  = String.format('select {0} from {1} where Project__c in :idSet AND Task__r.Name LIKE :searchKey', 
                        new List<String> { String.join(selectFields, ','), getSObjectName() }
                        );
        
        return (List<Task_Assignment__c>) Database.query(query);    
    }
         
}