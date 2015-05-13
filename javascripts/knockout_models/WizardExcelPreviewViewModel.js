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
    WorksheetPreviewFile: function(file) {
        var self = this;
        self.fileName = ko.observable(file.fileName);
        self.fileAbsoluteName = ko.observable(file.fileAbsoluteName);

        self.worksheetPreviewTables = ko.observableArray([]);

        self.progressBarViewModel = ko.observable(new ProgressBarViewModel());

        self.isError = ko.observable(false);
        self.errorMessage = ko.observable();

        self.previewRowsPerPage = ko.observable(20);
        self.previewPage = ko.observable(1);

        self.loadPreview = function() {
            var rowsPerPage = self.previewRowsPerPage();
            var page = self.previewPage();
            
            self.progressBarViewModel().isProgressing(true);
            
            // Start updating progress bar periodically until a page of data is downloaded.
            getEstimatedLoadingSeconds().done(function (data) {

                if (data.isSuccessful) {
                    var estimatedLoadingTimestamp = data.payload * 1000;
                    self.progressBarViewModel().start(estimatedLoadingTimestamp);
                    
                    getPreviewFromServer(rowsPerPage, page).always(function() {
                        self.progressBarViewModel().stop();
                    });
                }
                else {
                    self.isError(true);
                    self.errorMessage(data.message);
                }                
            }).error(function() {
                self.isError(true);
                self.errorMessage("Some errors occur at server, please refresh page and try again.");
                
            });
        };

        var getPreviewFromServer = function(rowsPerPage, page) {
            return $.ajax({
                url: ColFusionServerUrl + "/Wizard/getDataPreviewFromFile", //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=10",
                type: 'post',
                dataType: 'json',
                contentType: "application/json",
                crossDomain: true,
                data: JSON.stringify({
                    previewRowsPerPage: rowsPerPage,
                    previewPage: page,
                    fileName: self.fileName(),
                    fileAbsoluteName: self.fileAbsoluteName()
                }),
                success: function(data) {

                    if (data.isSuccessful) {

                        self.worksheetPreviewTables([]);
                        for (var k = 0; k < data.payload.worksheetsData.length; k++) {

                            var worksheetsData = data.payload.worksheetsData[k];
                                          
                            var numRows = worksheetsData.worksheetData.length;
                            var cells = new Array(numRows);

                            for (var i = 0; i < numRows; i++) {
                                var numCol = worksheetsData.worksheetData[i].worksheetDataRow.length;
                                cells[i] = new Array(numCol);

                               for (var j = 0; j < numCol; j++) {
                                    cells[i][j] = worksheetsData.worksheetData[i].worksheetDataRow[j];
                                };
                            };

                            self.worksheetPreviewTables.push(new WizardExcelPreviewProperties.WorksheetPreviewTable(worksheetsData.worksheetName, cells));
                        }
                    }
                    else {
                        self.isError(true);
                        self.errorMessage(data.message);
                    }

                },
                error: function() {
                    self.isError(true);
                    self.errorMessage("Some errors occur at server, please refresh page and try again.");
                }
            });
        };

        function  getEstimatedLoadingSeconds() {
            return $.ajax({
                url: ColFusionServerUrl + "/Wizard/estimateDataPreviewFromFile", //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=9",
                type: 'post',
                contentType: "application/json",
                crossDomain: true,
                dataType: 'json',
                data: JSON.stringify({
                    fileName: self.fileName(),
                    fileAbsoluteName: self.fileAbsoluteName()
                }),
            });
        }

        function  generateOPM() {
            return $.ajax({
                url: my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=11",
                type: 'post',
                data: {filename: self.filename()},
                dataType: 'html'
            });
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

    self.initFilePreview = function(sid, files) {
        self.sid = sid;
        self.previewFiles([]);
        for (var i = 0; i < files.length; i++) {
            var worksheetPreviewFile = new WizardExcelPreviewProperties.WorksheetPreviewFile(files[i]);
            self.previewFiles.push(worksheetPreviewFile);
            worksheetPreviewFile.loadPreview();
        }
    };
}