function getExcelLikeIndex(index) {
    var charCodesOffset = [];
    var power26 = 1;
    charCodesOffset.push(Math.floor(index % 26));
    while (true) {
        var offset = Math.floor(index / Math.pow(26, power26));
        if (offset > 0) {
            charCodesOffset.unshift(offset - 1);
        } else {
            break;
        }
        power26++;
    }

    var alphaColumnIndex = "";
    for (var j = 0; j < charCodesOffset.length; j++) {
        alphaColumnIndex += String.fromCharCode("A".charCodeAt(0) + charCodesOffset[j]);
    }

    return alphaColumnIndex;
}

ko.bindingHandlers.previewTable = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        $(element).empty();

        var cells = valueAccessor();
        if (cells.length <= 0) {
            return;
        }

        var numRow = cells.length;
        var numCol = cells[0].length;

        var table = $('<table class="previewTable"></table>');

        var columnRow = $('<tr class="columnRow"></tr>');
        $('<td></td>').appendTo(columnRow);
        for (var i = 0; i < numCol; i++) {
            $('<td></td>').text(getExcelLikeIndex(i)).appendTo(columnRow);
        }
        $(table).append(columnRow);

        for (var i = 0; i < cells.length; i++) {
            var row = $('<tr></tr>');
            $('<td class="rowColumn"></td>')
                    .text((bindingContext.$root.previewPage() - 1) * numRow + i + 1)
                    .appendTo(row);
            for (var j = 0; j < cells[i].length; j++) {
                $('<td></td>').text(cells[i][j]).appendTo(row);
            }
            $(table).append(row);
        }
        $(element).append(table);
    }
};

var WizardExcelPreviewProperties = {
    WorksheetSetting: function(sheetName, startRow, startColumn) {
        var self = this;
        self.sheetName = ko.observable(sheetName);
        self.startRow = ko.observable(startRow);
        self.startColumn = ko.observable(startColumn);
        self.rowNum = 11;
    },
    WorksheetPreviewTable: function(sheetName, cells) {
        var self = this;
        self.sheetName = ko.observable(sheetName);
        self.cells = cells;
    }
};

function WizardExcelPreviewViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.numOfWorksheets = ko.observable(0);
    self.numOfWorksheetsOptions = ko.observableArray();
    self.worksheets = ko.observableArray();
    self.worksheetSettings = ko.observableArray();

    self.loadingProgressPercent = ko.observable(0);
    self.isPreviewLoadingComplete = ko.observable(false);
    // Record the estimated loading time so can be reused in step 3 if needed.
    self.estimatedTimestamp = ko.observable(0);
    self.previewRowsPerPage = ko.observable(20);
    self.previewPage = ko.observable(1);
    self.previewTables = ko.observableArray();

    self.loadWorksheets = function() {
        $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=3&sid=" + sid,
            type: 'post',
            dataType: 'json',
            success: function(data) {
                self.worksheets(data);
                for (var i = 0; i < data.length; i++) {
                    self.numOfWorksheetsOptions.push(i + 1);
                }
            }
        });
    };

    self.chooseNumOfWorsheets = function() {
        self.worksheetSettings([]);
        for (var i = 0; i < self.numOfWorksheets(); i++) {
            self.worksheetSettings.push(new WizardExcelPreviewProperties.WorksheetSetting(null, 1, 'A'));
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

    var getEstimatedLoadingSeconds = function() {
        return $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=9&sid=" + sid,
            type: 'post',
            dataType: 'html'
        });
    };

    var updateLoadingProgress = function(startLoadingTimeStamp, estimatedLoadingTimestamp) {
        if (!self.isPreviewLoadingComplete()) {
            var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
            var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
            progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;
            self.loadingProgressPercent(Math.floor(progressPercent));
            setTimeout(function() {
                updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
            }, 1000);
        }
    };

    var getPreviewFromServer = function(rowsPerPage, page) {
        $.ajax({
            url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=8&sid=" + sid,
            type: 'post',
            dataType: 'json',
            data: {
                previewRowsPerPage: rowsPerPage,
                previewPage: page
            },
            success: function(data) {
                self.isPreviewLoadingComplete(true);
                WizardExcelPreviewAjaxCallbacks.loadPreviewCallback(data, self.previewTables);
            },
            error: function() {
                alert("Some errors occur at server, please refresh page and try again.");
            }
        });
    };

    self.loadPreview = function(rowsPerPage, page) {
        self.isPreviewLoadingComplete(false);
        getEstimatedLoadingSeconds().done(function(estimatedSeconds) {         
            startLoadingTimeStamp = new Date().getTime();
            estimatedLoadingTimestamp = estimatedSeconds * 1000;
            self.estimatedTimestamp(estimatedLoadingTimestamp);
            updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
            getPreviewFromServer(rowsPerPage, page);
        }).error(function() {
            alert("Some errors occur at server, please refresh page and try again.");
        });
    };

    self.loadPreviewNextPage = function() {
        self.previewPage(self.previewPage() + 1);
        self.loadPreview(self.previewRowsPerPage(), self.previewPage());
    };

    self.loadPreviewPreviousPage = function() {
        self.previewPage(self.previewPage() - 1);
        self.loadPreview(self.previewRowsPerPage(), self.previewPage());
    };

    self.hasMoreData = function() {
        var hasMoreData = false;
        for (var index in self.previewTables()) {
            hasMoreData = hasMoreData || self.previewTables()[index].cells.length >= self.previewRowsPerPage();
        }
        return hasMoreData;
    };

    self.loadWorksheets();
    self.loadPreview(self.previewRowsPerPage(), self.previewPage());
}

var WizardExcelPreviewAjaxCallbacks = {
    loadPreviewCallback: function(data, previewTablesObservableArray) {
        previewTablesObservableArray([]);
        for (var key in data) {
            previewTablesObservableArray.push(new WizardExcelPreviewProperties.WorksheetPreviewTable(key, data[key]));
        }     
    }
};
