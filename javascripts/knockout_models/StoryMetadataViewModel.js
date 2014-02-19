function StoryMetadataViewModel(sid){
	var self = this;
    self.sid = sid;

    self.title = ko.observable();
    self.description = ko.observable();
    self.sourceType = ko.observable();
    self.status = ko.observable();
    self.tags = ko.observable();

    self.isFetchCurrentValuesInProgress = ko.observable(false);

    self.fetchCurrentValues = function() {
    	self.isFetchCurrentValuesInProgress(true);

    	$.ajax({
            url: "http://localhost:8080/ColFusionServer/Story/metadata/" + self.sid, //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
            	if (data.isSuccessful) {
	            	self.title(data.payload.title);
	            	self.description(data.payload.description);
	           		self.sourceType(data.payload.sourceType);
	           		self.status(data.payload.status);
	           		self.tags(data.payload.tags);

	           		self.isFetchCurrentValuesInProgress(false);
           		}
            }
        });
    };

    self.fetchCurrentValues();
}