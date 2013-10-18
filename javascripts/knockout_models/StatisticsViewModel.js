function StatisticsViewModel() {
    var self = this;

    self.m = ko.observableArray();
    self.s = ko.observableArray();
    self.c = ko.observableArray();
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
    self.table = ko.observableArray([new tableContainer(self.m,self.s,self.c)]);
    
    self.goToNextPage = function() {
        if (self.isLoading())
            return;
        var currentTable = self.currentTable();
        var currentPage = currentTable.currentPage();
        var totalPage = currentTable.totalPage();
        if (currentPage < totalPage) {
            currentTable.currentPage(parseInt(currentPage) + 1);
            self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage, currentTable.currentPage());
        }
    };

    self.goToPreviousPage = function() {
        if (self.isLoading())
            return;
        var currentTable = self.currentTable();
        var currentPage = currentTable.currentPage();
        if (currentPage > 1) {
            currentTable.currentPage(parseInt(currentPage) - 1);
            self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage, currentTable.currentPage());
        }
    };

}

function tableContainer(mean,stdev,count){
    var self = this;
    self.mean = mean;
    self.stdev = stdev;
    self.count = count;

}
ko.applyBindings(new StatisticsViewModel(), document.getElementById('statisticTest'));

