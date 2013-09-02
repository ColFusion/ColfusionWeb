ko.bindingHandlers.jqueryPagedEditable = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var tableParams = valueAccessor()();
        if (!tableParams) {
            return;
        }

        var tableDom = $('<table class="linkDataTable"><thead></thead><tbody></tbody></table>');
        $(element).empty().append(tableDom);
        $(tableDom).dataTable({
            "sEcho": 3,
            "iDisplayLength": tableParams.pageLength,
            "bLengthChange": false,
            "bSort": false,
            "bProcessing": true,
            "bServerSide": true,
            "sAjaxSource": "../dataMatchChecker/getDataTables.php",
            "aaSorting": [],
            "fnServerData": function(sSource, aoData, fnCallback) {
                for (var key in tableParams) {
                    aoData.push({"name": key, "value": tableParams[key]});
                }

                console.log(sSource);
                console.log(JSON.stringify(aoData));

                

                $.ajax({
                    url: sSource,
                    data: aoData,
                    type: 'post',
                    dataType: 'json',
                    success: function(json) {
                        /* Do whatever additional processing you want on the callback, then tell DataTables */
                        var columns = json.aoColumns;
                        var colDoms = $(tableDom).find('.distinctTableColumn');
                        for (var i = 0; i < columns.length && i < colDoms.length; i++) {
                            $(colDoms).eq(i).text(columns[i]);
                        }

                        fnCallback(json);
                    }
                });
            },
            "aoColumnDefs": [
                {"sClass": "distinctTableColumn", "aTargets": ['_all']}
            ],
            "aoColumns": [
                {"sTitle": "Column1"}
            ]
        }).makeEditable({
            sUpdateURL: "UpdateData.php",
            fnOnEditing: function(jInput, oEditableSettings, sOriginalText, id)
            {
                return true;
            },
            fnOnEdited: function(status)
            {
                if (status == "success") {

                }
            }
        });
    }
};

ko.bindingHandlers.jqueryEditable = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var dataTable = valueAccessor()();

        if (!dataTable) {
            return;
        }

        var tableDom = $('<table class="linkDataTable"><thead></thead><tbody></tbody></table>');
        $(tableDom).children('thead').append('<tr>');

        $.each(dataTable.headers(), function(index, header) {
            var col = header.name();
            $(tableDom).find('tr').append('<th>' + col + '</th>');
        });

        $.each(dataTable.rows(), function(index, row) {
            var tr = $('<tr>');
            $(tableDom).children('tbody').append(tr);
            var cells = row.cells();
            $.each(cells, function(index, cell) {
                $(tr).append('<td>' + cell + '</td>');
            });
        });

        $(element).empty().append(tableDom);
        $(element).children('table').dataTable({
            "bLengthChange": false,
            "bSort": false,
            "iDisplayLength": 20
        }).makeEditable({
            sUpdateURL: "UpdateData.php",
            fnOnEditing: function(jInput, oEditableSettings, sOriginalText, id)
            {
                return true;
            },
            fnOnEdited: function(status)
            {
                if (status == "success") {

                }
            }
        });
    }
};

