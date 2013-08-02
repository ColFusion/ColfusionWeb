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
                    .text((bindingContext.$parent.previewPage() - 1) * numRow + i + 1)
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
    },
    WorksheetPreviewFile: function(filename) {
        var self = this;
        self.filename = ko.observable(filename);
        self.worksheetPreviewTables = ko.observableArray([]);

        self.loadingProgressPercent = ko.observable(0);
        self.isPreviewLoadingComplete = ko.observable(false);
        // Record the estimated loading time so can be reused in step 3 if needed.
        self.estimatedTimestamp = ko.observable(0);
        self.previewRowsPerPage = ko.observable(20);
        self.previewPage = ko.observable(1);

        self.loadPreview = function() {
            var rowsPerPage = self.previewRowsPerPage();
            var page = self.previewPage();

            self.isPreviewLoadingComplete(false);
            self.loadingProgressPercent(0);
            getEstimatedLoadingSeconds().done(function(estimatedSeconds) {
                console.log("startGetPreview");
                var startLoadingTimeStamp = new Date().getTime();
                var estimatedLoadingTimestamp = estimatedSeconds * 1000;
                self.estimatedTimestamp(estimatedLoadingTimestamp);
                updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
                getPreviewFromServer(rowsPerPage, page);
            }).error(function() {
                alert("Some errors occur at server, please refresh page and try again.");
            });
        };

        var getPreviewFromServer = function(rowsPerPage, page) {
            $.ajax({
                url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=10",
                type: 'post',
                dataType: 'json',
                data: {
                    previewRowsPerPage: rowsPerPage,
                    previewPage: page,
                    filename: self.filename()
                },
                success: function(data) {
                    self.worksheetPreviewTables([]);
                    for (var sheetName in data) {
                        self.worksheetPreviewTables.push(new WizardExcelPreviewProperties.WorksheetPreviewTable(sheetName, data[sheetName]));
                    }
                },
                error: function() {
                    alert("Some errors occur at server, please refresh page and try again.");
                }
            }).always(function() {
                self.isPreviewLoadingComplete(true);
            });
        };

        function  getEstimatedLoadingSeconds() {
            return $.ajax({
                url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=9",
                type: 'post',
                data: {filename: self.filename()},
                dataType: 'html'
            });
        }

        function updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp) {
            if (!self.isPreviewLoadingComplete()) {
                var hasLoadedTimestamp = new Date().getTime() - startLoadingTimeStamp;
                console.log("hasLoadedTimestamp: " + hasLoadedTimestamp);
                console.log("estimatedLoadingTimestamp: " + estimatedLoadingTimestamp);
                var progressPercent = hasLoadedTimestamp / estimatedLoadingTimestamp * 100;
                progressPercent = (progressPercent >= 100 || isNaN(progressPercent) || progressPercent == 'Infinity') ? 99 : progressPercent;
                console.log("progressPercent: " + progressPercent);
                self.loadingProgressPercent(Math.floor(progressPercent));
                setTimeout(function() {
                    updateLoadingProgress(startLoadingTimeStamp, estimatedLoadingTimestamp);
                }, 1000);
            }
        }

        self.loadPreviewNextPage = function() {
            self.previewPage(self.previewPage() + 1);
            self.loadPreview();
        };

        self.loadPreviewPreviousPage = function() {
            self.previewPage(self.previewPage() - 1);
            self.loadPreview();
        };

        self.hasMoreData = function() {
            var hasMoreData = false;
            for (var index in self.worksheetPreviewTables()) {
                hasMoreData = hasMoreData || self.worksheetPreviewTables()[index].cells.length >= self.previewRowsPerPage();
            }
            return hasMoreData;
        };
    }
};

function WizardExcelPreviewViewModel(sid) {
    var self = this;
    self.sid = sid;
    self.previewFiles = ko.observableArray();

    self.initFilePreview = function(sid, filenames) {
        self.sid = sid;
        self.previewFiles([]);
        for (var i = 0; i < filenames.length; i++) {
            var worksheetPreviewFile = new WizardExcelPreviewProperties.WorksheetPreviewFile(filenames[i]);
            self.previewFiles.push(worksheetPreviewFile);
            worksheetPreviewFile.loadPreview();
        }
    };
}