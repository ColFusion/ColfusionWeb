var wizardFromFile = (function() {
    var wizardFromFile = {};

    var filenames = [];

    /* Variables */
    var wizardExcelPreviewViewModel;
    var sourceWorksheetSettingsViewModel;

    wizardFromFile.fromComputerUploadFileViewModel;

    wizardFromFile.sid = "";

    /*************/

    /* Functions */

    // Set KO bindings.
    wizardFromFile.Init = function(sid) {
        wizardFromFile.sid = sid;
        
        wizardExcelPreviewViewModel = new WizardExcelPreviewViewModel();
        var previewNode = document.getElementById('dataPreviewTabContent');
        ko.applyBindings(wizardExcelPreviewViewModel, previewNode);

        sourceWorksheetSettingsViewModel = new SourceWorksheetSettingsViewModel();
        var viewModelDom = document.getElementById('dataRangeSettingsTabContent');
        ko.applyBindings(sourceWorksheetSettingsViewModel, viewModelDom);

        wizardFromFile.fromComputerUploadFileViewModel = new FromComputerUploadFileViewModel(sid);
        var container = document.getElementById('divFromComputer');
        ko.applyBindings(wizardFromFile.fromComputerUploadFileViewModel, container);

        // bind form using 'ajaxForm' 
        wizardFromFile.fromComputerUploadFileViewModel.initFileUploadForm($('#upload_form'));
    };

    //Process the remote file given by the input url
    wizardFromFile.validateUrl = function() {
        var file_url = document.getElementById("in_url").value;
        var xmlHttp = importWizard.getXMLHttp();

        xmlHttp.open("GET", my_pligg_base + '/DataImportWizard/acceptFileFromWizard.php?phase=2&url=' + file_url + '&sid=' + wizardFromFile.sid, false);
        xmlHttp.send(null);

        if (xmlHttp.responseText !== "") {
            
            document.getElementById("result").innerHTML = xmlHttp.responseText;
            //alert(file_url+xmlHttp.responseText);
            wizard.enableNextButton();
        } else {
            alert("No response!");
        }
    };

    wizardFromFile.createKtrFiles = function() {
        $.ajax({
            url: ColFusionServerUrl + "/Wizard/createTemplate", //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'post',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify({
                sid: wizardFromFile.sid,
                fileMode: wizardFromFile.fromComputerUploadFileViewModel.selectedFileMode().fileMode,
                fileName: wizardFromFile.fromComputerUploadFileViewModel.uploadedFileInfos()
            })
        });
    };

    wizardFromFile.showExcelFile = function() {

        $("#previewFiles").show();
        $("#showFilePreviewButtonContainer").hide();

        wizardExcelPreviewViewModel.initFilePreview(wizardFromFile.sid, filenames);
    };

    wizardFromFile.getLoadingTime = function() {
        return $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=9",
            type: 'post'
        });
    };

    wizardFromFile.getFileSources = function() {
        return $.ajax({
            url: ColFusionServerUrl + "/Wizard/getFilesContentInfo", //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=8",
            type: 'post',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify({
                sid: wizardFromFile.sid,
                fileMode: wizardFromFile.fromComputerUploadFileViewModel.selectedFileMode().fileMode,
                fileName: wizardFromFile.fromComputerUploadFileViewModel.uploadedFileInfos()
            }),
            success: function(jsonResponse) {
                sourceWorksheetSettingsViewModel.cleanSource();

                for (var i = 0; i < jsonResponse.payload.length; i++) {
                    var fileSource = jsonResponse.payload[i];
                    var filename = fileSource.fileName;
                    var worksheets = [];
                    for (var i = 0; i < fileSource.worksheets.length; i++) {
                         worksheets.push(fileSource.worksheets[i].sheetName);
                     }; 
                    var ext = fileSource.extension;
                    sourceWorksheetSettingsViewModel.addSource(filename, worksheets, ext);

                    filenames.push(fileSource.fileName);

                    if (ext == 'csv') {
                        var gotCSVs = true;
                    }
                }

                if (gotCSVs) {
                    
                    $("#liDataRangeSettingsDataSourceStep").hide();
                    //$("#iconCaretNextToWrenchDataSourceStep").css('visibility', 'hidden');
                    //$("#iconWrenchDataSourceStep").css('visibility', 'hidden');
          
                    $("#iconCaretNextTableDataSourceStep").css('visibility', 'visible');

              
                    $('#sourceSelectionNavContents').children('*').hide();
                    $("#dataPreviewTabContent").show();
                }
            }
        });
    };

    wizardFromFile.passSheetInfoFromDisplayOptionStep = function() {
    
        var sheetsRanges = sourceWorksheetSettingsViewModel.getSourceWorksheetSettings();
    
        return $.ajax({
            url: ColFusionServerUrl + "/Wizard/getFilesVariablesAndNameRecommendations", //my_pligg_base + '/DataImportWizard/generate_ktr.php',
            type: 'post',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: SON.stringify({
                sid: wizardFromFile.sid,
                sheetsRanges: sheetsRanges,
                source: 'file'
            })
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
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php?sid=' + wizardFromFile.sid,
            data: dataToSend
        });
    };

    wizardFromFile.executeFromFile = function() {
        importWizard.getDataMatchingUserInputs();

        var dataToSend = {
            'sid': wizardFromFile.sid,
            'phase': 5,
            'dataMatchingUserInputs': importWizard.getDataMatchingUserInputs()
        };
        
        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php',
            data: dataToSend
        });
    };

    wizardFromFile.resetFileUploadForm = function() {
        
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
//                .add('#excelFileMode')
                .add('#uploadFileType')
                .add('#fromComputerDatabaseDump').prop('disabled', false);
        $('input[name="place"]').prop('disabled', false);

        var uploadForm = $('#upload_form');
        var newUploadForm = $(uploadForm).clone();
        $(uploadForm).remove();
        $('#divFromComputer').prepend(newUploadForm);

        var container = document.getElementById('divFromComputer');
        ko.cleanNode(container);
        wizardFromFile.fromComputerUploadFileViewModel = new FromComputerUploadFileViewModel(wizardFromFile.sid);
        ko.applyBindings(wizardFromFile.fromComputerUploadFileViewModel, container);
    };

    wizardFromFile.toggleSourceSelectionPanel = function(liDom, contentSelector){
        $(liDom).parent().find('.icon-caret-right').css('visibility', 'hidden');
        $(liDom).children('.icon-caret-right').css('visibility', 'visible');
        $('#sourceSelectionNavContents').children('*').hide();
        $(contentSelector).show();
    };

    return wizardFromFile;
})();

