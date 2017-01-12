public with sharing class TimesheetsSelector extends SObjectSelector {
    
    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Timesheet__c.Id,
            Timesheet__c.User__c,
            Timesheet__c.Project__c,
            Timesheet__c.Start_Date__c,
            Timesheet__c.Approval_Manager__c,
            Timesheet__c.Status__c
        };
    }
    
    public override Schema.SObjectType getSObjectType()
    {
        return Timesheet__c.sObjectType;
    }
    
    public List<Timesheet__c> getCurrentWeekTimesheetForUser(Set<ID> idSet)
    {
        String query = String.format(
            'select {0} from {1} ' + 
            'where User__c in :idSet AND Start_Date__c = THIS_WEEK' +
            ' order by SystemModstamp DESC', 
            new List<String>{ getFieldListString(), getSObjectName()});
    	system.debug(query);
        return (List<Timesheet__c>) Database.query(query);
    
    } 
}