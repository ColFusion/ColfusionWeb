//wrapper for an observable that protects value until committed
// found here: http://www.knockmeout.net/2013/01/simple-editor-pattern-knockout-js.html
ko.protectedObservable = function(initialValue) {
    //private variables
    var _temp = initialValue;
    var _actual = ko.observable(initialValue);

    var result = ko.dependentObservable({
        read: _actual,
        write: function(newValue) {
            _temp = newValue;
        }
    });
    
    //commit the temporary value to our observable, if it is different
    result.commit = function() {
        if (_temp !== _actual()) {
            _actual(_temp);
        }
    };

    //notify subscribers to update their value with the original
    result.reset = function() {
        _actual.valueHasMutated();
        _temp = _actual();
    };

    result.getTemp = function() {
    	return _temp;
    }

    return result;
};


function StoryMetadataViewModel(sid){
	var self = this;
    self.sid = ko.observable(sid);
    self.userId = ko.observable();

    self.title = ko.protectedObservable();
    self.description = ko.protectedObservable();
    self.sourceType = ko.protectedObservable();
    self.status = ko.protectedObservable("draft");
    self.tags = ko.protectedObservable();
    self.dateSubmitted = ko.protectedObservable(new Date());

    self.isFetchCurrentValuesInProgress = ko.observable(false);

    self.isInEditMode = ko.observable(false);
    self.showFormLegend = ko.observable(true);

    self.fetchCurrentValues = function() {
    	var url = "http://localhost:8080/ColFusionServer/Story/metadata/" + self.sid();

    	doAjaxForFetchOrCreate(url, "");
    };

    self.createNewStory = function(userId, callBack) {
    	var url = "http://localhost:8080/ColFusionServer/Story/metadata/new/" + userId;

    	doAjaxForFetchOrCreate(url, callBack);
    }

    self.switchToEditMode = function() {
    	self.isInEditMode(true);
    }

    self.switchToReadMode = function() {
    	self.isInEditMode(false);
    }

    self.hideFormLegend = function() {
    	self.showFormLegend(false);
    }

    self.commitAll = function() {
    	self.title.commit();
    	self.description.commit();
    	self.sourceType.commit();
    	self.status.commit();
    	self.tags.commit();
    	self.dateSubmitted.commit();
    }

    self.resetAll = function() {
    	self.title.reset();
    	self.description.reset();
    	self.sourceType.reset();
    	self.status.reset();
    	self.tags.reset();
    	self.dateSubmitted.reset();
    }

    self.saveChanges = function() {
    	self.commitAll();
    	self.switchToReadMode();

    	fileManager.loadSourceAttachments(sid, $("#attachmentList2"), $("#attachmentLoadingIcon2"));
    }

    self.cancelChanges = function() {
    	self.resetAll();
    	self.switchToReadMode();
    }

    self.submitStoryMetadata = function() {
    	//self.commitAll();

    	return $.ajax({
            url: "http://localhost:8080/ColFusionServer/Story/metadata/" + self.sid(), //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'POST',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify({
            	sid : self.sid(),
            	userId : self.userId(),
            	title : self.title.getTemp(),
            	description : self.description.getTemp(),
            	status : self.status.getTemp(),
            	sourceType : self.sourceType.getTemp(),
            	tags : self.tags.getTemp(),
            	dateSubmitted : self.dateSubmitted.getTemp()
            })
        });       
    }    

    function doAjaxForFetchOrCreate(url, callBack) {
    	self.isFetchCurrentValuesInProgress(true);

    	$.ajax({
            url: url, //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
            	if (data.isSuccessful) {
            		self.sid(data.payload.sid);
            		self.userId(data.payload.userId);
	            	self.title(data.payload.title);
	            	self.description(data.payload.description);
	           		self.sourceType(data.payload.sourceType);
	           		self.status(data.payload.status);
	           		self.tags(data.payload.tags);
	           		self.dateSubmitted(new Date(data.payload.dateSubmitted));

	           		self.isFetchCurrentValuesInProgress(false);
	           		self.commitAll();

	           		if (callBack)
	           			callBack(self.sid());
           		}
            }
        });
    }
}