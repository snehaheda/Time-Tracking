({
	/*
        @purpose : invoke the apex method to perform the action

     */
    stopTimerRecord : function(component,obj) {
		//call the method	
		var action = component.get("c.stopTimerRecord");
        console.log(action);
        //pass data
        action.setParams({
            'timeEntry': obj
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();          
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            
            var title=state === 'SUCCESS' ? "Success!" :"Error!";
            var message=state === 'SUCCESS'?" Timer has been stopped.":"Something has gone wrong.";
            	
	        if(toastEvent){
                toastEvent.setParams({
                    "title": title,
                    "message": message
                });
                toastEvent.fire();
            }else{
               
            }
            var evt = component.getEvent("refreshTaskTimeList");
            evt.fire();
        });
        $A.enqueueAction(action);
        
	},
    
    /*
        @purpose : invoke the apex method to perform the action

     */
    resumeTimerRecord : function(component,obj) {
		//call the method
		var action = component.get("c.resumeTimerRecord");
        //pass data
        action.setParams({
            'timeEntry': obj
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            
            var title=state === 'SUCCESS' ? "Success!" :"Error!";
            var message=state === 'SUCCESS'?" Timer has been resumed.":"Something has gone wrong.";
            	
	        if(toastEvent){
                toastEvent.setParams({
                    "title": title,
                    "message": message
                });
                toastEvent.fire();
            }else{
               
            }
            var evt = component.getEvent("refreshTaskTimeList");
            evt.fire();
           
        });
        $A.enqueueAction(action);	
	}
})