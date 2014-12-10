function ColfusionServicesViewModel() {
    var self = this;
    
    self.servicesList = ko.observableArray();
    self.serviceFoundList = ko.observableArray();
    
    self.serviceNamePattern = ko.observable("");
    
    self.getServicesList = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/getServicesStatus",
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                for (var i = 0; i < data.length; i++) {
                    self.servicesList.push(data[i]);
                }
            },
            error: function(data) {
                alert("Something went wrong while getting services' list. Please try again.");
            }
        });
    };
    
    self.getServiceStatusByNamePattern = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/getServiceStatusByNamePattern/" + self.serviceNamePattern(),
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
            	for (var i = 0; i < data.length; i++) {
                    self.serviceFoundList.push(data[i]);
                }
            },
            error: function(data) {
                alert("Something went wrong while getting service's status by name pattern. Please try again.");
            }
        }); 
    };

    self.addService = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/addNewService",
            type: 'POST',
            dataType: 'json',
            data: '',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                self.servicesList.push();
                alert(data.message);
            },
            error: function(data) {
                alert("Something went wrong while adding service. Please try again.");
            }
        });
    };
    
    self.removeService = function(serviceToRemove) {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/deleteServiceByID/" + serviceToRemove.serviceID,
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                self.servicesList.remove(serviceToRemove);
                alert(data.message);
            },
            error: function(data) {
                alert("Something went wrong while removing service by ID. Please try again.");
            }
        });
    };

    self.editService = function(serviceToEdit) {
        //TODO: implement
    };
    
    self.getServicesList();
}

ko.applyBindings(new ColfusionServicesViewModel());