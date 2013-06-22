var RelationshipModel = {
    Relationship: function(rid) {
        var self = this;
        self.rid = rid;
        self.name = ko.observable();
        self.description = ko.observable();
        self.creator = ko.observable();
        self.createdTime = ko.observable();

        self.fromDataset = ko.observable();
        self.toDataset = ko.observable();
        self.fromTableName = ko.observable();
        self.toTableName = ko.observable();

        self.links = ko.observableArray();

        self.avgConfidence = ko.observable();
        self.comments = ko.observable();
        
        
    },
    DataSet: function(sid) {
        var self = this;
        self.sid = ko.observable(sid);
        self.name = ko.observable('');
        self.tableList = ko.observableArray();
        self.chosenTableName = ko.observable();
        self.currentTable = ko.observable();
        self.isLoadingTableInfo = ko.observable(false);

        self.loadTableInfo = function() {
            if (!self.sid()
                    || (self.currentTable() && !confirm("Do you want to discard all editing relationships and reload the table?")))
                return;

            self.isLoadingTableInfo(true);
            dataSourceUtil.getTableInfo(self.sid(), self.chosenTableName()).done(function(data) {
                if (data.length <= 0)
                    return;
                var cols = [];
                for (var key in data[0]) {
                    cols.push(key);
                }

                var rows = [];
                for (var i = 0; i < data.length; i++) {
                    rows.push(data[i]);
                }

                self.currentTable(new RelationshipModel.Table(cols, rows));
            }).always(function() {
                self.isLoadingTableInfo(false);
            });
        };

        self.chosenTableName.subscribe(function(newValue) {
            self.loadTableInfo(self.sid(), newValue);
        }, self);

        self.loadTableList = function() {
            if (self.sid() >= 1) {
                dataSourceUtil.getTablesList(self.sid()).done(function(data) {
                    if (data != null) {
                        self.tableList(data);
                    }

                    if (data.length === 1) {
                        self.chosenTableName(data[0]);
                        self.loadTableInfo();
                    }
                });
            }
        };
    },
    // cols: [],
    // rows: [{}, {}]
    Table: function(cols, rows) {
        var self = this;
        // Change data structure.
        self.columns = ko.observableArray($.map(cols, function(i, val) {
            return new RelationshipModel.Column(val);
        }));
        self.rows = ko.observableArray();
        for (var i = 0; i < rows.length; i++) {
            self.rows.push(new RelationshipModel.Row(rows[i]));
        }

        self.getRawDataColumns = function() {
            return $.map(self.rows(), function(row, i) {
                var rawObj = row.colfusionDataColumn.rawColfusionDataColumnObj;
                // Properties for typeahead.js.
                rawObj.name = rawObj.dname_chosen;
                rawObj.tokens = [];
                rawObj.tokens.push(rawObj.name);
                if (!rawObj.dname_value_description)
                    rawObj.dname_value_description = 'No description.';
                return rawObj;
            });
        };
        self.isSelected = ko.observable(false);
    },
    Column: function(name) {
        var self = this;
        self.name = ko.observable(name);
    },
    Row: function(colfusionDataColumn) {
        var self = this;
        self.colfusionDataColumn = new RelationshipModel.ColfusionDataColumn(colfusionDataColumn);
        self.isChecked = ko.observable(false);
    },
    ColfusionDataColumn: function(rawDataColumn) {
        var self = this;
        self.cid = ko.observable();
        self.dname_chosen = ko.observable();
        self.dname_value_description = ko.observable();
        self.dname_value_type = ko.observable();
        self.dname_value_unit = ko.observable();
        self.rawColfusionDataColumnObj = rawDataColumn;

        self.mapFromRawDataColumn = function(rawDataColumn) {
            if (rawDataColumn !== undefined) {
                self.cid(rawDataColumn.cid);
                self.dname_chosen(rawDataColumn.dname_chosen);
                self.dname_value_description(rawDataColumn.dname_value_description);
                self.dname_value_type(rawDataColumn.dname_value_type);
                self.dname_value_unit(rawDataColumn.dname_value_unit);
            }
        };

        self.mapFromRawDataColumn(rawDataColumn);
    },
    Link: function(fromDataSet, toDataSet) {
        var self = this;
        self.fromLinkPart = ko.observable(new RelationshipModel.LinkPart(fromDataSet));
        self.toLinkPart = ko.observable(new RelationshipModel.LinkPart(toDataSet));
    },
    LinkPart: function(dataSet) {
        var self = this;
        self.dataSet = dataSet;
        self.transInput = ko.observable('');
        self.colfusionDataColumn = ko.observable(new RelationshipModel.ColfusionDataColumn());

        self.getEncodedTransInput = function() {

            var encodedInput = self.transInput();
            var rawDataColumns = dataSet.currentTable().getRawDataColumns();

            $.each(rawDataColumns, function(index, rawDataColumnObj) {
                encodedInput = encodedInput.replace(rawDataColumnObj.dname_chosen, 'cid(' + rawDataColumnObj.cid + ')');
            });

            return encodedInput;
        };
    }
};