var WizardVariableViewModel = function(originalName, chosenName, description, valueUnit, valueType, valueFormat) {
    self = this;

    self.originalName = ko.observable(originalName);
    self.chosenName = ko.observable(chosenName);
    self.description = ko.observable(description);
    self.valueUnit = ko.observable(valueUnit);
    self.valueType = ko.observable(valueType);
    self.valueFormat = ko.observable(valueFormat);
};

var WizardWorksheetViewModel = function(sheetName, headerRow, startColumn, numberOfRows, indexInTheFile, variables) {
    self = this;

    self.sheetName = ko.observable(sheetName);
    self.headerRow = ko.observable(headerRow);
    self.startColumn = ko.observable(startColumn);
    self.numberOfRows = ko.observable(numberOfRows);
    self.indexInTheFile = ko.observable(indexInTheFile);
    self.variables = ko.observableArray(variables);
};

var WizardFileViewModel = function(extension, fileName, fileAbsoluteName, worksheets) {
    self = this;

    self.extension = ko.observable(extension);
    self.fileName = ko.observable(fileName);
    self.fileAbsoluteName = ko.observable(fileAbsoluteName);
    self.worksheets = ko.observableArray(worksheets);
};


function WizardDataMatchingStepViewModel() {
    var self = this;

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

                                var wizardVariable = new WizardVariableViewModel(variable.originalName, variable.chosenName, 
                                    variable.description, variable.valueUnit, variable.valueType, variable.valueFormat);

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
}