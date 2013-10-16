function StatisticsViewModel() {
    var self = this;

    self.m = ko.observable();
    self.s = ko.observable();
    self.c = ko.observable();
    //self.table = ko.observableArray();

    // obtain data from Engine
    $.ajax({
        url: my_pligg_base + '/Statistics/GlobalStatisticsController.php?action=storyStatisticsSummary',
        type: "GET",
        dataType: "json",
        success: function(data){
            // assign values to knockout observable variables
            self.m(data.mean);
            self.s(data.stdev);
            self.c(data.count);
        }
    });
    self.table = ko.observableArray([new tableContainer(self.m,self.s,self.c),
                                     new tableContainer(self.m,self.s,self.c)]);
}

function tableContainer(mean,stdev,count){
    var self = this;
    self.mean = mean;
    self.stdev = stdev;
    self.count = count;

}
ko.applyBindings(new StatisticsViewModel(), document.getElementById('statisticTest'));

