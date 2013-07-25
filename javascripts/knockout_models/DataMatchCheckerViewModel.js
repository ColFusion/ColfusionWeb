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
            console.log(col);
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
    self.differentValueFromTable = ko.observable();
    self.differentValueToTable = ko.observable();
    self.sameValueTable = ko.observable();
    self.partlyValueTable = ko.observable();

    self.synFrom = ko.observable('fromData1');
    self.synTo = ko.observable('toData1');
    self.isAddingSynonym = ko.observable(false);
    self.addingSynonymMessage = ko.observable();

    self.loadLinkData = function() {
        // this = Link
        self.currentLink(this);
        self.differentValueFromTable(getStaticDataTable());
        self.differentValueToTable(getStaticDataTable());
        self.sameValueTable(getStaticDataTable());
        self.partlyValueTable(getStaticDataTable());
    };

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

        updateTables(self.synFrom(), self.synTo());
        //self.synFrom('');
        //self.synTo('');

        /*
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
         });*/
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
        
        var headerNames = [];
        headerNames = $.map(oldTable.headers(), function(i, headerObj){
            headerNames.push();
        });
        
        return new DataPreviewViewModelProperties.Table(oldTable.tableName, oldTable.headers(), newCells);
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

