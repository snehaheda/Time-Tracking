({

    /*
        fired when u start typeing in lookup text box
     */
	keyPressController : function(component, event, helper) 
    { 
		var getInputkeyWord = component.get("v.searchKeyWord");

        if( getInputkeyWord.length > 0 ){
           var forOpen = component.find("searchRes");
           $A.util.addClass(forOpen, 'slds-is-open');
           $A.util.removeClass(forOpen, 'slds-is-close');
           helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }       
    },

  	// function for clear the Record Selaction 
    clear :function(component,event,helper){

         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 

         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');

         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');

         component.set("v.searchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
    },

  	// This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {


        var selected = event.getParam("taskSelected");

        component.set("v.selectedRecord" , selected);
       
        //component.set("v.searchKeyWord" , selected.btdevtestsh__Task__r.Name); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');


        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  

    },

  	// automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
      var spinner = component.find('spinner');
      var evt = spinner.get("e.toggle");
      evt.setParams({ isVisible : false });
      evt.fire();    
    },
 	
    // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },

    /*
        create the record back in the database
    */
    createRecord: function (component, event, helper) {
        var obj = component.get("v.selectedRecord"); 
        helper.createTimeEntry(component,obj);
    },

})