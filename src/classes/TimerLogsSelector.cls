public with sharing class TimerLogsSelector extends SObjectSelector {
    
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Timer_Log__c.Id,
            Timer_Log__c.Time_Entry__c,
            Timer_Log__c.Ended_At__c,
            Timer_Log__c.Started_At__c
        };
    }
    
    public override Schema.SObjectType getSObjectType()
    {
        return Timer_Log__c.sObjectType;
    }

    /*
    
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