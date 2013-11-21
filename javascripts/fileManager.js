var fileManager = (function() {
    var fileManager = {};

    fileManager.loadSourceAttachments = function(sid, container) {
        var loadingIconDom = $('#attachmentLoadingIcon');
        $(loadingIconDom).show();
        $.ajax({
            type: 'POST',
            url: "fileManagers/attachmentList.php",
            data: {sid: sid},
            success: function(data) {
                $(container).children('.fileListItem').remove();
                $(container).prepend(data);
                
                // This is only useful at story page.               
                var fileTable = $(container).parents('#upload_result').children('table');            
                if ($(container).children('.fileListItem').length < 1) {
                      $(fileTable).hide();
                } else {
                      $(fileTable).prev('br').remove();
                }
                
                $(loadingIconDom).hide();
            },
            dataType: 'html'
        });
    };
    
    fileManager.deleteFile = function(deleteBtnDom, title, delete_url){
        if(confirm("Do you want to remove " + title + " ?")){
            $("body").find("#attach_remove_noti_wrap").show();
            $('body').append('<div id="fade" style="position:absolute;background: #000;position: fixed; left: 0; top: 0;z-index: 10;width: 100%; height: 100%;opacity: .70;"></div>'); //Add the fade layer to bottom of the body tag.
            $('body #fade').css({'filter' : 'alpha(opacity=70)'}).fadeIn();
            $("body #fade,body #attach_remove_noti_cancel").bind("click",function(){
                $("body #attach_remove_noti_wrap").fadeOut("fast");
                $("body #fade").remove();
                $("body #attach_remove_noti_submit").unbind();
                $(this).unbind();
                return;
            });

            $("body #attach_remove_noti_submit").bind("click",function(){
                $.ajax({
                    url: delete_url,
                    type: 'POST',
                    dataType: 'html'
                });
                
                $(deleteBtnDom).parents('.fileListItem').remove();                
                $("body #attach_remove_noti_wrap").hide();
                $("body #fade").remove();
                $("body #attach_remove_noti_cancel").unbind();
                $("body #fade").unbind();
                $(this).unbind();
            });
            /*
            $.ajax({
                url: delete_url,
                type: 'POST',
                dataType: 'html'
            });
            
            $(deleteBtnDom).parents('.fileListItem').remove();
            */
        }
    };

    return fileManager;
})();
