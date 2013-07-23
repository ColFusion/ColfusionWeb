var importWizard = (function() {
    var importWizard = {};

    /* Variables */

    var sourceType = "";

    importWizard.loadingGif = "";

    /*************/

    /* Functions */


    importWizard.Init = function() {
        wizardFromFile.Init();

        $.ajaxSetup({
            data: {sid: sid},
            error: function(jqXHR, textStatus, errorThrown) {
                triggerError();
            }
        });

        $("#computer").click(function() {
            $('#divFromComputer').show();
            $('#divFromDatabase').hide();
            $('#divFromInternet').hide();
        });

        $("#internet").click(function() {
            $('#divFromComputer').hide();
            $('#divFromDatabase').hide();
            $('#divFromInternet').show();
        });

        $("#database").click(function() {
            $('#divFromComputer').hide();
            $('#divFromDatabase').show();
            $('#divFromInternet').hide();
        });


        $('#divFromComputer').hide();
        $('#divFromInternet').hide();
        $('#divFromDatabase').hide();
        $('#h1').hide();
        $('#h2').hide();
        $('#h3').hide();
        $('#h4').hide();

        $('div[id^=inDiv]').hide();
        $('div[id^=suggested]').hide();
        $('div[id^=sugmoreDiv]').hide();

        $('#more').click(function(event) {

            $("#inDiv").dialog({
                width: 600,
                modal: true,
                //position: relative,
                //zIndex: 39990,
                close: function(event, ui) {
                    $("#inDiv").hide();
                }
            });
        });


        $("#help1").click(function() {
            $('#h1').show();
        });

        $("#hd1").click(function() {
            $('#h1').hide();
        });

        $("#help2").click(function() {
            $('#h2').show();
        });

        $("#hd2").click(function() {
            $('#h2').hide();
        });

        $("#help3").click(function() {
            $('#h3').show();
        });

        $("#hd3").click(function() {
            $('#h3').hide();
        });

        $("#help4").click(function() {
            $('#h4').show();
        });

        $("#hd4").click(function() {
            $('#h4').hide();
        });

        $("#toggleAllColumns").click(function() {
            $('#toggleAllColumns').change(function() {
                $('input[name="columns[]"]').prop('checked', this.checked);
            });
        });

        $("#done").click(function() {
            document.getElementById("final").disabled = false;
            finishSubmittingData();
        });

        $("img").tooltip();

        initBootstrapWizard();

        importWizard.loadingGif = "<img src='" + my_pligg_base + "/templates/wistie/images/ajax-loader_cp.gif'/>";
    };

    //***********************************************************************************************
    // For STEP 3 in wizard (Schems Matching)

    // is callsed by dropdown change event which coming from generate_ktr.php file
    // Candidate for knowout.js
    importWizard.checkToEnableInputByUserOnSchemaMatchingStep = function(name) {

        if (document.getElementById(name).value == 'other') {
            //var input = document.getElementById(name+'2');
            var input = $('#' + name + '2');
            input.toggle();
            //input.disabled = false;

            if (input.id != "Location2" && input.id != "AggrType2" && input.value == "")
            {
                var d = new Date();

                var month = d.getMonth() + 1;
                var day = d.getDate();

                var output = d.getFullYear() + '/' +
                        (month < 10 ? '0' : '') + month + '/' +
                        (day < 10 ? '0' : '') + day;

                input.val(output);
            }
        }
        else {
            $('#' + name + '2').toggle();
            //document.getElementById(name+'2').disabled = true;
            document.getElementById(name).focus();
        }
    };

    importWizard.checkToEnableNextButtonOnSchemaMatchinStep = function() {
        if ((document.getElementById('Spd').value != -1) && (document.getElementById('Drd').value != -1) && (document.getElementById('Location').value != -1) &&
                (document.getElementById('AggrType').value != -1) && (document.getElementById('Start').value != -1) && (document.getElementById('End').value != -1)) {
            wizard.enableNextButton();
        }
    };

    importWizard.getSchemaMatchingUserInputs = function() {
        var spd = $('#Spd').val();
        var drd = $('#Drd').val();
        var start = $('#Start').val();
        var end = $('#End').val();
        var location = $('#Location').val();
        var aggrtype = $('#AggrType').val();

        var spd2 = $('#Spd2').val();
        var drd2 = $('#Drd2').val();
        var start2 = $('#Start2').val();
        var end2 = $('#End2').val();
        var location2 = $('#Location2').val();
        var aggrtype2 = $('#AggrType2').val();

        return {"spd": spd, "spd2": spd2, "drd": drd, "drd2": drd2, "start": start, "end2": end2, "start2": start2, "end": end, "location": location,
            'location2': location2, 'aggrtype': aggrtype, 'aggrtype2': aggrtype2};
    };

    importWizard.getDataMatchingUserInputs = function() {
        var result = new Array();

        var checkboxes = document.getElementsByName('columns[]');

        for (var i = 0; i < checkboxes.length; i++) {

            if (checkboxes[i].checked == true) {

                var m_check = "match_checkbox" + i;
                var suggest = "suggest_from_user" + i;

                var metadata = new Array();

                var metaCheckboxes = document.getElementsByName(m_check);
                for (var j = 0; j < metaCheckboxes.length; j++) {

                    if (metaCheckboxes[j].checked == true) {

                        metadata.push({
                            'category': metaCheckboxes[j].value,
                            'suggestedValue': document.getElementsByName(suggest)[j].value
                        });
                    }
                }

                result.push({
                    'originalDname': checkboxes[i].value,
                    'newDname': document.getElementsByName('Dname')[i].value,
                    'type': document.getElementsByName('dname_value_type')[i].value,
                    'unit': document.getElementsByName('dname_value_unit')[i].value,
                    'description': document.getElementsByName('dname_value_description')[i].value,
                    'tableName': document.getElementsByName('dname_value_tableName')[i].value,
                    'metadata': metadata
                });
            }
        }

        return result;
    };

    importWizard.passInfofromDisplayOptionsStep = function() {
        $('#schemaMatchinStepInProgressWrapper').show();
        $("#schemaMatchinTable").empty();
        document.getElementById("schemaMatchinTable").innerHTML = '';
        if (getImportSource() == "database") {
            var deferred = wizardFromDB.passSelectedTablesFromDisplayOptionStep();
        }
        else {
            var deferred = wizardFromFile.passSheetInfoFromDisplayOptionStep();
        }
        deferred.done(function(data) {
            importWizard.showSchemaMatchingStep(data);
        });
    };

    importWizard.showSchemaMatchingStep = function(data) {

        $('#schemaMatchinStepInProgressWrapper').hide();
        $("#schemaMatchinTable").html(data);
        importWizard.checkToEnableNextButtonOnSchemaMatchinStep();

        var datePickerOption = {
            changeMonth: true,
            changeYear: true,
            dateFormat: "yy/mm/dd",
            yearRange: "0:2023"
        };

        $("#Spd2").datepicker(datePickerOption);
        $("#Drd2").datepicker(datePickerOption);
        $("#Start2").datepicker(datePickerOption);
        $("#End2").datepicker(datePickerOption);
    };

    importWizard.passSchemaMatchinInfo = function() {
        $('#dataMatchingTable').empty();
        if (getImportSource() == "database") {
            var deferred = wizardFromDB.passSchemaMatchinInfo(importWizard.getSchemaMatchingUserInputs());
        }
        else {
            var deferred = wizardFromFile.passSchemaMatchinInfo(importWizard.getSchemaMatchingUserInputs());
        }
        deferred.done(function(data) {
            importWizard.showDataMatchingStep(data);
        });
    };

    importWizard.showDataMatchingStep = function(data) {
        $('#dataMatchingTable').html(data);
        $('#dataMatchingStepInProgress').hide();
    };
    //***********************************************************************************************  


    /*************/

    /* Helper functions */

    function initBootstrapWizard() {
        $.fn.wizard.logging = false;

        wizard = $("#wizard-demo").wizard();

        wizard.cards['displayOptionsStepCard'].on("validate", function(card) {
            if (getImportSource() == 'database') {
                return isDbSourceSelected($('#displayOptoinsStepCardFromDBForm'));
            } else {
                return isFileSourceSelected($('#displayOptoinsStepCardFromFileForm'));
            }
        });

        $(".chzn-select").chosen();

        wizard.el.find(".wizard-ns-select").change(function() {
            wizard.el.find(".wizard-ns-detail").show();
        });

        wizard.el.find(".create-server-service-list").change(function() {
            var noOption = $(this).find("option:selected").length == 0;
            wizard.getCard(this).toggleAlert(null, noOption);
        });

        // steps
        wizard.cards["UploadOptionStepCard"].on("validated", function(card) {
            var hostname = card.el.find("#new-server-fqdn").val();
        });

        wizard.cards["displayOptionsStepCard"].on("selected", displayOptionsStepCardOnLoad);

        wizard.cards["schemaMatchinStepCard"].on("selected", function(card) {
            wizard.disableNextButton();
            importWizard.passInfofromDisplayOptionsStep();
        });

        wizard.cards["dataMatchingStepCard"].on("selected", function(card) {
            importWizard.passSchemaMatchinInfo();
        });

        wizard.on("submit", function(wizard) {
            $('#dataMatchingStepInProgress').show();

            var submit = {
                "hostname": $("#new-server-fqdn").val()
            };

            var bck_btn = '<button class="btn wizard-back" type="button">Back</button>';

            $('button.wizard-close').hide();
            execute().done(function(resultJson) {
                $('button.wizard-close').show();

                $("#exe").html(resultJson.message);
                if (resultJson.isSuccessful) {
                    wizard.trigger("success");

                    wizard.hideButtons();
                    wizard._submitting = false;
                    wizard.showSubmitCard("success");

                    $('#fromDataSetWrapper').find('.sidInput').val('New Dataset');
                } else {
                    $("#exe").html(resultJson.message);
                }
            });
        });

        wizard.on("reset", function(wizard) {
            wizardFromFile.resetFileUploadForm();
            wizard.setSubtitle("");
            wizard.el.find("#new-server-fqdn").val("");
            wizard.el.find("#new-server-name").val("");
        });

        wizard.el.find(".wizard-success .im-done").click(function() {
            wizard.reset().close();
        });

        wizard.el.find(".wizard-success .create-another-server").click(function() {
            wizard.reset();
        });

        $(".wizard-group-list").click(function() {
            alert("Disabled for demo.");
        });

        $("#open-wizard").click(function() {

            // set sid for uplod file form. Tried to set it in Init, didn't work, value was empty
            $('#sid', '#upload_form').val($('#sid', '#thisform').val());

            wizard.show();
            wizard.disableNextButton();
            return false;
        });

        $('.wizard-back').bind('click', function() {
            wizard.enableNextButton();
        });
    }

    function finishSubmittingData() {
        dataPreviewViewModel.getTablesList();
        relationshipViewModel.mineRelationships(10, 1);
        loadInitialFromDataSet();
    }

    function execute() {
        if (getImportSource() == "database") {
            return wizardFromDB.excuteFromDB();
        } else {

            var callExecuteKtr = function() {
                return $.ajax({
                    url: my_pligg_base + "/DataImportWizard/execute_ktr.php?sid=" + $('#sid').val(),
                    type: 'get',
                    dataType: 'json'
                });
            };

            return $.when(wizardFromFile.excuteFromFile()).then(callExecuteKtr);
        }
    }

    // Step 2
    function displayOptionsStepCardOnLoad(card) {
        if (getImportSource() == "database") {
            $("#displayOptoinsStepCardFromFile").hide();
            $("#displayOptoinsStepCardFromDB").show();
            $('#loadingProgressContainer').show();

            $("#displayOptoinsStepCardFromDB").append(importWizard.loadingGif);
            wizardFromDB
                    .LoadDatabaseTables($("#dbServerName").val(), $("#dbServerUserName").val(), $("#dbServerPassword").val(), $("#dbServerDatabase").val(), $('#dbServerPort').val(), $('#selectDBServer').val(), $('#isImport').val())
                    .done(function(JSON_Response) {
                $('#loadingProgressContainer').hide();
                printTableList($("#displayOptoinsStepCardFromDB"), JSON_Response);
                wizard.enableNextButton();
            });
        }
        else {
            $("#displayOptoinsStepCardFromFile").hide();
            $("#displayOptoinsStepCardFromDB").hide();

            wizard.disableNextButton();

            $('#loadingProgressContainer').show();
            wizardFromFile.createKtrFiles().done(function() {            
                wizardFromFile.getFileSources().done(function(jsonResponse) {
                    var filenames = [];
                    for (var i = 0; i < jsonResponse.data.length; i++) {
                        var fileSource = jsonResponse.data[i];
                        filenames.push(fileSource.filename);                       
                    }
                    wizardFromFile.showExcelFile(filenames);
                }).done(function() {
                    $('#loadingProgressContainer').hide();
                    $("#displayOptoinsStepCardFromFile").show();
                    wizard.enableNextButton();
                });               
            }).fail(function() {
                $('#loadingProgressContainer').hide();
            });
        }
    }

    function printTableList(container, JSON_Response) {
        container.empty();

        if (JSON_Response.isSuccessful) {
            var el = "<p>Tables in selected database:</p><div style='height: 80%; overflow-y: scroll;'>";
            for (var i = 0; JSON_Response.data && i < JSON_Response.data.length; i++) {
                el += "<label style='display: inline;'><input type='checkbox' name='table[]' value='" + JSON_Response.data[i] + "'/>" + JSON_Response.data[i] + "</lable><br/>";
            }
            el += "</div>";
        } else {
            var el = "<p style='color:red;'>Errors occur when loading tables.</p>";
        }

        container.append(el);
    }

    function getImportSource() {
        if ($("input[name='place']:checked").val() == "database" || $('#uploadFileType').val() == 'dbDump') {
            return 'database';
        } else {
            return 'file';
        }
    }

    function isDbSourceSelected(inputContainer) {
        return true;
    }

    function isFileSourceSelected(inputContainer) {
        $(inputContainer).parsley('destroy');
        $(inputContainer).parsley({
            validators: {
                excelcol: function(val, attrVal) {
                    var isValid = Boolean(val);
                    var Acode = 'A'.charCodeAt(0);
                    var Zcode = 'Z'.charCodeAt(0)

                    for (var i = 0; i < val.length; i++) {
                        var charCode = val.charCodeAt(i);
                        isValid = isValid && Acode <= charCode && Zcode >= charCode;
                    }

                    return isValid;
                }
            }
            , messages: {
                excelcol: "This value should be a valid excel column"
            }
        });
        var isValid = $(inputContainer).parsley('validate');
        return isValid;
    }

    function triggerError() {
        console.log('error is triggered');
        wizard.trigger("error");
        wizard._submitting = false;
        wizard.showSubmitCard("error");
        wizard.updateProgressBar(0);
    }

    /********************/

    return importWizard;
})();