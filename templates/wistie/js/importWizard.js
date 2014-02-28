var importWizard = (function () {
    var importWizard = {};

    importWizard.loadingGif = "";
    importWizard.wizardDataMatchingStepViewModel = new WizardDataMatchingStepViewModel();

    importWizard.wizardUploadDatasetViewModel = new WizardUploadDatasetViewModel();

    importWizard.sid = "";

    importWizard.Init = function (sid) {
        importWizard.sid = sid;
        wizardFromFile.Init(sid);

       

        // $.ajaxSetup({
        //     data: {
        //         sid: sid
        //     },
        //     error: function (jqXHR, textStatus, errorThrown) {
        //         triggerError();
        //     }
        // });

        $("#computer").click(function () {
            $('#divFromComputer').show();
            $('#divFromDatabase').hide();
            $('#divFromInternet').hide();
        });

        $("#internet").click(function () {
            $('#divFromComputer').hide();
            $('#divFromDatabase').hide();
            $('#divFromInternet').show();
        });

        $("#database").click(function () {
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

        $('#more').click(function (event) {

            $("#inDiv").dialog({
                width: 600,
                modal: true,
                // position: relative,
                // zIndex: 39990,
                close: function (event, ui) {
                    $("#inDiv").hide();
                }
            });
        });

        $("#help1").click(function () {
            $('#h1').show();
        });

        $("#hd1").click(function () {
            $('#h1').hide();
        });

        $("#help2").click(function () {
            $('#h2').show();
        });

        $("#hd2").click(function () {
            $('#h2').hide();
        });

        $("#help3").click(function () {
            $('#h3').show();
        });

        $("#hd3").click(function () {
            $('#h3').hide();
        });

        $("#help4").click(function () {
            $('#h4').show();
        });

        $("#hd4").click(function () {
            $('#h4').hide();
        });

        $('#toggleAllColumns').change(function () {
            $('input[name="columns[]"]').prop('checked', this.checked);
        });

        $("#done").click(function () {
            document.getElementById("finishYourSubmissionButton").disabled = false;
            finishSubmittingData();
        });

        $("img").tooltip();

        
        initBootstrapWizard();

        
        importWizard.loadingGif = "<img src='" + my_pligg_base + "/templates/wistie/images/ajax-loader_cp.gif'/>";

        //ko.applyBindings(importWizard.wizardUploadDatasetViewModel, document.getElementById('filenameListContainer'));

        ko.applyBindings(importWizard.wizardDataMatchingStepViewModel, document.getElementById('dataMatchingStepCard'));
    };

    // ***********************************************************************************************
    // For STEP 3 in wizard (Schems Matching)

    // is callsed by dropdown change event which coming from generate_ktr.php
    // file
    // Candidate for knowout.js

    importWizard.getDataMatchingUserInputs = function () {
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
                            'suggestedValue': document
									.getElementsByName(suggest)[j].value
                        });
                    }
                }

                result
						.push({
						    'originalDname': checkboxes[i].value,
						    'newDname': document.getElementsByName('Dname')[i].value,
						    'type': document
									.getElementsByName('dname_value_type')[i].value,
						    'unit': document
									.getElementsByName('dname_value_unit')[i].value,
						    'description': document
									.getElementsByName('dname_value_description')[i].value,
						    'tableName': document
									.getElementsByName('dname_value_tableName')[i].value,
						    'metadata': metadata
						});
            }
        }

        return result;
    };

    importWizard.getDataMatchingLoadingProgress = function () {
        if (getImportSource() == "database") {
            importWizard.dataMatchingProgressViewModel.stop();
        } else {
            return wizardFromFile.getLoadingTime();
        }
    };
    
    // ***********************************************************************************************

    /** ********** */

    /* Helper functions */

    function initBootstrapWizard() {
        $.fn.wizard.logging = true;

        wizard = $("#dataSubmissionWizardContainer").wizard();

        wizard.cards['displayOptionsStepCard']
				.on(
						"validate",
						function (card) {
						    if (getImportSource() == 'database') {
						        return isDbSourceSelected($('#displayOptoinsStepCardFromDBForm'));
						    } else {
						        return isFileSourceSelected($('#displayOptoinsStepCardFromFileForm'));
						    }
						});

        $(".chzn-select").chosen();

        wizard.el.find(".wizard-ns-select").change(function () {
            wizard.el.find(".wizard-ns-detail").show();
        });

        wizard.el.find(".create-server-service-list").change(function () {
            var noOption = $(this).find("option:selected").length == 0;
            wizard.getCard(this).toggleAlert(null, noOption);
        });

        // steps
        wizard.cards["UploadOptionStepCard"].on("validated", function (card) {
        });

        wizard.cards["displayOptionsStepCard"].on("selected", function(card) {
				displayOptionsStepCardOnLoad(card);
            });

        wizard.cards["dataMatchingStepCard"].on("selected", function (card) {
            wizard.disableNextButton();

            
            //TODO: the settings should be send as a general json, so it should not depend on the source type.
            var sourceSettings = wizardFromFile.sourceWorksheetSettingsViewModel.getSourceWorksheetSettings();
            importWizard.wizardDataMatchingStepViewModel.fetchVariables(getImportSource(), sourceSettings, function () {
                    wizard.enableNextButton();
                });
        });

        wizard.on("submit", function(wizard) {
            //TODO: I don't know, but if not wrapping it in the functino here, the onWizard... got called on page load

            importWizard.onWizardSubmitClick(wizard);
        });

        wizard.on("reset", function (wizard) {
            wizardFromFile.resetFileUploadForm();
            wizard.setSubtitle("");
        });

        wizard.el.find(".wizard-success .im-done").click(function () {
            wizard.reset().close();
        });

        wizard.el.find(".wizard-success .create-another-server").click(
				function () {
				    wizard.reset();
				});

        $("#open-wizard").click(function () {

            // set sid for uplod file form. Tried to set it in Init, didn't
            // work, value was empty
            $('#sid', '#upload_form').val($('#sid', '#thisform').val());

            wizard.show();
            wizard.disableNextButton();
            return false;
        });
    }

    // Performs submission of data matching staff and triggers data load on the server (e.g. ktr exec)
    // Also transitions on the last page of the wizard where the message of success/or failure will be shown.
    importWizard.onWizardSubmitClick = function(wiz) {
        $('#dataMatchingStepInProgress').show();

        $('button.wizard-close').hide();

        var submitDataDeffered = importWizard.wizardDataMatchingStepViewModel.getSubmitDataAsDeffered(getImportSource());

        submitDataDeffered.done(function(data) {
            if (data.isSuccessful) {
                var tiggerDataLoadDeffered = importWizard.triggerDataLoadOnServerAsDeffered();

                tiggerDataLoadDeffered.done(function(data) {
                    if (data.isSuccessful) {
                        wizard.trigger("success");

                        wizard.hideButtons();
                        wizard._submitting = false;
                        wizard.showSubmitCard("success");

                        $('#fromDataSetWrapper').find('.sidInput').val('New Dataset');
                    }
                    else {
                        wiz.trigger("failure");
                        $("#messageContainer").html(data.message);
                    }
                })
                .fail(function(data) {
                    wiz.trigger("failure");
                    $("#messageContainer").html("Could not perform submission request. Please try again later.");
                });
            }
            else {
                wiz.trigger("failure");
                $("#messageContainer").html(data.message);
            }
        })
        .fail(function(data) {
            wiz.trigger("failure");
            $("#messageContainer").html("Could not perform submission request. Please try again later.");
        });
    }

    importWizard.triggerDataLoadOnServerAsDeffered = function() {
        return $.ajax({
            url: ColFusionServerUrl + "/Wizard/triggerDataLoad/" + importWizard.sid, //my_pligg_base + '/DataImportWizard/generate_ktr.php',
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true
        });
    }

    function finishSubmittingData() {
       $("#dockcontent"). removeClass('hidden').addClass('show');
       $("#dataSubmissionStep3Container"). removeClass('hidden').addClass('show');
       
        dataPreviewViewModel.getTablesList();
        relationshipViewModel.mineRelationships(10, 1);
        loadInitialFromDataSet();
    }

    function execute() {
        if (getImportSource() == "database") {
            return wizardFromDB.executeFromDB();
        } else {

            var callExecuteKtr = function () {
                console.log("callExecuteKtr");
                return $.ajax({
                    url: my_pligg_base
							+ "/DataImportWizard/execute_ktr.php?sid="
							+ $('#sid').val(),
                    type: 'get',
                    dataType: 'json'
                });
            };

            return $.when(wizardFromFile.executeFromFile())
					.then(callExecuteKtr);
        }
    }

    // Step 2
    function displayOptionsStepCardOnLoad(card) {
        if (getImportSource() == "database") {
            $("#displayOptoinsStepCardFromFile").hide();
            $("#displayOptoinsStepCardFromDB").show();
            $('#loadingProgressContainer').show();

            $("#displayOptoinsStepCardFromDB").append(importWizard.loadingGif);
            wizardFromDB.LoadDatabaseTables($("#dbServerName").val(),
					$("#dbServerUserName").val(), $("#dbServerPassword").val(),
					$("#dbServerDatabase").val(), $('#dbServerPort').val(),
					$('#selectDBServer').val(), $('#isImport').val()).done(
					function (JSON_Response) {
					    $('#loadingProgressContainer').hide();
					    printTableList($("#displayOptoinsStepCardFromDB"),
								JSON_Response);
					    wizard.enableNextButton();
					});
        } else {
            $("#displayOptoinsStepCardFromFile").hide();
            $("#displayOptoinsStepCardFromDB").hide();

            wizard.disableNextButton();

            $('#loadingProgressContainer').show();
          //  var deffered = wizardFromFile.createKtrFiles();

           // deffered.done(function(data) {
          //      alert("iamdone");

            try {
                var deffered = wizardFromFile.getFileSources();
                
                deffered.done(function(data) {
                        $('#loadingProgressContainer').hide();
                        $("#displayOptoinsStepCardFromFile").show();
                        wizard.enableNextButton();
                }).fail(function(data) {
                    $('#loadingProgressContainer').hide();
                });
            }
            catch(err) {
                alert(err);
            }
        }
    }

    function printTableList(container, JSON_Response) {
        container.empty();

        if (JSON_Response.isSuccessful) {
            var el = "<p>Tables in selected database:</p><div style='height: 80%; overflow-y: scroll;'>";
            for (var i = 0; JSON_Response.data
					&& i < JSON_Response.data.length; i++) {
                el += "<label style='display: inline;'><input type='checkbox' name='table[]' value='"
						+ JSON_Response.data[i]
						+ "'/>"
						+ JSON_Response.data[i]
						+ "</lable><br/>";
            }
            el += "</div>";
        } else {
            var el = "<p style='color:red;'>Errors occur when loading tables.</p>";
        }

        container.append(el);
    }

    function getImportSource() {
        if ($("input[name='place']:checked").val() == "database"
				|| $('#uploadFileType').val() == 'dbDump') {
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
        $(inputContainer).parsley(
				{
				    validators: {
				        excelcol: function (val, attrVal) {
				            var isValid = Boolean(val);
				            var Acode = 'A'.charCodeAt(0);
				            var Zcode = 'Z'.charCodeAt(0)

				            for (var i = 0; i < val.length; i++) {
				                var charCode = val.charCodeAt(i);
				                isValid = isValid && Acode <= charCode
										&& Zcode >= charCode;
				            }

				            return isValid;
				        }
				    },
				    messages: {
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

    /** ***************** */

    return importWizard;
})();