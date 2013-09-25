function ProgressBarViewModel() {
    var self = this;

    self.loadingProgressPercent = ko.observable(0);
    self.isProgressing = ko.observable(false);

    self.start = function (loadingTimestamp) {
        self.isProgressing(true);
        self.loadingProgressPercent(0);
        var startLoadingTimeStamp = new Date().getTime();
        updateLoadingProgress(startLoadingTimeStamp, loadingTimestamp);
    };
    
    self.stop = function(){
        self.isProgressing(false);
    };

    function updateLoadingProgress(startLoadingTimeStamp, loadingTimestamp) {
        if (self.isProgressing()) {
            var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;

            var progressPercent = hasLoadedTimestamp / loadingTimestamp * 100;
            progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;

            self.loadingProgressPercent(Math.floor(progressPercent));
            setTimeout(function() {
                updateLoadingProgress(startLoadingTimeStamp, loadingTimestamp);
            }, 1000);
        }
    }
}
