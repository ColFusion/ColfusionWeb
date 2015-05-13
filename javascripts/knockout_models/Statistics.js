function StatisticsViewModel() {
    var self = this;

    self.nDatasets = ko.observable();
    self.nDvariables = ko.observable();
    self.nRelationships = ko.observable();
    self.nRecords = ko.observable();
    self.nUsers = ko.observable();

    // obtain data from Engine
    $.ajax({
    	url: my_pligg_base + '/Statistics/GlobalStatisticsController.php?action=GetGlobalStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){
            // assign values to knockout observable variables
            self.nDatasets(data.numberOfStories);
            self.nDvariables(data.numberOfDvariables);
            self.nRelationships(data.numberOfRelationships);
            self.nRecords(data.numberOfRecords);
            self.nUsers(data.numberOfUsers);
        }
    });
}



ko.applyBindings(new StatisticsViewModel(), document.getElementById('globalStatistics'));
