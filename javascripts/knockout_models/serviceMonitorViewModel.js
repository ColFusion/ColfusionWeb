// Class to represent a row in the ColfusionServices objects grid
function ColfusionServices(name, initialAddress) {
    var self = this;
    self.name = name;
    self.address = ko.observable(initialAddress);
}

// Overall viewmodel for this screen, along with initial state
function ColfusionServicesViewModel() {
    var self = this;

    // Non-editable catalog data - would come from the server
    self.currentServices = [
        { addressName: "address1", price: 0 },
        { addressName: "address2", price: 1 },
        { addressName: "address3", price: 2 }
    ];    

    // Editable data
    self.services = ko.observableArray([
        new ColfusionServices("service1", self.currentServices[0]),
        new ColfusionServices("service2", self.currentServices[1])
    ]);
}

ko.applyBindings(new ColfusionServicesViewModel());