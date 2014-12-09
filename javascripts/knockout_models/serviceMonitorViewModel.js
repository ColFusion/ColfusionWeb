function ColfusionServicesViewModel() {
    var self = this;
    
    self.servicesList = ko.observableArray();
    
    self.fetchServicesLists = function() {
        $.ajax({
            url: ColFusionServiceMonitorUrl + "/ServiceMonitor/getServicesStatus",
            type: 'GET',
            dataType: 'json',
            ontentType: "application/json",
            rossDomain: true,
            success: function(data) {
                for (var i = 0; i < data.length; i++) {
                    self.servicesList.push(data[i]);
                }
            },
            error: function(data) {
                alert("Something went wrong while fetching services. Please try again.");
            }
        });
    };
    
    self.fetchServicesLists();
}

ko.applyBindings(new ColfusionServicesViewModel());