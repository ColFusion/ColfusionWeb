/*
To loose UpdateStatusViewModel's dependency on DataPreviewViewModel,
we define a Mock DataPreviewViewModel to prevent error if there's no DataPreviewViewModel passed in UpdateStatusViewModel.
*/
function MockDataPreviewViewModel() {
    this.getTableList = function () {
    };
}

var StoryStatusProperties = {
    DatasetStatus: function() {
        var self = this;

        self.statusObj = ko.observable();
        self.timeElapse = ko.observable(0);
        self.needRefreshing = ko.observable(true);

        self.isNeedRefreshing = function () {
            return self.statusObj().status != 'error' && self.statusObj().status != 'success';
        };

        self.isReadyForLoading = function() {
            return self.statusObj() &&
                parseInt(self.statusObj().numberProcessRecords) >= 1000 || self.statusObj().status == 'success';
        };

        self.tickTimeElapse = function() {
            var timeStart = moment(self.statusObj().TimeStart);
            var timeElapseInSecond = (moment().valueOf() - timeStart.valueOf()) / 1000;
            
            self.timeElapse(generalUtil.getTimerString(timeElapseInSecond));
            if (self.isNeedRefreshing()) {
                setTimeout(function() {
                    self.tickTimeElapse();
                }, 1000);
            } else {
                self.needRefreshing(false);
            }
        };
    }
};

/*
This model can be seemed as a wrapper of DataPreivewViewModel.
It manages importing status and helps DataPreivewViewModel to retrieve data in appropiate time.
*/
function StoryStatusViewModel(sid, dataPreviewViewModel) {
    var self = this;

    self.sid = sid;
    self.dataPreviewViewModel = dataPreviewViewModel || new MockDataPreviewViewModel();

    self.isStatusShown = ko.observable(true);
    self.isDataShown = ko.observable(false);
    self.isRefreshingUpdateStatus = ko.observable(true);
    
    self.datasetStatus = ko.observableArray();
    dataPreviewViewModel.isRefreshingUpdateStatus = self.isRefreshingUpdateStatus;
    
    self.refreshUpdateStatus = function () {
        console.log("Refreshing Status");

        $('#datasetDescription-lastRefresh').text(new Date().toString("yyyy-MM-dd HH:mm:ss"));

        return $.ajax({
            url: my_pligg_base + '/DataImportWizard/ImportWizardAPI.php?action=GetStoryStatus',
            // url: my_pligg_base + '/DataImportWizard/testStoryStatus.json',
            data: { sid: self.sid },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                
                if (self.datasetStatus().length != data.length) {
                    ko.utils.arrayForEach(data, function () {
                        self.datasetStatus.push(new StoryStatusProperties.DatasetStatus());
                    });
                }
                
                for (var i = 0; i < data.length; i++) {
                    var dataStatus = self.datasetStatus()[i];
                    dataStatus.statusObj(data[i]);
                    dataStatus.tickTimeElapse();
                }

                loadData();
            }
        });
    };

    function loadData() {
        console.log("load Data");

        var readyForLoading = self.datasetStatus() != null && self.datasetStatus().length > 0;
        
        ko.utils.arrayForEach(self.datasetStatus(), function (dataStatus) {
            readyForLoading = readyForLoading && dataStatus.isReadyForLoading();
        });

        if (readyForLoading && !self.isDataShown()) {
            self.dataPreviewViewModel.getTablesList();
            self.isDataShown(true);
        }
    }

    function autoRefreshUpdateStatus() {
        var needRefreshing = self.datasetStatus().length == 0;

        ko.utils.arrayForEach(self.datasetStatus(), function (dataStatus) {
            needRefreshing = needRefreshing || dataStatus.isNeedRefreshing();
        });

        if (needRefreshing) {
            self.refreshUpdateStatus().done(function (data) {
                setTimeout(autoRefreshUpdateStatus, 5000);
            });
        } else {
            self.isRefreshingUpdateStatus(false);
        }
    }

    // class value for i element using font-awesome.
    self.getStatusIcon = function (status) {
        if (status == 'success') {
            return 'icon-ok-sign';
        } else if (status == 'error') {
            return 'icon-remove-sign';
        } else {
            return 'icon-upload';
        }
    };

    self.getStatusTextColor = function (status) {
        if (status == 'success') {
            return 'green';
        } else if (status == 'error') {
            return 'red';
        } else {
            return 'black';
        }
    };
    
    autoRefreshUpdateStatus();
}