var variableDataTypes = [
  {
    "name": "Number",
    "units": [ "kilometre", "metre", "mile", "kilogram", "gram", "hundreds", "thousands", "millions"],
    "format" : []
  },
  {
    "name": "String",
    "units": [],
    "format" : []
  },
  {
    "name": "Date",
    "units": [ ],
    "format" : ["yy/mm/dd", "mm/dd/yy", "dd/mm/yy", "mm-dd-yy", "yy-mm-dd", "dd-mm-yy"]
  },
  {
    "name": "Time",
    "units": [ ],
    "format" : ["hh:mm:ss", "hh:mm:ss AM/PM", "hh", "mm", "ss", "hh:mm"]
  },
  {
    "name": "Location",
    "units": [ "country", "state", "city", "street", "zipcode", "latitude", "longitude"],
    "format" : []
  },
];


var WizardVariableViewModel = function(originalName, chosenName, description, variableMeasuringUnit, variableValueType,
    variableValueFormat, missingValue) {

    self = this;

    self.originalName = ko.observable(originalName);
    self.chosenName = ko.observable(chosenName);
    
    self.description = ko.observable(description);

    self.variableMeasuringUnit = ko.observable(variableMeasuringUnit);
    self.variableValueType = ko.observable(variableValueType);
    self.variableValueFormat = ko.observable(variableValueFormat);

    self.missingValue = ko.observable(missingValue);

    self.checked = ko.observable(false);
    self.isSettingRowVisible = ko.observable(false);

    self.toggleSettingsRowVisibility = function(item) {
        item.isSettingRowVisible(!item.isSettingRowVisible());
    };
};

var WizardWorksheetViewModel = function(sheetName, headerRow, startColumn, numberOfRows, indexInTheFile, variables) {
    self = this;

    self.sheetName = ko.observable(sheetName);
    self.headerRow = ko.observable(headerRow);
    self.startColumn = ko.observable(startColumn);
    self.numberOfRows = ko.observable(numberOfRows);
    self.indexInTheFile = ko.observable(indexInTheFile);
    self.variables = ko.observableArray(variables);

    self.allToggled = ko.observable(false);

    self.toggleAll = function(wsheet) {

        var all = wsheet.allToggled();

        ko.utils.arrayForEach(wsheet.variables(), function(variable) {
            variable.checked(!all);
        });

        return true;
    };
};

var WizardFileViewModel = function(extension, fileName, fileAbsoluteName, worksheets) {
    self = this;

    self.extension = ko.observable(extension);
    self.fileName = ko.observable(fileName);
    self.fileAbsoluteName = ko.observable(fileAbsoluteName);
    self.worksheets = ko.observableArray(worksheets);
};


function WizardDataMatchingStepViewModel(sid, userId) {
    var self = this;

    self.sid = sid;
    self.userId = userId;


    self.files = ko.observableArray([]);

    self.progressBarViewModel = ko.observable(new ProgressBarViewModel());

    //TODO: need to be refactored according to future changes in how the soruce setting will be sent as json object
    //for now it only works for excel files.
    self.fetchVariables = function(sourceType, sourceSettings, callBack) {
        $.ajax({
            url: ColFusionServerUrl + "/Wizard/getFilesVariablesAndNameRecommendations", //my_pligg_base + '/DataImportWizard/generate_ktr.php',
            type: 'post',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify(sourceSettings),
            success: function(data) {

                if (data.isSuccessful) {

                    for (var i = 0; i < data.payload.length; i++) {

                        var wizardWorksheets = [];

                        for (var j = 0; j < data.payload[i].worksheets.length; j++) {
                                
                            var wizardVariables = [];

                            for (var k = 0; k < data.payload[i].worksheets[j].variables.length; k++) {

                                var variable = data.payload[i].worksheets[j].variables[k];

                                var dataType = variableDataTypes[1];

                                for (var z = 0; z < variableDataTypes.length; z++) {
                                    if (variableDataTypes[z].name === variable.variableValueType) {
                                        dataType = variableDataTypes[z];
                                        break;
                                    }
                                };

                                var wizardVariable = new WizardVariableViewModel(variable.originalName, variable.chosenName, 
                                    variable.description, variable.variableMeasuringUnit, dataType, variable.variableValueFormat, variable.missingValue);

                                wizardVariables.push(wizardVariable);
                            };

                            var worksheet = data.payload[i].worksheets[j];

                            var wizardWorksheet = new WizardWorksheetViewModel(worksheet.sheetName, worksheet.headerRow, 
                                worksheet.startColumn, worksheet.numberOfRows, worksheet.indexInTheFile, wizardVariables);

                            wizardWorksheets.push(wizardWorksheet);
                        };


                        var file = data.payload[i];

                        var wizardFile = new WizardFileViewModel(file.extension, file.fileName, file.fileAbsoluteName, wizardWorksheets);

                        self.files.push(wizardFile);
                        
                    };

                    if (callBack) {
                        callBack();
                    }
                }
            },
            error: function(data) {

            }
        });
    }

    self.getSubmitDataAsDeffered = function(sourceType) {
        var modelToJS = ko.toJS(self.files);

        var files = $.map(modelToJS, function(file) {
            return {
                extension: file.extension,
                fileAbsoluteName: file.fileAbsoluteName,
                fileName: file.fileName,
                worksheets: $.map(file.worksheets, function(worksheet) {
                    return {
                        headerRow: worksheet.headerRow,
                        indexInTheFile: worksheet.indexInTheFile,
                        numberOfRows: worksheet.numberOfRows,
                        sheetName: worksheet.sheetName,
                        startColumn: worksheet.startColumn,
                        variables: $.map(worksheet.variables, function(variable) {
                            return {
                                checked: variable.checked,
                                chosenName: variable.chosenName,
                                description: variable.description,
                                originalName: variable.originalName,
                                variableValueFormat: variable.variableValueFormat,
                                variableValueType: variable.variableValueType.name,
                                variableMeasuringUnit: variable.variableMeasuringUnit,
                                missingValue : variable.missingValue
                            };
                        })
                    };
                })
            };
        });

        var data = {
            sid : self.sid,
            userId : self.userId,
            files : files
        };
         
        return $.ajax({
            url: ColFusionServerUrl + "/Wizard/putDataMatchingStepData", //my_pligg_base + '/DataImportWizard/generate_ktr.php',
            type: 'post',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify(data)
        });
    }
}