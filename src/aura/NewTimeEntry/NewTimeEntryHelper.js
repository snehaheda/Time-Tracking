({
	
  /* method that perform the serach in the database */
  searchHelper : function(component,event,getInputkeyWord) {
	  	  // call the apex class method 
     	  var action = component.get("c.getTaskForProject");
      	// set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
          });
      	// set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
  /* helper method that calls the apex method which inturn creates the record in system */
  createTimeEntry: function(component,obj) {
     	var action = component.get("c.startTimer");
      	// set param to method  
        action.setParams({
            'selectedTask': obj
        }); 
        action.setCallback(this, function(response) {
        	  var state = response.getState();
            if (state === "SUCCESS") {
             	//show a toast message & reload the data fire the event   
             	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": 'Success',
                    "message": "Timer Has been started"
                });
                toastEvent.fire();
            }
			      var evt = component.getEvent("refreshTaskTimeList");
            evt.fire();            
        });
      	// enqueue the Action  
        $A.enqueueAction(action);
  }

})