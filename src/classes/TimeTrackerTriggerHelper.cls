/**
	@author : Sneha
	@date : 10/1/2017
	@purpose : Class contains all the methods that are invoked in trigger execution
 */
public class TimeTrackerTriggerHelper{

    /*
    	@author : Sneha
		@date : 10/1/2017
		@purpose : this method is fired when the new time entry record is create. This method then populate the amount 
		value based on the project billy parameter
		
		@params : list of Time_Entry__c
    */
    public static void updateRates(List<Time_Entry__c> records){
    	
    	List<String> taskAssignmentId = new List<String> ();
    	List<String> projectId = new List<String> ();
    	
    	//get the task assignment id to fetch the details of project rate,tasks rates
    	for(Time_Entry__c entry :records){
    		taskAssignmentId.add(entry.Task_Assignment__c);	
    	}
    	
    	//get all the required details
    	Map<Id,Task_Assignment__c> taskRecord = new Map<Id,Task_Assignment__c>(
										    	[Select Id,Project__c,Project__r.Hourly_Rate__c,
										    	        Project__r.Bill_by__c ,Hourly_rate__c
										    	 FROM Task_Assignment__c 
										    	 WHERE Id IN:taskAssignmentId ]
										    	);
    	
    	//init the project id as we need to get user rate from project team
    	for(Task_Assignment__c record : taskRecord.values()){
    		projectId.add(record.project__c);
    	}
    	
    	//get the data
    	List<Project_User_Assignment__c> userRates = [Select Id,Hourly_Rate__c,User__c,Project__c 
    												  FROM Project_User_Assignment__c 
    												  WHERE Project__c IN:projectId];
    	
    	//init the map with user/project rate											  
    	Map<String,Double> userRateMap = new Map<String,Double>();
    	for(Project_User_Assignment__c assignment:userRates)
    			userRateMap.put(assignment.project__c+'-'+assignment.user__c,assignment.Hourly_Rate__c);
    	
    	//finally update the rate in the record		
    	for(Time_Entry__c rec : records){
    		Double rate = taskRecord.get(rec.Task_Assignment__c).Project__r.Bill_by__c=='Project' ?
    					  taskRecord.get(rec.Task_Assignment__c).Project__r.Hourly_Rate__c:
    					  taskRecord.get(rec.Task_Assignment__c).Project__r.Bill_by__c=='Task' ?
    					  taskRecord.get(rec.Task_Assignment__c).Hourly_Rate__c :
    					  userRateMap.get(taskRecord.get(rec.Task_Assignment__c).Project__c+'-'+rec.user__c);
    					
    		rec.Bill_By_Rate__c = rate;
    	}			
    	
    }
    
    /*
    	@author : Sneha
		@date : 10/1/2017
		@purpose : this method is fired when the new time entry record is created. It create a  timer record which keeps 
		track of start and end time. This will create with record start time
		
		@params : list of Time_Entry__c
    */
    
    public static void insertTimer(List<Time_Entry__c> records){
        
         
           List<Timer_Log__c> logs = new List<Timer_Log__c>();              
           for(Time_Entry__c entry  : records){
                if(entry.status__c=='Started'){
                   logs.add(new Timer_Log__c(Started_At__c=Datetime.now(),Time_Entry__c=entry.id)); 
                }   
           }
           
           insert logs;
    }
    
    /*
    	@author : Sneha
		@date : 10/1/2017
		@purpose : this method is fired when the  time entry record is being created. IIt stops the previous entry
		
		@params : none
    */
    public static void stopOtherTimerEntry(){
    	List<Time_Entry__c> userExistingRecord =[Select Id,Status__c FROM Time_Entry__c
    											 WHERE Status__c='Started' AND User__c =:UserInfo.getUserId()
    											];
    	
    	for(Time_Entry__c entry : userExistingRecord){
    		entry.status__c='Stopped';	
    	}
    	
    	update userExistingRecord;
    		
    }
    
    /*
    	@author : Sneha
		@date : 10/1/2017
		@purpose : this method is fired when the  time entry record is updated. It updates a  timer record which keeps 
		track of start and end time. This will update the record end time
		
		@params : list of Time_Entry__c
    */
    public static void stopTimer(List<Time_Entry__c> records){
           
           //get the all the time log records where end date not presetm
           Map<Id, Time_Entry__c > entryIdMap = new Map<Id, Time_Entry__c>(records);
             
           List<Timer_Log__c> logs = [Select Id,Ended_At__c FROM Timer_Log__c WHERE Ended_At__c=null AND Time_Entry__c IN : entryIdMap.keySet() AND Time_Entry__r.Status__c='Stopped'];             
           for(Timer_Log__c entry  : logs ){
                entry.Ended_At__c = DateTime.Now();
           }
           
           update logs;
    }


}