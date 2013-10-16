function StatisticsViewModel() {
    var self = this;

    self.mean = ko.observable();
    self.stdev = ko.observable();
    self.count = ko.observable();

    // obtain data from Engine
    $.ajax({
    	url: my_pligg_base + '/Statistics/GlobalStatisticsController.php?action=storyStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){
            // assign values to knockout observable variables
            self.mean(data.mean);
            self.stdev(data.stdev);
            self.count(data.count);
        }
    });
}



ko.applyBindings(new StatisticsViewModel(), document.getElementById('statisticTest'));
