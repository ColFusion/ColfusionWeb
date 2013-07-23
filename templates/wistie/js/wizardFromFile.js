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

        // bind form using 'ajaxForm' 
        wizardFileUpload.initFileUploadForm($('#upload_form'));

        wizardExcelPreviewViewModel = new WizardExcelPreviewViewModel($('#sid').val());
        var previewNode = document.getElementById('dataPreviewTabContent');
        ko.applyBindings(wizardExcelPreviewViewModel, previewNode);

        sourceWorksheetSettingsViewModel = new SourceWorksheetSettingsViewModel();
        var viewModelDom = document.getElementById('dataRangeSettingsTabContent');
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

    wizardFromFile.showExcelFile = function(filenames) {
        wizardExcelPreviewViewModel.initFilePreview($('#sid').val(), filenames);
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
    
        var sheetsRanges = sourceWorksheetSettingsViewModel.getSourceWorksheetSettings();
    
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
            data: dataToSend
        });
    };

    wizardFromFile.resetFileUploadForm = function() {
        $('#uploadWidgetCover').text('No file chosen');
        $('#uploadMessage').text('');
        $('#uploadProgressText').text('0%').hide();
        $('#uploadProgressBar').hide().find('.bar').css('width', '0');
        $('input[name="place"]').removeAttr('checked');
        $('#divFromComputer').add('#divFromInternet').add('#divFromDatabase').hide();
        $('#selectDBServer')
                .add('#dbServerName')
                .add('#dbServerPort')
                .add('#dbServerUserName')
                .add('#dbServerPassword')
                .add('#dbServerDatabase')
                .add('#excelFileMode')
                .add('#uploadFileType')
                .add('#dbType').prop('disabled', false);
        $('input[name="place"]').prop('disabled', false);
        var uploadForm = $('#upload_form');
        var newUploadForm = $(uploadForm).clone();
        $(uploadForm).remove();
        $('#divFromComputer').prepend(newUploadForm);
        wizardFileUpload.initFileUploadForm(newUploadForm);
    };

    wizardFromFile.toggleSourceSelectionPanel = function(liDom, contentSelector){
        $(liDom).parent().find('.icon-caret-right').css('visibility', 'hidden');
        $(liDom).children('.icon-caret-right').css('visibility', 'visible');
        $('#sourceSelectionNavContents').children('*').hide();
        $(contentSelector).show();
    };

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
            if (self.fileInfos().length === 0) {
                $('#uploadPanel').hide();
            }
        };
    }

    var fileListViewModel;

    wizardFileUpload.initFileUploadForm = function(form) {

        $('#dbType').hide();
        $(form).find('#uploadFileType').change(function() {
            if ($(this).val() == 'dbDump') {
                $('#dbType').show();
                $('#excelFileMode').hide();
            } else {
                $('#dbType').hide();
                $('#excelFileMode').show();
            }
        });

        fileListViewModel = new FileListViewModel();
        ko.cleanNode(document.getElementById('filenameListContainer'));
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
                    $('#uploadFileType').add('#dbType').add('#excelFileMode').prop('disabled', true);
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