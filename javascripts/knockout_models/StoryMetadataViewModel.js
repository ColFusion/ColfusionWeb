var addAuthorTypeaheadTemplate = '<div class="dataColumnSuggestion">' +
        '<div style="overflow: auto; margin-bottom: 5px;">' +
        '<p class="dataColumnSuggestion-Author">' +
        '{{userInfo}} ({{login}})' +
        '</p>' +
        '</div>' +
        '</div>';

// valueAccessor should be dataset.
// Dom element should be input.
ko.bindingHandlers.searchUsersTypeahead = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

        var search_typeahead_tpl = addAuthorTypeaheadTemplate;

        var storyModel = valueAccessor();

        $(element).on('keyup', function(event) {
            var code = event.keyCode || event.which;
            if (code != 13) { //Enter keycode
                storyModel.selectedLookedUpUser(null);
                $(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingIcon').show();
                $(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingText').show();
            }
        }).typeahead({
            name: 'users',
            remote: {
                url: "http://localhost:8080/ColFusionServer/User/lookup?searchTerm=%QUERY&limit=10",//'datasetController/findDataset.php?searchTerm=%QUERY',
                cache: false,
                maxParallelRequests: 2,
                filter: function(data) {

                	$(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingIcon').hide();
                	$(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingText').hide();

                    if (data === null) {
                        return [];
                    }
                    else if (!data.isSuccessful) {
						return [];
                    }
                    
                    return $.map(data.payload, function(user) {
                    	var userInfo = user;
                    	user.userInfo = user.lastName + ", " + user.firstName;

                    	return userInfo;
                    });
                }
            },
            valueKey: 'userInfo',
            template: search_typeahead_tpl,
            engine: Hogan
        }).bind('typeahead:selected', function(event, datum) {
            storyModel.selectedLookedUpUser(new StoryAuthorModel(datum.userId, datum.firstName, datum.lastName, datum.login, 
            	datum.avatarSource, datum.karma, datum.roleId));
            $(this).parent().next('button').prop("disabled", false);
        }).bind('typeahead:opened', function() {
            $(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingIcon').hide();
            $(element).parents("#userAuthorLookupDiv").find('.userAuthorSearchLoadingText').hide();
        });
    },
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {

    }
};


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



var AuthorRoleModel = function (roleId, roleName, roleDescription) {
	var self = this;

	self.roleId = ko.protectedObservable(roleId);
	self.roleName = ko.protectedObservable(roleName);
	self.roleDescription = ko.protectedObservable(roleDescription);

	self.commit = function () {
		self.roleId.commit();
		self.roleName.commit();
		self.roleDescription.commit();
	}

	self.reset = function () {
		self.roleId.reset();
		self.roleName.reset();
		self.roleDescription.reset();
	}
}

//TODO, FIXME: should be read from the server
var authorRoles = [ new AuthorRoleModel(1, "submitter", "the person who submits the data to Col*Fusion"), 
	new AuthorRoleModel(2, "owner", "the person who owns the data to Col*Fusion")
];

var StoryAuthorModel = function(userId, firstName, lastName, login, avatarSource, karma, roleId) {
	var self = this;

	self.userId = ko.protectedObservable(userId);
	self.firstName = ko.protectedObservable(firstName);
	self.lastName = ko.protectedObservable(lastName);
	self.login = ko.protectedObservable(login);
	self.avatarSource = ko.protectedObservable(avatarSource);
	self.karma = ko.protectedObservable(karma);
	self.roleId = ko.protectedObservable(roleId);
	
	self.authorInfo = ko.computed(function() {
		var info = "";

		if (self.lastName()) {
			info = info + self.lastName(); + ", " + self.firstName;
		}

		if (self.firstName()) {
			if (info.length > 0) {
				info = info + ", " + self.firstName();
			}
			else {
				info = self.firstName();
			}
		}

		if (info.length == 0) {
			info = self.login();
		}

		return info;
	});

	self.commit = function() {
		self.userId.commit();
		self.firstName.commit();
		self.lastName.commit();
		self.login.commit();
		self.avatarSource.commit();
		self.karma.commit();
		self.roleId.commit();
	}

	self.reset = function() {
		self.userId.reset();
		self.firstName.reset();
		self.lastName.reset();
		self.login.reset();
		self.avatarSource.reset();
		self.karma.reset();
		self.roleId.reset();
	}

	self.getTemp = function() {
		return new StoryAuthorModel(self.userId.getTemp(), self.firstName.getTemp(), self.lastName.getTemp(), self.login.getTemp(), 
			self.avatarSource.getTemp(), self.karma.getTemp(), self.roleId.getTemp());
	}

	self.getTempAsJSONObj = function() {
		var temp = self.getTemp();
		return 	{
            		userId : temp.userId(),
					firstName : temp.firstName(),
					lastName : temp.lastName(),
					login : temp.login(),
					avatarSource : temp.avatarSource(),
					karma : temp.karma(),
					roleId : temp.roleId()
        		};
    }
};

function StoryMetadataViewModel(sid){
	var self = this;
    self.sid = ko.observable(sid);
    
    self.submitter = ko.protectedObservable();
    self.storyAuthors = ko.observableArray();

    self.title = ko.protectedObservable();
    self.description = ko.protectedObservable();
    self.sourceType = ko.protectedObservable();
    self.status = ko.protectedObservable("draft");
    self.tags = ko.protectedObservable();
    self.dateSubmitted = ko.protectedObservable(new Date());

    self.selectedLookedUpUser = ko.observable();

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

    	//TODO: might be better to do with map.
    	for (var i = 0; i < self.storyAuthors().length; i++) {
    		self.storyAuthors()[i].commit();
    	};
    }

    self.resetAll = function() {
    	self.title.reset();
    	self.description.reset();
    	self.sourceType.reset();
    	self.status.reset();
    	self.tags.reset();
    	self.dateSubmitted.reset();
    	self.submitter.reset();

    	//TODO: might be better to do with map.
    	for (var i = 0; i < self.storyAuthors().length; i++) {
    		self.storyAuthors()[i].reset();
    	};
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
    	var data = {
            	sid : self.sid(),
            	title : self.title.getTemp(),
            	description : self.description.getTemp(),
            	status : self.status.getTemp(),
            	sourceType : self.sourceType.getTemp(),
            	tags : self.tags.getTemp(),
            	dateSubmitted : self.dateSubmitted.getTemp()
        	};

        data.storySubmitter = self.submitter().getTempAsJSONObj();
        data.storyAuthors = $.map(self.storyAuthors(), function (item) {
            		return 	item.getTempAsJSONObj();});

    	return $.ajax({
            url: "http://localhost:8080/ColFusionServer/Story/metadata/" + self.sid(), //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
            type: 'POST',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify(data)       
    	});
    }    

    self.addAuthor = function() {
    	if (self.selectedLookedUpUser) {
    		self.storyAuthors.push(self.selectedLookedUpUser().getTemp());
    		self.selectedLookedUpUser(null);
    		$("#lookUpUsersAuthors").typeahead("setQuery", "");
    	}
    }

    self.removeAuthor = function (author) {
    	self.storyAuthors.remove(author);
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

         //    		var submitterRole = new AuthorRoleModel(data.payload.storySubmitter.storyUserRoleId, data.payload.storySubmitter.storyUserRoleName,
 								// data.payload.storySubmitter.storyUserRoleDescription);

            		var submitterModel = new StoryAuthorModel(data.payload.storySubmitter.userId, data.payload.storySubmitter.firstName, 
            			data.payload.storySubmitter.lastName, data.payload.storySubmitter.login, 
            			data.payload.storySubmitter.avatarSource, data.payload.storySubmitter.karma, data.payload.storySubmitter.roleId);

            		self.submitter(submitterModel);

	            	self.title(data.payload.title);
	            	self.description(data.payload.description);
	           		self.sourceType(data.payload.sourceType);
	           		self.status(data.payload.status);
	           		self.tags(data.payload.tags);
	           		self.dateSubmitted(new Date(data.payload.dateSubmitted));

	           		var authors = data.payload.storyAuthors;
	           		if (authors) {
		           		for (var i = 0; i < authors.length - 1; i++) {

		           			// var authorRole = new AuthorRoleModel(authors[i].storyUserRoleId, authors[i].storyUserRoleName, 
		           			// 					authors[i].storyUserRoleDescription);

		           			var authorModel = new StoryAuthorModel(authors[i].userId, authors[i].firstName, 
	            			authors[i].lastName, authors[i].login, authors[i].avatarSource, authors[i].karma, authors[i].roleId);
	            			
	            			self.storyAuthors.push(authorModel);
		           		};
		           	};

	           		self.isFetchCurrentValuesInProgress(false);
	           		self.commitAll();

	           		if (callBack)
	           			callBack(self.sid());
           		}
            }
        });
    }
}