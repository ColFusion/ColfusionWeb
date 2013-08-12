ko.bindingHandlers.bootstrapTooltip = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        // Replace value in html using id
        var tooltipDynamicValues = allBindingsAccessor().tooltipDynamicValues || {};
        for (id in tooltipDynamicValues) {
            $(element).find('#' + id).html(tooltipDynamicValues[id] || 'N/A');
        }

        var tooltipContent = $(element).html();
        var options = {
            title: tooltipContent,
            html: true
        };

        for (key in allBindingsAccessor().tooltipOptions) {
            options[key] = allBindingsAccessor().tooltipOptions[key];
        }

        $(element).tooltip(options);
    },
    update: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        $(element).html(valueAccessor());
    }
};

ko.bindingHandlers.horizontalScrollable = {
    init: function (element, valueAccessor, allBindingsAccessor) {
        var options = allBindingsAccessor().horiScrollOptions || {};
        var scale = options.scale || 100;

        $(element).bind('mousewheel', function (event, delta) {
            var val = this.scrollLeft - (delta * scale);
            jQuery(this).stop().animate({ scrollLeft: val });
            event.preventDefault();
        });
    }
};

ko.bindingHandlers.slider = {
    init: function (element, valueAccessor, allBindingsAccessor) {
        var options = allBindingsAccessor().sliderOptions || {};
        $(element).slider(options);
        ko.utils.registerEventHandler(element, "slidechange", function (event, ui) {
            var observable = valueAccessor();
            observable(ui.value);
        });
        ko.utils.domNodeDisposal.addDisposeCallback(element, function () {
            $(element).slider("destroy");
        });
        ko.utils.registerEventHandler(element, "slide", function (event, ui) {
            var observable = valueAccessor();
            observable(ui.value);
        });
    },
    update: function (element, valueAccessor) {
        var value = ko.utils.unwrapObservable(valueAccessor());
        if (isNaN(value))
            value = 0;
        $(element).slider("value", value);
    }
};

ko.bindingHandlers.relationshipGraph = {
    init: function (element, valueAccessor, allBindingsAccessor) {      
        var relGraphDom = $('<div class="relGraph"></div>');
        var nodeTooltipDom = $('<div class="relGraphTooltip_node"></div>');
        var edgeTootipDom = $('<div class="relGraphTooltip_edge"></div>');
        $(element).append(relGraphDom);
        $(element).append(nodeTooltipDom);
        $(element).append(edgeTootipDom);
    },
    update: function (element, valueAccessor, allBindingsAccessor) {
        var allPaths = valueAccessor();
        var elements = ko_bindingHandlers_relationshipGraph.getElements(allPaths);


    }
};

var ko_bindingHandlers_relationshipGraph = (function () {
    var ko_bindingHandlers_relationshipGraph = {};

    ko_bindingHandlers_relationshipGraph.getElements = function (allPaths) {
        
        var allDatasets = [];
        $.each(allPaths, function (i, path) {
            for (var j = 0; j < path.sids.length; j++) {
                allDatasets.push({
                    sid: path.sids[j],
                    name: path.sidTitles[j]
                });
            }
        });
        var distinctDatasets = generalUtil.convertArrayToSet('sid', allDatasets);

        var allRelationships = [];
        $.each(allPaths, function (i, path) {
            $.each(path.relationships, function (j, relationship) {
                allRelationships.push(relationship);
            });
        });
        var distinctRelationships = generalUtil.convertArrayToSet('relId', allRelationships);

        var nodes = $.map(distinctDatasets, function (dataset, i) {
            dataset.id = String(dataset.sid);
            return {
                group: 'nodes',
                data: dataset,
                classes: 'node datasetNode'
            };
        });

        var edges = $.map(distinctRelationships, function (relationship) {
            relationship.id = String(relationship.relId);
            relationship.source = String(relationship.sidFrom.sid);
            relationship.target = String(relationship.sidTo.sid);

            return {
                group: 'edges',
                data: relationship
            };
        });

        return {
            nodes: nodes,
            edges: edges
        };
    };

    return ko_bindingHandlers_relationshipGraph;
})();

var KnockoutUtil = {
    TimeProgress: function (startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval) {
        var self = this;
        self.startLoadingTimeStamp = ko.observable(startLoadingTimeStamp);
        self.estimatedLoadingTimestamp = ko.observable(estimatedLoadingTimestamp);
        self.updateInterval = updateInterval || 1000;
        self.loadingProgressPercent = ko.observable(0);

        self.start = function () {
            updateLoadingProgress(self.startLoadingTimeStamp(), self.estimatedLoadingTimestamp());
        };

        var updateLoadingProgress = function (startLoadingTimeStamp, estimatedLoadingTimestamp) {
            if (self.loadingProgressPercent() < 99) {
                var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
                var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
                progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;
                self.loadingProgressPercent(Math.floor(progressPercent));
                setTimeout(function () {
                    updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
                }, updateInterval);
            }
        };
    }
};

