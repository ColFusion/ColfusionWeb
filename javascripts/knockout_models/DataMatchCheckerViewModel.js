ko.bindingHandlers.jqueryEditable = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var dataTable = valueAccessor()();
        console.log(dataTable);

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
            "iDisplayLength" : 20
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

    self.currentLink = ko.observable();
    self.differentValueFromTable = ko.observable(getStaticDataTable());
    self.differentValueToTable = ko.observable(getStaticDataTable());
    self.sameValueTable = ko.observable(getStaticDataTable());
    self.partlyValueTable = ko.observable(getStaticDataTable());

    self.synFrom = ko.observable();
    self.synTo = ko.observable();
    self.isAddingSynonym = ko.observable(false);
    self.addingSynonymMessage = ko.observable();

    self.loadLinkData = function() {
        console.log(this);
        self.currentLink(this);
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

        console.log(data);
    };

    // TODO: remove values on diff table and add values to smae table.
    function updateTables() {

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