function DataMatchCheckerViewModel() {
    var self = this;

    self.name = ko.observable();
    self.description = ko.observable();
    self.fromDataset = ko.observable();
    self.toDataset = ko.observable();
    self.links = ko.observableArray();

    self.isLoadingData = ko.observable(false);
    self.currentLink = ko.observable();

    self.isDistinctTablesShown = ko.observable(false);

    self.distinctFromTableParams = ko.observable();
    self.distinctToTableParams = ko.observable();

    self.differentValueFromTable = ko.observable();
    self.differentValueToTable = ko.observable();
    self.sameValueTable = ko.observable();
    self.partlyValueTable = ko.observable();

    self.countOfMatchedData = ko.observable(0);
    self.countOfTotalDistinctData = ko.observable(0);
    self.matchPercent = ko.computed(function() {
        var percent = self.countOfMatchedData() / self.countOfTotalDistinctData();
        percent = isNaN(percent) ? 0 : percent;
        return Number(percent * 100).toFixed(2);
    });

    self.synFrom = ko.observable();
    self.synTo = ko.observable();
    self.isAddingSynonym = ko.observable(false);
    self.addingSynonymMessage = ko.observable();

    self.loadLinkData = function() {

        // this = Link
        self.currentLink(this);
        setDistinctTableParams();

        self.isLoadingData(true);
        $.when(loadValueTables()).then(function() {
            self.isLoadingData(false);
        }, function() {
            self.isLoadingData(false);
        });
    };

    // Required params for jEditable Pagination.
    function setDistinctTableParams() {
        var fromTableParams = getDataTableParam();
        fromTableParams.action = 'getDistinctFromTable';
        fromTableParams.pageLength = 20;
        self.distinctFromTableParams(fromTableParams);

        var toTableParams = getDataTableParam();
        toTableParams.action = 'getDistinctToTable';
        toTableParams.pageLength = 20;
        self.distinctToTableParams(toTableParams);
    }

    // Value tables updates when adding synonyms.
    function loadValueTables() {
        var params = getDataTableParam();
        params.action = 'getDifferentAndSameValueTables';

        return  $.ajax({
            url: '../dataMatchChecker/getDataTables.php',
            type: 'post',
            dataType: 'json',
            data: params,
            success: function(data) {
                self.differentValueFromTable(createDataTable(data.notMatchedInFromData, "FromTable"));
                self.differentValueToTable(createDataTable(data.notMatchedInToData, "ToTable"));
                self.sameValueTable(getStaticDataTable());
                self.countOfMatchedData(data.countOfMachedData.rows[0].ct);
                self.countOfTotalDistinctData(data.countOfTotalDistinctData.rows[0].ct);
            }
        }).always(function() {
            self.isLoadingData(false);
        });
    }

    function getDataTableParam() {
        var params = {
            fromSid: self.fromDataset().sid,
            fromTable: self.fromDataset().shownTableName,
            toSid: self.toDataset().sid,
            toTable: self.toDataset().shownTableName,
            fromTransInput: self.currentLink().fromLinkPart.transInput,
            toTransInput: self.currentLink().toLinkPart.transInput
        };

        return params;
    }

    self.saveSynonym = function () {

        if (!isValueInTable(self.differentValueFromTable(), self.synFrom())) {
            self.addingSynonymMessage('Value in From part is not found.');
            return;
        }

        if (!isValueInTable(self.differentValueToTable(), self.synTo())) {
            self.addingSynonymMessage('Value in To part is not found.');
            return;
        }

        var data = {
            fromTransInput: self.currentLink().fromLinkPart.transInput,
            toTransInput: self.currentLink().toLinkPart.transInput,
            synFrom: self.synFrom(),
            synTo: self.synTo(),
            sidFrom: self.fromDataset().sid,
            sidTo: self.toDataset().sid,
            tableFrom: self.fromDataset().shownTableName,
            tableTo: self.toDataset().shownTableName
        };
        
        self.isAddingSynonym(true);
        self.addingSynonymMessage('');
       
        $.ajax({
            url: 'addSynonym.php',
            type: 'post',
            dataType: 'json',
            data: data,
            success: function(jsonResponse) {
                if (jsonResponse.isSuccessful) {
                    updateTables(self.synFrom(), self.synTo());
                    self.synFrom('');
                    self.synTo('');
                } else {
                    self.addingSynonymMessage((jsonResponse.message) ? jsonResponse.message : 'Some errors occur when adding the values' );
                }
            }
        }).error(function() {
            self.addingSynonymMessage('Some errors occur when adding the values');
        }).always(function() {
            self.isAddingSynonym(false);
        });
    };

    function updateTables(synFrom, synTo) {     
        var oldFromTable = self.differentValueFromTable();
        var oldToTable = self.differentValueToTable();
               
        self.differentValueFromTable(removeValueInTable(oldFromTable, synFrom));
        self.differentValueToTable(removeValueInTable(oldToTable, synTo));
        addValueToTable(self.sameValueTable(), synFrom, synTo);
        self.countOfMatchedData(Number(self.countOfMatchedData()) + 1);
    }

    function isValueInTable(table, value) {
        return true;

        for (var i = 0; i < table.getCells().length; i++) {
            var row = table.getCells()[i];
            for (var j = 0; j < row.length; j++) {
                if (row[j] != null && value != null && row[j].trim() == value.trim()) {
                    return true;
                }
            }      
        }

        return false;
    }

    // DataPreviewViewModelProperties.Table
    function removeValueInTable(oldTable, value, replaceColIndex) {
        replaceColIndex = replaceColIndex === undefined ? 0 : replaceColIndex;
        var newCells = [];

        $.each(oldTable.getCells(), function (i, row) {
            if (row[replaceColIndex] != null && value != null
                && row[replaceColIndex].toString().trim() == value.toString().trim()) {
                return;
            }
            newCells.push(row);
        });

        var headerNames = $.map(oldTable.headers(), function(headerObj) {
            return headerObj.name();
        });

        return new DataPreviewViewModelProperties.Table(oldTable.tableName, headerNames, newCells);
    }

    function addValueToTable(table, synFrom, synTo) {
        var row = [];
        row.push(synFrom);
        row.push(synTo);
        table.addRow(row);
    }

    // Handle json sent from server and creates DataTable object.
    function createDataTable(tableJson, tableName) {
        var columns = tableJson.columns;
        var rows = [];

        $.each(tableJson.rows, function(i, rowObj) {
            var row = [];
            $.each(columns, function(j, column) {
                row.push(rowObj[column]);
            });
            rows.push(row);
        });

        return new DataPreviewViewModelProperties.Table(tableName || "FromTable", columns, rows);
    }
}

function getStaticDataTable() {
    var tableName = "Static table data";
    var cols = ["fromColumnData", "toColumnData"];
    var rows = [];
    for (var i = 1; i <= 50; i++) {
        rows.push(["fromData" + i, "toData" + i]);
    }

    var table = new DataPreviewViewModelProperties.Table(tableName, cols, rows);
    return table;
}

