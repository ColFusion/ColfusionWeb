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
