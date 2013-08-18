﻿/*
To loose UpdateStatusViewModel's dependency on DataPreviewViewModel,
we define a Mock DataPreviewViewModel to prevent error if there's no DataPreviewViewModel passed in UpdateStatusViewModel.
*/
function MockDataPreviewViewModel() {
    this.getTableList = function () {
    };
}

/*
This model can be seemed as a wrapper of DataPreivewViewModel.
It manages importing status and helps DataPreivewViewModel to retrieve data in appropiate time.
*/

function StoryStatusViewModel(sid, dataPreviewViewModel) {
    var self = this;

    self.sid = sid;
    self.dataPreviewViewModel = dataPreviewViewModel || new MockDataPreviewViewModel();

    self.isDataShown = ko.observable(false);
    self.isRefreshingUpdateStatus = ko.observable(false);
    self.datasetStatus = ko.observableArray();
    
    self.refreshUpdateStatus = function () {
        console.log("Refreshing Status");

        self.isRefreshingUpdateStatus(true);

        return $.ajax({
            url: my_pligg_base + '/DataImportWizard/ImportWizardAPI.php?action=GetStoryStatus',
            data: { sid: self.sid },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                self.datasetStatus(data);
                loadData();
            }
        }).always(function () {
            self.isRefreshingUpdateStatus(false);
        });
    };

    function loadData() {
        console.log("load Data");

        var readyForLoading = self.datasetStatus() != null && self.datasetStatus().length > 0;
        ko.utils.arrayForEach(self.datasetStatus(), function (statusObj) {
            readyForLoading = readyForLoading && (statusObj.RecordsProcessed >= 1000 || statusObj.status == 'success');
        });

        if (readyForLoading && !self.isDataShown()) {
            self.dataPreviewViewModel.getTablesList();
            self.isDataShown(true);
        }
    }

    function autoRefreshUpdateStatus() {
        var needRefreshing = self.datasetStatus().length == 0;

        ko.utils.arrayForEach(self.datasetStatus(), function (statusObj) {
            needRefreshing = needRefreshing || (statusObj.status != 'error' && statusObj.status != 'success');
        });

        if (needRefreshing) {
            self.refreshUpdateStatus().done(function (data) {
                setTimeout(autoRefreshUpdateStatus, 5000);
            });
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