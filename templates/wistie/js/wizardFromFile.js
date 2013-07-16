var wizardFromFile = (function() {
    var wizardFromFile = {};

    /* Variables */

    var intervals = new Array();
    var wizardExcelPreviewViewModel;
    var sourceWorksheetSettingsViewModel;

    /*************/

    /* Functions */

    // Get all actions form friends.
    wizardFromFile.Init = function() {
        $('#uploadFormSid').val(sid);
        $('#uploadFileType').change(function() {
            if ($(this).val() == 'dbDump') {
                $('#dbType').show();
            } else {
                $('#dbType').hide();
            }
        });

        // bind form using 'ajaxForm' 
        wizardFileUpload.initFileUploadForm($('#upload_form'));

        /*
         wizardExcelPreviewViewModel = new WizardExcelPreviewViewModel($('#sid').val());
         var secondNode = document.getElementById('second');
         ko.cleanNode(secondNode);
         ko.applyBindings(wizardExcelPreviewViewModel, secondNode);
         */

        sourceWorksheetSettingsViewModel = new SourceWorksheetSettingsViewModel();
        var viewModelDom = document.getElementById('displayOptoinsStepCardFromFile');
        ko.applyBindings(sourceWorksheetSettingsViewModel, viewModelDom);
    };

    //Process the remote file given by the input url
    wizardFromFile.validateUrl = function() {
        var file_url = document.getElementById("in_url").value;
        var xmlHttp = importWizard.getXMLHttp();

        xmlHttp.open("GET", my_pligg_base + '/DataImportWizard/acceptFileFromWizard.php?phase=2&url=' + file_url + '&sid=' + $('#sid').val(), false);
        xmlHttp.send(null);

        if (xmlHttp.responseText != "") {
            clearInterval(intervals[0]);
            document.getElementById("result").innerHTML = xmlHttp.responseText;
            //alert(file_url+xmlHttp.responseText);
            wizard.enableNextButton();
        } else {
            alert("No response!");
        }
    };

    wizardFromFile.createKtrFiles = function() {
        return $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'post'
        });
    };

    wizardFromFile.showExcelFile = function() {
        wizardExcelPreviewViewModel.initFilePreview($('#sid').val());
    };

    wizardFromFile.getLoadingTime = function() {
        sourceWorksheetSettingsViewModel.isPreviewLoadingComplete(false);
        return $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=9",
            type: 'post',
            success: function(estimatedSeconds) {
                sourceWorksheetSettingsViewModel.setTimeProgress(new Date().getTime(), estimatedSeconds * 1000);
            },
            error: function() {
                sourceWorksheetSettingsViewModel.isPreviewLoadingComplete(true);
            }
        });
    };

    wizardFromFile.getFileSources = function() {
        return $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=8",
            type: 'post',
            dataType: 'json',
            success: function(jsonResponse) {               
                sourceWorksheetSettingsViewModel.cleanSource();

                for (var i = 0; i < jsonResponse.data.length; i++) {
                    var fileSource = jsonResponse.data[i];
                    var filename = fileSource.filename;
                    var worksheets = fileSource.worksheets;
                    sourceWorksheetSettingsViewModel.addSource(filename, worksheets);
                }
            }
        }).always(function() {
            sourceWorksheetSettingsViewModel.isPreviewLoadingComplete(true);
        });
    };

    wizardFromFile.passSheetInfoFromDisplayOptionStep = function() {
        
        console.log('passSheetInfoFromDisplayOptionStep');
        var sheetsRanges = sourceWorksheetSettingsViewModel.getSourceWorksheetSettings();     
        console.log(sheetsRanges);

        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php',
            dataType: 'html',
            data: {
                phase: 1,
                sid: $('#sid').val(),
                sheetsRanges: sheetsRanges,
                source: 'file'
            }          
        });
    };

    function updateLoadingProgress(textElement, startLoadingTimeStamp, estimatedLoadingTimestamp) {
        var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
        var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
        progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : Math.floor(progressPercent);
        $(textElement).text('Loading... ' + progressPercent + '%');
        if (progressPercent >= 99) {
            return;
        }
        setTimeout(function() {
            updateLoadingProgress(textElement, startLoadingTimeStamp, estimatedLoadingTimestamp);
        }, 1000);
    }

    wizardFromFile.passSchemaMatchinInfo = function(schemaMatchingUserInputs) {
        var dataToSend = {'phase': '2', "schemaMatchingUserInputs": schemaMatchingUserInputs};

        // alert(JSON.stringify(dataToSend));
        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php?sid=' + $('#sid').val(),
            data: dataToSend          
        });
    };

    wizardFromFile.excuteFromFile = function() {
        importWizard.getDataMatchingUserInputs();

        var dataToSend = {
            'sid': $('#sid').val(),
            'phase': 5,
            'schemaMatchingUserInputs': importWizard.getSchemaMatchingUserInputs(),
            'dataMatchingUserInputs': importWizard.getDataMatchingUserInputs()
        };

        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php',
            data: dataToSend,
            dataType: 'json'
        });
    };

    function getName() {
        var f_name, file_url, a_link;
        var xmlHttp = importWizard.getXMLHttp();

        xmlhttp.open("GET", my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=6&sid=" + $('#sid').val(), false);
        xmlhttp.send(null);

        if (xmlhttp.responseText != "")
        {
            f_name = xmlhttp.responseText;
            file_url = "upload_raw_data/" + f_name;
            a_link = "<a href=" + file_url + ">" + f_name + "</a>";
            document.getElementById('f_url').innerHTML = a_link;
            //alert(document.getElementById('sid').value);
        } else {
            document.getElementById('f_url').value = "nothing";
            //alert(document.getElementById('sid').value);
        }
    }

    return wizardFromFile;
})();

