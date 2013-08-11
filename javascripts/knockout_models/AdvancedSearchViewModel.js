var advDebug = true;

var AdvancedSearchViewModelProperties = {
    Filter: function () {
        var self = this;

        self.variable = ko.observable();
        self.condition = ko.observable();
        self.value = ko.observable();
    },

    DatasetSearchResult: function (resultObj) {
        var self = this;

        self.resultObj = resultObj;

        self.isDataPreviewTableShown = ko.observable(false);
        self.dataPreviewViewModel = ko.observable();

        self.openVisualizationPage = function (item, event) {
            $('#visualizationDatasetSerializeInput').val(JSON.stringify(self.resultObj));
            $('#visualizationDatasetSerializeForm').submit();
        };

        self.togglePreviewTable = function (item, event) {

            // If preview is not loaded yet, load markup and bind view model.
            if (!self.dataPreviewViewModel()) {
                if (advDebug) {
                    self.dataPreviewViewModel(new DataPreviewViewModel(2080));
                    self.dataPreviewViewModel().getTableDataBySidAndName("small.xls", 10, 1);
                } else {
                    self.dataPreviewViewModel(new DataPreviewViewModel(self.resultObj.sid));
                    self.dataPreviewViewModel().getTableDataBySidAndName(self.resultObj.tableName, 10, 1);
                }
            }

            self.isDataPreviewTableShown(!self.isDataPreviewTableShown());
        };
    },

    PathSearchResult: function (resultObj) {
        var self = this;

        self.resultObj = resultObj;
        self.paths = ko.observableArray();

        $.each(resultObj.allPaths, function (i, pathObj) {
            self.paths.push(new AdvancedSearchViewModelProperties.Path(pathObj));
        });            
    },

    Path: function (pathObj) {
        var self = this;

        // Neo4j returns redundancy relationshps.
        // Here remove redundant ones.       
        pathObj.relationships = generalUtil.convertArrayToSet("relId", pathObj.relationships);

        self.pathObj = pathObj;
        self.isPreviewShown = ko.observable(false);
        self.isMoreShown = ko.observable(false);
        self.isRelInfoShown = ko.observable(false);


        self.dataPreviewViewModel = ko.observable();

        self.isRelationshipInfoLoaded = {};
        self.isError = {};
        self.relationshipInfos = {};

        $.each(pathObj.relIds, function (i, relId) {
            self.isRelationshipInfoLoaded[relId] = ko.observable(false);
            self.isError[relId] = ko.observable(false);
        });

        self.togglePreview = function () {

            if (!self.dataPreviewViewModel()) {
                self.dataPreviewViewModel(new DataPreviewViewModel(-1));
                self.dataPreviewViewModel().getTableDataByObject(self.pathObj, 10, 1);
            }

            self.isPreviewShown(!self.isPreviewShown());
        };

        /*
            "More/Less" is a text cell in Data Table, so we cannot use observable to toggle those words.
            (Dom manipulation is required.)
        */
        self.showMoreClicked = function (rel_id, relRow, event) {
            self.isError[rel_id](false);

            var mineRelDom = $(event.target).parents('tr').next('tr');

            $(mineRelDom).toggle();
            if ($(mineRelDom).css("display") === "none") {
                $(event.target).text("More...");
            } else {
                $(event.target).text("Less");
                if (!self.relationshipInfos[rel_id]) {
                    $(mineRelDom).find('.relInfoLoadingIcon').show();
                    loadRelationshipInfo(rel_id, mineRelDom);
                }
            }
        };

        function loadRelationshipInfo(relId, mineRelDom) {
            dataSourceUtil.loadRelationshipInfo(relId).done(function (data) {
                self.relationshipInfos[data.rid] = ko.observable(new RelationshipModel.Relationship(data));
                self.isRelationshipInfoLoaded[data.rid](true);
                $(mineRelDom).find('.relInfoLoadingIcon').hide();
            }).error(function (jqXHR, statusCode, errMessage) {
                alert(errMessage);
                self.isError[relId](true);
            });
        }
        
        self.openVisualizationPage = function (item, event) {
            $('#visualizationDatasetSerializeInput').val(JSON.stringify(self.pathObj));
            $('#visualizationDatasetSerializeForm').submit();
        };
    }
};

function AdvancedSearchViewModel() {
    var self = this;

    self.searchTerm = ko.observable('Ccode');
    self.filters = ko.observableArray();
    self.filters.push(new AdvancedSearchViewModelProperties.Filter());
    self.category = ko.observable();

    self.isNoResultTextShown = ko.observable(false);
    self.searchResults = ko.observableArray();
    self.isSearchError = ko.observable(false);

    self.addFilter = function () {
        self.filters.push(new AdvancedSearchViewModelProperties.Filter());
    };

    self.removeFilter = function () {
        self.filters.remove(this);
    };

    self.search = function () {

        // Delete btn is not used in search result.
        $('.removeRelBtnWrapper').remove();

        if (!$('#advancedsearch').parsley('validate')) {
            return;
        }

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

        self.isSearchError(false);
        self.isNoResultTextShown(false);
        $.ajax({
            url: advDebug ? 'advSearch.json' : 'searchResult.php',
            data: {
                "search[]": searchKeys,
                "variable[]": filterVariables,
                "select[]": filterConditions,
                "condition[]": filterValues
            },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                self.searchResults([]);
                $.each(data, function (i, resultObj) {
                    var searchResult = resultObj.oneSid ? new AdvancedSearchViewModelProperties.DatasetSearchResult(resultObj) :
                        new AdvancedSearchViewModelProperties.PathSearchResult(resultObj);
                    self.searchResults.push(searchResult);
                });
                self.isNoResultTextShown(true);
            },
            error: function() {
                self.isSearchError(true);
            }
        });
    };

    // Adapt to story-page-based relationship info template.
    self.removeRelationship = function() {
    };
}