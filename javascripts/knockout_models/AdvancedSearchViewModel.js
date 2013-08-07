var AdvancedSearchViewModelProperties = {
    Filter: function () {
        var self = this;

        self.variable = ko.observable();
        self.condition = ko.observable();
        self.value = ko.observable();
    },

    SearchResult: function (resultObj) {
        var self = this;

        self.resultObj = resultObj;

        self.isDataPreviewTableShown = ko.observable(false);
        self.dataPreviewViewModel = ko.observable();

        self.openVisualizationPage = function (item, event) {


        };

        self.togglePreviewTable = function (item, event) {

            // If preview is not loaded yet, load markup and bind view model.
            if (!self.dataPreviewViewModel()) {
                /*
                self.dataPreviewViewModel(new DataPreviewViewModel(self.resultObj.sid));
                self.dataPreviewViewModel().getTableDataBySidAndName(self.resultObj.tableName, 10, 1);
                */
                self.dataPreviewViewModel(new DataPreviewViewModel(2080));
                self.dataPreviewViewModel().getTableDataBySidAndName("small.xls", 10, 1);
            }

            self.isDataPreviewTableShown(!self.isDataPreviewTableShown());
        };
    }
};

function AdvancedSearchViewModel() {
    var self = this;

    self.searchTerm = ko.observable('default');
    self.filters = ko.observableArray();
    self.filters.push(new AdvancedSearchViewModelProperties.Filter());
    self.category = ko.observable();

    self.searchResults = ko.observableArray();

    self.addFilter = function () {
        self.filters.push(new AdvancedSearchViewModelProperties.Filter());
    };

    self.removeFilter = function () {
        self.filters.remove(this);
    };

    self.search = function () {

        var searchKeys = $.map(self.searchTerm().split(','), function (searchKey) {
            return searchKey.trim();
        });

        var filterVariables = $.map(self.filters(), function (filter) {
            return filter.variable();
        });

        var filterConditions = $.map(self.filters(), function (filter) {
            return filter.condition();
        });

        var filterValues = $.map(self.filters(), function (filter) {
            return filter.value();
        });

        $.ajax({
            url: 'advSearch.json',
            data: {
                "search[]": searchKeys,
                "variable[]": filterVariables,
                "select[]": filterConditions,
                "condition[]": filterValues
            },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                $.each(data, function (i, resultObj) {
                    self.searchResults.push(new AdvancedSearchViewModelProperties.SearchResult(resultObj));
                });
            }
        });
    };
}