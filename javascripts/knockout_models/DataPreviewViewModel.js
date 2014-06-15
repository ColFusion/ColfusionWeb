var DataPreviewViewModelProperties = {
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
    Table: function(sid, tableName, cols, rows, rawData, totalPage, currentPage, perPage) {
        var self = this;
        self.sid = sid;
        self.tableName = tableName;
        self.totalPage = ko.observable(totalPage);
        self.currentPage = ko.observable(currentPage);
        self.perPage = ko.observable(perPage);
        self.headers = ko.observableArray($.map(cols, function(header) {
            return new DataPreviewViewModelProperties.Header(header);
        }));

        self.rows = ko.observableArray($.map(rows, function(row) {
            return new DataPreviewViewModelProperties.Row(row);
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
            self.rows.push(new DataPreviewViewModelProperties.Row(row));
        };

        /*
        ** Added 06/13/2014
        ** Aim to check if the table is edit and by whom 
        */

        self.isEditLinkVisible = ko.observable(true);

        self.checkIfBeingEdited = function(sid) {
            // alert("check edit");
           $.ajax({
            url: "http://localhost/OpenRefine/command/core/is-table-locked?sid=" + sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                if(data.isTableLocked)
                    self.isEditLinkVisible(false);
                }
            });
        };

        self.openRefineURL = ko.observable();


        self.swithToOpenRefine = function() {

            if (self.sid == -1)
                return;

            // var test = 12;
            // alert("swithToOpenRefine");
            $.ajax({
                url: "http://localhost/OpenRefine/command/core/create-project-from-colfusion-story?sid=" + self.sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                    // alert("userId: " + data.testMsg);
                    if (data.successful) {
                        if(data.isEditing && !data.isTimeOut) {
                            alert(data.msg);
                        } else {
                            self.openRefineURL(data.openrefineURL);

                            $("#storyTitleOpenRefinePopUp").text(storyMetadataViewModel.title());

                            $('#editpopup').lightbox({resizeToFit: false});
                        }
                    }
                }
            });
        };

    }
};

function DataPreviewViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.tableList = ko.observableArray();
    self.currentTable = ko.observable();
    
    self.isLoading = ko.observable(false);
    self.isError = ko.observable(false);
    self.isNoData = ko.observable(false);

    self.setTableList = function (tableList) {
        self.tableList($.map(tableList, function(tableName) {
            return new DataPreviewViewModelProperties.TableListItem(tableName);
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

        dataSourceUtil.getTableDataBySidAndName(self.sid, tableName, perPage, pageNo).done(function(data) {
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
        self.currentTable(new DataPreviewViewModelProperties.Table(self.sid, tableName, transformedData.columns, transformedData.rows, tableData.data, totalPage, currentPage, perPage));
        self.currentTable().checkIfBeingEdited(self.sid);
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

   

    self.refreshPreview = function() {

        var currentTable = self.currentTable();
       
        self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage, currentTable.currentPage());
    }
/*
* The following two functions "saveToDb" and "cancelButton" will not be used anymore, because
* related buttons have been removed from "published data -> dataPreview page", but just keep these
* functions for future use  ------ by Alex
*/
    self.saveToDb = function() {
        $.ajax({
            url: ColFusionServerUrl + "/OpenRefine/savePreview/" + self.sid + "/" + self.currentTable().tableName, 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                if (data.successful) {
                    var testMsg = data.payload;
                    alert(testMsg);
                }
            }
        });
        alert("Save Button!");
    }

    self.cancelButton = function() {
        $.ajax({
            url: ColFusionServerUrl + "/OpenRefine/cancelPreview/" + self.sid + "/" + self.currentTable().tableName, 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                if (data.successful) {
                    var testMsg = data.payload;
                    alert(testMsg);
                    if(testMsg == "Change has been cancelled!")
                        location.reload(true);
                }
            }
        });
    }

}