/**
 * Knockout model for the "From Computer" part of the Upload File step of the wizard.
 * @param  {[type]} sid [description]
 * @return {[type]}     [description]
 */
function FromComputerUploadFileViewModel(sid) {
    var self = this;
    self.sid = sid;
    
    var progressAll = 0;
    var progressSingle = 0;
    var completeCount = 0;
    var isUploadError = false;

    self.uploadFormSid = ko.observable(sid);
    self.uploadTimestamp = ko.observable();
    self.uploadProgressText = ko.observable();
    self.isUploadSuccessful = ko.observable(true);
    self.uploadMessage = ko.observable();

    // Info about chosen files to be uploaded
    self.fileInfos = ko.observableArray([]);

    // Info about uploaded files. This info is returned by the server.
    self.uploadedFileInfos = ko.observableArray([]);


    self.uploadFileTypes = [
        { fileType: "dataFile", fileTypeDescripiton: "CSV, Excel File, Zip Archive" },
        { fileType: "dbDump", fileTypeDescripiton: "Database Dump File" }
    ];
    self.selectedFileType = ko.observable(self.uploadFileTypes[0]);

    self.databaseDumpEngines = [
        { dbEngine: "MySQL", dbEngineDescripiton: "MySQL" },
        //{ dbEngine: "PostgreSQL", dbEngineDescripiton: "PostgreSQL" },
        //{ dbEngine: "MSSQL", dbEngineDescripiton: "MS SQL Server" },
        //{ dbEngine: "Oracle", dbEngineDescripiton: "Oracle" }
    ];
    self.selectedDatabaseDumpEngine = ko.observable(self.databaseDumpEngines[0]);

    self.fileModes = [
        { fileMode: "append", fileModeDescripiton: "Append data into one table" },
        { fileMode: "separatelly", fileModeDescripiton: "View each file as a table" }
    ];
    self.selectedFileMode = ko.observable(self.fileModes[0]);

    self.addFileInfo = function(fileInfo) {
        self.fileInfos.push(fileInfo);
    };

    self.removeFileInfo = function(index) {
        self.fileInfos.splice(index, 1);
        if (self.fileInfos().length === 0) {
            $('#uploadPanel').hide();
        }
    };

    self.initFileUploadForm = function(form) {

        initJqueryUpload(form);

        $(form).find('#uploadProgressBar').hide().find('.bar').css({'width': '0'});
        $('#uploadProgressText').hide();
    };

    function initJqueryUpload(form) {
        $(form).find('input[name="upload_file"]').fileupload({
            dataType: 'json',
            url: ColFusionServerUrl + '/Wizard/acceptFileFromWizard', //'DataImportWizard/acceptFileFromWizard.php',
            acceptFileTypes: '/(\.|\/)(xlsx?|csv|sql)$/i',
            sequentialUploads: true,
            crossDomain: true,
            add: function(e, data) {

                // When file type is db dump, we only accept one file.
                if (self.selectedFileType().fileType == 'dbDump') {
                    var singleFile = [];
                    singleFile.push(data);
                    self.fileInfos(singleFile);
                } else {
                    self.addFileInfo(data);
                }
            },
            send: function(e, data) {
                progressSingle = 0;
            },
            done: function(e, data) {

                completeCount++;
                progressAll += progressSingle;
                var resultJson = data.result;
                self.isUploadSuccessful(resultJson.isSuccessful);

                if (resultJson.isSuccessful) {
                    self.uploadedFileInfos.push(resultJson.payload[0]);
                   

                    if (completeCount == self.fileInfos().length) {
                        $('#isImport').val(false);

                        $('#uploadFileType').add('#fromComputerDatabaseDump').add('#excelFileMode').prop('disabled', true);
                        $('input[name="place"]').prop('disabled', true);

                        self.fileInfos([]);

                        

                        if (self.selectedFileType().fileType == 'dbDump') {
                            connectFromDumpFile();
                        } else {
                            self.uploadMessage(resultJson.message);
                            wizard.enableNextButton();
                        }
                    }
                } else if (resultJson.isSuccessful === false) {
                    isUploadError = true; // Used to cancel subsquent uploadings.
                    self.uploadMessage(resultJson.message);
                }
            },
            progress: function(e, data) {
                progressSingle = Math.round(data.loaded / data.total * 100, 10) / self.fileInfos().length;
                var progressAllTemp = progressAll + progressSingle / self.fileInfos().length;
                if (progressAllTemp >= 99) {
                    var processingText = 'Processing...';
                    if (self.selectedFileType().fileType == 'dbDump') {
                        processingText = 'Importing dump file...';
                    }
                    self.isUploadSuccessful(true);
                    self.uploadMessage(processingText);
                }

                self.uploadProgressText(Math.round(progressAllTemp) + '%');
                $('#uploadProgressBar').find('.bar').css('width', Math.round(progressAllTemp) + '%');
            }
        });
    }

    self.submitFiles =  function() {
        var acceptedFileTypes = /\.(zip|sql)$/i;
        var fileNotAcceptedMsg = '(.sql or .zip file)';

        if (self.selectedFileType().fileType == 'dataFile') {
            acceptedFileTypes = /\.(xlsx?|csv|zip)$/i;
            fileNotAcceptedMsg = '(.csv, .excel, or .zip file)';
        }

        for (var i = 0; i < self.fileInfos().length; i++) {
            var fileInfo = self.fileInfos()[i];
            if (!acceptedFileTypes.test(fileInfo.files[0].name)) {
                $('#uploadMessage').css('color', 'red').text('Please select a valid file ' + fileNotAcceptedMsg + '.');
                return;
            }
        }

        progressAll = 0;
        completeCount = 0;
        isUploadError = false;

        // Used to identify the files are uploaded at the same time.
        self.uploadTimestamp(new Date().getTime());

        $('#uploadProgressBar').add($('#uploadProgressText')).show();
        for (i = 0; i < self.fileInfos().length && !isUploadError; i++) {
            var fileInfo = self.fileInfos()[i];
            fileInfo.submit();
        }
    };

    self.connectFromDumpFile = function() {

        $('input[id="database"]').attr('checked', true);

        self.isUploadSuccessful(true);
        self.uploadMessage('Connecting to database...');

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
            self.isUploadSuccessful(data.isSuccessful);
            self.uploadMessage(data.message);
        });
    }
};