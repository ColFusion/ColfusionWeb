var restBaseUrl = "http://localhost:8080/ColFusionServer/rest/";

function AuthorViewModel(userId, firstName, lastName, login, avatarSource, karma, roleId){
	var self = this;
	self.userId = ko.observable(userId);
	self.firstName = ko.observable(firstName);
	self.lastName = ko.observable(lastName);
	self.login = ko.observable(login);
	self.avatarSource = ko.observable(avatarSource);
	self.karma = ko.observable(karma);
	self.roleId = ko.observable(roleId);
}

function DraftViewModel(sid, title, userId, description, status, licenseId, sourceType, tags, storySubmitter) {
	var self = this;
	self.sid = ko.observable(sid);
	self.title = ko.observable(title);
	self.userId = ko.observable(userId);
	self.description = ko.observable(description);
	self.status = ko.observable(status);
	self.licenseId = ko.observable(licenseId);
	self.sourceType = ko.observable(sourceType);
	self.tags = ko.observable(tags);
	self.storySubmitter = ko.observable(storySubmitter);
}

function DraftListViewModel(sid, title, createdBy, createdOn, lastUpdated, status) {
	var self = this;
	self.sid = ko.observable(sid);
	self.title = ko.observable(title);
	self.createdBy = ko.observable(createdBy);
	self.createdOn = ko.observable(createdOn);
	self.lastUpdated = ko.observable(lastUpdated);
	self.status = ko.observable(status);
}

function DraftsViewModel() {
	var self = this;
	self.drafts = ko.observableArray();
	self.chosenDraftData = ko.observable(new DraftViewModel());
	self.findAll = function() {
		$.ajax({
			url: restBaseUrl + "Story/all/1",
			type: 'GET',
			dataType: 'json',
			contentType: "application/json",
			crossDomain: true,
			success: function(data) {
				self.drafts.removeAll();
				var payload = data.payload;
				for (var i = 0; i < payload.length; i++) {
					var draft = new DraftListViewModel(payload[i].sid, payload[i].title, payload[i].user.userLogin, payload[i].entryDate, payload[i].lastUpdated, payload[i].status);
					self.drafts.push(draft);
				}
			},
			error: function(data) {
				alert("Something went wrong while getting drafts list. Please try again.");
			}
		});
	};
	self.editDraft = function(draft){
		$.ajax({
			url: restBaseUrl + "Story/metadata/"+draft.sid(),
			type: 'GET',
			dataType: 'json',
			contentType: "application/json",
			crossDomain: true,
			success: function(data) {
				var payload = data.payload;
				var dr = new DraftViewModel(payload.sid, payload.title, payload.userId, payload.description, payload.status, payload.licenseId, payload.sourceType, payload.tags, payload.storySubmitter);
				self.chosenDraftData(dr);
				window.location.href = "http://localhost/Colfusion/story.php?title="+dr.sid();
			},
			error: function(data) {
				alert("Something went wrong while getting drafts list. Please try again.");
			}
		});
	}
	self.updateDraft = function(){
		alert('hello'+self.chosenDraftData().title());
		$.ajax({
			url: restBaseUrl + "Story/metadata/"+self.chosenDraftData().sid(),
			type: 'POST',
			data: ko.toJSON(self.chosenDraftData()),
			dataType: 'json',
			contentType: "application/json",
			crossDomain: true,
			success: function(data) {
				var payload = data.payload;
			},
			error: function(data) {
				alert("Something went wrong while updating the draft. Please try again.");
			}
		});
	}
	self.findAll();
}

ko.applyBindings(new DraftsViewModel(), $("#draftsContainer")[0]);