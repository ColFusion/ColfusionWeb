var fileManager = (function() {
    var fileManager = {};

    fileManager.loadSourceAttachments = function(sid, container, loadingIconDom) {
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
            $.ajax({
                url: delete_url,
                type: 'POST',
                dataType: 'html'
            });
            
            $(deleteBtnDom).parents('.fileListItem').remove();
        }
    };

    return fileManager;
})();
