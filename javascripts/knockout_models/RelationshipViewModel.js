ko.bindingHandlers.bootstrapTooltip = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        $(element).tooltip({title: $(element).text()});
        $(element).text(valueAccessor());
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        $(element).text(valueAccessor());
    }
};

function RelationshipViewModel(sid) {
    var self = this;

    self.sid = sid;

    self.isRelationshipDataLoading = ko.observable(false);
    self.isNoRelationshipData = ko.observable(false);
    self.mineRelationshipsTable = ko.observable();

    self.isRelationshipInfoLoaded = {};
    self.relationshipInfos = {};

    self.removeRelationship = function(relId) {
        delete self.relationshipInfos[relId];
        $('tr[id="relationship_' + relId + '"]').add('#mineRelRec_' + relId).remove();
        if ($('.relationshipInfoRow').length === 0) {
            self.isNoRelationshipData(true);
        }

        $.ajax({
            url: 'datasetController/deleteRelationship.php',
            type: 'POST',
            dataType: 'json',
            data: {relId: relId}
        });
    };

    self.mineRelationships = function(perPage, pageNo) {

        self.isRelationshipDataLoading(true);
        self.isNoRelationshipData(false);

        dataSourceUtil.mineRelationship(self.sid, perPage, pageNo).done(function(data) {
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
            console.log(transformedData);
            console.log(data);

            for (var i = 0; i < data.data.length; i++) {
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
                $('#relInfoLoadingIcon_' + rel_id).show();
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
                $('#relInfoLoadingIcon_' + relId).hide();
            },
            error: function(jqXHR, statusCode, errMessage) {
                alert(errMessage);
            }
        });
    }
}