function ProgressBarViewModel() {
    var self = this;

    self.loadingProgressPercent = ko.observable(0);
    self.isProgressing = ko.observable(false);
    self.estimatedTimestamp = ko.observable(0);

    self.setEstimatedTimeStamp = function(et) {
        self.estimatedTimestamp(et);
    };

    self.start = function() {
        console.log("start progressing");
        self.isProgressing(true);
        self.loadingProgressPercent(0);
        var startLoadingTimeStamp = new Date().getTime();
        updateLoadingProgress(startLoadingTimeStamp, self.estimatedTimestamp());
    };
    
    self.stop = function(){
        console.log("stop progressing");
        self.isProgressing(false);
    };

    function updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp) {
        if (!self.isProgressing()) {
            var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
            console.log("hasLoadedTimestamp: " + hasLoadedTimestamp);
            console.log("estimatedLoadingTimestamp: " + estimatedLoadingTimestamp);
            var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
            progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;
            console.log("progressPercent: " + progressPercent);
            self.loadingProgressPercent(Math.floor(progressPercent));
            setTimeout(function() {
                updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
            }, 1000);
        }
    }
}
