/**
	@author : Sneha
	@date : 10/1/2017
	@purpose : Define the methods that will be use by the Test class
 */
public class TestDataHelper {

	/*
		@purpose : this method create a sample project
		@params : none
		@return : Project
	*/
    public static  Project__c setupProject() {
       	Project__c project = new Project__c(Name='Sample Project');
       	project.bill_by__c='Project';
       	project.Hourly_Rate__c=50;
        
        insert project;
        
        //add user to project 
        Project_User_Assignment__c userAdd = new Project_User_Assignment__c(Project__c=project.Id,User__c=UserInfo.getUserId(),Is_Project_Manager__c=true);
        insert userAdd;
        
        return project;
        
    }
    
    /*
    	@purpose: this method creates task under project
    	@params : String Id of the project
    	@return : List<Task_Assignment__c>
    */
    public static List<Task_Assignment__c> createTaskUnderProject(string projectId){
    	
    	//create 5 sample tasks and assign it to the project
    	List<Task__c> tasks = new List<Task__c>();
    	for(Integer i=0;i<5;i++){
    		tasks.add(new Task__c(Name='Sample Task '+i));
    	}
    	
    	insert tasks;
    	
    	List<Task_Assignment__c> assignments = new List<Task_Assignment__c>();
    	for(Integer i=0;i<5;i++){
    			assignments.add(new Task_Assignment__c(Project__c=projectId,Task__c=tasks[i].Id));
    	}
    	
    	insert assignments;
    	return assignments;
    	
    }
}