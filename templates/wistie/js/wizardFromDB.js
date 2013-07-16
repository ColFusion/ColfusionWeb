var wizardFromDB = (function() {
    var wizardFromDB = {};

    /* Variables */
    wizardFromDB.server = "";
    wizardFromDB.user = "";
    wizardFromDB.password = "";
    wizardFromDB.database = "";
    wizardFromDB.port = "";
    wizardFromDB.driver = "";
    wizardFromDB.isImport = false;

    /*************/

    /* Functions */

    // Get all actions form friends.
    wizardFromDB.TestDBConnection = function(container, server, user, password, port, driver, database, isImport) {
        $('#testDBConnectionResultMsg').css('color', '#707070').text('Connecting...');
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/DataImportWizard/wizardFromDBController.php?action=TestConnection",
            data: {'serverName': server,
                'userName': user,
                'password': password,
                'port': port,
                'driver': driver,
                'database': database,
                'isImport': isImport
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
    wizardFromDB.LoadDatabaseTables = function(server, user, password, database, port, driver, isImport) {
        wizardFromDB.server = server;
        wizardFromDB.user = user;
        wizardFromDB.password = password;
        wizardFromDB.database = database;
        wizardFromDB.port = port;
        wizardFromDB.driver = driver;
        wizardFromDB.isImport = isImport;

        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/DataImportWizard/wizardFromDBController.php?action=LoadDatabaseTables",
            data: {'serverName': server,
                'userName': user,
                'password': password,
                'database': database,
                'port': port,
                'driver': driver,
                'isImport': isImport
            },          
            dataType: 'json'
        });
    };

    wizardFromDB.passSelectedTablesFromDisplayOptionStep = function() {

        var dataToSend = {
            'selectedTables[]': getSelectedTables(),
            'serverName': wizardFromDB.server,
            "userName": wizardFromDB.user,
            "password": wizardFromDB.password,
            "database": wizardFromDB.database,
            'port': wizardFromDB.port,
            'driver': wizardFromDB.driver,
            'isImport': wizardFromDB.isImport
        };

        // alert(JSON.stringify(dataToSend));
        return $.ajax({type: 'POST',
            url: my_pligg_base + '/DataImportWizard/wizardFromDBController.php?action=PrintTableForSchemaMatchingStep',
            data: dataToSend          
        });
    };

    wizardFromDB.passSchemaMatchinInfo = function(schemaMatchingUserInputs) {
        var dataToSend = {"schemaMatchingUserInputs": schemaMatchingUserInputs};

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
            'dataMatchingUserInputs': importWizard.getDataMatchingUserInputs(),
            'isImport': wizardFromDB.isImport
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
        switch (selectedValue.toLowerCase()) {
            case "mysql":
                container.val(3306);
                break;
            case "mssql":
            case "sql server":
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