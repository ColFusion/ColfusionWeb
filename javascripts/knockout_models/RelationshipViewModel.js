function RelationshipViewModel(userid,sid) {
    var self = this;

    self.sid = sid;
    self.userid = userid;
    
    // Properties for message control.
    self.isRelationshipDataLoading = ko.observable(false);
    self.isNoRelationshipData = ko.observable(false);
    self.isMiningRelationshipsError = ko.observable(false);

    self.mineRelationshipsTable = ko.observable();

    self.isRelationshipInfoLoaded = {};
    self.relationshipInfos = {};  
    self.isError = {};

    self.removeRelationship = function (relId) {
        delete self.relationshipInfos[relId];
        $('tr[id="relationship_' + relId + '"]').add('#mineRelRec_' + relId).remove();
        if ($('.relationshipInfoRow').length === 0) {
            self.isNoRelationshipData(true);
        }

        $.ajax({
            url: my_pligg_base + '/datasetController/deleteRelationship.php',
            type: 'POST',
            dataType: 'json',
            data: { relId: relId }
        });
    };

    self.mineRelationships = function (perPage, pageNo) {

        self.isRelationshipDataLoading(true);
        self.isNoRelationshipData(false);
        self.isMiningRelationshipsError(false);

        dataSourceUtil.mineRelationship(self.userid, self.sid, perPage, pageNo).done(function() {

        })
        .always(function() {
            dataSourceUtil.getRelationshipsList(self.userid, self.sid, perPage, pageNo).done(function (data) {

                if (!data || !data.Control || !data.Control.cols || data.Control.cols.length === 0) {
                    // Show 'no data' text;
                    self.isRelationshipDataLoading(false);
                    self.isNoRelationshipData(true);
                    return;
                }

                $.each(data.data, function (i, relObj) {
                    self.isError[relObj.rel_id] = ko.observable(false);
                });

                self.isNoRelationshipData(false);
                // Controls.
                var perPage = data.Control.perPage;
                var totalPage = data.Control.totalPage;
                var currentPage = data.Control.pageNo;

                var transformedData = dataSourceUtil.transformRawDataToColsAndRows(data);

                for (var i = 0; i < data.data.length; i++) {
                    self.isRelationshipInfoLoaded[data.data[i].rel_id] = ko.observable(false);
                }

                self.mineRelationshipsTable(new DataPreviewViewModelProperties.Table(self.sid, 'mineRelationships', transformedData.columns, transformedData.rows, data.data, totalPage, currentPage, perPage));
               
            }).error(function() {
                self.isMiningRelationshipsError(true);
            }).always(function() {
                self.isRelationshipDataLoading(false);
            });
        });        
    };

    /*
        "More/Less" is a text cell in Data Table, so we cannot use observable to toggle those words.
        (Dom manipulation is required.)
    */
    self.showMoreClicked = function (rel_id, relRow, event) {
        self.isError[rel_id](false);

        var mineRelDom = $(event.target).parents('tr').next('tr');

        $(mineRelDom).toggle();
        if ($(mineRelDom).css("display") === "none") {
            $(event.target).text("More...");
        } else {
            $(event.target).text("Less");
            if (!self.relationshipInfos[rel_id]) {
                $(mineRelDom).find('.relInfoLoadingIcon').show();
                loadRelationshipInfo(rel_id, 1, mineRelDom);
            }
        }
    };

    function loadRelationshipInfo(relId, simThreshold, mineRelDom) {
        dataSourceUtil.loadRelationshipInfo(relId, simThreshold).done(function (data) {
            self.isRelationshipInfoLoaded[data.rid](false);
            self.relationshipInfos[data.rid] = ko.observable(new RelationshipModel.Relationship(data));
            self.isRelationshipInfoLoaded[data.rid](true);
            
            $(mineRelDom).find('.relInfoLoadingIcon').hide();
        }).error(function (jqXHR, statusCode, errMessage) {
            alert(errMessage);
            self.isError[relId](true);
        });
    }

    
}
