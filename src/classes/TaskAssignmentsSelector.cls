public with sharing class TaskAssignmentsSelector extends SObjectSelector{
    
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
    
    public override Schema.SObjectType getSObjectType()
    {
        return Task_Assignment__c.sObjectType;
    }

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