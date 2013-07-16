var KnockoutUtil = {
    TimeProgress: function(startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval) {
        var self = this;
        self.startLoadingTimeStamp = ko.observable(startLoadingTimeStamp);
        self.estimatedLoadingTimestamp = ko.observable(estimatedLoadingTimestamp);
        self.updateInterval = updateInterval || 1000;
        self.loadingProgressPercent = ko.observable(0);

        self.start = function() {
            updateLoadingProgress(self.startLoadingTimeStamp(), self.estimatedLoadingTimestamp());
        };

        var updateLoadingProgress = function(startLoadingTimeStamp, estimatedLoadingTimestamp) {
            if (self.loadingProgressPercent() < 99) {
                var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
                var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
                progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;
                self.loadingProgressPercent(Math.floor(progressPercent));
                setTimeout(function() {
                    updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
                }, updateInterval);
            }
        };
    }
};