var wizardFileUpload = (function() {
    var wizardFileUpload = {};

    // store 'data' object sent by file-upload's add event.
    // var fileInfos = [];
    var progressAll = 0;
    var progressSingle = 0;
    var completeCount = 0;
    var isUploadError = false;

    function FileListViewModel() {
        var self = this;
        self.fileInfos = ko.observableArray([]);

        self.addFileInfo = function(fileInfo) {
            self.fileInfos.push(fileInfo);
        };

        self.removeFileInfo = function(index) {
            self.fileInfos.splice(index, 1);
        };
    }

    var fileListViewModel = new FileListViewModel();

    wizardFileUpload.initFileUploadForm = function(form) {

        ko.applyBindings(fileListViewModel, document.getElementById('filenameListContainer'));
        initJqueryUpload(form);

        $('#uploadFileType').change(function() {
            fileListViewModel.fileInfos([]);
        });

        $(form).find('#uploadWidgetCover').text('');
        $(form).find('#uploadProgressBar').hide().find('.bar').css({'width': '0'});
        $('#uploadProgressText').hide();
        $('#uploadPanel').find('#uploadBtn').click(submitFiles);
    };

    function initJqueryUpload(form) {
        $(form).find('input[name="upload_file"]').fileupload({
            dataType: 'json',
            url: 'DataImportWizard/acceptFileFromWizard.php',
            acceptFileTypes: '/(\.|\/)(xlsx?|csv|sql)$/i',
            sequentialUploads: true,
            add: function(e, data) {

                // When file type is db dump, we only accept one file.
                if ($('#uploadFileType').val() == 'dbDump') {
                    var singleFile = [];
                    singleFile.push(data);
                    fileListViewModel.fileInfos(singleFile);
                } else {
                    fileListViewModel.addFileInfo(data);
                }

                $('#uploadPanel').show().find('#uploadBtn').show();
            },
            send: function(e, data) {
                progressSingle = 0;
            },
            done: function(e, data) {

                completeCount++;
                progressAll += progressSingle;
                var resultJson = data.result;
                var messageDom = $('#uploadMessage');

                if (resultJson.isSuccessful && completeCount == fileListViewModel.fileInfos().length) {

                    $('#uploadPanel').fadeOut();
                    $('#isImport').val(false);

                    $(messageDom).css('color', 'green');
                    $('#uploadFileType').add('#dbType').prop('disabled', true);
                    $('input[name="place"]').prop('disabled', true);

                    fileListViewModel.fileInfos([]);

                    if ($('#uploadFileType').val() == 'dbDump') {
                        connectFromDumpFile();
                    } else {
                        $(messageDom).text(resultJson.message);
                        wizard.enableNextButton();
                    }
                } else if (resultJson.isSuccessful === false) {
                    isUploadError = true; // Used to cancel subsquent uploadings.
                    $('#uploadPanel').fadeOut();
                    $(messageDom).css('color', 'red').text(resultJson.message);
                }
            },
            progress: function(e, data) {
                progressSingle = Math.round(data.loaded / data.total * 100, 10) / fileListViewModel.fileInfos().length;
                var progressAllTemp = progressAll + progressSingle / fileListViewModel.fileInfos().length;
                if (progressAllTemp >= 99) {
                    if ($('#uploadFileType').val() == 'dataFile') {
                        var processingText = 'Processing...';
                    } else {
                        var processingText = 'Importing dump file...';
                    }
                    $('#uploadMessage').css('color', '').text(processingText);
                }

                $('#uploadProgressText').text(Math.round(progressAllTemp) + '%');
                $('#uploadProgressBar').find('.bar').css('width', Math.round(progressAllTemp) + '%');
            }
        });
    }

    function submitFiles() {
        var fileType = $('#uploadFileType').val();
        if (fileType == 'dataFile') {
            var acceptedFileTypes = /\.(xlsx?|csv|zip)$/i;
            var fileNotAcceptedMsg = '(.csv, .excel, or .zip file)';
        } else {
            var acceptedFileTypes = /\.(zip|sql)$/i;
            var fileNotAcceptedMsg = '(.sql or .zip file)';
        }

        for (var i = 0; i < fileListViewModel.fileInfos().length; i++) {
            var fileInfo = fileListViewModel.fileInfos()[i];
            if (!acceptedFileTypes.test(fileInfo.files[0].name)) {
                $('#uploadMessage').css('color', 'red').text('Please select a valid file ' + fileNotAcceptedMsg + '.');
                return;
            }
        }

        progressAll = 0;
        completeCount = 0;
        isUploadError = false;

        // Used to identify the files are uploaded at the same time.
        $('#uploadTimestamp').val(new Date().getTime());

        $('#uploadProgressBar').add($('#uploadProgressText')).show();
        for (var i = 0; i < fileListViewModel.fileInfos().length && !isUploadError; i++) {
            var fileInfo = fileListViewModel.fileInfos()[i];
            fileInfo.submit();
        }
    }

    function connectFromDumpFile() {

        $('input[id="database"]').attr('checked', true);

        var messageDom = $('#uploadMessage');
        $(messageDom).text('Connecting to database...');

        // Jump to "From database" and fill inputs to tell user the database is built from dump file.
        var dbType = $('#dbType').val();
        $('#selectDBServer option[value="' + dbType + '"]').prop('selected', true);
        $('#selectDBServer').val('Colfusion Server');
        $('#dbServerDatabase').val('Dump File');
        $('#selectDBServer')
                .add('#dbServerName')
                .add('#dbServerPort')
                .add('#dbServerUserName')
                .add('#dbServerPassword')
                .add('#dbServerDatabase').prop('disabled', true);
        $('#isImport').val(true);

        wizardFromDB.TestDBConnection(null, null, null, null, null, $('#dbType').val(), null, true).done(function(data) {
            $(messageDom).css('color', data.isSuccessful ? 'green' : 'red').text(data.message);
        });
    }

    return wizardFileUpload;
})();

