var wizardFromDataverse = (function() {
    var wizardFromDataverse = {};

    wizardFromDataverse.fromDataverseViewModel;

    wizardFromDataverse.init = function(sid) {
        wizardFromDataverse.fromDataverseViewModel = new FromDataverseViewModel(sid);
        var viewModelDom = document.getElementById('divFromDataverseKnockoutContainer');
        ko.applyBindings(wizardFromDataverse.fromDataverseViewModel, viewModelDom);
    }

    function DataverseFileInfoViewModel(fileId, fileName, size, citation, publishedAt) {
        var self = this;
        self.fileId = ko.observable(fileId);
        self.fileName = ko.observable(fileName);
        self.size = ko.observable(size);
        self.citation = ko.observable(citation);
        self.publishedAt = ko.observable(publishedAt);
    }

    function FromDataverseViewModel(sid) {
        var self = this;
        self.sid = sid;

        self.foundFiles = ko.observableArray();

        self.fileName = ko.observable();
        self.datasetName = ko.observable("");
        self.dataverseName = ko.observable("");

        self.showNoFilesFoundMessage = ko.observable(false);
        self.showSearchErrorMessage = ko.observable(false);
        self.showSearchLoading = ko.observable(false);
        self.showUploadLoading = ko.observable(false);
        self.showUploadErrorMessage = ko.observable(false);
        self.showUploadErrorMessage403 = ko.observable(false);
        self.showUploadSuccessMessage = ko.observable(false);
        

        self.selectedFile = ko.observable();

        self.searchForFile = function() {
            self.showSearchLoading(true);
            self.showUploadErrorMessage(false); 
            self.showSearchErrorMessage(false); 
            $.ajax({
                url: restApis.getDataverseSearch(self.fileName(), self.dataverseName(), self.datasetName()), 
                type: 'GET',
                contentType: 'application/json',
                success: function(data) {
                    if (data.isSuccessful) {
                        self.showSearchErrorMessage(false); 
                        self.foundFiles.removeAll();

                        if (data.payload.length == 0) {
                            self.showNoFilesFoundMessage(true);
                            return;
                        }

                        for (i = 0; i < data.payload.length; i++){
                            self.foundFiles.push(new DataverseFileInfoViewModel(data.payload[i].fileId,
                                data.payload[i].fileName, data.payload[i].size, 
                                data.payload[i].citation, data.payload[i].publishedAt));
                        }
                        self.showNoFilesFoundMessage(false);
                    }
                    else {
                        self.showSearchErrorMessage(true); 
                    }
                },
                error: function(data) {
                    self.showSearchErrorMessage(true); 
                }
            })
            .always(function() {
                self.showSearchLoading(false);
            });
        }

        self.getDataFile = function() {
            if (!self.selectedFile()) {
                alert('Please select a file first');
                return;
            }

            self.showUploadLoading(true);
            self.showSearchLoading(false);
            self.showUploadLoading(false);
            self.showUploadSuccessMessage(false);

            var data = {'sid': self.sid, 'fileId': self.selectedFile().fileId(), 'fileName': self.selectedFile().fileName()};

            $.ajax({
                url: restApis.postGetDataFile(), 
                type: 'POST',
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function(data) {
                    if (data.isSuccessful) {
                        self.showUploadErrorMessage(false);
                        self.showUploadSuccessMessage(true);

                        wizard.enableNextButton();
                        // var resultJson = JSON.parse(data);
                        wizardFromFile.fromComputerUploadFileViewModel.uploadedFileInfos.push(data.payload[0]);
                        wizardFromFile.fromComputerUploadFileViewModel.isUploadSuccessful(data.isSuccessful);
                        wizardFromFile.fromComputerUploadFileViewModel.uploadMessage(data.message);
                    }
                    else {
                        self.showUploadErrorMessage(true); 
                    }
                },
                error: function(data) {
                    if (data.status == 403) {
                        self.showUploadErrorMessage403(true);
                    }
                    else {
                        self.showUploadErrorMessage403(false);    
                    }
                    
                    self.showUploadErrorMessage(true); 
                }
            })
            .always(function(){
                self.showUploadLoading(false);
            });
        }

        self.updateSelectedBackground = function(data, event) {
            $('#tableDataverseFiles tr').removeClass('selectedDataverseFile');
            $(event.target).parent().closest('tr').addClass('selectedDataverseFile');
            self.selectedFile(data);
            $(event.target).prop("checked", true);
        }
    }

    return wizardFromDataverse;
})();