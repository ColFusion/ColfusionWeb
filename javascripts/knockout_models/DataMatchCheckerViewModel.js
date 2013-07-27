ko.bindingHandlers.jqueryPagedEditable = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var tableParams = valueAccessor()();
        if (!tableParams) {
            return;
        }

        var tableDom = $('<table><thead></thead><tbody></tbody></table>');
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
                $.ajax({
                    url: sSource,
                    data: aoData,
                    type: 'post',
                    dataType: 'json',
                    success: function(json) {
                        /* Do whatever additional processing you want on the callback, then tell DataTables */
                        fnCallback(json);
                    }
                });
            },
            "aoColumnDefs": [
                {"sClass":"distinctTableColumn", "aTargets": ['_all']}
            ],
            "aoColumns": [
                {"sTitle": "StateNme"}
            ]
        }).makeEditable();
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
        }).makeEditable();
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

    // Distinct table shows values from DB and does not update with synonyms.
    function loadDistinctTables() {
        var params = getDataTableParam();
        params.action = 'getDistinctValueTable';

        return  $.ajax({
            url: '../dataMatchChecker/getDataTables.php',
            type: 'post',
            dataType: 'json',
            data: params,
            success: function(data) {
                self.distinctFromTable(createDataTable(data.distinctFromTable));
                self.distinctToTable(createDataTable(data.distinctToTable));
            }
        }).always(function() {
            self.isLoadingData(false);
        });
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
                self.differentValueFromTable(createDataTable(data.notMatchedInFromData));
                self.differentValueToTable(createDataTable(data.notMatchedInToData));
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
            fromTable: self.fromDataset().chosenTableName,
            toSid: self.toDataset().sid,
            toTable: self.toDataset().chosenTableName,
            fromTransInput: self.currentLink().fromLinkPart.transInput,
            toTransInput: self.currentLink().toLinkPart.transInput
        };

        return params;
    }

    self.saveSynonym = function() {
        var data = {
            fromTransInput: self.currentLink().fromLinkPart.transInput,
            toTransInput: self.currentLink().toLinkPart.transInput,
            synFrom: self.synFrom(),
            synTo: self.synTo(),
            sidFrom: self.fromDataset().sid,
            sidTo: self.toDataset().sid,
            tableFrom: self.fromDataset().chosenTableName,
            tableTo: self.toDataset().chosenTableName
        };

        self.isAddingSynonym(true);
        self.addingSynonymMessage('');
        /*
         updateTables(self.synFrom(), self.synTo());
         self.synFrom('');
         self.synTo('');
         */
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
                    self.addingSynonymMessage('Some errors occur when adding the values');
                }
            }
        }).error(function() {
            self.addingSynonymMessage('Some errors occur when adding the values');
        }).always(function() {
            self.isAddingSynonym(false);
        });
    };

    // TODO: remove values on diff table and add values to smae table.
    function updateTables(synFrom, synTo) {
        var oldFromTable = self.differentValueFromTable();
        var oldToTable = self.differentValueToTable();
        self.differentValueFromTable(removeValueInTable(oldFromTable, synFrom));
        self.differentValueToTable(removeValueInTable(oldToTable, synTo, 1));
    }

    // DataPreviewViewModelProperties.Table
    function removeValueInTable(oldTable, value, replaceColIndex) {
        replaceColIndex = replaceColIndex === undefined ? 0 : replaceColIndex;
        var newCells = [];

        $.each(oldTable.getCells(), function(i, row) {
            if (row[replaceColIndex] == value) {
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
    function createDataTable(tableJson) {
        var columns = tableJson.columns;
        var rows = [];
        $.each(tableJson.rows, function(i, rowObj) {
            var row = [];
            $.each(columns, function(j, column) {
                row.push(rowObj[column]);
            });
            rows.push(row);
        });

        return new DataPreviewViewModelProperties.Table("FromTable", columns, rows);
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

