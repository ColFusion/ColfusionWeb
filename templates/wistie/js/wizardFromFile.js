var wizardFromFile = (function() {
    var wizardFromFile = {};

    /* Variables */

    var intervals = new Array();
    var wizardExcelPreviewViewModel;

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

        var options = {
            beforeSubmit: showRequest, // pre-submit callback 
            success: showResponse  // post-submit callback 
        };

        // bind form using 'ajaxForm' 
        wizardFileUpload.initFileUploadForm($('#upload_form'));

        wizardExcelPreviewViewModel = new WizardExcelPreviewViewModel($('#sid').val());
        var secondNode = document.getElementById('second');
        ko.cleanNode(secondNode);
        ko.applyBindings(wizardExcelPreviewViewModel, secondNode);
    };

    wizardFromFile.submitUploadForm = function()
    {
        $('#uploadingFileInProgress').show();

        //Setup timer to check file status
        intervals[0] = setInterval("wizardFromFile.getUploadMsg()", 1000);

        intervals[1] = 0;
    };

    wizardFromFile.getUploadMsg = function() {

        var xmlHttp = importWizard.getXMLHttp();

        xmlHttp.open("GET", my_pligg_base + '/DataImportWizard/acceptFileFromWizard.php?phase=1&sid=' + $('#sid').val(), false);
        xmlHttp.send(null);

        if (xmlHttp.responseText != "") {
            clearInterval(intervals[0]);

            $('#uploadingFileInProgress').hide();

            document.getElementById("result").innerHTML = xmlHttp.responseText;
            wizard.enableNextButton();
            //getName();
        }
        else {
            clearInterval(intervals[0]);
        }
    };

    wizardFromFile.getFileExtentsion = function() {

        var xmlHttp = importWizard.getXMLHttp();

        xmlHttp.open("GET", my_pligg_base + '/DataImportWizard/acceptFileFromWizard.php?phase=3&sid=' + $('#sid').val(), false);
        xmlHttp.send(null);

        if (xmlHttp.responseText != "") {
            if (xmlHttp.responseText == 'csv') {
                document.getElementById('second').style.display = 'none';
            }
            else {
                document.getElementById('csv').style.display = 'none';
            }
        }
        else {
            alert("No response!");
        }

        return xmlHttp.responseText;
    };


    wizardFromFile.showSheetRowColumnsTable = function(str) {
        if (str == "") {
            document.getElementById("txtHint").innerHTML = "";
            return;
        }

        var xmlHttp = importWizard.getXMLHttp();

        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("sheetRowColumnsTable").innerHTML = xmlhttp.responseText;
                checkToEnableNextButtonOnDisplayOptionsStep();
            }
        };
        xmlhttp.open("GET", my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=3&q=" + str + "&sid=" + $('#sid').val(), true);
        xmlhttp.send();
    };

    wizardFromFile.cleanRowInSheetRowColumnsTable = function(column_index) {
        var sheet_number = "sheet_" + column_index;

        if (document.getElementById(sheet_number).options.length != 0) {
            var row_number = "row_" + column_index;
            var column_number = "column_" + column_index;
            document.getElementById(row_number).value = "";
            document.getElementById(column_number).options.length = 0;
        }
    }


    wizardFromFile.getColumnsBySheetNumber = function(column_index) {
        var sheet_number = "sheet_" + column_index;
        var sheet_selected = document.getElementById(sheet_number).value;

        var row_number = "row_" + column_index;
        var row_selected = document.getElementById(row_number).value;

        var column_number = "column_" + column_index;

        var xmlHttp = importWizard.getXMLHttp();

        if (document.getElementById(column_number).options.length == 0) {

            // dynamic_column
            xmlhttp.open("GET", my_pligg_base + '/DataImportWizard/generate_ktr.php?phase=4&s=' + sheet_selected + '&r=' + row_selected + '&sid=' + $('#sid').val(), true);
            xmlhttp.send(null);
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

                    var teamArray = eval("(" + xmlhttp.responseText + ")");

                    var arLen = teamArray.length;

                    for (var i = 0; i < arLen; i++) {
                        document.getElementById(column_number).options[i] = new Option(teamArray[i], i);
                    }
                }
            }
        }
    }


    wizardFromFile.passSheetInfoFromDisplayOptionStep = function() {
        var sheetsRange = wizardExcelPreviewViewModel.getWorksheetSettings();
        var estimatedLoadingTimestamp = wizardExcelPreviewViewModel.estimatedTimestamp();
        var loadingTextElement = $('#schemaMatchinStepInProgressText').hide();

        // Show estimated loading time.
        setTimeout(function() {
            $(loadingTextElement).show();
            updateLoadingProgress(loadingTextElement, new Date().getTime(), estimatedLoadingTimestamp);
        }, 3500);

        $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php',
            dataType: 'html',
            data: {
                phase: 1,
                sid: $('#sid').val(),
                sheetsRange: sheetsRange,
                source: 'file'
            },
            success: function(data) {
                importWizard.showSchemaMatchingStep(data);
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

    wizardFromFile.passSchemaMatchinInfo = function() {
        var dataToSend = {'phase': '2', "schemaMatchingUserInputs": importWizard.getSchemaMatchingUserInputs()};

        // alert(JSON.stringify(dataToSend));
        $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/generate_ktr.php?sid=' + $('#sid').val(),
            data: dataToSend,
            success: function(data) {
                importWizard.showDataMatchingStep(data);
            }
        });
    }


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
    }

    wizardFromFile.showExcelFile = function() {
        var xmlHttp = importWizard.getXMLHttp();
        xmlhttp.open("GET", my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0&sid=" + $('#sid').val(), false);
        xmlhttp.send(null);

        wizardExcelPreviewViewModel.initFilePreview($('#sid').val());
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

    // pre-submit callback 
    function showRequest(formData, jqForm, options) {
        // formData is an array; here we use $.param to convert it to a string to display it 
        // but the form plugin does this for you automatically when it submits the data 
        var queryString = $.param(formData);

        // jqForm is a jQuery object encapsulating the form element.  To access the 
        // DOM element for the form do this: 
        // var formElement = jqForm[0]; 

        // here we could return false to prevent the form from being submitted; 
        // returning anything other than false will allow the form submit to continue 
        return true;
    }

    // post-submit callback 
    function showResponse(responseText, statusText, xhr, $form) {
    }

    function getUploadMsg() {

        var xmlHttp = importWizard.getXMLHttp();

        xmlHttp.open("GET", my_pligg_base + '/DataImportWizard/acceptFileFromWizard.php?phase=1&sid=' + $('#sid').val(), false);
        xmlHttp.send(null);

        if (xmlHttp.responseText != "") {
            clearInterval(intervals[0]);
            document.getElementById("result").innerHTML = xmlHttp.responseText;
            wizard.enableNextButton();
            //getName();
        }
        else {
            clearInterval(intervals[0]);
        }
    }

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

    //Enables next button in wizard.
    //TODO: replace this functionality with knowout.js
    function checkToEnableNextButtonOnDisplayOptionsStep() {

        if (document.getElementById('selectNumberOfSheets').value > 0) {
            wizard.enableNextButton();
        }
        else {
            wizard.disableNextButton();
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