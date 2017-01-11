({
	/*
		@purpose: this controller action is used to stop the timer
		record
	*/
	stopTimer : function(component, event, helper) {			
        var obj = component.get("v.task");      
        helper.stopTimerRecord(component,obj);
	},
    
    /*
    @purpose: this controller action is used to resume a stopped the timer
		record
     */
    resumeTimer: function(component, event, helper) {
        //restart the timer:-
        var obj = component.get("v.task");
        helper.resumeTimerRecord(component,obj);
	}
})