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
                .replace("{{dname_chosen}}", "{{title}}")
                .replace("{{dataset_name}}", "{{userName}}")
                .replace("{{dname_value_description}}", "{{description}}");

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
            valueKey: 'source_key',
            template: search_typeahead_tpl,
            engine: Hogan
        }).bind('typeahead:selected', function(event, datum) {
            dataSet.sid(datum.sid);
            dataSet.name(datum.title);
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

function NewRelationshipViewModel() {
    var self = this;
    self.name = ko.observable('');
    self.description = ko.observable('');
    self.fromDataSet = ko.observable(new RelationshipModel.DataSet());
    self.toDataSet = ko.observable(new RelationshipModel.DataSet());
    self.confidenceValue = ko.observable(0);
    self.confidenceComment = ko.observable('');

    /* Properties for link. */
    self.links = ko.observableArray();

    /* Properties for style. */
    self.isContainerShowned = ko.observable(false);
    self.isAddingRelationship = ko.observable(false);
    self.isAddingSuccessful = ko.observable(false);
    self.isAddingFailed = ko.observable(false);
    /**************************************************/

    /* Used to pass data to dataMatchChecker.php */
    self.persistStore = new Persist.Store('NewRelationshipViewModel');

    self.fromDataSet().currentTable.subscribe(function(newValue) {
        resetLinks();
    }, self);

    self.toDataSet().currentTable.subscribe(function(newValue) {
        resetLinks();
    }, self);

    self.addLink = function() {
        self.links.push(new RelationshipModel.Link(self.fromDataSet(), self.toDataSet()));
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
                relationshipViewModel.mineRelationships(10, 1);
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
        console.log(self.links());
        console.log(JSON.stringify(self.links()));
        self.persistStore.set('checkDataMatching_' + self.fromDataSet().sid() + '_' + self.fromDataSet().chosenTableName()
                + '_' + self.toDataSet().sid() + '_' + self.toDataSet().chosenTableName(), ko.toJSON(self));

        $('#dataMatchCheckingForm input[name="fromSid"]').val(self.fromDataSet().sid());
        $('#dataMatchCheckingForm input[name="toSid"]').val(self.toDataSet().sid());
        $('#dataMatchCheckingForm input[name="fromTable"]').val(self.fromDataSet().chosenTableName());
        $('#dataMatchCheckingForm input[name="toTable"]').val(self.toDataSet().chosenTableName());
        $('#dataMatchCheckingForm').submit();
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
        self.fromDataSet(new RelationshipModel.DataSet(self.fromDataSet().sid()));
        self.fromDataSet().loadTableList();
        self.toDataSet(new RelationshipModel.DataSet());
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
