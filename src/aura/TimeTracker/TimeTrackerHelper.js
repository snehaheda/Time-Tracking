({
	
    /*
        @purpose: helper method that invoke apex method to fetch the
        task timer entry for a current day 
    */
    getTaskForUser : function(cmp) {
		// Load all data
        var action = cmp.get("c.getTodayTimerEntry");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                
                cmp.set("v.tasks", response.getReturnValue());
            }

            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            
            var title=state === 'SUCCESS' ? "Success!" :"Error!";
            var message=state === 'SUCCESS'?" Your tasks have been loaded successfully.":"Something has gone wrong.";
            	
	        if(toastEvent){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your tasks have been loaded successfully."
                });
                toastEvent.fire();
            }else{
               
            }
            
           
        });
        $A.enqueueAction(action);
	}
})