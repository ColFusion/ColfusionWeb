var DataPreviewViewModelProperties = {
    Header: function(name, cid, originalName, description, variableMeasuringUnit, variableValueType, variableValueFormat, missingValue) {
        var self = this;
        self.cid = ko.observable(cid);
        self.name = ko.observable(name);
        self.originalName = ko.observable(originalName);
        self.description = ko.observable(description);
        self.variableMeasuringUnit = ko.observable(variableMeasuringUnit);
        self.variableValueType = ko.observable(variableValueType);
        self.variableValueFormat = ko.observable(variableValueFormat);
        self.missingValue = ko.observable(missingValue);
        
    },
    ColumnMetaData: function(name){
        var selt = this;
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
        self.metabutton=1;
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
        self.isEditingMsgShown = function(sid) {
            $.ajax({
            url: OpenRefineUrl+"/command/core/is-table-locked?sid=" + sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                if(data.isTableLocked)
                    self.isEditLinkVisible(false);
                    isMsgShown = false;
                }
            });
        }

        self.isEditLinkVisible = ko.observable(true);
        self.isHeaderVisible = ko.observable(true);
        self.isHeaderMetaVisible = ko.observable(false);
        self.isProjectLoading = ko.observable(false);
        

        self.checkIfBeingEdited = function(sid) {
            // alert("check edit");
           $.ajax({
            url: OpenRefineUrl+"/command/core/is-table-locked?sid=" + sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
                if(data.isTableLocked) {
                    // alert("{" + data.userLogin + "}");
                    // var msgShown = "Table is being edited by <b><a href='user.php?login=" + data.userLogin + "'>" + data.userLogin + "</a></b>.";
                    var msgShown = "<span style='font-size:12px'><i>You cannot edit this table now, because the table is being edited by </i></span><b><a href='user.php?login=" + data.userLogin  + "'>" + data.userLogin + "</a></b><span style='font-size:12px'><i>, but you can see latest changes by clicking on Refresh button.</i></span>"
                    document.getElementById('isEditingMsg').innerHTML=msgShown;
                }
                }
            });
        };

        self.openRefineURL = ko.observable();

        // self.user_idFromPage = $("#user_id").val();

        self.swithToOpenRefine = function() {
            self.isProjectLoading(!self.isProjectLoading());
            self.isEditLinkVisible(!self.isEditLinkVisible());

            if (self.sid == -1)
                return;

            // var test = 12;
            // alert("swithToOpenRefine");
            $.ajax({
                url: OpenRefineUrl+"/command/core/create-project-from-colfusion-story?sid=" + self.sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
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
                            // use '#' to pass userid to OpenRefine page's 'save' button
                            self.openRefineURL(data.openrefineURL + "#" + $("#user_id").val());

                            $("#storyTitleOpenRefinePopUp").text(storyMetadataViewModel.title());

                            $('#editpopup').lightbox({resizeToFit: false});
                            self.isProjectLoading(!self.isProjectLoading());
                            self.isEditLinkVisible(!self.isEditLinkVisible());
                        }
                    }
                }
            });


            timeId = setInterval(function() {
                $.ajax({
                    url: OpenRefineUrl+"/command/core/timeout-notice?sid=" + self.sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
                    type: 'GET',
                    dataType: 'json',
                    contentType: "application/json",
                    crossDomain: true,
                    success: function(data) {
                        if(!data.isTableLocked) {
                            clearInterval(timeId);
                        } else if(data.isTimeOuting) {
                            alert("You have 5 mins left");
                            clearInterval(timeId);
                        }
                    }
                });
            },30000);
        };

        self.loadMetaData = function() {
               $.ajax({
                url: ColFusionServerUrl + "/Story/" + self.sid + "/" + self.tableName + "/metadata/columns",
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                   
                    self.headers.removeAll();

                   $.map(data.payload, function(column) {
                            self.headers.push(new DataPreviewViewModelProperties.Header(
                                column.chosenName,
                                column.cid,
                                column.originalName,
                                column.description ,
                                column.variableMeasuringUnit,
                                column.variableValueType,
                                column.variableValueFormat,
                                column.missingValue));
                    }); 
                    
                   
                }

            }) 

        }

        self.showColumnMetaData =function() {
            if(self.metabutton==1){
                $('#metabutton').text("[Hide]");
                self.metabutton=2;
            }
            else{
                $('#metabutton').text("[Display]");
                self.metabutton=1;
            }
             self.isHeaderVisible(!self.isHeaderVisible());
                    self.isHeaderMetaVisible(!self.isHeaderMetaVisible());
            
          };

        self.refreshPage = function() {
            self.loadMetaData();
            alert("Changes have been saved!");
        }

     self.loadMetaData();
     
 }
}

function DataPreviewViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.oldname;
    self.tableList = ko.observableArray();
    self.currentTable = ko.observable();
    self.columnName = ko.observable();
    self.variableValueType = ko.observable();
    self.originalName = ko.observable();
    self.description = ko.observable();
    self.variableMeasuringUnit = ko.observable();
    self.variableValueFormat = ko.observable();
    self.missingValue = ko.observable();
    
    self.isLoading = ko.observable(false);
    self.isError = ko.observable(false);
    self.isNoData = ko.observable(false);
    self.isPreviewStory = ko.observable(true);
    self.isEditColumnData = ko.observable(false);

    self.Modify = function(name,variableValueType,originalName,description,variableMeasuringUnit,variableValueFormat,missingValue){
        self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());
        self.oldname=name;
        self.columnName(name);
        self.variableValueType(variableValueType);
        self.originalName(originalName);
        self.description(description);
        self.variableMeasuringUnit(variableMeasuringUnit);
        self.variableValueFormat(variableValueFormat);
        self.missingValue(missingValue);
        
     }

    self.editColumnSave = function(){
        dataSourceUtil.updateColumnMetaData(self.sid,self.oldname,self.columnName(),self.variableValueType(),self.originalName(),self.description(),self.variableMeasuringUnit(),self.variableValueFormat(),self.missingValue());
     self.currentTable().refreshPage();
     self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());
     }

    self.editColumnCancel = function(){
        self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());
    }

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
        self.currentTable().isEditingMsgShown(self.sid);
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

    self.refreshTablePreview = function() {
        var currentTable = self.currentTable();
       
        self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage, currentTable.currentPage());
    }
   

    self.refreshPreview = function() {
        /*
        ** Add an ajax call to make clicking the "close this dialog" to release the table instead of clicking "save" button
        */
        $.ajax({
                url: OpenRefineUrl + "/command/core/release-table?sid=" + self.sid + "&tableName=" + self.currentTable().tableName + "&userId=" + $("#user_id").val(), 
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                    // alert("userId: " + data.testMsg);
                    if (data.successful) {
                        // alert(data.msg);
                    }
                }
            });

/* TODO:
** If tableName is renamed, we need to update the knockout model to make the change shown, but for now
** have no idea how to update it except refreshing the whole page.
*/
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