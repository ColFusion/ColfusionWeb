var StoryStatisticsViewModelProperties = {
    Header: function(name) {
        var self = this;
        self.name = ko.observable(name);
    },
    Row: function(cells) {
        var self = this;
        self.cells = ko.observableArray(cells);
    },
    TableListItem: function(tableName) {
        var self = this;
        self.isChoosen = ko.observable(false);
        self.tableName = ko.observable(tableName);
    },
    Table: function(tableName, cols, rows, rawData, totalPage, currentPage, perPage) {
        var self = this;
        self.tableName = tableName;
        self.totalPage = ko.observable(totalPage);
        self.currentPage = ko.observable(currentPage);
        self.perPage = ko.observable(perPage);
        self.headers = ko.observableArray($.map(cols, function(header) {
            return new StoryStatisticsViewModelProperties.Header(header);
        }));

        self.rows = ko.observableArray($.map(rows, function(row) {
            return new StoryStatisticsViewModelProperties.Row(row);
        }));

        self.rawData = ko.observableArray(rawData);

        self.getCells = function() {
            var cells = [];
            $.each(self.rows(), function(index, row) {
                cells.push(row.cells());
            });
            return cells;
        };

        self.addRow = function(row) {
            self.rows.push(new StoryStatisticsViewModelProperties.Row(row));
        };
    }
};

function StoryStatisticsViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.tableList = ko.observableArray();
    self.currentTable = ko.observable();
    
    self.isLoading = ko.observable(false);
    self.isError = ko.observable(false);
    self.isNoData = ko.observable(false);
    
    self.setTableList = function (tableList) {
        self.tableList($.map(tableList, function(tableName) {
            return new StoryStatisticsViewModelProperties.TableListItem(tableName);
        }));
    };
    // Get all tables of a data set and choose the first table.

    self.getTablesList = function() {
        dataSourceUtil.getTablesList(self.sid).done(function (data) {
            self.setTableList(data);
            self.chooseTable(self.tableList()[0]);
        });
    };

    self.getTableDataBySidAndName = function(tableName, perPage, pageNo) {
        self.isLoading(true);
        self.isNoData(false);
        self.isError(false);

        dataSourceUtil.getStoryStatisticsBySidAndName(self.sid, tableName, perPage, pageNo).done(function(data) {
            createDataTable(tableName, data);
            self.isError(false);
        }).error(function() {
            self.isError(true);
        }).always(function() {
            self.isLoading(false);
        });
    };

    self.getTableDataByObject = function (object, perPage, pageNo) {
        self.isLoading(true);
        self.isNoData(false);
        self.isError(false);

        dataSourceUtil.getTableDataByObject(object, perPage, pageNo).done(function (data) {
            createDataTable('Merged Dataset', data);
            self.isError(false);
        }).error(function () {
            self.isError(true);
        }).always(function () {
            self.isLoading(false);
        });
    };

    function createDataTable(tableName, tableData) {
        if (!tableData.Control || !tableData.Control.cols || tableData.Control.cols.length === 0) {
            self.isNoData(true);
            self.currentTable(null);
            return;
        }
        self.isNoData(false);
        // Controls.
        var perPage = tableData.Control.perPage;
        var totalPage = tableData.Control.totalPage;
        var currentPage = tableData.Control.pageNo;

        var transformedData = dataSourceUtil.transformRawDataToColsAndRows(tableData);
        self.currentTable(new StoryStatisticsViewModelProperties.Table(tableName, transformedData.columns, transformedData.rows, tableData.data, totalPage, currentPage, perPage));
    }

    self.chooseTable = function(tableListItem) {
        if (self.isLoading())
            return;

        // Unchoose all list items.
        $(self.tableList()).each(function(index, tableListItem) {
            tableListItem.isChoosen(false);
        });

        // Choose clicked item.
        tableListItem.isChoosen(true);
        var tableName = tableListItem.tableName();
        self.getTableDataBySidAndName(tableName, 10, 1);
    };

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

