public with sharing class TimeEntriesSelector extends SObjectSelector{
    
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
    
    public override Schema.SObjectType getSObjectType()
    {
        return Time_Entry__c.sObjectType;
    }

    public List<Time_Entry__c> selectById(Set<ID> idSet)
    {
        return (List<Time_Entry__c>) selectSObjectsById(idSet);
    }
    
   /**
    * @author Sneha
    * @date 8/01/2017
    * @description this will return list of time entry that has been created today 
      @param : Set : id of the user
      @return list of records
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