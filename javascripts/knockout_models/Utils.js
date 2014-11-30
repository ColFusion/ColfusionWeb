/* 
This binding handler init tooltip by using the content in elem as tooltip's text, 
and replace the content with binding value.

If 'tooltipDynamicValues' is specified (elem id-value pair object), 
the original content will be replace with new value before moved into tooltip.
*/ 
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
        $(element).html(ko.unwrap(valueAccessor()));
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
        
        // Initial value in option seems not work.
        // Here manually trigger slider event to change init value.
        if (options.value) {
            $(element).slider("option", "value", options.value);
            $(element).trigger('slidechange', { handle: 'a.ui-slider-handle ui-state-default ui-corner-all ui-state-focus ui-state-hover', value: options.value});
        }
    },
    update: function (element, valueAccessor) {
        var value = ko.utils.unwrapObservable(valueAccessor());
        if (isNaN(value))
            value = 0;
        $(element).slider("value", value);
    }
};

//TODO: this should be rewritten as class with Decorator pattern, for now just use if to check what was input type
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

        debugger;

        var pathModels = valueAccessor()();

        var cyGraphElements;

        if (pathModels instanceof RelationshipGraphData) {
            cyGraphElements = koBindingHandlersRelationshipGraph.getCyGraphElementsFromRelationshipGraphData(pathModels);
        }
        else {
            var allPaths = $.map(pathModels, function (pathModel) {
                return pathModel.pathObj;
            });

            cyGraphElements = koBindingHandlersRelationshipGraph.getCyGraphElements(allPaths);

            $.each(pathModels, function (i, pathModel) {
                koBindingHandlersRelationshipGraph.addHighlightPathButton(i, pathModel, element);
            });
        }

        $(element).children('.relGraph').empty().cytoscape({
            elements: cyGraphElements,

            style: cytoscape.stylesheet()
                   .selector('node')
                   .css(koBindingHandlersRelationshipGraph.defaultNodeCss)
                   .selector('edge')
                   .css(koBindingHandlersRelationshipGraph.defaultEdgeCss),

            minZoom: 0,
            maxZoom: 0
        });

        koBindingHandlersRelationshipGraph.bindNodeTooltipEvents(element);
        koBindingHandlersRelationshipGraph.bindEdgeTooltipEvents(element);
    }
};

