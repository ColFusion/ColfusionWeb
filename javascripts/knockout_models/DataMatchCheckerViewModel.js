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
        $(element).children('table').dataTable().makeEditable();
    }
};

function DataMatchCheckerViewModel() {
    var self = this;

    self.name = ko.observable();
    self.description = ko.observable();
    self.fromDataset = ko.observable();
    self.toDataset = ko.observable();
    self.links = ko.observableArray();

    self.differentValueTable = ko.observable(getStaticDataTable());
    self.sameValueTable = ko.observable(getStaticDataTable());
    self.partlyValueTable = ko.observable(getStaticDataTable());

    self.loadLinkData = function() {

    };
}

function getStaticDataTable() {
    var tableName = "Static table data";
    var cols = ["fromColumnData", "toColumnData"];
    var rows = [];
    for (var i = 1; i <= 10; i++) {
        rows.push(["fromData" + i, "toData" + i]);
    }

    var table = new DataPreviewViewModelProperties.Table(tableName, cols, rows);
    return table;
}

