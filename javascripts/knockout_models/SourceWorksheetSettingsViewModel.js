function SourceWorksheetSettingsViewModel() {
    var self = this;
    self.sourceWorksheetSettings = ko.observableArray();
    self.loadingProgress = ko.observable();

    self.addSource = function(sourceName, worksheets, ext) {
        self.sourceWorksheetSettings.push(new SourceWorksheetSettings(sourceName, worksheets, ext));
    };

    self.cleanSource = function() {
        self.sourceWorksheetSettings([]);
    };

    self.setTimeProgress = function(startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval) {
        self.loadingProgress(new KnockoutUtil.TimeProgress(startLoadingTimeStamp, estimatedLoadingTimestamp, updateInterval));
        self.loadingProgress().start();
    };

    self.getSourceWorksheetSettings = function() {
        var sourceWorksheetSettingsWithoutObservable = {};
        for (var i = 0; i < self.sourceWorksheetSettings().length; i++) {
            var sourceWorksheetSettings = self.sourceWorksheetSettings()[i];
            sourceWorksheetSettingsWithoutObservable[sourceWorksheetSettings.sourceName] =
                    sourceWorksheetSettings.getWorksheetSettings();
        }
        return sourceWorksheetSettingsWithoutObservable;
    };
}

function SourceWorksheetSettings(sourceName, worksheets, ext) {
    var self = this;
    self.sourceName = sourceName;
    self.worksheets = ko.observableArray(worksheets);
    self.numOfWorksheets = ko.observable(1);
    self.numOfWorksheetsOptions = ko.observableArray([]);
    self.worksheetSettings = ko.observableArray();

    self.ext = ext;

    for (var i = 0; i < worksheets.length; i++) {
        self.numOfWorksheetsOptions.push(i + 1);
    }

    self.chooseNumOfWorsheets = function() {
        self.worksheetSettings([]);
        for (var i = 0; i < self.numOfWorksheets(); i++) {
                self.worksheetSettings.push(new WizardExcelPreviewProperties.WorksheetSetting(self.worksheets()[i], 1, 'A'));
        }
    };

    self.getWorksheetSettings = function() {
        // $sheetsRange = {'sheetName' : {startRow, startColumn, rowNum}} 
        var sheetsRange = {};
        var worksheetSettings = self.worksheetSettings();

        for (var index in worksheetSettings) {
            var worksheetSetting = worksheetSettings[index];
            sheetsRange[worksheetSetting.sheetName()] = {};
            sheetsRange[worksheetSetting.sheetName()]['startRow'] = worksheetSetting.startRow();
            sheetsRange[worksheetSetting.sheetName()]['startColumn'] = worksheetSetting.startColumn();
            sheetsRange[worksheetSetting.sheetName()]['rowNum'] = worksheetSetting.rowNum;
        }

        return sheetsRange;
    };

    // if (ext == "csv") {
    //     self.numOfWorksheets(1);
    self.chooseNumOfWorsheets();
    // }
}