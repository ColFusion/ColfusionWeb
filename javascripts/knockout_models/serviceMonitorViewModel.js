function ColfusionServicesViewModel() {
    var self = this;

    self.isFetchServicesInProgress = ko.observable(false);
    self.isFetchServicesErrorMessage = ko.observable(false);
    
    self.servicesList = ko.observableArray();
    
    self.fetchServicesLists = function() {
    	self.isFetchServicesInProgress(true);
        self.isFetchServicesErrorMessage(false);
        
	    $.ajax({
	        url: ColFusionServiceMonitorUrl + "/ServiceMonitor/getServicesStatus",
	        type: 'GET',
	        dataType: 'json',
	        contentType: "application/json",
	        crossDomain: true,
	        success: function(data) {
		         self.isFetchServicesInProgress(false);
		         if (data.isSuccessful) {
		        	 
			          var payload = data.payload;
			          var serviceItem;
			          
			          for (var i = 0; i < payload.length; i++) {
			        	  serviceItem = new ColfusionServicesViewModel();
			        	  serviceItem = payload[i];
			
			        	  self.serviceList.push(serviceItem);
			          };
		         }
		         else {
		              self.isFetchServicesErrorMessage("Something went wrong while fetching services. Please try again.");
		         }
	        },
	        error: function(data) {
		         self.isFetchServicesInProgress(false);
		         self.isFetchServicesErrorMessage("Something went wrong while fetching services. Please try again.");
	        }
	    });
    }
    
    self.fetchServicesLists();
}

ko.applyBindings(new ColfusionServicesViewModel());

