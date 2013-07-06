var wizardFromDB = (function() {
    var wizardFromDB = {};

    /* Variables */
    wizardFromDB.server = "";
    wizardFromDB.user = "";
    wizardFromDB.password = "";
    wizardFromDB.database = "";
    wizardFromDB.port = "";
    wizardFromDB.driver = "";

    /*************/

    /* Functions */

    // Get all actions form friends.
    wizardFromDB.TestDBConnection = function(container, server, user, password, port, driver, database) {
        $('#testDBConnectionResultMsg').css('color', '#707070').text('Connecting...');
        $.ajax({
            type: 'POST',
            url: my_pligg_base + "/DataImportWizard/wizardFromDBController.php?action=TestConnection",
            data: {'serverName': server,
                'userName': user,
                'password': password,
                'port': port,
                'driver': driver,
                'database': database
            },
            success: function(data) {
                $('#testDBConnectionResultMsg').css('color', data.isSuccessful ? 'green' : 'red').text(data.message);
                if (data.isSuccessful) {
                    wizard.enableNextButton();
                }
            },
            dataType: 'json',
            async: false
        });
    };

    // Get all actions form friends.
    wizardFromDB.LoadDatabaseTables = function(container, server, user, password, database, port, driver) {
        wizardFromDB.server = server;
        wizardFromDB.user = user;
        wizardFromDB.password = password;
        wizardFromDB.database = database;
        wizardFromDB.port = port;
        wizardFromDB.driver = driver;


        $.ajax({
            type: 'POST',
            url: my_pligg_base + "/DataImportWizard/wizardFromDBController.php?action=LoadDatabaseTables",
            data: {'serverName': server,
                'userName': user,
                'password': password,
                'database': database,
                'port': port,
                'driver': driver
            },
            success: function(JSON_Response) {

                container.empty();

                if (JSON_Response.isSuccessful) {
                    var el = "<p>Tables in selected database:</p><div style='height: 80%; overflow-y: scroll;'>";
                    for (var i = 0; i < JSON_Response.data.length; i++) {
                        el += "<label style='display: inline;'><input type='checkbox' name='table[]' value='" + JSON_Response.data[i] + "'/>" + JSON_Response.data[i] + "</lable><br/>";

                    }
                    el += "</div>"
                } else {
                    var el = "<p style='color:red;'>Errors occur when loading tables.</p>";
                }

                container.append(el);
            },
            dataType: 'json',
            async: false
        });
    };

    wizardFromDB.passSelectedTablesFromDisplayOptionStep = function() {

        var dataToSend = {'selectedTables[]': getSelectedTables(), 'serverName': wizardFromDB.server, "userName": wizardFromDB.user, "password": wizardFromDB.password,
            "database": wizardFromDB.database, 'port': wizardFromDB.port, 'driver': wizardFromDB.driver};

        // alert(JSON.stringify(dataToSend));
        $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/wizardFromDBController.php?action=PrintTableForSchemaMatchingStep',
            data: dataToSend,
            success: function(data) {
                importWizard.showSchemaMatchingStep(data);
            }
        });
    };

    wizardFromDB.passSchemaMatchinInfo = function() {
        var dataToSend = {"schemaMatchingUserInputs": importWizard.getSchemaMatchingUserInputs()};

        // alert(JSON.stringify(dataToSend));
        $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/wizardFromDBController.php?action=PrintTableForDataMatchingStep',
            data: dataToSend,
            success: function(data) {
                importWizard.showDataMatchingStep(data);
            }
        });
    }

    wizardFromDB.excuteFromDB = function() {

        var dataToSend = {
            'sid': $('#sid').val(),
            'server': wizardFromDB.server, "user": wizardFromDB.user, "password": wizardFromDB.password, 'database': wizardFromDB.database,
            'port': wizardFromDB.port, 'driver': wizardFromDB.driver,
            'selectedTables[]': getSelectedTables(),
            'schemaMatchingUserInputs': importWizard.getSchemaMatchingUserInputs(),
            'dataMatchingUserInputs': importWizard.getDataMatchingUserInputs()
        };

        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/wizardFromDBController.php?action=Execute',
            data: dataToSend,
            dataType: 'json'
        });
    };

    wizardFromDB.togglePort = function() {
        $('#fromDBPortRow').toggle();

        if ($('#fromDBPortRow').css("display") === "none")
            $('#showHideAdvancedOptionsFromDatabase').text("Show Advanced Options");
        else
            $('#showHideAdvancedOptionsFromDatabase').text("Hide Advanced Options");
    }

    wizardFromDB.setDefaultAdvancedSettingsByServerName = function(container, selectedValue) {
        switch (selectedValue) {
            case "0":
                container.val(3306);
                break;
            case "1":
                container.val(1433);
                break;
        }
    }

    /*************/

    /* Helper functions */

    function getSelectedTables() {
        var selectedTables = new Array();

        $.each($("input[name='table[]']:checked"), function() {
            selectedTables.push($(this).val());
        });

        return selectedTables;
    }

    /********************/

    return wizardFromDB;
})();