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
    $.ajax({
        url: 'notificationController.php?action=allUserNTF',
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
        story_url = "http://localhost/Colfusion/story.php?title="+ntf.target_id;
        window.open(story_url);
    }

}

function GetCurrentNTFNum(){
    var number = 0;
    $.ajax({
        url: '../notification/notificationController.php?action=getNTFnum',
        type: 'get',
        dataType: 'json',
        success: function (data) {
            number = data[0].total;
            if (number != 0)
                document.getElementById("notification_icon").innerHTML += "("+number+")";
        }
    });
}