function newNotification(ntf_id, sender_id, action, receiver_id){
    var self = this;

    self.ntf_id = ntf_id;
    self.sender_id = sender_id;
    self.action = action;
    self.receiver_id = receiver_id;
}

function NotificationViewModel() {
    var self = this;
    self.ntfs = ko.observableArray();
    $.ajax({
        url: 'getNtfs.php?action=allUserNTF',
        type: 'get',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0){
                for (var i = 0; i <data.length; i++) {
                    var tmpntf = new newNotification(data[i].ntf_id,data[i].sender,data[i].action,data[i].target);
                    self.ntfs.push(tmpntf);
                }
            }
            else;
        },
        error: function () {
            self.isSearchError(true);
        }
    });

}