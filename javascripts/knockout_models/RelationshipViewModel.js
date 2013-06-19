ko.bindingHandlers.slider = {
    init: function(element, valueAccessor, allBindingsAccessor) {
        var options = allBindingsAccessor().sliderOptions || {};
        $(element).slider(options);
        ko.utils.registerEventHandler(element, "slidechange", function(event, ui) {
            var observable = valueAccessor();
            observable(ui.value);
        });
        ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
            $(element).slider("destroy");
        });
        ko.utils.registerEventHandler(element, "slide", function(event, ui) {
            var observable = valueAccessor();
            observable(ui.value);
        });
    },
    update: function(element, valueAccessor) {
        var value = ko.utils.unwrapObservable(valueAccessor());
        if (isNaN(value))
            value = 0;
        $(element).slider("value", value);
    }
};
var typeahead_template = '<div class="dataColumnSuggestion">' +
        '<div style="overflow: auto; margin-bottom: 5px;">' +
        '<p class="dataColumnSuggestion-Name">' +
        '{{dname_chosen}}' +
        '</p>' +
        '<p class="dataColumnSuggestion-dataSetName"><span class="byText">by</span>' +
        '{{dataset_name}}' +
        '</p>' +
        '</div>' +
        '<div class="dataColumnSuggestion-Description">' +
        '{{dname_value_description}}' +
        '</div>' +
        '</div>';

// valueAccessor should be dataset.
// Dom element should be input.
ko.bindingHandlers.searchDatasetTypeahead = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        var search_typeahead_tpl = typeahead_template
                .replace("{{dname_chosen}}", "{{link_title}}")
                .replace("{{dataset_name}}", "{{user_login}}")
                .replace("{{dname_value_description}}", "{{link_summary}}");

        var dataSet = valueAccessor();
        $(element).parent().next('button').prop("disabled", true);

        $(element).on('keyup', function(event) {
            var code = event.keyCode || event.which;
            if (code != 13) { //Enter keycode
                $(this).parent().next('button').prop("disabled", true);
            }
        }).typeahead({
            name: 'datasets',
            prefetch: {
                url: 'datasetController/findDataset.php',
                ttl: 10 * 60 * 1000 // cache 10 mins
            },
            valueKey: 'link_key',
            template: search_typeahead_tpl,
            engine: Hogan
        }).bind('typeahead:selected', function(event, datum) {
            dataSet.sid(datum.link_id);
            dataSet.name(datum.link_title);
            $(this).parent().next('button').prop("disabled", false);
        });
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

    }
};

// valueAccessor should be dataset.
// Dom element should be input.
ko.bindingHandlers.linkPartTypeahead = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var linkPart = bindingContext.$data;
        var dataSet = valueAccessor();
        var rawDataColumns = dataSet.currentTable().getRawDataColumns();
        $.each(rawDataColumns, function(index, rawObj) {
            rawObj.dataset_name = dataSet.name();
        });

        $(element).find('input[type="text"]').typeahead({
            name: dataSet.sid(),
            local: rawDataColumns,
            valueKey: 'dname_chosen',
            template: typeahead_template,
            engine: Hogan
        }).bind('typeahead:selected', function(event, datum) {
            datum.dataset_name = dataSet.name();
            $(this).val(datum.dname_chosen);
            $(this).parent().next('input').val(datum.cid);

            // value bind doesn't work, change object manually.
            linkPart.colfusionDataColumn().mapFromRawDataColumn(datum);
        });
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

    }
};

ko.bindingHandlers.multipleTypeahead = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        var linkPart = valueAccessor();
        var dataSet = linkPart.dataSet;
        var rawDataColumns = dataSet.currentTable().getRawDataColumns();
        var dropdownListSource = $.map(rawDataColumns, function(rawObj, index) {
            return rawObj.dname_chosen;
        });
        console.log(dropdownListSource);

        function split(val) {
            return val.split(/\s+/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        function updateInputValue(value) {
            linkPart.transInput(value);
        }

        $(element).bind("keydown", function(event) {
            if (event.keyCode === $.ui.keyCode.TAB &&
                    $(this).data("ui-autocomplete").menu.active) {
                event.preventDefault();
            }
        }).on('keyup', function(event) {
            var code = event.keyCode || event.which;
            if (code != 13) { //Enter keycode
                updateInputValue(this.value.trim());
            }
        }).autocomplete({
            minLength: 0,
            source: function(request, response) {
                // delegate back to autocomplete, but extract the last term
                response($.ui.autocomplete.filter(dropdownListSource, extractLast(request.term)));
            },
            focus: function() {
                // prevent value inserted on focus
                return false;
            },
            select: function(event, ui) {
                var terms = split(this.value);
                // remove the current input
                terms.pop();
                // add the selected item
                terms.push(ui.item.value);
                // add placeholder to get the comma-and-space at the end
                terms.push("");
                this.value = terms.join(" ");
                updateInputValue(this.value.trim());

                return false;
            }
        });
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

    }
};

