var url = "deal_with_request.php";
// trim the white space
function trim(str){   
    return str.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,'');   
}
function trimLeft(s){  
    var whitespace = new String(" \t\n\r");  
    var str = new String(s);  
    if (whitespace.indexOf(str.charAt(0)) != -1) {  
        var j=0, i = str.length;  
        while (j < i && whitespace.indexOf(str.charAt(j)) != -1){  
            j++;  
        }  
        str = str.substring(j, i);  
    }  
    return str;  
}  
    //trim the white space from right   
function trimRight(s){  
    if(s == null) return "";  
    var whitespace = new String(" \t\n\r");  
    var str = new String(s);  
    if (whitespace.indexOf(str.charAt(str.length-1)) != -1){  
        var i = str.length - 1;  
        while (i >= 0 && whitespace.indexOf(str.charAt(i)) != -1){  
            i--;  
        }  
        str = str.substring(0, i+1);  
    }  
    return str;  
}

/*
//escape the special char
function escapeSpecial(text,original,replacement) {
    while (text.match(original)!=null) {
        text=text.replace(original,replacement);
    }
}
*/
     
function getDescription() {
    var content=document.getElementById("des_input").value;
    //content=content.replace('\r\n','<br />');
    while (content.match("\n") !=null) {
       content=content.replace('\n','<br>');   
    }
    //escapeSpecial(content,'\n','<br/>');
           
    return content;
}

function getNotification(element) {
    
    var noti = document.getElementById(element).value;
    while (noti.match("\n") !=null) {
       noti=noti.replace('\n','<br>');   
    }     
    return noti;
}

var category_value=0;
function getOption(value) {
    category_value = value;
    return;
}

function showShade() {
    $('body').append('<div id="fade" style="position:absolute;background: #000;position: fixed; left: 0; top: 0;z-index: 10;width: 100%; height: 100%;opacity: .70;"></div>'); //Add the fade layer to bottom of the body tag.
    $('#fade').css({'filter' : 'alpha(opacity=70)'}).fadeIn();
}

//record the current vision for rollback
var currentTitle;
var currentDescription;
var currentCategory;
var currentTags;
function getCurrentVision(section) {  //section includes title_vision,des_vision,tags_vision
    var currentVision;
    for (var i=0;i<$("input[name="+section+"]").length;i++) {
        var current = $("input[name="+section+"]").eq(i).attr("checked");
        if (current) {
            currentVision = i;
            break;
        }
    }
    return currentVision;
}
    
$(document).ready(function() {
    
    
    
    $("#title_popup").hide();
    $("#des_popup").hide();
    $("#category_popup").hide();
    $("#tags_popup").hide();
    $("#notification2").hide();
    $("#save_button").hide();
    $("#cancel_button").hide();
    //$(".deleteFileBtnWrapper").hide();
    
    
    
    //record the current vision for rollback
    currentTitle = getCurrentVision("title_popup");
    currentDescription = getCurrentVision("des_popup");
    currentCategory = getCurrentVision("category_popup");
    currentTags = getCurrentVision("tags_popup");
    //alert(currentCategory);
    $("#edit_button").click(function() {
        $(this).hide();
        $("body").find(".deleteFileBtnWrapper").show();
        $("#save_button").show();
        $("#cancel_button").show();        
        //change the mode of title to editable
        var titleOriginalTxt = $("#dataset_title").html();
        var input = '<input id="title_input" type="text" style="width:250px" maxlength="40" value="' +titleOriginalTxt+ '">';
        var titleHistory = '<span id="title_history" style="padding-left:10px;"><a>[history]</a></span>';
        $("#dataset_title").empty();
        $("#dataset_title").html(input+titleHistory);
        
        //change the mode of description to editable
        var desOriginalTxt = $("#profile_datasetDescription").html();
        
        while (desOriginalTxt.match("<br>") !=null) {
           desOriginalTxt=desOriginalTxt.replace('<br>','\n');   
        } 
        var input = '<textarea id="des_input" cols="60" rows="15" style="width:450px;">'+desOriginalTxt+ '</textarea>';
        var descriptionHistory = '<span id="des_history" style="padding-left:10px;"><a>[history]</a></span>';
        $("#profile_datasetDescription").empty();
        $("#profile_datasetDescription").html(input+descriptionHistory);
        
        //change the mode of category to editable
        var categoryOption = $("#dataset_category").html();     
        var select = '<select id="category" onchange="getOption(this.value)"><option value="1">News</option><option value="2">Bussiness</option><option value="3">History</option></select>';
        var categoryHistory = '<span id="category_history" style="padding-left:10px;"><a>[history]</a></span>'
        $("#dataset_category").empty();
        $("#dataset_category").html(select+categoryHistory);
        //set the default option
        for (var i=0;i<3;i++) {
            var optionTxt = $("#category option").eq(i).text();
            if (optionTxt==categoryOption) {
                $("#category option").eq(i).attr("selected",true);
                break;
            }
        }
        
        //change the mode of tags to editable
        var tagsOriginalTxt = $("#dataset_tags").html();
        var input = '<input id="tags_input" type="text" style="width:250px" maxlength="40" value="' +tagsOriginalTxt+ '">';
        var tagsHistory = '<span id="tags_history" style="padding-left:10px;"><a>[history]</a></span>'
        $("#dataset_tags").empty();
        $("#dataset_tags").html(input+tagsHistory);        
        
        //listener of cancel and save button
        $("#cancel_button").click(function() {
            window.location.reload();            
        });
        $("#save_button").click(function() {
            beforeSubmit();
            
        });
        
        
        // deal with pop up
        $("#title_history").click(function(){
            $("#title_popup").fadeIn('fast');
            showShade();
            $("#fade").click(function(){
                $("#title_popup").fadeOut('fast');
                $("#fade").remove();        
            });
        });

        
        $("#des_history").click(function(){
            $("#des_popup").fadeIn('fast');
            showShade();
            $("#fade").click(function(){
                $("#des_popup").fadeOut('fast');
                $("#fade").remove();        
            });
        });
        
        $("#category_history").click(function(){
            $("#category_popup").fadeIn('fast');
            showShade();
            $("#fade").click(function(){
                $("#category_popup").fadeOut('fast');
                $("#fade").remove();        
            });
        });        
        
        $("#tags_history").click(function(){
            $("#tags_popup").fadeIn('fast');
            showShade();
            $("#fade").click(function(){
                $("#tags_popup").fadeOut('fast');
                $("#fade").remove();        
            });
        });
        
    
    // ---------wiki part of attachment -------------
    var attachDesOriginalTxt = $("body").find(".attachmentDescription").html();
    //alert(attachment_description);    
    var input = '<input id="attach_des_input" type="text" style="width:250px" maxlength="40" value="' +attachDesOriginalTxt+ '">';
    var attachDescriptionHistory = '<span id="des_history" style="padding-left:10px;"><a>[history]</a></span>';
    $("body").find(".attachmentDescription").empty();
    $("body").find(".attachmentDescription").html(input);
    $("body").find(".deleteFileBtnWrapper").after(attachDescriptionHistory);
    
    });    

});


            
            
            