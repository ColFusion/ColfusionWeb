ko.extenders.withPrevious = function (target, option) {
    // Define new properties for previous value and whether it's changed
    target.previous = ko.observable();
    target.changed = ko.computed(function () {
        return target() !== target.previous();
    });

    // Subscribe to observable to update previous, before change.
    target.subscribe(function (v) {
        target.previous(v);
    }, null, 'beforeChange');

    // Return modified observable
    return target;
};

var RelationshipModel = {
    Relationship: function (relJson) {
        var self = this;
        self.rid = relJson.rid;
        self.name = ko.observable(relJson.name);
        self.description = ko.observable(relJson.description);
        self.creator = ko.observable(relJson.creator);
        self.createdTime = ko.observable(relJson.createdTime);
        self.isOwned = ko.observable(relJson.isOwned);

        self.fromDataset = ko.observable(createDatasetModel(relJson.fromDataset, relJson.fromTableName));
        self.toDataset = ko.observable(createDatasetModel(relJson.toDataset, relJson.toTableName));

        self.links = ko.observableArray($.map(relJson.links, function (linkObj) {
            return new RelationshipModel.RelInfoLink(linkObj);
        }));

        self.avgConfidence = ko.observable(relJson.avgConfidence);

        self.comments = ko.observableArray();
        self.isCommentLoaded = {};
        self.isCommentLoading = ko.observable(false);
        self.isCommentHided = ko.observable(true);
        self.isCommentLoadingError = ko.observable(false);

        self.yourComment = ko.observable();
        self.isYourCommentEditing = ko.observable(false);
        self.editingComment = ko.observable();
        self.isSavingYourComment = ko.observable(false);

        function createDatasetModel(dsJson, tableName) {
            var dataset = new RelationshipModel.DataSet(dsJson.sid);
            dataset.name(dsJson.title);
            dataset.content(dsJson.content);
            dataset.userId(dsJson.userId);
            dataset.userName(dsJson.userName);
            dataset.createdTime(dsJson.entryDate);
            dataset.lastUpdated(dsJson.lastUpdated);
            dataset.sourceType(dsJson.sourceType);
            dataset.shownTableName(tableName);
            return dataset;
        }

        function createCommentModel(commentJson, isControlPanelShown) {
            return new RelationshipModel.Comment(
                    commentJson.rid,
                    commentJson.confidence,
                    commentJson.comment,
                    commentJson.userId,
                    commentJson.userName,
                    commentJson.userEmail,
                    commentJson.commentTime,
                    isControlPanelShown);
        }

        function createEmptyCommentModel() {
            return createCommentModel(
                    {
                        rid: self.rid,
                        confidence: 0,
                        comment: '',
                        userId: 0,
                        userName: '',
                        commentTime: new Date()
                    }, true);
        }

        function cloneCommentModel(commentModel) {
            var commentJson = ko.mapping.toJS(commentModel);
            return createCommentModel(commentJson, commentJson.isControlPanelShown);
        }

        function updateFeedbackStatistics() {
            var totalConfidence = 0;
            var numOfFeedback = 0;

            $.each(self.comments(), function (i, val) {
                numOfFeedback++;
                totalConfidence += parseFloat(val.confidence());
            });

            var yourComment = self.yourComment();
            if (yourComment) {
                numOfFeedback++;
                totalConfidence += parseFloat(yourComment.confidence());
            }

            var avgConfidence = totalConfidence / numOfFeedback;
            self.avgConfidence(avgConfidence);

            var relationshipTableDom = $('#mineRelationshipsTableWrapper').find('#relationship_' + self.rid);
            $(relationshipTableDom).find('.numOfVerdicts').text(numOfFeedback);
            $(relationshipTableDom).find('.avgConfidence').text((avgConfidence * 100 / 100).toFixed(2));
            $('.relConfidence_' + self.rid).text((avgConfidence * 100 / 100).toFixed(2));
        }

        self.showComments = function () {
            self.isCommentHided(false);
            self.isCommentLoadingError(false);

            if (!self.isCommentLoaded[self.rid]) {
                self.isCommentLoading(true);

                $.ajax({
                    url: my_pligg_base + '/datasetController/relationshipComments.php',
                    data: { relId: self.rid },
                    type: 'POST',
                    dataType: 'json',
                    success: function (data) {
                        if (data.yourComment) {
                            self.yourComment(createCommentModel(data.yourComment, true));
                        } else {
                            self.yourComment(null);
                        }
                        for (var i = 0; i < data.comments.length; i++) {
                            self.comments([]);
                            self.comments.push(createCommentModel(data.comments[i], false));
                        }
                        self.isCommentLoaded[self.rid] = true;
                        self.isCommentLoading(false);
                    },
                    error: function (jqXHR, statusCode, errMessage) {
                        self.isCommentLoading(false);
                        self.isCommentLoadingError(true);
                        self.isCommentLoaded[self.rid] = false;
                    }
                });
            }
        };

        self.hideComments = function () {
            self.isCommentHided(true);
        };

        self.editComment = function () {
            self.isYourCommentEditing(true);
            if (self.yourComment()) {
                self.editingComment(cloneCommentModel(self.yourComment()));
            } else {
                self.editingComment(createEmptyCommentModel());
            }
        };

        self.cancelEditingComment = function () {
            self.isYourCommentEditing(false);
        };

        self.saveComment = function () {
            var action = self.yourComment() ? 'updateComment' : 'addComment';
            self.yourComment(cloneCommentModel(self.editingComment()));
            self.isSavingYourComment(true);
            $.ajax({
                url: my_pligg_base + '/datasetController/commentUpdater.php',
                data: {
                    relId: self.rid,
                    action: action,
                    comment: self.yourComment().comment(),
                    confidence: self.yourComment().confidence()
                },
                type: 'POST',
                dataType: 'json',
            }).pipe(function (data) {
                return $.ajax({
                    url: my_pligg_base + '/datasetController/getYourComment.php',
                    data: { relId: self.rid },
                    type: 'POST',
                    dataType: 'json'
                });
            }).done(function (data) {
                self.yourComment(createCommentModel(data, true));
                self.isYourCommentEditing(false);
                updateFeedbackStatistics();
            }).fail(function (jqXHR, statusCode, errMessage) {
                self.isCommentLoadingError(true);
                self.isCommentLoaded[self.rid] = false;
            }).always(function () {
                self.isSavingYourComment(false);
            });
        };

        self.removeComment = function () {

            if (!confirm('Do you want to remove your comment?')) {
                return;
            }

            $.ajax({
                url: my_pligg_base + '/datasetController/commentUpdater.php',
                data: {
                    relId: self.rid,
                    action: 'removeComment'
                },
                type: 'POST',
                dataType: 'json',
                success: function (data) {
                    self.yourComment(null);
                    updateFeedbackStatistics();
                },
                error: function (jqXHR, statusCode, errMessage) {
                    alert(errMessage);
                }
            });
        };

        self.checkDataMatching = function () {
            self.fromDataset().name($('#fromDataSet').find('input.sidInput').val() || self.fromDataset().name());

            $('#dataMatchCheckingForm input[name="fromSid"]').val(self.fromDataset().sid());
            $('#dataMatchCheckingForm input[name="toSid"]').val(self.toDataset().sid());
            $('#dataMatchCheckingForm input[name="fromTable"]').val(self.fromDataset().shownTableName());
            $('#dataMatchCheckingForm input[name="toTable"]').val(self.toDataset().shownTableName());
            $('#dataMatchCheckingForm input[name="relSerializedString"]').val(ko.toJSON(self));
            $('#dataMatchCheckingForm').submit();
        };
    },
    Comment: function (rid, confidence, comment, userId, userName, userEmail, commentTime, isControlPanelShown) {
        var self = this;
        self.rid = rid;
        self.confidence = ko.observable(Number(confidence).toFixed(1));
        self.comment = ko.observable(comment);
        self.userId = ko.observable(userId);
        self.userName = ko.observable(userName);
        self.userEmail = ko.observable(userEmail);
        self.commentTime = ko.observable(commentTime);

        self.isControlPanelShown = ko.observable(isControlPanelShown);
    },
    DataSet: function (sid) {
        var self = this;

        self.sid = ko.observable(sid);
        self.name = ko.observable('');
        self.tableList = ko.observableArray();
        self.chosenTableName = ko.observable().extend({ withPrevious: 'option' });

        // shownTableName does not trigger load table info event.
        self.shownTableName = ko.observable();
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

        self.loadTableInfo = function () {
            if (!self.sid()
                    || (self.currentTable() && !confirm("Do you want to discard all editing relationships and reload the table?")))
                return;

            self.isLoadingTableInfo(true);
            dataSourceUtil.getTableInfo(self.sid(), self.chosenTableName()).done(function (data) {
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
            }).always(function () {
                self.isLoadingTableInfo(false);
            });
        };

        self.chosenTableName.subscribe(function (newValue) {
            if (self.chosenTableName.changed()) {
                if (!newValue) {
                    self.currentTable(null);
                } else {
                    self.loadTableInfo(self.sid(), newValue);
                }
            }
        }, self);

        // Table list in adding relationship process.
        self.loadTableList = function () {
            if (self.sid() >= 1) {
                dataSourceUtil.getTablesList(self.sid()).done(function (data) {
                    if (data != null) {
                        self.tableList(data);
                    }

                    if (data.length === 1) {
                        self.chosenTableName(data[0]);
                    }
                });
            }
        };
    },
    // cols: [],
    // rows: [{}, {}]
    Table: function (cols, rows) {
        var self = this;
        // Change data structure.
        self.columns = ko.observableArray($.map(cols, function (i, val) {
            return new RelationshipModel.Column(val);
        }));
        self.rows = ko.observableArray();
        for (var i = 0; i < rows.length; i++) {
            self.rows.push(new RelationshipModel.Row(rows[i]));
        }

        self.getRawDataColumns = function () {
            return $.map(self.rows(), function (row, i) {
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
    Column: function (name) {
        var self = this;
        self.name = ko.observable(name);
    },
    Row: function (colfusionDataColumn) {
        var self = this;
        self.colfusionDataColumn = new RelationshipModel.ColfusionDataColumn(colfusionDataColumn);
        self.isChecked = ko.observable(false);
    },
    ColfusionDataColumn: function (rawDataColumn) {
        var self = this;
        self.cid = ko.observable();
        self.dname_chosen = ko.observable();
        self.dname_value_description = ko.observable();
        self.dname_value_type = ko.observable();
        self.dname_value_unit = ko.observable();
        self.rawColfusionDataColumnObj = rawDataColumn;

        self.mapFromRawDataColumn = function (rawDataColumn) {
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

    // Link is for newRelationshipModel, RelInfoLink is for relationshipInfo
    RelInfoLink: function (linkObj) {
        var self = this;

        self.isSelectedForMerge = ko.observable(true);

        self.fromPart = ko.observable(linkObj.fromPart);
        self.toPart = ko.observable(linkObj.toPart);
        self.fromPartEncoded = ko.observable(linkObj.fromPartEncoded);
        self.toPartEncoded = ko.observable(linkObj.toPartEncoded);
    },
    Link: function (fromDataSet, toDataSet) {
        var self = this;

        self.isSelectedForMerge = ko.observable(true);

        self.fromLinkPart = ko.observable(new RelationshipModel.LinkPart(fromDataSet));
        self.toLinkPart = ko.observable(new RelationshipModel.LinkPart(toDataSet));
    },
    LinkPart: function (dataSet) {
        var self = this;
        self.dataSet = dataSet;
        self.transInput = ko.observable('');
        self.colfusionDataColumn = ko.observable(new RelationshipModel.ColfusionDataColumn());

        self.getEncodedTransInput = function () {

            var encodedInput = self.transInput();
            var rawDataColumns = dataSet.currentTable().getRawDataColumns();

            $.each(rawDataColumns, function (index, rawDataColumnObj) {
                encodedInput = encodedInput.replace(rawDataColumnObj.dname_chosen, 'cid(' + rawDataColumnObj.cid + ')');
            });

            return encodedInput;
        };
    }
};