function StatisticsViewModel() {
    var self = this;

    self.nDatasets = ko.observable();
    self.nDvariables = ko.observable();
    self.nRelationships = ko.observable();
    self.nRecords = ko.observable();
    self.nUsers = ko.observable();


    $.ajax({
    	url: "/Colfusion" + '/Statistics/GlobalStatisticsController.php?action=GetGlobalStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){

            self.nDatasets(data.numberOfStories);
            self.nDvariables(data.numberOfDvariables);
            self.nRelationships(data.numberOfRelationships);
            self.nRecords(data.numberOfRecords);
            self.nUsers(data.numberOfUsers);
        }
    });
}



ko.applyBindings(new StatisticsViewModel());
