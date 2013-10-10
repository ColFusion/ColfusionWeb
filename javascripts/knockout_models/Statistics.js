function StatisticsViewModel() {
    var self = this;

    self.nDatasets = ko.observable();
    self.nDvariables = ko.observable();


    $.ajax({
    	url: "/Colfusion" + '/Statistics/GlobalStatisticsController.php?action=GetGlobalStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){

            self.nDatasets(data.numberOfStories);
            self.nDvariables(data.numberOfDvariables);
        }
    });
}



ko.applyBindings(new StatisticsViewModel());
