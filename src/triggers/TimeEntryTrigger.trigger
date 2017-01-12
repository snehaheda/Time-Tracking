trigger TimeEntryTrigger on Time_Entry__c (before insert,after update ,after insert) {
    
  SObjectDomain.triggerHandler(TimeEntries.class);
}