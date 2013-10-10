function StatisticsViewModel() {
    var self = this;

    self.nDatasets = ko.observable();

    $.ajax({
    	url: "/Colfusion" + '/Statistics/GlobalStatisticsController.php?action=GetGlobalStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){
            self.nDatasets(data)
        }
    });
}



ko.applyBindings(new StatisticsViewModel());
