var importWizard = (function () {
    var importWizard = {};

    importWizard.loadingGif = "";
    importWizard.dataMatchingProgressViewModel = new ProgressBarViewModel();

    importWizard.Init = function () {
        wizardFromFile.Init();

        $.ajaxSetup({
            data: {
                sid: sid
            },
            error: function (jqXHR, textStatus, errorThrown) {
                triggerError(jqXHR, textStatus, errorThrown);
            }
        });

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
            document.getElementById("final").disabled = false;
            finishSubmittingData();
        });

        $("img").tooltip();

        initBootstrapWizard();
        importWizard.loadingGif = "<img src='" + my_pligg_base
				+ "/templates/wistie/images/ajax-loader_cp.gif'/>";

        ko.applyBindings(importWizard.dataMatchingProgressViewModel, document
				.getElementById('dataMatchingStepCard'));
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

                var tableName = document
                                    .getElementsByName('dname_value_tableName')[i].value;

                result
						.push({
						    'originalDname': checkboxes[i].value,
						    'newDname': document.getElementsByName('Dname')[i].value,
						    'type': 'INT',//document.getElementsByName('dname_value_type')[i].value,
						    'unit': document.getElementsByName('dname_value_unit')[i].value,
						    'description': document
									.getElementsByName('dname_value_description')[i].value,
						    'tableName': tableName,
						    'metadata': metadata,
                            'missingValue' : document
                                    .getElementsByName(tableName)[0].value
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

    importWizard.passInfofromDisplayOptionsStep = function () {
        $('#dataMatchingTable').empty();
        if (getImportSource() == "database") {
            var deferred = wizardFromDB
					.passSelectedTablesFromDisplayOptionStep();
        } else {
            var deferred = wizardFromFile.passSheetInfoFromDisplayOptionStep();
        }
        return deferred.done(function (data) {
            importWizard.showDataMatchingStep(data);
        });
    };

    importWizard.showDataMatchingStep = function (data) {
        $('#dataMatchingTable').html(data);
        $('#dataMatchingStepInProgress').hide();
    };
    // ***********************************************************************************************

    /** ********** */

    /* Helper functions */

    function initBootstrapWizard() {
        $.fn.wizard.logging = false;

        wizard = $("#wizard-demo").wizard();

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

        wizard.cards["displayOptionsStepCard"].on("selected",
				displayOptionsStepCardOnLoad);

        wizard.cards["dataMatchingStepCard"].on("selected", function (card) {
            wizard.disableNextButton();

            importWizard.dataMatchingProgressViewModel.isProgressing(true);
            var deferred = importWizard.getDataMatchingLoadingProgress();

            if (deferred) {
                deferred.done(function (estimatedSeconds) {
                    importWizard.dataMatchingProgressViewModel.start(estimatedSeconds * 1000);
                    importWizard.passInfofromDisplayOptionsStep().done(
							function () {
							    wizard.enableNextButton();
							}).always(function () {
							    importWizard.dataMatchingProgressViewModel.stop();
							});
                });
            } else {
                importWizard.passInfofromDisplayOptionsStep().done(function () {
                    wizard.enableNextButton();
                });
            }
        });

        wizard.on("submit", function (wizard) {
            $('#dataMatchingStepInProgress').show();

            $('button.wizard-close').hide();
            execute().done(
					function (resultJson) {
					    $('button.wizard-close').show();

					    $("#exe").html(resultJson.message);
					    if (resultJson.isSuccessful) {
					        wizard.trigger("success");

					        wizard.hideButtons();
					        wizard._submitting = false;
					        wizard.showSubmitCard("success");

					        $('#fromDataSetWrapper').find('.sidInput').val(
									'New Dataset');
					    } else {
					        wizard.trigger("failure");
					        $("#exe").html(resultJson.message);
					    }
					});
        });

        wizard.on("reset", function (wizard) {
            wizardFromFile.resetFileUploadForm();
            wizard.setSubtitle("");
            wizard.el.find("#new-server-fqdn").val("");
            wizard.el.find("#new-server-name").val("");
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

    function finishSubmittingData() {
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
            wizardFromFile.createKtrFiles().done(function () {
                wizardFromFile.getFileSources().done(function (jsonResponse) {
                    var filenames = [];
                    for (var i = 0; i < jsonResponse.data.length; i++) {
                        var fileSource = jsonResponse.data[i];
                        filenames.push(fileSource.filename);
                    }
                    wizardFromFile.showExcelFile(filenames);
                }).done(function () {
                    $('#loadingProgressContainer').hide();
                    $("#displayOptoinsStepCardFromFile").show();
                    wizard.enableNextButton();
                });
            }).fail(function () {
                $('#loadingProgressContainer').hide();
            });
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

    function triggerError(jqXHR, textStatus, errorThrown) {
        console.log('error is triggered');
        console.log(jqXHR);
        console.log(textStatus);
        console.log(errorThrown);
        wizard.trigger("error");
        wizard._submitting = false;
        wizard.showSubmitCard("error");
        wizard.updateProgressBar(0);
    }

    /** ***************** */
    function selectChange(event){
    var selValue=$(event).val();
    if(selValue=="STRING"){
        
        $("#unit_number").hide();
        $("#unit_date").hide();
    }
    if(selValue=="INT"){
        $("#unit_number").show();
        $("#unit_date").hide();
        }
    if(selValue=="DATE"){
        $("#unit_date").show();
        $("#unit_number").hide();
        }
    
    }
    $(document).ready(function(){
    $("#unit_number").hide();
    $("#unit_date").hide();
    });
    return importWizard;
})();