function SourceWorksheetSettingsViewModel() {
    var self = this;
    self.sourceWorksheetSettings = ko.observableArray();
    self.isPreviewLoadingComplete = ko.observable(true);
    self.loadingProgress = ko.observable();

    self.addSource = function(sourceName, worksheets) {
        self.sourceWorksheetSettings.push(new SourceWorksheetSettings(sourceName, worksheets));
    };

    self.cleanSource = function() {
        self.sourceWorksheetSettings([]);
    };

    self.setTimeProgress = function(startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval) {
        self.loadingProgress(new KnockoutUtil.TimeProgress(startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval));
        self.loadingProgress().start();
    };

    self.getSourceWorksheetSettings = function() {
        var sourceWorksheetSettingsWithoutObservable = {};
        for (var i = 0; i < self.sourceWorksheetSettings().length; i++) {
            var sourceWorksheetSettings = self.sourceWorksheetSettings()[i];
            sourceWorksheetSettingsWithoutObservable[sourceWorksheetSettings.sourceName] =
                    sourceWorksheetSettings.getWorksheetSettings();
        }
        return sourceWorksheetSettingsWithoutObservable;
    };
}

function SourceWorksheetSettings(sourceName, worksheets) {
    var self = this;
    self.sourceName = sourceName;
    self.worksheets = ko.observableArray(worksheets);
    self.numOfWorksheets = ko.observable(0);
    self.numOfWorksheetsOptions = ko.observableArray([]);
    self.worksheetSettings = ko.observableArray();

    for (var i = 0; i < worksheets.length; i++) {
        self.numOfWorksheetsOptions.push(i + 1);
    }

    self.chooseNumOfWorsheets = function() {
        self.worksheetSettings([]);
        for (var i = 0; i < self.numOfWorksheets(); i++) {
            self.worksheetSettings.push(new WizardExcelPreviewProperties.WorksheetSetting(self.worksheets()[i], 1, 'A'));
        }
    };

    self.getWorksheetSettings = function() {
        // $sheetsRange = {'sheetName' : {startRow, startColumn, rowNum}} 
        var sheetsRange = {};
        var worksheetSettings = self.worksheetSettings();

        for (var index in worksheetSettings) {
            var worksheetSetting = worksheetSettings[index];
            sheetsRange[worksheetSetting.sheetName()] = {};
            sheetsRange[worksheetSetting.sheetName()]['startRow'] = worksheetSetting.startRow();
            sheetsRange[worksheetSetting.sheetName()]['startColumn'] = worksheetSetting.startColumn();
            sheetsRange[worksheetSetting.sheetName()]['rowNum'] = worksheetSetting.rowNum;
        }

        return sheetsRange;
    };
}