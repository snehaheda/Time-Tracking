public with sharing class ProjectAssignmentsSelector extends SObjectSelector {
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description This overrides the method of base class to defined  field of this object
	* @return List of SObject field
	*/
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Project_User_Assignment__c.Id,
            Project_User_Assignment__c.User__c,
            Project_User_Assignment__c.Project__c,
            Project_User_Assignment__c.Hourly_rate__c,
            Project_User_Assignment__c.Is_Deactivated__c,
            Project_User_Assignment__c.Is_Project_Manager__c
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
        return Project_User_Assignment__c.sObjectType;
    }
	
	/**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all assignment records based on th id
 	* @param idSet  id of the Project_User_Assignment__c records to be fetched
	* @return list Project_User_Assignment__c records
	*/
    public List<Project_User_Assignment__c> selectById(Set<Id> idSet)
    {
    	 String query = String.format(
            'select {0},Project__r.Name,Project__r.OwnerId from {1} ' + 
            'where Id in :idSet ' , 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
        //return (List<Project_User_Assignment__c>) selectSObjectsById(idSet);
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all assignment records based on the project id
 	* @param idSet  id of the Project records to be fetched
	* @return list Project_User_Assignment__c records
	*/
    public List<Project_User_Assignment__c> selectByProject(Set<ID> idSet)
    {
        String query = String.format(
            'select {0},Project__r.Name,Project__r.Hourly_Rate__c from {1} ' + 
            'where Project__c in :idSet ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
    
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all assignment records based on the project & user
 	* @param projectIdSet  id of the Project records to be fetched
 	* @param userIdSet  id of the Users for whom the record are fetched
	* @return list Project_User_Assignment__c records
	*/
    public List<Project_User_Assignment__c> selectAssignmentByProjectByUser(Set<ID> projectIdSet,Set<ID> userIdSet){
    	
    	String query = String.format(
            'select {0},Project__r.Name,Project__r.Hourly_Rate__c from {1} ' + 
            'where User__c in :userIdSet AND Project__c in :projectIdSet ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
    }
    
    /**
	* @author Sneha
	* @date 12/1/2017
	* @description this method returns all assignment records based on the project id
 	* @param idSet  id of the Users for whom records to be fetched
	* @return list Project_User_Assignment__c records
	*/
    public List<Project_User_Assignment__c> projectsAssignedToUser(Set<ID> idSet)
    {
        String query = String.format(
            'select {0},Project__r.Name,Project__r.Hourly_Rate__c from {1} ' + 
            'where User__c in :idSet ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
    
    }
    
    
}