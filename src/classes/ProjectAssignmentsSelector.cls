public with sharing class ProjectAssignmentsSelector extends SObjectSelector {
    
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
    
    public override Schema.SObjectType getSObjectType()
    {
        return Project_User_Assignment__c.sObjectType;
    }

    public List<Project_User_Assignment__c> selectById(Set<Id> idSet)
    {
    	 String query = String.format(
            'select {0},Project__r.Name,Project__r.OwnerId from {1} ' + 
            'where Id in :idSet ' , 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
        //return (List<Project_User_Assignment__c>) selectSObjectsById(idSet);
    }
    
    public List<Project_User_Assignment__c> selectByProject(Set<ID> idSet)
    {
        String query = String.format(
            'select {0},Project__r.Name,Project__r.Hourly_Rate__c from {1} ' + 
            'where Project__c in :idSet ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
    
    }
    
    public List<Project_User_Assignment__c> selectAssignmentByProjectByUser(Set<ID> projectIdSet,Set<ID> userIdSet){
    	
    	String query = String.format(
            'select {0},Project__r.Name,Project__r.Hourly_Rate__c from {1} ' + 
            'where User__c in :userIdSet AND Project__c in :projectIdSet ' +
            'order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    
        return (List<Project_User_Assignment__c>) Database.query(query);
    }
    
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