function RelationshipViewModel(sid) {
    var self = this;

    self.sid = sid;

    self.isRelationshipDataLoading = ko.observable(false);
    self.isNoRelationshipData = ko.observable(false);
    self.mineRelationshipsTable = ko.observable();

    self.isRelationshipInfoLoaded = {};
    self.relationshipInfos = {};

    self.mineRelationships = function(perPage, pageNo) {
        //$('#relationshipMiningInProgress').show();
        self.isRelationshipDataLoading(true);
        self.isNoRelationshipData(false);

        dataSourceUtil.mineRelationship(self.sid, perPage, pageNo).done(function(data) {
            //  $('#relationshipMiningInProgress').hide();

            if (!data.Control || !data.Control.cols || data.Control.cols.length === 0) {
                // Show 'no data' text;
                self.isRelationshipDataLoading(false);
                self.isNoRelationshipData(true);
                return;
            }

            self.isNoRelationshipData(false);
            // Controls.
            var perPage = data.Control.perPage;
            var totalPage = data.Control.totalPage;
            var currentPage = data.Control.pageNo;

            var transformedData = dataSourceUtil.transformRawDataToColsAndRows(data);
            for(var i=0 ; i<data.data.length ; i++){
                self.isRelationshipInfoLoaded[data.data[i].rel_id] = ko.observable(false);
            }
            self.mineRelationshipsTable(new DataPreviewViewModelProperties.Table('mineRelationships', transformedData.columns, transformedData.rows, data.data, totalPage, currentPage, perPage));
            self.isRelationshipDataLoading(false);
        });
    };

    self.showMoreClicked = function(rel_id) {
        $('#mineRelRec_' + rel_id).toggle();
        if ($('#mineRelRec_' + rel_id).css("display") === "none") {
            $('#mineRelRecSpan_' + rel_id).text("More...");
        } else {
            $('#mineRelRecSpan_' + rel_id).text("Less");
            if (!self.relationshipInfos[rel_id]) {
                loadRelationshipInfo(rel_id);
            }
        }
    };

    function loadRelationshipInfo(relId) {
        $.ajax({
            url: 'datasetController/relationshipInfo.php',
            data: {relId: relId},
            type: 'POST',
            dataType: 'json',
            success: function(data) {
                self.relationshipInfos[data.rid] = ko.observable(new RelationshipModel.Relationship(data));
                self.isRelationshipInfoLoaded[data.rid](true);
            },
            error: function(jqXHR, statusCode, errMessage) {
                alert(errMessage);
            }
        });
    }
}