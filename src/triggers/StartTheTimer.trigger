trigger StartTheTimer on Time_Entry__c (before insert,after update ,after insert) {
    
   
   /*
   		when the timer record gets created we need to update the rate at which this record
   		is billed to calculte the amount of the entry
   */
   
   if(Trigger.isInsert && Trigger.isBefore){
   		TimeTrackerTriggerHelper.updateRates(Trigger.new);
   		
   		//also stop the other records:-
   		TimeTrackerTriggerHelper.stopOtherTimerEntry();		
   }
   
    /*
        @purpose : This trigger is actually responsible for creating the time log
        that is used for hour calculation  
    */
    if(Trigger.isInsert && Trigger.isAfter){
        List<Time_Entry__c> recordsCreated = Trigger.new;
        //create a timer log
        TimeTrackerTriggerHelper.insertTimer(recordsCreated);
    }
    
    if(Trigger.isUpdate){
        List<Time_Entry__c> recordsCreated = new List<Time_Entry__c>();
        
        //in case the user has updated the time entry to be stopped we need to stop the timer
        TimeTrackerTriggerHelper.stopTimer(Trigger.new);
        
        //create a timer log if the user as tried restart any entry again :)
        for(Time_Entry__c entry : Trigger.new){
            if(entry.status__c =='Started' && Trigger.oldMap.get(entry.Id).Status__c!=entry.status__c){
                recordsCreated.add(entry);
            }
        }
        if(recordsCreated.size()>0){        	
        	TimeTrackerTriggerHelper.insertTimer(recordsCreated);
        }
    }
}