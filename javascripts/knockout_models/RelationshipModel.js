var RelationshipModel = {
    Relationship: function(relJson) {
        var self = this;
        self.rid = relJson.rid;
        self.name = ko.observable(relJson.name);
        self.description = ko.observable(relJson.description);
        self.creator = ko.observable(relJson.creator);
        self.createdTime = ko.observable(relJson.createdTime);

        self.fromDataset = ko.observable(createDatasetModel(relJson.fromDataset));
        self.toDataset = ko.observable(relJson.toDataset);
        self.fromTableName = ko.observable(relJson.fromTableName);
        self.toTableName = ko.observable(relJson.toTableName);

        self.links = ko.observableArray(relJson.links);

        self.avgConfidence = ko.observable(relJson.avgConfidence);
        self.yourComment = ko.observable();
        self.comments = ko.observableArray();

        function createDatasetModel(dsJson) {
            var dataset = new RelationshipModel.DataSet(dsJson.sid);
            dataset.name(dsJson.title);
            dataset.content(dsJson.content);
            dataset.userId(dsJson.userId);
            dataset.userName(dsJson.userName);
            dataset.createdTime(dsJson.entryDate);
            dataset.lastUpdated(dsJson.lastUpdated);
            dataset.sourceType(dsJson.sourceType);
            return dataset;
        }

        function createCommentModel(commentJson) {
            return new RelationshipModel.Comment(
                    commentJson.rid,
                    commentJson.confidence,
                    commentJson.comment,
                    commentJson.userId,
                    commentJson.userName,
                    commentJson.commentTime);
        }

        self.getComments = function() {
            $.ajax({
                url: 'datasetController/relationshipComments.php',
                data: {relId: self.rid},
                type: 'POST',
                dataType: 'json',
                success: function(data) {
                    self.yourComment(createCommentModel(data.yourComment));
                    for (var i = 0; i < data.comments.length; i++) {
                        self.comments([]);
                        self.comments.push(createCommentModel(data.comments[i]));
                    }                  
                },
                error: function(jqXHR, statusCode, errMessage) {
                    alert(errMessage);
                }
            });
        };

        self.getComments();
    },
    Comment: function(rid, confidence, comment, userId, userName, commentTime) {
        var self = this;
        self.rid = rid;
        self.confidence = ko.observable(confidence);
        self.comment = ko.observable(comment);
        self.userId = ko.observable(userId);
        self.userName = ko.observable(userName);
        self.commentTime = ko.observable(commentTime);
    },
    DataSet: function(sid) {
        var self = this;
        self.sid = ko.observable(sid);
        self.name = ko.observable('');
        self.tableList = ko.observableArray();
        self.chosenTableName = ko.observable();
        self.currentTable = ko.observable();
        self.isLoadingTableInfo = ko.observable(false);

        /* Used by relationship info. */
        self.content = ko.observable('');
        self.userId = ko.observable();
        self.userName = ko.observable();
        self.createdTime = ko.observable();
        self.lastUpdated = ko.observable();
        self.sourceType = ko.observable();
        /* ********* */

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