function DataMatchCheckerViewModel() {
    var self = this;
    
    self.name = ko.observable();
    self.description = ko.observable();
    self.fromDataset = ko.observable();
    self.toDataset = ko.observable();   
    self.links = ko.observableArray();
    
    self.differentValueTable = ko.observable();
    self.sameValueTable = ko.observable();
    self.partlyValueTable = ko.observable();
}

