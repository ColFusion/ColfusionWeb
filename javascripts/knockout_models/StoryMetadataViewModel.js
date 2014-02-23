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

var StoryAuthorModel = function(userId, firstName, lastName, login, avatarSource, karma, storyUserRoleId, storyUserRoleName,
 								storyUserRoleDescription) {
	var self = this;

	self.userId = ko.protectedObservable(userId);
	self.firstName = ko.protectedObservable(firstName);
	self.lastName = ko.protectedObservable(lastName);
	self.login = ko.protectedObservable(login);
	self.avatarSource = ko.protectedObservable(avatarSource);
	self.karma = ko.protectedObservable(karma);
	self.storyUserRoleId = ko.protectedObservable(storyUserRoleId);
	self.storyUserRoleName = ko.protectedObservable(storyUserRoleName);
	self.storyUserRoleDescription = ko.protectedObservable(storyUserRoleDescription);

	self.commit = function() {
		self.userId.commit();
		self.firstName.commit();
		self.lastName.commit();
		self.login.commit();
		self.avatarSource.commit();
		self.karma.commit();
		self.storyUserRoleId.commit();
		self.storyUserRoleName.commit();
		self.storyUserRoleDescription.commit();
	}

	self.reset = function() {
		self.userId.reset();
		self.firstName.reset();
		self.lastName.reset();
		self.login.reset();
		self.avatarSource.reset();
		self.karma.reset();
		self.storyUserRoleId.reset();
		self.storyUserRoleName.reset();
		self.storyUserRoleDescription.reset();
	}
};

function StoryMetadataViewModel(sid){
	var self = this;
    self.sid = ko.observable(sid);
    
    self.submitter = ko.protectedObservable();

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
    	self.submitter.commit();
    }

    self.resetAll = function() {
    	self.title.reset();
    	self.description.reset();
    	self.sourceType.reset();
    	self.status.reset();
    	self.tags.reset();
    	self.dateSubmitted.reset();
    	self.submitter.reset();
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
            		self.submitter(new StoryAuthorModel(data.payload.storySubmitter.userId, data.payload.storySubmitter.firstName, 
            			data.payload.storySubmitter.lastName, data.payload.storySubmitter.login, 
            			data.payload.storySubmitter.avatarSource, data.payload.storySubmitter.karma, 
            			data.payload.storySubmitter.storyUserRoleId, data.payload.storySubmitter.storyUserRoleName,
 								data.payload.storySubmitter.storyUserRoleDescription));

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