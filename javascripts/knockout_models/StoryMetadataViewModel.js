var addAuthorTypeaheadTemplate = '<div class="dataColumnSuggestion">' +
        '<div style="overflow: auto; margin-bottom: 5px;">' +
        '<p class="dataColumnSuggestion-Author">' +
        '{{userInfo}}' +
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
                url: ColFusionServerUrl + "/User/lookup?searchTerm=%QUERY&limit=10",//'datasetController/findDataset.php?searchTerm=%QUERY',
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
                    	
                        var userIntoString = "";

                        if (user.lastName.length !== 0) {
                            userIntoString += user.lastName;
                        }

                        if (user.firstName.length !== 0) {
                            if (userIntoString.length === 0) {
                                userIntoString += user.firstName;
                            }
                            else {
                                userIntoString += ", " + user.firstName;
                            }
                        }

                        if (userIntoString.length === 0) {
                            userIntoString = user.login;
                        }
                        else {
                            userIntoString += " (" + user.login + ")";
                        }

                    	user.userInfo = userIntoString;

                        return user;
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
};

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

var StoryMetadataHistoryLogRecordViewModel = function() {
	self = this;
	self.hid = ko.observable();
	self.author = ko.observable();
	self.whenSaved = ko.observable();
	self.item = ko.observable();
	self.reason = ko.observable();
	self.itemValue = ko.observable();
}

var StoryMetadataHistoryViewModel = function() {
	self = this;
	self.sid = ko.observable();
	self.historyItem = ko.observable();
	self.historyLogRecords = ko.observableArray();
}

var AttachmentViewModel = function(fileId, sid, userId, title, filename, description, size, uploadTime) {
    self = this;
    self.fileId = ko.observable(fileId);
    self.sid = ko.observable(sid);
    self.userId = ko.observable(userId);
    self.title = ko.observable(title);
    self.filename = ko.observable(filename);
    self.description = ko.observable(description);
    self.size = ko.observable(size);
    self.uploadTime = ko.observable(uploadTime);

    self.fileDownloadUrl = ko.computed(function() {
        return my_pligg_base + "/fileManagers/downloadSourceAttachment.php?fileId=" + self.fileId();
    });

    self.iconurl =  ko.computed(function() {
            var filename = self.filename();

            var extension = filename.substring(filename.lastIndexOf(".") + 1, filename.length);//"jpg";
            
            var icon_dir = 'icons/';
            var icon_filename = "";
            switch(extension){
                case 'doc':          
                case 'docx':              
                case 'xls':            
                case 'xlsx':             
                case 'xlsx':              
                case 'xlsx':         
                case 'ppt':              
                case 'pptx':              
                case 'pdf':             
                case 'sql':
                    icon_filename = extension + '.jpg';
                    break;
                case 'jpg':
                case 'jpeg':
                case 'png':
                case 'tiff':
                case 'gif':
                    icon_filename = 'image.png';
                    break;
                default:
                    icon_filename = 'file.jpg';
                    break;
            }

            return my_pligg_base + "/fileManagers/" + icon_dir + icon_filename;        
        }); 

    self.deleteAttachment = function() {
        fileManager.deleteFile(self.title(), my_pligg_base + "/fileManagers/deleteSourceAttachment.php?fileId=" + self.fileId());
    }; 
}

