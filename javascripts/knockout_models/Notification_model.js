function newNotification(ntf_id, sender_id, action, receiver_id, target, target_id){
    var self = this;

    self.ntf_id = ntf_id;
    self.sender_id = sender_id;
    self.action = action;
    self.receiver_id = receiver_id;
    self.target = target;
    self.target_id = target_id;
}

function NotificationViewModel() {
    var self = this;
    self.ntfs = ko.observableArray();
    self.ntf_id = ko.observable();
    self.ntfsNUM = ko.observable();
    self.visible = ko.observable(false);

    self.displayMore = function(){
        self.visible(!self.visible());
    }

    $.ajax({
        url: '/Colfusion/notification/notificationController.php?action=allUserNTF',
        type: 'get',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0){
                for (var i = 0; i <data.length; i++) {
                    var tmpntf = new newNotification(data[i].ntf_id,data[i].sender,data[i].action,data[i].receiver_id,data[i].target, data[i].target_id);
                    self.ntfs.push(tmpntf);
                }
            }
            else;
        }
    });

    self.goToStory = function(ntf) {
        story_url = "/Colfusion/story.php?title="+ntf.target_id;
        //story_url = "http://localhost/Colfusion/story.php?title="+ntf.target_id;
        window.open(story_url);
    }

}

function GetCurrentNTFNum(){
    var number = 0;
    $.ajax({
        url: '../Colfusion/notification/notificationController.php?action=getNTFnum',
        type: 'get',
        dataType: 'json',
        success: function (data) {
            number = data[0].total;
            if (number != 0)
                document.getElementById("notification_icon").innerHTML += "("+number+")";
        }
    });
}

ko.bindingHandlers.ntfVisible = {
    init: function(element, valueAccessor) {
        // Initially set the element to be instantly visible/hidden depending on the value
        var value = valueAccessor();
        $(element).toggle(ko.utils.unwrapObservable(value)); // Use "unwrapObservable" so we can handle values that may or may not be observable
    },
    update: function(element, valueAccessor) {
        // Whenever the value subsequently changes, slowly fade the element in or out
        var value = valueAccessor();
        ko.utils.unwrapObservable(value) ? $(element).fadeIn() : $(element).fadeOut();
    }
};

function applyb() {
    ko.applyBindings(new NotificationViewModel);
}

