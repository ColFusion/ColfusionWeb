var advDebug = false;

var AdvancedSearchViewModelProperties = {

    WhereCondition: function () {
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

        self.confidenceFilter = ko.observable(0);
        self.pathFilter = ko.observable(0);
        self.dataMatchFilter = ko.observable(0);

        self.resultObj = resultObj;
        self.paths = ko.observableArray();

        self.filterSearchResults = function () {
            ko.utils.arrayForEach(self.paths(), function (path) {
                path.isFilterSatisfied(path.avgConfidence() >= self.confidenceFilter() && path.pathObj.sids.length <= self.pathFilter());
            });
        };

        $.each(resultObj.allPaths, function (i, pathObj) {
            self.paths.push(new AdvancedSearchViewModelProperties.Path(pathObj));
        });
    },

    Path: function (pathObj) {
        var self = this;

        self.isFilterSatisfied = ko.observable(true);

        // Neo4j returns redundancy relationshps.
        // Here remove redundant ones.       
        pathObj.relationships = generalUtil.convertArrayToSet("relId", pathObj.relationships);

        self.pathObj = pathObj;
        self.avgConfidence = ko.computed(function () {
            var confidence = 0;
            $.each(self.pathObj.relationships, function (i, rel) {
                confidence += Number(rel.confidence);
            });

            return confidence / self.pathObj.relationships.length;
        });

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

            var dataObj = self.pathObj;
         
            // If self.relationshipInfos[relId] is loaded, add selected link info.
            // Otherwise do not send selected links, which means using all links.
            ko.utils.arrayForEach(dataObj.relationships, function (relationship) {
                
                var relationshipInfo = self.relationshipInfos[relationship.relId];             

                if (relationshipInfo) {
                    relationship.selectedLinks = [];

                    ko.utils.arrayForEach(relationshipInfo().links(), function (relInfoLink) {
                        if (relInfoLink.isSelectedForMerge()) {
                            var selectedLink = {};
                            selectedLink.fromPartEncoded = relInfoLink.fromPartEncoded();
                            selectedLink.toPartEncoded = relInfoLink.toPartEncoded();
                            relationship.selectedLinks.push(selectedLink);
                        }
                    });
                }
            });
           
            if (!self.dataPreviewViewModel()) {
                self.dataPreviewViewModel(new DataPreviewViewModel(-1));
                self.dataPreviewViewModel().getTableDataByObject(dataObj, 10, 1);
            }
            
            self.isPreviewShown(!self.isPreviewShown());
        };

        self.refreshPreview = function () {
            self.isPreviewShown(false);
            self.dataPreviewViewModel(null);
            self.togglePreview();
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

    self.searchTerm = ko.observable();
    self.whereConditions = ko.observableArray();
    self.whereConditions.push(new AdvancedSearchViewModelProperties.WhereCondition());
    self.category = ko.observable();

    self.isSearching = ko.observable(false);
    self.isNoResultTextShown = ko.observable(false);
    self.searchResults = ko.observableArray();
    self.isSearchError = ko.observable(false);

    self.addWhereCondition = function () {
        self.whereConditions.push(new AdvancedSearchViewModelProperties.WhereCondition());
    };

    self.removeWhereCondition = function () {
        self.whereConditions.remove(this);
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

        var whereConditionVariables = $.map(self.whereConditions(), function (whereCondition) {
            return whereCondition.variable();
        });

        var whereConditionConditions = $.map(self.whereConditions(), function (whereCondition) {
            return whereCondition.condition();
        });

        var whereConditionValues = $.map(self.whereConditions(), function (whereCondition) {
            return whereCondition.value();
        });

        self.isSearching(true);
        self.isSearchError(false);
        self.isNoResultTextShown(false);

        $.ajax({
            url: advDebug ? 'advSearch.json' : 'searchResult.php',
            data: {
                "search[]": searchKeys,
                "variable[]": whereConditionVariables,
                "select[]": whereConditionConditions,
                "condition[]": whereConditionValues
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
            error: function () {
                self.isSearchError(true);
            }
        }).always(function () {
            self.isSearching(false);
        });
    };

    // Adapt to story-page-based relationship info template.
    // TODO: implement.
    self.removeRelationship = function () {
    };
}