function StoryMetadataViewModel(sid, userId){
    
  	var self = this;
    self.sid = ko.observable(sid);
    self.userId = ko.observable(userId);
    
    self.submitter = ko.observable();
    self.storyAuthors = ko.observableArray();
    self.removedStoryAuthors = ko.observableArray();
    self.licenseValue = ko.observable();
    self.licenseName = ko.observable();

    self.title = ko.observable();
    self.description = ko.observable();
    self.sourceType = ko.observable();
    self.status = ko.observable("draft");
    self.tags = ko.observable();
    self.dateSubmitted = ko.observable(new Date());

    self.editReason = ko.observable();

    self.attachments = ko.observableArray();

    self.storyMetadataHistory = ko.observable();

    self.selectedLookedUpUser = ko.observable();

    self.isFetchCurrentValuesInProgress = ko.observable(false);
    self.isFetchHistoryInProgress = ko.observable(false)
    self.isFetchHistoryErrorMessage = ko.observable("");
    self.historyLogHeaderText = ko.observable();

    self.isInEditMode = ko.observable(false);
    self.showFormLegend = ko.observable(true);

//----------------------------------------
    //
    self.availableLicenses = new Array();

     // sent ajax request to get license content  
    $.ajax({
        url: ColFusionServerUrl + "/Story/metadata/license",
        async:false, 
        type: 'GET',
        dataType: 'json',
        contentType: "application/json",
        crossDomain: true,
        success:function(data){
            if (data.isSuccessful) {
                var payload = data.payload;
                var licenseList = payload.licenseList;
                for (var i = 0;i<licenseList.length;i++){
                    newLicense = new Array();
                    newLicense['licenseName'] = licenseList[i].licenseName;
                    newLicense['description'] =licenseList[i].licenseDes;
                    newLicense['URL'] = licenseList[i].licenseUrl;
                    newLicense['licenseId'] = licenseList[i].licenseId;
                    self.availableLicenses.push(newLicense);
                }
            }

        }
    });

    //-------------------------------------------------
    /*function LicenseSelection(initial) {
        var self = this;
        self.license = ko.observable(initial);

        self.formattedDescription = ko.computed(function() {
            var description = self.license().description;
            
            return description;        
        });  
        self.formattedURL = ko.computed(function() {
            var URL = self.license().URL;
            return URL;
        });
    }*/
    //-------------------------------------------------


    // Editable data
    self.licenseOp = ko.observableArray(self.availableLicenses);
    self.licenseValue = ko.observable();
//----------------------------------------
    self.fetchCurrentValues = function() {
    	var url = ColFusionServerUrl + "/Story/metadata/" + self.sid();

    	doAjaxForFetchOrCreate(url, "");
    };

    self.createNewStory = function(callBack) {
    	var url = ColFusionServerUrl + "/Story/metadata/new/" + self.userId();

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

        if (!isUserAuthor) {
            if (self.submitter() !== undefined && self.submitter().userId() == self.userId()) {
                isUserAuthor = true;
            }
        }

    	return isUserAuthor && ! self.isInEditMode();
    }

    self.switchToReadModeAndUpdateAttachments = function() {
    	
    	self.switchToReadMode();

        self.getAttachments();

        


//    	fileManager.loadSourceAttachments(sid, $("#attachmentList2"), $("#attachmentLoadingIcon2"));
    }

    //TODO: read from server old data again
    self.cancelChanges = function() {

        self.editReason("");
        
    	self.switchToReadMode();

    	self.storyAuthors.removeAll();

    	self.fetchCurrentValues();
    }

    self.submitStoryMetadata = function() {
    	//self.commitAll();
    	var data = {
            	sid : self.sid(),
            	userId : self.userId(),
            	title : self.title(),
            	description : self.description(),
            	status : self.status(),
            	sourceType : self.sourceType(),
            	tags : self.tags(),
            	dateSubmitted : self.dateSubmitted(),
                editReason : self.editReason(),
                licenseId:self.licenseValue().licenseId
        	};
        self.editReason("");
        //alert(self.licenseValue().licenseId);
        data.storySubmitter = self.submitter().getTempAsJSONObj();
        data.storyAuthors = $.map(self.storyAuthors(), function (item) {
            		return 	item.getTempAsJSONObj();});
        data.removedStoryAuthors = $.map(self.removedStoryAuthors(), function (item) {
            		return 	item.getTempAsJSONObj();});
        for (var i =0;i<self.availableLicenses.length;i++){
            if (self.availableLicenses[i]['licenseId']==self.licenseValue().licenseId){
                 license = self.availableLicenses[i];
                 self.licenseValue(self.availableLicenses[i]);
            }
        }
        self.licenseName(license['description']);
    	return $.ajax({
            url: ColFusionServerUrl + "/Story/metadata/" + self.sid(), //my_pligg_base + "/DataImportWizard/generate_ktr.php?phase=0",
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

    self.showHistory = function(historyItem) {
    	self.isFetchHistoryInProgress(true);
    	self.historyLogHeaderText("Edit History Log for " + historyItem);

    	$.ajax({
            url: ColFusionServerUrl + "/Story/metadata/" + self.sid() + "/history/" + historyItem,
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success: function(data) {
            	self.isFetchHistoryInProgress(false);
            	if (data.isSuccessful) {
            		var payload = data.payload;

            		var storyMetadataEditHistory = new StoryMetadataHistoryViewModel();
            		storyMetadataEditHistory.sid(payload.sid);
            		storyMetadataEditHistory.historyItem(payload.historyItem);

            		for (var i = 0; i < payload.historyLogRecords.length; i++) {
            			var historyRecord = payload.historyLogRecords[i];

            			var storyMetadataHistoryLogRecord = new StoryMetadataHistoryLogRecordViewModel();

            			storyMetadataHistoryLogRecord.hid(historyRecord.hid);
            			storyMetadataHistoryLogRecord.whenSaved(historyRecord.whenSaved);
            			storyMetadataHistoryLogRecord.item(historyRecord.item);
            			storyMetadataHistoryLogRecord.reason(historyRecord.reason);
            			storyMetadataHistoryLogRecord.itemValue(historyRecord.itemValue);

            			var author = new StoryAuthorModel(historyRecord.author.userId, historyRecord.author.firstName, 
            			historyRecord.author.lastName, historyRecord.author.login, 
            			historyRecord.author.avatarSource, historyRecord.author.karma, historyRecord.author.roleId);

            			storyMetadataHistoryLogRecord.author(author);

            			storyMetadataEditHistory.historyLogRecords.push(storyMetadataHistoryLogRecord);
            		};

            		self.storyMetadataHistory(storyMetadataEditHistory);
           		}
           		else {
           			self.isFetchHistoryErrorMessage("Something went wrong while fetching history for " + historyItem + 
           				". Please try again.");
           		}
            },
            error: function(data) {
            	self.isFetchHistoryInProgress(false);
            	self.isFetchHistoryErrorMessage("Something went wrong while fetching history for " + historyItem + 
           				". Please try again.");
            }
        });
    }

    function doAjaxForFetchOrCreate(url, callBack) {
    	self.isFetchCurrentValuesInProgress(true);
        //alert(url);
    	$.ajax({
            url: url, 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            //crossDomain: true,
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
                    
                    //self.licenseName(data.payload.licenseId);
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
                    for (var i =0;i<self.availableLicenses.length;i++){
                        if (self.availableLicenses[i]['licenseId']==data.payload.licenseId){
                             license = self.availableLicenses[i];
                             self.licenseValue(self.availableLicenses[i]);
                        }
                    }
                    self.licenseName(license['description']);

                    self.getAttachments();

	           		self.isFetchCurrentValuesInProgress(false);
	           		
	           		if (callBack)
	           			callBack(self.sid(), self.userId());
           		}
            }
        });
    }

    self.getAttachments = function() {
        $.ajax({
            url: ColFusionServerUrl + "/Story/" + self.sid() + "/AttachmentList", 
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            success:function(data){

                if (data.isSuccessful) {
                    var payload = data.payload;
                    
                    self.attachments.removeAll();

                    for (var i = 0; i < payload.length; i++){
                        
                        var attachment = new AttachmentViewModel(payload[i].fileId, 
                            payload[i].sid, 
                            payload[i].userId, 
                            payload[i].title, 
                            payload[i].filename, 
                            payload[i].description, 
                            payload[i].size, 
                            payload[i].uploadTime);
                        
                        self.attachments.push(attachment);
                    }
                }

            }
        });
    }
}