var koBindingHandlersRelationshipGraph = (function () {
    var koBindingHandlersRelationshipGraph = {};

    koBindingHandlersRelationshipGraph.defaultNodeCss = {
        'content': 'data(graphLabel)',
        'class': 'node datasetNode',
        'font-family': 'helvetica',
        'font-size': 14,
        'text-outline-width': 3,
        'text-outline-color': '#888',
        'text-valign': 'center',
        'color': '#fff',
        'width': '40',
        'height': '40',
        'border-color': '#fff',
        'background-color': '#888'
    };

    koBindingHandlersRelationshipGraph.defaultEdgeCss = {
        'width': 2,
        'class': 'edge relEdge',
        'line-color': '#888'
    };

    koBindingHandlersRelationshipGraph.getCyGraphElements = function (allPaths) {

        debugger;

        var allDatasetTableCombs = [];
        $.each(allPaths, function (i, path) {
            for (var j = 0; j < path.relationships.length; j++) {
                var relationship = path.relationships[j];

                relationship.sidFrom.name = relationship.sidFrom.sidTitle;
                relationship.sidTo.name = relationship.sidTo.sidTitle;

                var fromDTComb = relationship.sidFrom;
                fromDTComb.id = fromDTComb.sid + '(' + fromDTComb.tableName + ')';
                fromDTComb.graphLabel = fromDTComb.sidTitle + ' (' + fromDTComb.tableName + ')';

                var toDTComb = relationship.sidTo;
                toDTComb.id = toDTComb.sid + '(' + toDTComb.tableName + ')';
                toDTComb.graphLabel = toDTComb.sidTitle + ' (' + toDTComb.tableName + ')';

                allDatasetTableCombs.push(fromDTComb);
                allDatasetTableCombs.push(toDTComb);
            }
        });
        var distinctDatasetTableCombs = generalUtil.convertArrayToSet('id', allDatasetTableCombs);

        var allRelationships = [];
        $.each(allPaths, function (i, path) {
            $.each(path.relationships, function (j, relationship) {
                allRelationships.push(relationship);
            });
        });
        var distinctRelationships = generalUtil.convertArrayToSet('relId', allRelationships);

        var nodes = $.map(distinctDatasetTableCombs, function (dataset, i) {
            // dataset.id = String(dataset.sid);
            return {
                group: 'nodes',
                data: dataset,
                classes: 'node datasetNode'
            };
        });

        var edges = $.map(distinctRelationships, function (relationship) {
            relationship.id = String(relationship.relId);
            relationship.source = String(relationship.sidFrom.sid + '(' + relationship.sidFrom.tableName + ')');
            relationship.target = String(relationship.sidTo.sid + '(' + relationship.sidTo.tableName + ')');

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

    koBindingHandlersRelationshipGraph.getCyGraphElementsFromRelationshipGraphData = function(relationshipGraphData) {

        debugger;

        //TODO FIXME: this might cause memory problem, better to use nodes from relationshipGraphData directly in the graph tool
        var nodes = $.map(relationshipGraphData.nodes, function(node, i) {
            var nodeForGraph = node;

            nodeForGraph.name = node.sidTitle;
            nodeForGraph.id = node.sid + '(' + node.tableName + ')';
            nodeForGraph.graphLabel = node.sidTitle + ' (' + node.tableName + ')'; //too long, maybe abbreviate

            return {
                group: 'nodes',
                data: nodeForGraph,
                classes: 'node datasetNode'
            };
        });

        var edges = $.map(relationshipGraphData.edges, function (edge, i) {
            var edgeForGraph = edge;

            edgeForGraph.id = String(edge.relId);
            edgeForGraph.source = String(edge.sidFrom.sid + '(' + edge.sidFrom.tableName + ')');
            edgeForGraph.target = String(edge.sidTo.sid + '(' + edge.sidTo.tableName + ')');

            return {
                group: 'edges',
                data: edgeForGraph
            };
        });

        return {
            nodes: nodes,
            edges: edges
        };
    };

    koBindingHandlersRelationshipGraph.bindNodeTooltipEvents = function (relGraphElem) {

        var nodeTooltip = $(relGraphElem).children('.relGraphTooltip_node');

        var cy = $(relGraphElem).children('.relGraph').cytoscape('get');
        cy.nodes().bind("mouseover", function (evt) {

            koBindingHandlersRelationshipGraph.updateNodeTooltip(evt.cyTarget._private.data, nodeTooltip);
            $(nodeTooltip).css({ 'left': evt.originalEvent.x, 'top': evt.originalEvent.y }).show();

        }).bind('mouseout', function (evt) {
            $(nodeTooltip).hide();
        }).bind('click', function (evt) {
            var sid = evt.cyTarget._private.data.sid;
            window.open('../story.php?title=' + sid, '_blank');
        });

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

    koBindingHandlersRelationshipGraph.bindEdgeTooltipEvents = function (relGraphElem) {

        var edgeTootip = $(relGraphElem).children('.relGraphTooltip_edge');
        var cy = $(relGraphElem).children('.relGraph').cytoscape('get');

        cy.edges().bind("mouseover", function (evt) {

            koBindingHandlersRelationshipGraph.updateEdgeTooltip(evt.cyTarget._private.data, edgeTootip);
            $(edgeTootip).css({ 'left': evt.originalEvent.x, 'top': evt.originalEvent.y }).show();

        }).bind('mouseout', function (evt) {
            $(edgeTootip).hide();
        });

    };

    koBindingHandlersRelationshipGraph.updateEdgeTooltip = function (edge, tooltipDom) {

        var tooltipTable = $('<table class="relationshipGraphTooltipTable">' +
            '<tr>' +
            '<td class="titleText">Title: </td>' +
            '<td>' + edge.relName + '</td>' +
            '</tr>' +
            '<tr>' +
            '<td class="titleText">Avg Confidence: </td>' +
            '<td>' + Number(edge.confidence).toFixed(2) + '</td>' +
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

    koBindingHandlersRelationshipGraph.addHighlightPathButton = function (i, pathModel, relGraphElem) {

        console.log('addHighlight');

        var pathElems = $(relGraphElem).parent().find('.path');
        var highlightPathBtn = $(
            '<button class="highlightPathBtn btn">' +
                '<i class="icon-code-fork" title="Highlight this path in graph"></i>' +
            '</button>'
        );
        $(pathElems).find('.buttonPanel').eq(i).prepend(highlightPathBtn);

        $(highlightPathBtn).click(function () {

            if (!$(this).hasClass('active')) {

                $(pathElems).find('.buttonPanel').find('.highlightPathBtn').removeClass('active');
                $(this).addClass('active');
                koBindingHandlersRelationshipGraph.highlightPath(pathModel, relGraphElem);

                $('html, body').animate({
                    scrollTop: $(relGraphElem).offset().top - 50
                }, 1000);

            } else {

                $(this).removeClass('active');
                koBindingHandlersRelationshipGraph.restoreToDefaultStyle(relGraphElem);

            }

        });
    };

    koBindingHandlersRelationshipGraph.highlightPath = function (pathModel, relGraphElem) {
        var pathObj = pathModel.pathObj;
        var cy = $(relGraphElem).children('.relGraph').cytoscape('get');

        var nodeFilterString = "";
        $.each(pathObj.relationships, function (i, relationship) {
            nodeFilterString += "[id='" + relationship.sidFrom.id + "'],[id='" + relationship.sidTo.id + "'],";
        });
        nodeFilterString = nodeFilterString.substring(0, nodeFilterString.length - 1);

        var edgeFilterString = "";
        $.each(pathObj.relIds, function (i, relId) {
            edgeFilterString += "[relId='" + relId + "'],";
        });
        edgeFilterString = edgeFilterString.substring(0, edgeFilterString.length - 1);

        cy.style()
            .selector('node').css(koBindingHandlersRelationshipGraph.defaultNodeCss)
            .selector('edge').css(koBindingHandlersRelationshipGraph.defaultEdgeCss)
            .selector('node' + nodeFilterString).css({
                'background-color': '#FFAC59',
                'content': 'data(graphLabel)',
                'class': 'node datasetNode',
                'font-family': 'helvetica',
                'font-size': 14,
                'text-outline-width': 3,
                'text-outline-color': '#FFAC59',
                'text-valign': 'center',
                'color': '#fff',
                'width': '40',
                'height': '40',
                'border-color': '#FFAC59'
            })
            .selector('edge' + edgeFilterString).css({
                'line-color': '#FFAC59'
            }).update();
    };

    koBindingHandlersRelationshipGraph.restoreToDefaultStyle = function (relGraphElem) {
        var cy = $(relGraphElem).children('.relGraph').cytoscape('get');

        cy.style()
            .selector('node').css(koBindingHandlersRelationshipGraph.defaultNodeCss)
            .selector('edge').css(koBindingHandlersRelationshipGraph.defaultEdgeCss)
            .update();
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