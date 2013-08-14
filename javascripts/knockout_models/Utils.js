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
        var elements = koBindingHandlersRelationshipGraph.getElements(allPaths);

        $(element).children('.relGraph').empty().cytoscape({
            elements: elements,

            style: cytoscape.stylesheet().selector('node').css({
                'content': 'data(name)',
                'class': 'node datasetNode',
                'font-family': 'helvetica',
                'font-size': 14,
                'text-outline-width': 3,
                'text-outline-color': '#888',
                'text-valign': 'center',
                'color': '#fff',
                'width': '40',
                'height': '40',
                'border-color': '#fff'
            })
          .selector('edge')
            .css({
                'width': 2,
                'class': 'edge relEdge',
            }),
            
            minZoom: 0,
            maxZoom: 0
        });

        var nodeTooltip = $(element).children('.relGraphTooltip_node');
        var edgeTootip = $(element).children('.relGraphTooltip_edge');

        var cy = $(element).children('.relGraph').cytoscape('get');
        cy.nodes().bind("mouseover", function (evt) {
            
            koBindingHandlersRelationshipGraph.updateNodeTooltip(evt.cyTarget._private.data, nodeTooltip);
            $(nodeTooltip).css({ 'left': evt.originalEvent.x, 'top': evt.originalEvent.y }).show();
            
        }).bind('mouseout', function (evt) {
            $(nodeTooltip).hide();
        }).bind('click', function (evt) {
            var sid = evt.cyTarget._private.data.sid;
            window.open('../story.php?title=' + sid, '_blank');
        });

        cy.edges().bind("mouseover", function (evt) {
       
            koBindingHandlersRelationshipGraph.updateEdgeTooltip(evt.cyTarget._private.data, edgeTootip);
            $(edgeTootip).css({ 'left': evt.originalEvent.x, 'top': evt.originalEvent.y }).show();
            
        }).bind('mouseout', function (evt) {
            $(edgeTootip).hide();
        });
    }
};

var koBindingHandlersRelationshipGraph = (function () {
    var koBindingHandlersRelationshipGraph = {};

    koBindingHandlersRelationshipGraph.getElements = function (allPaths) {

        var allDatasets = [];
        $.each(allPaths, function (i, path) {
            for (var j = 0; j < path.relationships.length; j++) {
                var relationship = path.relationships[j];

                relationship.sidFrom.name = relationship.sidFrom.sidTitle;
                relationship.sidTo.name = relationship.sidTo.sidTitle;

                allDatasets.push(relationship.sidFrom);
                allDatasets.push(relationship.sidTo);
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

    koBindingHandlersRelationshipGraph.updateNodeTooltip = function (node, tooltipDom) {

        var tooltipTable = $('<table class="tableInfoTable">' +
            '<thead>' +
            '<tr>' +
            '<th style="width: 100px">Column Name</th>' +
            '<th style="width: 80px">Type</th>' +
            '<th style="width: 80px">Unit/Format</th>' +
            '<th style="width: 150px; text-align: center;">Description</th>' +
            '</tr>' +
            '</thead>' +
            '<tbody></tbody>' +
            '</table>');

        $.each(node.allColumns, function (i, col) {
            var colDom = $('<tr></tr>');

            $(colDom).append('<td>' + col.dname_chosen + '</td>')
                .append('<td>' + col.dname_value_type + '</td>')
                .append('<td>' + col.dname_value_unit + '</td>')
                .append('<td>' + col.dname_value_description + '</td>');

            $(tooltipTable).children('tbody').append(colDom);
        });

        $(tooltipDom).empty().append('<div class="tableInfoTableWrapper"></div>')
            .children('.tableInfoTableWrapper').append(tooltipTable);
    };

    koBindingHandlersRelationshipGraph.updateEdgeTooltip = function (edge, tooltipDom) {

        var tooltipTable = $('<table class="relationshipGraphTooltipTable">' +
            '<tr>' +
            '<td class="titleText">Title: </td>' +
            '<td>' + edge.relName + '</td>' +
            '</tr>' +
            '<tr>' +
            '<td class="titleText">Avg Confidence: </td>' +
            '<td>' + edge.confidence + '</td>' +
            '</tr>' +
            '<tr>' +
            '<td class="titleText">From: </td>' +
            '<td>' + edge.sidFrom.sidTitle + '.' + edge.sidFrom.tableName + '</td>' +
            '</tr>' +
            '<tr>' +
            '<td class="titleText">To: </td>' +
            '<td>' + edge.sidTo.sidTitle + '.' + edge.sidTo.tableName + '</td>' +
            '</tr>' +
            '</table>');

        $(tooltipDom).empty().append(tooltipTable);

    };

    return koBindingHandlersRelationshipGraph;
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

