({
	  
    /*
      initailize the component with initial data
    */
    doInit : function(component, event, helper) {
        // Retrieve list of task during component initialization
        helper.getTaskForUser(component);
        
        //hide the new component
        
        var toggleElement = component.find("newEntry");
        $A.util.addClass(toggleElement, "slds-hide");

        var toggleElementList = component.find("listview");
        $A.util.removeClass(toggleElementList, "slds-hide");
        
    },//Delimiter for future code
    
    
    /*
      showSpinner & hideSpinner : this methods are called automaticall for the 
      system events
    */
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
    hideSpinner : function (component, event, helper) {
       var spinner = component.find('spinner');
       var evt = spinner.get("e.toggle");
       evt.setParams({ isVisible : false });
       evt.fire();    
    },

    /*
      @purpose:  this method shows the new entry form

    */
    createRecord : function (component, event, helper) {
       var toggleElement = component.find("newEntry");
       $A.util.toggleClass(toggleElement, "slds-hide");
        
       var toggleElementList = component.find("listview");
       $A.util.toggleClass(toggleElementList, "slds-hide");
    },

})