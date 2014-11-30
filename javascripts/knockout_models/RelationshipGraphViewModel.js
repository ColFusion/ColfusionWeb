var advDebug = false;

function RelationshipGraphData() {
    var self = this;

    self.nodes = [];
    self.edges = [];
}

function RelationshipGraphViewModel() {
    var self = this;

    self.isSearching = ko.observable(false);
    self.isNoResultTextShown = ko.observable(false);
    self.isSearchError = ko.observable(false);

    //Maybe don't need to make it observable
    self.graphData = ko.observable(new RelationshipGraphData());

    self.search = function () {

        debugger;

        self.isSearching(true);
        self.isSearchError(false);
        self.isNoResultTextShown(false);
        
        $.ajax({
            url: advDebug? 'advSearch.json' : ColFusionServerUrl + "/Story/relationshipgraph",
            dataType: 'json',
            type: 'GET',
            contentType: "application/json",
            crossDomain: true,
            success: function(data){

                if (data.isSuccessful) {
                    var payload = data.payload;

                    var relationshipGraphData = new RelationshipGraphData();
                    relationshipGraphData.nodes = payload.nodes;
                    relationshipGraphData.edges = payload.edges;

                    self.graphData(relationshipGraphData);
                }
                else {
                    alert("Couldn't get relationship graph. Try again later.");
                    self.isSearchError(true);
                }
            },
            error: function () {
                self.isSearchError(true);
            }
        }).always(function () {
            self.isSearching(false);
        });
    };

    // Adapt to story-page-based relationship info template.
    // TODO: implement.
    self.removeRelationship = function () {
    };
}