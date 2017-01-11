({
	 selectTask : function(component, event, helper){      
        // get the selected Account from list  
        
        var selectedTask = component.get("v.taskRecord"); 
        console.log(selectedTask);
        // call the event   
        var compEvent = component.getEvent("selectedTaskEvent");   
        compEvent.setParams({"taskSelected" : selectedTask });  
        // fire the event  
        compEvent.fire();
    },
})