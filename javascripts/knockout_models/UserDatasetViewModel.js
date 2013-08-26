/*
This view model requires RelationshipModel.DataSet and StoryStatusProperties.DatasetStatus,
DatasetStatus is injected to DataSet with one-to-one relationship.
*/
function UserDatasetViewModel() {
    var self = this;

    self.isLoadingDataset = ko.observable(false);
    self.isLoadingDatasetError = ko.observable(false);

    self.datasets = ko.observableArray();

    self.fetchDatasets = function (userId) {

        self.isLoadingDataset(true);
        self.isLoadingDatasetError(false);

        $.ajax({
            url: my_pligg_base + '/datasetController/getUserDataset.php',
            data: { userId: userId },
            type: 'post',
            dataType: 'json',
            
            success: function (datasetInfos) {

                for (key in datasetInfos) {
                    var datasetInfo = datasetInfos[key];

                    var datasetModel = new RelationshipModel.DataSet(datasetInfo.sid);
                    datasetModel.name(datasetInfo.title);
                    datasetModel.content(datasetInfo.description);
                    datasetModel.userId(datasetInfo.userId);
                    datasetModel.userName(datasetInfo.userName);
                    datasetModel.createdTime(datasetInfo.entryDate);
                    datasetModel.lastUpdated(datasetInfo.lastUpdated);

                    // Inject dataset status and update functions into DataSet model.
                    injectDatasetStatus(datasetModel);

                    self.datasets.push(datasetModel);
                }
            },
            
            error: function () {                
                self.isLoadingDatasetError(true);
            }
        }).always(function () {
            self.isLoadingDataset(false);
        });
    };

    function injectDatasetStatus(datasetModel) {
   
        datasetModel.fetchStatus = function () {

            $.ajax({
                url: my_pligg_base + '/DataImportWizard/ImportWizardAPI.php?action=GetStoryStatus',
                // url: my_pligg_base + '/DataImportWizard/testStoryStatus.json',
                data: { sid: datasetModel.sid },
                type: 'post',
                dataType: 'json',
                success: function (data) {

                    if (datasetModel.status().length != data.length) {
                        ko.utils.arrayForEach(data, function () {
                            datasetModel.status.push(new StoryStatusProperties.DatasetStatus());
                        });
                    }

                    for (var i = 0; i < data.length; i++) {
                        var dataStatus = datasetModel.status()[i];
                        dataStatus.statusObj(data[i]);
                        dataStatus.tickTimeElapse();
                    }
                }
            });
        };

        datasetModel.storyStatusViewModel = ko.observable(new StoryStatusViewModel(datasetModel.sid));       
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

    self.fetchDatasets();
}