//wrapper for an observable that protects value until committed
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

    return result;
};


function StoryMetadataViewModel(sid){
	var self = this;
    self.sid = sid;

    self.title = ko.protectedObservable();
    self.description = ko.protectedObservable();
    self.sourceType = ko.protectedObservable();
    self.status = ko.protectedObservable();
    self.tags = ko.protectedObservable();

    self.isFetchCurrentValuesInProgress = ko.observable(false);

    self.isInEditMode = ko.observable(false);
    self.showFormLegend = ko.observable(true);

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
	           		self.commitAll();
           		}
            }
        });
    };

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
    }

    self.resetAll = function() {
    	self.title.reset();
    	self.description.reset();
    	self.sourceType.reset();
    	self.status.reset();
    	self.tags.reset();
    }

    self.saveChanges = function() {
    	self.commitAll();
    	self.switchToReadMode();
    }

    self.cancelChanges = function() {
    	self.resetAll();
    	self.switchToReadMode();
    }

    self.fetchCurrentValues();
}