var RelationshipViewModelProperties = {
    DataSet: function(sid) {
        var self = this;
        self.sid = ko.observable(sid);
        self.name = ko.observable('');
        self.tableList = ko.observableArray();
        self.chosenTableName = ko.observable();
        self.currentTable = ko.observable();
        self.isLoadingTableInfo = ko.observable(false);

        self.loadTableInfo = function() {
            if (!self.sid()
                    || (self.currentTable() && !confirm("Do you want to discard all editing relationships and reload the table?")))
                return;

            self.isLoadingTableInfo(true);
            dataSourceUtil.getTableInfo(self.sid(), self.chosenTableName()).done(function(data) {
                if (data.length <= 0)
                    return;
                var cols = [];
                for (var key in data[0]) {
                    cols.push(key);
                }

                var rows = [];
                for (var i = 0; i < data.length; i++) {
                    rows.push(data[i]);
                }

                self.currentTable(new RelationshipViewModelProperties.Table(cols, rows));
            }).always(function() {
                self.isLoadingTableInfo(false);
            });
        };

        self.chosenTableName.subscribe(function(newValue) {
            self.loadTableInfo(self.sid(), newValue);
        }, self);

        self.loadTableList = function() {
            if (self.sid() >= 1) {
                dataSourceUtil.getTablesList(self.sid()).done(function(data) {
                    if (data != null) {
                        self.tableList(data);
                    }

                    if (data.length === 1) {
                        self.chosenTableName(data[0]);
                        self.loadTableInfo();
                    }
                });
            }
        };
    },
    // cols: [],
    // rows: [{}, {}]
    Table: function(cols, rows) {
        var self = this;
        // Change data structure.
        self.columns = ko.observableArray($.map(cols, function(i, val) {
            return new RelationshipViewModelProperties.Column(val);
        }));
        self.rows = ko.observableArray();
        for (var i = 0; i < rows.length; i++) {
            self.rows.push(new RelationshipViewModelProperties.Row(rows[i]));
        }

        self.getRawDataColumns = function() {
            return $.map(self.rows(), function(row, i) {
                var rawObj = row.colfusionDataColumn.rawColfusionDataColumnObj;
                // Properties for typeahead.js.
                rawObj.name = rawObj.dname_chosen;
                rawObj.tokens = [];
                rawObj.tokens.push(rawObj.name);
                if (!rawObj.dname_value_description)
                    rawObj.dname_value_description = 'No description.';
                return rawObj;
            });
        };
        self.isSelected = ko.observable(false);
    },
    Column: function(name) {
        var self = this;
        self.name = ko.observable(name);
    },
    Row: function(colfusionDataColumn) {
        var self = this;
        self.colfusionDataColumn = new RelationshipViewModelProperties.ColfusionDataColumn(colfusionDataColumn);
        self.isChecked = ko.observable(false);
    },
    ColfusionDataColumn: function(rawDataColumn) {
        var self = this;
        self.cid = ko.observable();
        self.dname_chosen = ko.observable();
        self.dname_value_description = ko.observable();
        self.dname_value_type = ko.observable();
        self.dname_value_unit = ko.observable();
        self.rawColfusionDataColumnObj = rawDataColumn;

        self.mapFromRawDataColumn = function(rawDataColumn) {
            if (rawDataColumn !== undefined) {
                self.cid(rawDataColumn.cid);
                self.dname_chosen(rawDataColumn.dname_chosen);
                self.dname_value_description(rawDataColumn.dname_value_description);
                self.dname_value_type(rawDataColumn.dname_value_type);
                self.dname_value_unit(rawDataColumn.dname_value_unit);
            }
        };

        self.mapFromRawDataColumn(rawDataColumn);
    },
    Link: function(fromDataSet, toDataSet) {
        var self = this;
        self.fromLinkPart = ko.observable(new RelationshipViewModelProperties.LinkPart(fromDataSet));
        self.toLinkPart = ko.observable(new RelationshipViewModelProperties.LinkPart(toDataSet));
    },
    LinkPart: function(dataSet) {
        var self = this;
        self.dataSet = dataSet;
        self.transInput = ko.observable('');
        self.colfusionDataColumn = ko.observable(new RelationshipViewModelProperties.ColfusionDataColumn());

        self.getEncodedTransInput = function() {

            var encodedInput = self.transInput();
            var rawDataColumns = dataSet.currentTable().getRawDataColumns();

            $.each(rawDataColumns, function(index, rawDataColumnObj) {
                encodedInput = encodedInput.replace(rawDataColumnObj.dname_chosen, 'cid(' + rawDataColumnObj.cid + ')');
            });

            return encodedInput;
        };
    }
};
function RelationshipViewModel() {
    var self = this;
    self.name = ko.observable('');
    self.description = ko.observable('');
    self.fromDataSet = ko.observable(new RelationshipViewModelProperties.DataSet());
    self.toDataSet = ko.observable(new RelationshipViewModelProperties.DataSet());
    self.confidenceValue = ko.observable(0);
    self.confidenceComment = ko.observable('');
    /* Properties for link. */
    self.links = ko.observableArray();

    /* Properties for style. */
    self.isContainerShowned = ko.observable(false);
    self.isAddingRelationship = ko.observable(false);
    self.isAddingSuccessful = ko.observable(false);
    self.isAddingFailed = ko.observable(false);
    self.isPerformingDataMatchingCheck = ko.observable('');
    self.dataMatchingCheckResult = ko.observable('');
    /**************************************************/

    self.fromDataSet().currentTable.subscribe(function(newValue) {
        resetLinks();
    }, self);

    self.toDataSet().currentTable.subscribe(function(newValue) {
        resetLinks();
    }, self);

    self.addLink = function() {
        self.links.push(new RelationshipViewModelProperties.Link(self.fromDataSet(), self.toDataSet()));
    };
    self.removeLink = function() {
        self.links.remove(this);
    };

    self.addRelationship = function(context, event) {


        if (!$(event.target).parents('form').parsley('validate')
                || self.isAddingRelationship()) {
            return;
        }

        if (self.links().length <= 0) {
            alert('Please specify at least one relationship.');
            return;
        }

        self.isAddingRelationship(true);
        self.isAddingSuccessful(false);
        self.isAddingFailed(false);
        var fromDateColumns = getSentFromData();
        var toDateColumns = getSentToData();
        console.log(self.name());
        console.log(self.description());
        console.log(fromDateColumns);
        console.log(toDateColumns);
        console.log(self.confidenceValue());
        console.log(self.confidenceComment());
        $.ajax({
            type: 'POST',
            url: "visualization/VisualizationAPI.php?action=AddRelationship",
            data: {
                "name": self.name(),
                "description": self.description(),
                "from": fromDateColumns,
                "to": toDateColumns,
                "confidence": self.confidenceValue(),
                "comment": self.confidenceComment()
            },
            success: function(data) {
                self.isAddingRelationship(false);
                self.isAddingSuccessful(true);
                dataPreviewViewModel.mineRelationships(10, 1);
                setTimeout(function() {

                    reset();
                    self.isContainerShowned(false);
                }, 2000);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                self.isAddingRelationship(false);
                self.isAddingFailed(true);
            },
            dataType: 'json'
        });
    };

    self.cancelAddingRelationship = function() {
        if (confirm('Do you want to reset the inputs?')) {
            reset();
            self.isContainerShowned(false);
        }
    };

    self.checkDataMatching = function() {
        self.isPerformingDataMatchingCheck(true);

        dataSourceUtil.checkDataMatching(getSentFromData(), getSentToData()).done(function(data) {
            self.isPerformingDataMatchingCheck(false);
            self.dataMatchingCheckResult(data);
        }).error(function() {
            self.isPerformingDataMatchingCheck(false);
            self.dataMatchingCheckResult('Some errors occur when performing data checking.');
        });
    };

    self.testDataEncoding = function() {
        console.log(getSentFromData());
        console.log(getSentToData());
    };

    function reset() {
        resetRelDescription();
        resetDatasets();
        resetConfidence();
        resetLinks();
    }

    function resetRelDescription() {
        self.name('');
        self.description('');
    }

    function resetDatasets() {
        self.fromDataSet(new RelationshipViewModelProperties.DataSet(self.fromDataSet().sid()));
        self.fromDataSet().loadTableList();
        self.toDataSet(new RelationshipViewModelProperties.DataSet());
    }

    function resetConfidence() {
        self.confidenceValue(0);
        self.confidenceComment('');
    }

    function resetLinks() {
        self.links([]);
    }

    function getSentFromData() {
        var result = {};
        result.sid = self.fromDataSet().sid();
        result.tableName = self.fromDataSet().chosenTableName();

        result.columns = $.map(self.links(), function(link, i) {
            return link.fromLinkPart().getEncodedTransInput();
        });
        return result;
    }

    function getSentToData() {
        var result = {};
        result.sid = self.toDataSet().sid();
        result.tableName = self.toDataSet().chosenTableName();

        result.columns = $.map(self.links(), function(link, i) {
            return link.toLinkPart().getEncodedTransInput();
        });
        return result;
    }
}
