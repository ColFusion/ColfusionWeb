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


var AuthorRoleModel = function (roleId, roleName, roleDescription) {
	var self = this;

	self.roleId = ko.observable(roleId);
	self.roleName = ko.observable(roleName);
	self.roleDescription = ko.observable(roleDescription);
}

//TODO, FIXME: should be read from the server
var authorRoles = [ new AuthorRoleModel(1, "submitter", "the person who submits the data to Col*Fusion"), 
	new AuthorRoleModel(2, "owner", "the person who owns the data to Col*Fusion")
];

var StoryAuthorModel = function(userId, firstName, lastName, login, avatarSource, karma, roleId) {
	var self = this;

	self.userId = ko.observable(userId);
	self.firstName = ko.observable(firstName);
	self.lastName = ko.observable(lastName);
	self.login = ko.observable(login);
	self.avatarSource = ko.observable(avatarSource);
	self.karma = ko.observable(karma);
	self.roleId = ko.observable(roleId);

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

	self.roleName = ko.computed(function() {
		if (self.roleId() >= 1)
			return authorRoles[self.roleId() - 1].roleName();
		return "";
	});

	self.getTempAsJSONObj = function() {
		return 	{
            		userId : self.userId(),
					firstName : self.firstName(),
					lastName : self.lastName(),
					login : self.login(),
					avatarSource : self.avatarSource(),
					karma : self.karma(),
					roleId : self.roleId()
        		};
    }
};

function StoryMetadataViewModel(sid, userId){
	var self = this;
    self.sid = ko.observable(sid);
    self.userId = ko.observable(userId);
    
    self.submitter = ko.observable();
    self.storyAuthors = ko.observableArray();
    self.removedStoryAuthors = ko.observableArray();

    self.title = ko.observable();
    self.description = ko.observable();
    self.sourceType = ko.observable();
    self.status = ko.observable("draft");
    self.tags = ko.observable();
    self.dateSubmitted = ko.observable(new Date());

    self.selectedLookedUpUser = ko.observable();

    self.isFetchCurrentValuesInProgress = ko.observable(false);

    self.isInEditMode = ko.observable(false);
    self.showFormLegend = ko.observable(true);

    self.fetchCurrentValues = function() {
    	var url = "http://localhost:8080/ColFusionServer/Story/metadata/" + self.sid();

    	doAjaxForFetchOrCreate(url, "");
    };

    self.createNewStory = function(callBack) {
    	var url = "http://localhost:8080/ColFusionServer/Story/metadata/new/" + self.userId();

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

    self.showEditButton = function() {
    	var isUserAuthor = false;

    	for (var i = 0; i < self.storyAuthors().length; i++) {
    		if (self.storyAuthors()[i].userId() == self.userId()) {
    			isUserAuthor = true;
    			break;
    		}
    	};

    	return isUserAuthor && ! self.isInEditMode();
    }

    self.switchToReadModeAndUpdateAttachments = function() {
    	
    	self.switchToReadMode();

    	fileManager.loadSourceAttachments(sid, $("#attachmentList2"), $("#attachmentLoadingIcon2"));
    }

    //TODO: read from server old data again
    self.cancelChanges = function() {
    	self.switchToReadMode();

    	self.storyAuthors.removeAll();

    	self.fetchCurrentValues();
    }

    self.submitStoryMetadata = function() {
    	//self.commitAll();
    	var data = {
            	sid : self.sid(),
            	title : self.title(),
            	description : self.description(),
            	status : self.status(),
            	sourceType : self.sourceType(),
            	tags : self.tags(),
            	dateSubmitted : self.dateSubmitted()
        	};

        data.storySubmitter = self.submitter().getTempAsJSONObj();
        data.storyAuthors = $.map(self.storyAuthors(), function (item) {
            		return 	item.getTempAsJSONObj();});
        data.removedStoryAuthors = $.map(self.removedStoryAuthors(), function (item) {
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
    		self.storyAuthors.push(self.selectedLookedUpUser());
    		self.selectedLookedUpUser(null);
    		$("#lookUpUsersAuthors").typeahead("setQuery", "");
    	}
    }

    self.removeAuthor = function (author) {
    	self.removedStoryAuthors.push(author);
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
		           		for (var i = 0; i < authors.length; i++) {

		           			// var authorRole = new AuthorRoleModel(authors[i].storyUserRoleId, authors[i].storyUserRoleName, 
		           			// 					authors[i].storyUserRoleDescription);

		           			var authorModel = new StoryAuthorModel(authors[i].userId, authors[i].firstName, 
	            			authors[i].lastName, authors[i].login, authors[i].avatarSource, authors[i].karma, authors[i].roleId);
	            			
		           			authorModel.roleId.subscribe(function(newValue) {
						    	alert("Change happen " + newValue);
							});

		           			self.storyAuthors.push(authorModel);
		           		};
		           	};

	           		self.isFetchCurrentValuesInProgress(false);
	           		
	           		if (callBack)
	           			callBack(self.sid());
           		}
            }
        });
    }
}