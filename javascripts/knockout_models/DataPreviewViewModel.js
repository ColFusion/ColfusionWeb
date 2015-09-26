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
        self.isColumnMetaEdit = ko.observable();
        if($("#user_id").val()==0){
            self.isColumnMetaEdit(false);
        }
        else{
            self.isColumnMetaEdit(true);
        }
        
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
        debugger;
        var self = this;
        self.metabutton=1;
        self.sid = sid;
        self.tableName = tableName;
        self.totalPage = ko.observable(totalPage);
        self.currentPage = ko.observable(currentPage);
        self.perPage = ko.observable(perPage);
debugger;
        if (typeof cols === "string") {
            cols = cols.split(','); //TODO: this is quick hack that assumes if the cols is a string, then variables are comma separated, see issue #31
        }

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
            if (sid == -1) {
                return;
            }

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

        self.checkIfLoggedin = function(sid){
            if($("#user_id").val()==0){
                self.isEditLinkVisible(false);
            }
        }
        

        self.checkIfBeingEdited = function(sid) {

            if (sid == -1) {
                return;
            }

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

            if (self.sid == -1) {
                return;
            }

            var myOpenRefineUrl;
            var tempOpenRefineUrl;

            $.ajax({
                url: OpenRefineUrl + "/command/core/create-project-from-colfusion-story?sid=" + self.sid + "&tableName=" + self.tableName + "&userId=" + $("#user_id").val(), 
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                    // alert("userId: " + data.testMsg);
debugger;
                    if (data.successful) {
                        if(data.isEditing && !data.isTimeOut) {
                            alert(data.msg);
                        } else {
                            myOpenRefineUrl = data.openrefineURL;
                            tempOpenRefineUrl = data.openrefineURL + "#" + $("#user_id").val();
                            // use '#' to pass userid to OpenRefine page's 'save' button
                            self.openRefineURL(data.openrefineURL + "#" + $("#user_id").val() + "#" + myOpenRefineUrl + "#" + self.sid + "#" + self.tableName);
                            $("#storyTitleOpenRefinePopUp").text(storyMetadataViewModel.title());

                            $('#editpopup').show();
                            self.isProjectLoading(!self.isProjectLoading());
                            self.isEditLinkVisible(!self.isEditLinkVisible());                          
                        }
                    }
                }
            }).done(function() {
                $.ajax({
                    url: OpenRefineUrl+"/command/core/set-check-point?url=" + myOpenRefineUrl, 
                    type: 'GET',
                    dataType: 'json',
                    contentType: "application/json",
                    crossDomain: true,
                    success: function(data) {
                        //self.openRefineURL(tempOpenRefineUrl + "#" + myOpenRefineUrl + "#" + self.sid + "#" + self.tableName);
                        // alert(tempOpenRefineUrl);
                        //alert("Hey! New Command works!" + data.testMsg);
                    }
                });
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
                            window.clearInterval(timeId);
                        } else if(data.isTimeOuting) {
                            alert("You have 5 mins left");
                            window.clearInterval(timeId);
                        }
                    }
                });
            },30000);
        };

        self.loadMetaData = function() {
            //TODO: for now just check in sid -1 then don't need to load columns metadata. For in future, each column should ask for metadata about itself.
            
            if (self.sid == -1) {
                return;
            }

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
                $('#metabutton').text("[Details]");
                self.metabutton=1;
            }
             self.isHeaderVisible(!self.isHeaderVisible());
                    self.isHeaderMetaVisible(!self.isHeaderMetaVisible());
            
          };


     self.loadMetaData();
     
 }
}

function DataPreviewViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.cid;
    self.userid;
    self.index = ko.observable();

    self.oldname;
    self.oldvariableValueType;
    self.olddescription;
    self.oldvariableMeasuringUnit;
    self.oldvariableValueFormat;
    self.oldmissingValue;

    self.tableList = ko.observableArray();
    self.currentTable = ko.observable();
    self.columnName;
    self.variableValueType;
    self.description;
    self.variableMeasuringUnit;
    self.variableValueFormat;
    self.missingValue;
    self.reason = "";
    self.editAttribute;
    self.editValue;
    
    self.isLoading = ko.observable(false);
    self.isError = ko.observable(false);
    self.isNoData = ko.observable(false);
    self.isPreviewStory = ko.observable(true);
    self.isEditColumnData = ko.observable(false);
    self.isChosenNameEmpty = ko.observable(false);

    self.historyLogHeaderText = ko.observable();
    self.showAttribute;
    self.columnMetadataHistory = ko.observable();

    self.isFetchHistoryInProgress = ko.observable(false)
    self.isFetchHistoryErrorMessage = ko.observable("");

    self.selectValueType = ko.observableArray(['Number','String','Date','Time','Location']);
    self.selectUnit = ko.observableArray();
    self.selectFormat = ko.observableArray();


    self.Modify = function(cid,name,variableValueType,description,variableMeasuringUnit,variableValueFormat,missingValue,index){
        self.index(index);

        self.userid = $("#user_id").val();
        self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());
      
        self.cid = cid;

        self.oldname = name;
        self.oldvariableValueType = variableValueType;
        self.olddescription = description;
        self.oldvariableMeasuringUnit = variableMeasuringUnit;
        self.oldvariableValueFormat = variableValueFormat;
        self.oldmissingValue = missingValue;

        if(self.currentTable().headers()[self.index()].variableValueType()=="Number"){
            self.selectUnit(['','kilometer','meter','mile','kilogram','gram','hundreds','thousands','millions']);
            self.selectFormat(['']);
        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Location"){
            self.selectUnit(['','country','state','city','street','zipcode','latitude','longitude']);
            self.selectFormat(['']);
        }
         if(self.currentTable().headers()[self.index()].variableValueType()=="String"){
            self.selectUnit(['']);
            self.selectFormat(['']);
        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Date"){
            self.selectFormat(['','yy/mm/dd','mm/dd/yy','dd/mm/yy','mm-dd-yy','yy-mm-dd','dd-mm-yy',]);
            self.selectUnit(['']);

        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Time"){
            self.selectFormat(['','hh:mm:ss','hh:mm:ss AM/PM','hh','mm','ss','hh:mm']);
            self.selectUnit(['']);

        }

        self.currentTable().headers()[self.index()].name(self.oldname);
        self.currentTable().headers()[self.index()].variableValueType(self.oldvariableValueType);
        self.currentTable().headers()[self.index()].description(self.olddescription);
        self.currentTable().headers()[self.index()].variableMeasuringUnit(self.oldvariableMeasuringUnit);
        self.currentTable().headers()[self.index()].variableValueFormat(self.oldvariableValueFormat);
        self.currentTable().headers()[self.index()].missingValue(self.oldmissingValue);
        
     }

     self.valueTypeChange = function(){
        if(self.currentTable().headers()[self.index()].variableValueType()=="Number"){
            self.selectUnit(['','kilometer','meter','mile','kilogram','gram','hundreds','thousands','millions']);
            self.selectFormat(['']);
        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Location"){
            self.selectUnit(['','country','state','city','street','zipcode','latitude','longitude']);
            self.selectFormat(['']);
        }
         if(self.currentTable().headers()[self.index()].variableValueType()=="String"){
            self.selectUnit(['']);
            self.selectFormat(['']);
        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Date"){
            self.selectFormat(['','yy/mm/dd','mm/dd/yy','dd/mm/yy','mm-dd-yy','yy-mm-dd','dd-mm-yy',]);
            self.selectUnit(['']);

        }
        if(self.currentTable().headers()[self.index()].variableValueType()=="Time"){
            self.selectFormat(['','hh:mm:ss','hh:mm:ss AM/PM','hh','mm','ss','hh:mm']);
            self.selectUnit(['']);

        }
     }

  

    self.editColumnSave = function(){

        self.columnName = self.currentTable().headers()[self.index()].name();
        self.variableValueType = self.currentTable().headers()[self.index()].variableValueType();
        self.description = self.currentTable().headers()[self.index()].description();
        self.variableMeasuringUnit = self.currentTable().headers()[self.index()].variableMeasuringUnit();
        self.variableValueFormat = self.currentTable().headers()[self.index()].variableValueFormat();
        self.missingValue = self.currentTable().headers()[self.index()].missingValue();


        if(self.columnName==""){           
            self.isChosenNameEmpty(true);
            return;
        }
        else{
            self.isChosenNameEmpty(false);
        }

        self.reason = $("#reason").val();
        

        if(self.columnName!=self.oldname||self.variableValueType!=self.oldvariableValueType||self.description!=self.olddescription||self.variableMeasuringUnit!=self.oldvariableMeasuringUnit||self.variableValueFormat!=self.oldvariableValueFormat||self.missingValue!=self.oldmissingValue){
            dataSourceUtil.updateColumnMetaData(self.sid,self.oldname,self.columnName,self.variableValueType,self.description,self.variableMeasuringUnit,self.variableValueFormat,self.missingValue);


        }
        self.columnMetadataChanged();
        //dataSourceUtil.createColumnMetaDataHistory();
        $("#reason").val("");
        self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());  
     }

    self.editColumnCancel = function(){

        self.currentTable().headers()[self.index()].name(self.oldname);
        self.currentTable().headers()[self.index()].variableValueType(self.oldvariableValueType);
        self.currentTable().headers()[self.index()].description(self.olddescription);
        self.currentTable().headers()[self.index()].variableMeasuringUnit(self.oldvariableMeasuringUnit);
        self.currentTable().headers()[self.index()].variableValueFormat(self.oldvariableValueFormat);
        self.currentTable().headers()[self.index()].missingValue(self.oldmissingValue);

        self.isChosenNameEmpty(false);
        self.isPreviewStory(!self.isPreviewStory());
        self.isEditColumnData(!self.isEditColumnData());
    }


    self.columnMetadataChanged = function(){
        if(self.columnName!=self.oldname){
            self.editAttribute = "chosen name";
            self.editValue = self.columnName;
            self.addColumnMetadataEditHistory();
        }
        if(self.variableValueType!=self.oldvariableValueType){
            self.editAttribute = "data type";
            self.editValue = self.variableValueType;
            self.addColumnMetadataEditHistory();
        }
        if(self.description!=self.olddescription){
            self.editAttribute = "description";
            self.editValue = self.description;
            self.addColumnMetadataEditHistory();
        }
        if(self.variableMeasuringUnit!=self.oldvariableMeasuringUnit){
            self.editAttribute = "value unit";
            self.editValue = self.variableMeasuringUnit;
            self.addColumnMetadataEditHistory();
        }
        if(self.variableValueFormat!=self.oldvariableValueFormat){
            self.editAttribute = "format";
            self.editValue = self.variableValueFormat;
            self.addColumnMetadataEditHistory();
        }
        if(self.missingValue!=self.oldmissingValue){
            self.editAttribute = "missing value";
            self.editValue = self.missingValue;
            self.addColumnMetadataEditHistory();
        }
    }

    self.addColumnMetadataEditHistory =  function(){
        if(self.reason==""){
            self.reason="null";
        }
        if(self.editValue==""){
            self.editValue="null";
        }

    
         $.ajax({
                url: ColFusionServerUrl + "/Story/metadata/columns/addEditHistory/" + self.cid + "/" + self.userid + "/" + self.editAttribute + "/" + self.reason.replace(/\//g,"*!~~!*") + "/" + self.editValue.replace(/\//g,"*!~~!*"),
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true
            }) 
    }

    self.showColumnMetaHistory = function(attribute){
        self.showAttribute = attribute;
        self.historyLogHeaderText("Edit History Log for "+attribute);

        self.isFetchHistoryInProgress(true);
        self.getColumnMetaHistory();
    }

    self.getColumnMetaHistory = function(){
         $.ajax({
                url: ColFusionServerUrl + "/Story/metadata/columns/getEditHistory/" + self.cid + "/" + self.showAttribute,
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                    self.isFetchHistoryInProgress(false);
                    if (data.isSuccessful) {
                    var payload = data.payload;

                    var columnMetadataEditHistory = new ColumnMetadataHistoryViewModel();
                    columnMetadataEditHistory.cid(self.cid);
                    columnMetadataEditHistory.historyItem(self.showAttribute);

                    for (var i = 0; i < payload.length; i++) {
                        var historyRecord = payload[i];

                        var columnMetadataHistoryLogRecord = new ColumnMetadataHistoryLogRecordViewModel();

                        columnMetadataHistoryLogRecord.hid(historyRecord.hid);
                        columnMetadataHistoryLogRecord.whenSaved(historyRecord.whenSaved);
                        columnMetadataHistoryLogRecord.item(historyRecord.item);
                        columnMetadataHistoryLogRecord.reason(historyRecord.reason=="null"?"":historyRecord.reason);
                        columnMetadataHistoryLogRecord.itemValue(historyRecord.itemValue=="null"?"":historyRecord.itemValue);

                        var author = new ColumnAuthorModel(historyRecord.author.userId, historyRecord.author.firstName, 
                        historyRecord.author.lastName, historyRecord.author.login, 
                        historyRecord.author.avatarSource, historyRecord.author.karma, historyRecord.author.roleId);

                        columnMetadataHistoryLogRecord.author(author);

                        columnMetadataEditHistory.historyLogRecords.push(columnMetadataHistoryLogRecord);
                    };

                    self.columnMetadataHistory(columnMetadataEditHistory);
                }
                else {
                    self.isFetchHistoryErrorMessage("Something went wrong while fetching history for " + historyItem + 
                        ". Please try again.");
                }

                },
                error: function(data) {
                self.isFetchHistoryInProgress(false);
                self.isFetchHistoryErrorMessage("Something went wrong while fetching history for " + historyItem + 
                        ". Please try again.");
            }

            }) 
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
debugger;
    		transformedData = dataSourceUtil.mapSertverTableToDataPreviewTable(data);
    			
    		createDataTable(tableName, transformedData);
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

    self.getTableDataByRelIds = function (relIds, simThreshold, perPage, pageNo) {
        self.isLoading(true);
        self.isNoData(false);
        self.isError(false);

        dataSourceUtil.getTableDataByRelIds(relIds, simThreshold, perPage, pageNo).done(function (data) {

            transformedData = dataSourceUtil.mapSertverTableToDataPreviewTable(data);

            createDataTable('Merged Dataset', transformedData);
            self.isError(false);
        }).error(function () {
            self.isError(true);
        }).always(function () {
            self.isLoading(false);
        });
    };

    function createDataTable(tableName, tableData) {
    debugger;
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
        self.currentTable().checkIfLoggedin(self.sid);
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
            self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage(), currentTable.currentPage());
        }
    };

    self.goToPreviousPage = function() {
        if (self.isLoading())
            return;
        var currentTable = self.currentTable();
        var currentPage = currentTable.currentPage();
        if (currentPage > 1) {
            currentTable.currentPage(parseInt(currentPage) - 1);
            self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage(), currentTable.currentPage());
        }
    };

    self.refreshTablePreview = function() {
        var currentTable = self.currentTable();
       
        self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage(), currentTable.currentPage());
    }
   
    self.closeCurrentDialog = function() {
        // $("#closeDialog").attr('data-dismiss', "lightbox");
        $('#editpopup').hide();

        $.ajax({
            url: OpenRefineUrl + "/command/core/release-table?sid=" + self.sid + "&tableName=" + self.currentTable().tableName + "&userId=" + $("#user_id").val(), 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
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
               
        self.getTableDataBySidAndName(currentTable.tableName, currentTable.perPage(), currentTable.currentPage());
    }
    
    self.refreshPreview = function() {

        var msg = "Are you sure you want to close the dialog without saving? If you click 'OK', you can redo your operations in the Redo/Undo list when you open this table next time;\nIf you click 'Cancel', you'll come back to the dialog.";
        var isChangesSaved;

        $.ajax({
            // Added by Alex
            // TODO: here I use "async: false" is because I need to set #closeDialog's properties, (see self.isChangesSaved)
            // for an unknown reason, I cannot set them successfully if I do in ajax (no matter in the "success" nor in the ".done")
                async: false,
                url: OpenRefineUrl + "/command/core/is-changes-saved?sid=" + self.sid + "&tableName=" + self.currentTable().tableName, 
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                success: function(data) {
                    isChangesSaved = data.isChangesSaved;
                }
            });

        if(!isChangesSaved) {
            if(confirm(msg)) {
                self.closeCurrentDialog();
            }
        } else {
            self.closeCurrentDialog();
        }
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

var ColumnMetadataHistoryViewModel = function() {
    self = this;
    self.cid = ko.observable();
    self.historyItem = ko.observable();
    self.historyLogRecords = ko.observableArray();
}

var ColumnMetadataHistoryLogRecordViewModel = function() {
    self = this;
    self.hid = ko.observable();
    self.author = ko.observable();
    self.whenSaved = ko.observable();
    self.item = ko.observable();
    self.reason = ko.observable();
    self.itemValue = ko.observable();
}

var ColumnAuthorModel = function(userId, firstName, lastName, login, avatarSource, karma, roleId) {
    var self = this;

    self.userId = ko.observable(userId);
    self.firstName = ko.observable(firstName);
    self.lastName = ko.observable(lastName);
    self.login = ko.observable(login);
    self.avatarSource = ko.observable(avatarSource);
    self.karma = ko.observable(karma);
    self.roleId = ko.observable(roleId);

    self.authorInfo = ko.computed(function() {
        var info = "";

        if (self.lastName()) {
            info = info + self.lastName(); + ", " + self.firstName;
        }

        if (self.firstName()) {
            if (info.length > 0) {
                info = info + ", " + self.firstName();
            }
            else {
                info = self.firstName();
            }
        }

        if (info.length == 0) {
            info = self.login();
        }

        return info;
    });

    self.roleName = ko.computed(function() {
        if (self.roleId() >= 1)
            return authorRoles[self.roleId() - 1].roleName();
        return "";
    });

    self.getTempAsJSONObj = function() {
        return  {
                    userId : self.userId(),
                    firstName : self.firstName(),
                    lastName : self.lastName(),
                    login : self.login(),
                    avatarSource : self.avatarSource(),
                    karma : self.karma(),
                    roleId : self.roleId()
                };
    }
}