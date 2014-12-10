function ColfusionServiceViewModel() {
    var self = this;
    
    self.serviceID = -1;
    self.serviceName = ko.observable();
    self.serviceAddress = ko.observable();
    self.portNumber = ko.observable();
    self.serviceDir = ko.observable();
    self.serviceCommand = ko.observable();
    self.serviceStatus = ko.observable("unknown");
}

function ColfusionServicesViewModel() {
    var self = this;
    
    self.servicesList = ko.observableArray();
    self.serviceFoundList = ko.observableArray();
    
    self.serviceNamePattern = ko.observable("");

    self.newService = ko.observable(null);
    self.isAddingNewService = ko.computed(function() {
            return self.newService() === null;
        }, self);
    
    self.selectedService = ko.observable(null);
    self.selectedBackupService = null;
    
    self.getServicesList = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/getServicesStatus",
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                for (var i = 0; i < data.length; i++) {
                    var service = new ColfusionServiceViewModel();
                    service.serviceID = data[i].serviceID;
                    service.serviceName(data[i].serviceName);
                    service.serviceAddress(data[i].serviceAddress);
                    service.portNumber(data[i].portNumber);
                    service.serviceDir(data[i].serviceDir);
                    service.serviceCommand(data[i].serviceCommand);
                    service.serviceStatus(data[i].serviceStatus);
                    self.servicesList.push(service);
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
        self.newService(new ColfusionServiceViewModel());
    };

    self.saveAddNewService = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/addNewService",
            type: 'POST',
            dataType: 'json',
            data: ko.toJSON(self.newService()),
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                self.servicesList.push(data);
                self.newService(null);
            },
            error: function(data) {
                alert("Something went wrong while adding service. Please try again.");
            }
        });
    };

    self.cancelAddNewService = function() {
        self.newService(null);
    };
    
    self.editService = function(serviceToEdit) {
        self.cancelEditSelectedService();
        self.selectedService(serviceToEdit);
        self.selectedBackupService = ko.toJS(serviceToEdit);
    };

    self.saveEditSelectedService = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/updateServiceByID/" + self.selectedService().serviceID,
            type: 'POST',
            dataType: 'json',
            data: ko.toJSON(self.selectedService()),
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                //self.servicesList.push(data);
                self.selectedService(null);
            },
            error: function(data) {
                alert("Something went wrong while editing service. Please try again.");
            }
        });
    };

    self.cancelEditSelectedService = function() {
        if (self.selectedService() !== null) {

            self.selectedService().serviceName(self.selectedBackupService.serviceName);
            self.selectedService().serviceAddress(self.selectedBackupService.serviceAddress);
            self.selectedService().portNumber(self.selectedBackupService.portNumber);
            self.selectedService().serviceDir(self.selectedBackupService.serviceDir);
            self.selectedService().serviceCommand(self.selectedBackupService.serviceCommand);
            self.selectedService().serviceStatus(self.selectedBackupService.serviceStatus);

            self.selectedService(null);
        }
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
    
    self.getServicesList();
}

ko.applyBindings(new ColfusionServicesViewModel());