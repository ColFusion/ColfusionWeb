﻿<?php

include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'group.php');
include(mnminclude.'smartyvariables.php');
include_once(mnminclude.'user.php');


//include('c_1_wistie_submit_step_21_tpl.php');


// determine which step of the submit process we are on
  echo '<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>';
  echo '<script type="text/javascript" src="label_edit_js.js"></script>'; 
	
	global $current_user, $globals, $the_template, $smarty, $db;
	$Sid=$_SESSION['requestID'];
	$s = $db->get_row("SELECT link_id, UserId, Title, link_content, link_tags, link_category, EntryDate, LastUpdated FROM ".table_prefix."sourceinfo s inner join colfusion_links l on s.sid = l.link_id  WHERE Sid = $Sid");
	$user_id=$s->UserId;
	$u = $db->get_row("SELECT * FROM ".table_prefix."users WHERE user_id = '$user_id'");
	$lastUpdated=$s->LastUpdated;
	$link_id=$s->link_id;
	$link_tags=$s->link_tags;
	$link_content=$s->link_content;
	$title=$s->Title;
	$entryDate=$s->EntryDate;
	if(is_null($lastUpdated) === TRUE){
	    $lastUpdated = $s->EntryDate;
	}
	//get the category
	$link_category;
	switch ($s->link_category) {
	    case 1:
		$link_category = "News";
		break;
	    case 2:
		$link_category = "Bussiness";
		break;
	    case 3:
		$link_category = "History";
		break;
	    default:
		break;
	}
	
	//debug---replace <br /> with <br> of description(link_content)	; the bug will appear at first time
	if (strpos($link_content,"<br />")!=false) {
	    $link_content=str_replace("<br />","<br>",$link_content);
	    $link_content= mysql_real_escape_string($link_content);
	    $sql_update = "UPDATE colfusion_links ";
	    $sql_update .="SET link_content = '{$link_content}' ";
	    $sql_update .="WHERE link_id = {$link_id}";
	    if($db->query($sql_update)) {
            //update the link_summary
			$sql_update = "UPDATE colfusion_links ";
			$sql_update .="SET link_summary = '{$link_content}' ";
			$sql_update .="WHERE link_id = {$link_id}";
			$db->query($sql_update);
	    }
	}
	
	//insert data the wiki_history when the link is just created
    $sql = "CREATE TABLE if not exists wiki_history(
	sid int DEFAULT 0,
    user_id int DEFAULT 0,
    timestamp char(30),
    field char(30),
    VALUE mediumtext DEFAULT null,
    notification mediumtext DEFAULT null,
    checked tinyint DEFAULT 0,
    PRIMARY KEY (sid,user_id,timestamp,field))";
	$db->query($sql);

        $sql_select = "SELECT * 
                       FROM wiki_history  
                       WHERE sid={$link_id}";
	$result = mysql_query($sql_select);
	$row = mysql_fetch_array($result);
	if($row==null) {
	    $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,checked) 
		    VALUES ('{$link_id}','{$user_id}','{$entryDate}','title','{$title}',true)";
	    if($db->query($sql_insert)){
		$sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,checked) 
			VALUES ('{$link_id}','{$user_id}','{$entryDate}','description','{$link_content}',true)";
		if($db->query($sql_insert)) {
		    $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,checked) 
			    VALUES ('{$link_id}','{$user_id}','{$entryDate}','category','{$link_category}',true)";
		    if($db->query($sql_insert)) {
			$sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,checked) 
			    VALUES ('{$link_id}','{$user_id}','{$entryDate}','tags','{$link_tags}',true)";
			$db->query($sql_insert);		    
		    }
		}
	    }
	}
	/*
	$sql = "CREATE TABLE if not exists record_history(
	sid int DEFAULT 0,
    user_id int DEFAULT 0,
    timestamp char(30),
    cid char(30),
    VALUE mediumtext DEFAULT null,
    comment mediumtext DEFAULT null,
    checked tinyint DEFAULT 0,
    PRIMARY KEY (sid,user_id,timestamp,cid))";
	$db->query($sql);
	*/

    $sql_create = "CREATE TABLE if not exists record_history_{$Sid} (
                sid int,
                user_id int,
                cid char(30),
                timestamp char(50),
                value mediumtext,
                notification mediumtext,
                comment mediumtext,
                checked tinyint default 0,
                PRIMARY KEY (sid,user_id,timestamp,cid)
                )";

    $db->query($sql_create);






	//update the data of preview data
    $sql_select = "SELECT cid, value, checked 
		   FROM record_history_{$link_id} AS t  
		   WHERE checked=1 ";

    $result = mysql_query($sql_select);

    echo '<script>';
    echo 'function updateData() {';



    while($row = mysql_fetch_array($result)) {

    	echo '$("body #'.$row['cid'].'").html("'.$row['value'].'");$("body #'.$row['cid'].'").css("backgroundColor","#FFFF93");';
    }



    echo '}';


    $sql_select = "SELECT cid 
	   FROM record_history_{$link_id} 
	   WHERE comment <> 'null'  
	   GROUP BY cid ";

    $result = mysql_query($sql_select);
    echo 'function highlightComment() {';

    while($row = mysql_fetch_array($result)) {
    	//echo '$("body #'.$row['cid'].'").attr({href: "#myModal", role: "button", class: "btn", data-toggle:"modal"});';
    	//echo '$("body #'.$row['cid'].'").attr("onclick", "comment_popup(this.id);");';
    	echo '$("body #'.$row['cid'].'").css("backgroundColor","#FFC125");';
    	//echo 'var $str = $("body #'.$row['cid'].'").text(); $("body #'.$row['cid'].'").html($str); $("body #'.$row['cid'].'").wrap("<a href=\"#myModal\" role=\"button\" data-toggle=\"modal\"></a></span>"); ';
    	//echo '$("body #'.$row['cid'].'").after("<i class=\"icon-th-list\" style=\"float:right; margin-right: 10px;\" />");';
    	//echo 'var $str = $("body #'.$row['cid'].'").text(); $("body #'.$row['cid'].'").html($str); $("body #'.$row['cid'].'").wrap("<a href=\"#myModal\" role=\"button\" data-toggle=\"modal\"></a>"); ';
    	//echo '$("body #'.$row['cid'].'").find("div").after("<i class=\"icon-th-list\" style=\"float:right; margin-right: 10px;\" />");';
    	//echo '$("body #'.$row['cid'].'").wrap("<a href=\"#myModal\" role=\"button\" data-toggle=\"modal\"></a>"); ';
    }

    echo '}';


   


    echo '</script>';


	echo '<script>



	//this function judges whether data is modified,if yes, user should fill the notification, else submit
	function beforeSubmit() {
	    
	    var title_str = $("#title_input").val();
	    var des_str = getDescription();
	    //category value has been set, if the value is 0, means it did not been changed
	    var tags_str = $("#tags_input").val();
	    title_str = trimLeft(trimRight(title_str)); //trim space both side
	    des_str = trimLeft(trimRight(des_str));
	    tags_str = trimLeft(trimRight(tags_str));
	    
	    if (trim(title_str) =="") {
		alert("Title cannot be blank");
		return;
	    }
	    if(trim(des_str) =="") {
		alert("Description cannot be blank");
		return;
	    }
	    
	    if(title_str!="'. $title . '") {
		$("#title_noti_wrap").show();
	    } else {
		title_str = null;
	    }
	    if(des_str!="'. $link_content . '") {
		$("#des_noti_wrap").show();			
	    } else {
		des_str = null;
	    }
	    if(category_value!=0 && category_value!="'. $s->link_category . '") {
		$("#category_noti_wrap").show();			
	    } else {
		category_value = 0; //0 means it doesnt change
	    }	    
	    if(tags_str!="'. $link_tags . '") {
		$("#tags_noti_wrap").show();			
	    } else {
		tags_str = "000";//tags can be null, so it will be different from others
	    }
	    
	    if (title_str!=null || des_str!=null || category_value!=0 || tags_str!="000") {
		$("#notification2").fadeIn("fast");
		showShade();
		$("#fade, #noti_cancel").bind("click",function(){
		    $("#notification2").fadeOut("fast",function(){
			
			$("#title_noti_wrap").hide();
			$("#des_noti_wrap").hide();
			$("#category_noti_wrap").hide();
			$("#tags_noti_wrap").hide();		    
		    });
		    $("#fade").remove();
		    $("#noti_submit").unbind();
		    $(this).unbind();
		    return;
		});
		$("#noti_submit").bind("click",function(){
		    checkNotification(title_str,des_str,category_value,tags_str);
		    return;
		});
	    } else {
		loadXMLDoc(null,null,0,"000",0,null,null);
	    }
		
	}
	
	//this function will be called when data is modified
	function checkNotification(title,description,category,tags) {	
	    if($("#title_noti_wrap").css("display") != "none") {
		var title_noti = getNotification("title_noti");
		if (trim(title_noti) =="") {
		    alert("You should fill out all notification..");
		    return;
		}
	    }
	    if($("#des_noti_wrap").css("display") != "none") {
		var des_noti = getNotification("des_noti");
		if (trim(des_noti) =="") {
		    alert("You should fill out all notification..");
		    return;
		}
	    }
	    if($("#category_noti_wrap").css("display") != "none") {
		var category_noti = getNotification("category_noti");
		if (trim(category_noti) =="") {
		    alert("You should fill out all notification..");
		    return;
		}
	    }
	    if($("#tags_noti_wrap").css("display") != "none") {
		var tags_noti = getNotification("tags_noti");
		if (trim(tags_noti) =="") {
		    alert("You should fill out all notification..");
		    return;
		}
	    }
	    loadXMLDoc(title,description,category,tags,0,null,null);
	}
	

	function rollbackListener(value) {
	    if(value.match("confirm")!=null) {
		value = value.replace(/_confirm/,"");
		var date = $("#"+value+" :checked").parent().parent().find("td").eq(1).html();
		var data = $("#"+value+" :checked").parent().parent().find("td").eq(2).html();
		var user = $("#"+value+" :checked").parent().parent().find("td").eq(3).html();
    		switch (value) {
		    case "title_popup":
			//alert(date+"-------"+user);
			loadXMLDoc(data,null,0,"000",1,date,user);
			break;
		    case "des_popup":
			loadXMLDoc(null,data,0,"000",1,date,user);
			break;
		    case "category_popup":
			switch(data) {
			    case "News" :
				data = 1;
				break;
			    case "Bussiness" :
				data = 2;
				break;
			    case "History" :
				data = 3;
				break;
			}
			loadXMLDoc(null,null,data,"000",1,date,user);
			break;		    
		    case "tags_popup":
			loadXMLDoc(null,null,0,data,1,date,user);
			break;
		    default:
			break;
		}
	    } else {
		
		value = value.replace(/_cancel/,"");	
	        $("#"+value).fadeOut("fast",function(){
		    switch (value) {
			case "title_popup":
			    var currentVision = currentTitle;
			    break;
			case "des_popup":
			    var currentVision = currentDescription;
			    break;
			case "category_popup":
			    var currentVision = currentCategory;
			    //alert(currentVision);
			    break;
			case "tags_popup":
			    var currentVision = currentTags;
			    break;
			default:
			    break;		
		    }
		    $("#"+value+" :checked").attr("checked",false);
		    $("input[name="+value+"]").eq(currentVision).attr("checked",true); //keep the original radio button checked		
		});
                $("#fade").remove();

	    }
	}
	
	
	
	
	/*
	function rollbackListener_old(value,section) { //section includes title_vision,des_vision,tags_vision
	    var r = confirm("Are you sure this vision?");
	    if (r==true) {
		
		var date = $("input[value="+value+"]").parent().parent().find("td").eq(1).html();
		var data = $("input[value="+value+"]").parent().parent().find("td").eq(2).html();
		var user = $("input[value="+value+"]").parent().parent().find("td").eq(3).html();
		//alert(data+"   "+section);
		switch (section) {
		    case "title_vision":
			//alert(date+"-------"+user);
			loadXMLDoc(data,null,"000",1,date,user);
			break;
		    case "des_vision":
			loadXMLDoc(null,data,"000",1,date,user);
			break;
		    case "tags_vision":
			loadXMLDoc(null,null,data,1,date,user);
			break;
		    default:
			break;
		}
	    } else {
		switch (section) {
		    case "title_vision":
			var currentVision = currentTitle;
			break;
		    case "des_vision":
			var currentVision = currentDescription;
			break;
		    case "tags_vision":
			var currentVision = currentTags;
			break;
		    default:
			break;		
		}
		$("[value="+value+"]").attr("checked",false); 
		$("input[name="+section+"]").eq(currentVision).attr("checked",true); //keep the original radio button checked
	    }    
	}
	*/
	
	
	
	//rollback is used to distinguish between normal modification and rollback modification(change the current vision)
	//the arguments date and user are for rollback, it will be null if it is normal modification
	
	function loadXMLDoc(title,description,category,tags,rollback,date,user) {
	
	    //alert("loadXML");
	    var xmlhttp;
	    if (rollback==1) {
		url += "?id=' . $link_id . '&rollback="+rollback+"&date="+date+"&modifieduser="+user;
		
	    } else {
		url += "?id=' . $link_id . '&rollback="+rollback;		
	    }
	    if(title !=null) {
		var title_noti = getNotification("title_noti");
		title_noti = trimLeft(trimRight(title_noti));
		url += "&titlestr="+title+"&titlenoti="+title_noti;
	    }
	    if(description !=null) {
		var des_noti = getNotification("des_noti");
		des_noti = trimLeft(trimRight(des_noti));
		url += "&desstr="+description+"&desnoti="+des_noti;
	    }
	    if(category !=0) {
		var category_noti = getNotification("category_noti");
		category_noti = trimLeft(trimRight(category_noti));
		url += "&category="+category+"&categorynoti="+category_noti;
	    }	    
	    if(tags !="000") {
		var tags_noti = getNotification("tags_noti");
		tags_noti = trimLeft(trimRight(tags_noti));
		url += "&tagsstr="+tags+"&tagsnoti="+tags_noti;
	    }	    
	     
	    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	    } else {// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    xmlhttp.onreadystatechange=function() {
		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
		    //document.getElementById("report").innerHTML=xmlhttp.responseText;
		    window.location.reload();
		}
	    };
	    xmlhttp.open("GET",url,true);
	    xmlhttp.send();
	}
	
	//function loadXMLForRollback(title,description,tags,rollback,date,user) 



	//this function is for data preview
	
	function loadXMLForDataPreview(cellValue,cid,notification,comment) {

	    //alert("loadXML");
	    var xmlhttp;
	        var url = "deal_with_data_preview.php";
	        url += "?id='.$link_id.'&userid='.$user_id.'&value="+cellValue+"&cid="+cid+"&notification="+notification+"&comment="+comment;
	        //alert(url);
	    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	    } else {// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    xmlhttp.onreadystatechange=function() {
		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
			//alert("ok");
		    document.getElementById("report").innerHTML=xmlhttp.responseText;
		    //window.location.reload();
		}
	    };
	    xmlhttp.open("GET",url,true);
	    xmlhttp.send();
	}

	


    function Modify(id) {  
      var str=prompt("enter new value:");
      if(str!=="")
        {
        	
            var p=document.getElementById(id);
            p.innerHTML=str;
        	//$("#"+id).text(str);

            Mark(id);
            var notif = Notification(id);
            loadXMLForDataPreview(str,id,notif,null);

            $(".sub_nav").remove();
            showNav();

        }
        else if(str==""){
          Delete(id);
        }

      
    }


    function Delete(id) {
      alert("it is deleted!");
      document.getElementById(id).innerHTML="NULL";//need to be null instead of a String
      Mark(id);
      notif=Notification(id);
      loadXMLForDataPreview(null,id,notif,null);
    }

    function Mark(id){
      document.getElementById(id).style.background="#FFFF93";
    }

    function Notification(id){
    var p=prompt("please write a notification here: ");
    //alert(p);
    return p;

    Mark(id);
    // record the notification by id and insert it into db
    }

    function Comment(id){
    	var c=prompt("add comment here:");
    	loadXMLForDataPreview(null,id,null,c);
    }



    //comment popup when in DataPreviewMarkup
	function comment_popup(cid){
		if (cid =="") return;
     	//alert(cid);
     	var xmlhttp;
        var url = "deal_with_data_preview.php";
        url += "?id='.$link_id.'&cid="+cid;
        //alert(url);
	    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	    } else {// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    xmlhttp.onreadystatechange=function() {
		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
			//alert("ok");
		    document.getElementById("report").innerHTML=xmlhttp.responseText;
		    //window.location.reload();
		    var commentreport=xmlhttp.responseText;
		    return commentreport;
		}
	    };
	    xmlhttp.open("GET",url,true);
	    xmlhttp.send();
	}




	
      </script>';

    $title_index = 1;
	echo '<br/>









	<!-- history popup start -->
	    <div id="dataedit_popup" style="display:none;background-color:#f5f5f5;position:absolute;top: 40%;left: 20%;width:700px;height:500px;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
		<div style="width:100%;height:40px;border-bottom:2px solid #ddd;"><h3 style="position:relative;top:0px;display:inline;">Dataedit History</h3></div>
		<div style="width:100%;">
		    <table style="border-collapse:collapse;margin:auto;width:100%;">
		    <tr style="background-color:#1874cd;color:#b3d5f6;">
			<th style="border:1px solid #999;padding: 10px;width:10%;">VISION</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">MODIFIED DATE</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">NEW VALUE</th>
			<th style="border:1px solid #999;padding: 10px;width:15%;">USER ID</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">COMMENT</th>
		    </tr></table>';
	echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';	    
		    $sql_select = "SELECT timestamp, value, user_id, comment, checked 
				   FROM wiki_history AS w, colfusion_users AS u 
				   WHERE w.user_id=u.user_id and sid={$link_id} and field='dataedit' ORDER BY timestamp";

		    $result = mysql_query($sql_select);
		    while($row = mysql_fetch_array($result)) {
			echo '<tr style="background-color:#fdfdee;">';
			echo '<td style="padding: 0px;border:1px solid #999;width:10%;text-align:center;"><input type="radio" ';?><?php if($row['checked']) echo "checked ";?><?php echo 'name="title_popup" value="titlerollback-'.$title_index.'"/></td>';
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_id'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['comment'] . "</td>";
			echo "</tr>";
			$title_index ++;
		    }
		echo '</table></div></div>';
		echo '<div style="border-top:2px solid #ddd;width:100%;"><div style="margin:10px;float:right;">
			    <button class="btn" name="dataedit_popup_confirm" onclick="rollbackListener(this.name)">Confrim</button><button class="btn" name="dataedit_popup_cancel" onclick="rollbackListener(this.name)">Cancel</button>
			</div></div></div>';  

	$title_index = 1;
	echo '<br/>
	    <div id="title_popup" style="display:none;background-color:#f5f5f5;position:absolute;top: 40%;left: 20%;width:700px;height:500px;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
		<div style="width:100%;height:40px;border-bottom:2px solid #ddd;"><h3 style="position:relative;top:0px;display:inline;">Title History</h3></div>
		<div style="width:100%;">
		    <table style="border-collapse:collapse;margin:auto;width:100%;">
		    <tr style="background-color:#1874cd;color:#b3d5f6;">
			<th style="border:1px solid #999;padding: 10px;width:10%;">VISION</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">MODIFIED DATE</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">TITLE</th>
			<th style="border:1px solid #999;padding: 10px;width:15%;">USER NAME</th>
			<th style="border:1px solid #999;padding: 10px;width:25%;">NOTIFICATION</th>
		    </tr></table>';
	echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';	    
		    $sql_select = "SELECT user_login, timestamp, value, notification, checked 
				   FROM wiki_history AS w, colfusion_users AS u 
				   WHERE w.user_id=u.user_id and sid={$link_id} and field='title' ORDER BY timestamp";

		    $result = mysql_query($sql_select);
		    while($row = mysql_fetch_array($result)) {
			echo '<tr style="background-color:#fdfdee;">';
			echo '<td style="padding: 0px;border:1px solid #999;width:10%;text-align:center;"><input type="radio" ';?><?php if($row['checked']) echo "checked ";?><?php echo 'name="title_popup" value="titlerollback-'.$title_index.'"/></td>';
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_login'] . "</td>";
			echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['notification'] . "</td>";
			echo "</tr>";
			$title_index ++;
		    }
		echo '</table></div></div>';
		echo '<div style="border-top:2px solid #ddd;width:100%;"><div style="margin:10px;float:right;">
			    <button class="btn" name="title_popup_confirm" onclick="rollbackListener(this.name)">Confrim</button><button class="btn" name="title_popup_cancel" onclick="rollbackListener(this.name)">Cancel</button>
			</div></div></div>';
			
			
			
	$des_index = 1;
	echo '
	    <div id="des_popup" style="display:none;background-color:#f5f5f5;position:absolute;top: 40%;left: 20%;width:700px;height:500px;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
		<div style="width:100%;height:40px;border-bottom:2px solid #ddd;"><h3 style="position:relative;top:0px;display:inline;">Description History</h3></div>
		<div style="width:100%;">
		<table style="border-collapse:collapse;margin:auto;width:100%;">
		<tr style="background-color:#1874cd;color:#b3d5f6;">
		    <th style="border:1px solid #999;padding: 10px;width:10%;">VISION</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">MODIFIED DATE</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">DESCRIPTION</th>
		    <th style="border:1px solid #999;padding: 10px;width:15%;">USER NAME</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">NOTIFICATION</th>
		</tr></table>';
	echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';
		$sql_select = "SELECT user_login, timestamp, value, notification, checked  
			       FROM wiki_history AS w, colfusion_users AS u 
			       WHERE w.user_id=u.user_id and sid={$link_id} and field='description' ORDER BY timestamp";
        
		$result = mysql_query($sql_select);
		while($row = mysql_fetch_array($result)) {
		    echo '<tr style="background-color:#fdfdee;">';
		    echo '<td style="padding: 0px;border:1px solid #999;text-align:center;width:10%;"><input type="radio" ';?><?php if($row['checked']) echo "checked ";?><?php echo 'name="des_popup" value="desrollback-'.$des_index.'" /></td>';
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_login'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['notification'] . "</td>";
		    echo "</tr>";
		    $des_index ++;
		}
		echo '</table></div></div>';
		echo '<div style="border-top:2px solid #ddd;width:100%;"><div style="margin:10px;float:right;">
			    <button class="btn" name="des_popup_confirm" onclick="rollbackListener(this.name)">Confirm</button><button class="btn" name="des_popup_cancel" onclick="rollbackListener(this.name)">Cancel</button>
			</div></div></div>';
	

	

	$category_index = 1;
	echo '
	    <div id="category_popup" style="display:none;background-color:#f5f5f5;position:absolute;top: 40%;left: 20%;width:700px;height:500px;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
		<div style="width:100%;height:40px;border-bottom:2px solid #ddd;"><h3 style="position:relative;top:0px;display:inline;">Tags History</h3></div>
		<div style="width:100%;">
		<table style="border-collapse:collapse;margin:auto;width:100%;">
		<tr style="background-color:#1874cd;color:#b3d5f6;">
		    <th style="border:1px solid #999;padding: 10px;width:10%;">VISION</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">MODIFIED DATE</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">CATEGORY</th>
		    <th style="border:1px solid #999;padding: 10px;width:15%;">USER NAME</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">NOTIFICATION</th>
		</tr></table>';
	echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';
		$sql_select = "SELECT user_login, timestamp, value, notification, checked  
			       FROM wiki_history AS w, colfusion_users AS u 
			       WHERE w.user_id=u.user_id and sid={$link_id} and field='category' ORDER BY timestamp";
        
		$result = mysql_query($sql_select);
		while($row = mysql_fetch_array($result)) {
		    echo '<tr style="background-color:#fdfdee;">';
		    echo '<td style="padding: 0px;border:1px solid #999;width:10%;text-align:center;"><input type="radio" ';?><?php if($row['checked']) echo "checked ";?><?php echo 'name="category_popup" value="categoryrollback-'.$category_index.'"/></td>';
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_login'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['notification'] . "</td>";
		    echo "</tr>";
		    $tags_index ++;
		}
		echo '</table></div></div>';
		echo '<div style="border-top:2px solid #ddd;width:100%;"><div style="margin:10px;float:right;">
			    <button class="btn" name="category_popup_confirm" onclick="rollbackListener(this.name)">Confirm</button><button class="btn" name="category_popup_cancel" onclick="rollbackListener(this.name)">Cancel</button>
			</div></div></div>';



	
		
	$tags_index = 1;
	echo '
	    <div id="tags_popup" style="display:none;background-color:#f5f5f5;position:absolute;top: 40%;left: 20%;width:700px;height:500px;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
		<div style="width:100%;height:40px;border-bottom:2px solid #ddd;"><h3 style="position:relative;top:0px;display:inline;">Tags History</h3></div>
		<div style="width:100%;">
		<table style="border-collapse:collapse;margin:auto;width:100%;">
		<tr style="background-color:#1874cd;color:#b3d5f6;">
		    <th style="border:1px solid #999;padding: 10px;width:10%;">VISION</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">MODIFIED DATE</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">TAGS</th>
		    <th style="border:1px solid #999;padding: 10px;width:15%;">USER NAME</th>
		    <th style="border:1px solid #999;padding: 10px;width:25%;">NOTIFICATION</th>
		</tr></table>';
	echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';
		$sql_select = "SELECT user_login, timestamp, value, notification, checked  
			       FROM wiki_history AS w, colfusion_users AS u 
			       WHERE w.user_id=u.user_id and sid={$link_id} and field='tags' ORDER BY timestamp";
        
		$result = mysql_query($sql_select);
		while($row = mysql_fetch_array($result)) {
		    echo '<tr style="background-color:#fdfdee;">';
		    echo '<td style="padding: 0px;border:1px solid #999;width:10%;text-align:center;"><input type="radio" ';?><?php if($row['checked']) echo "checked ";?><?php echo 'name="tags_popup" value="tagsrollback-'.$tags_index.'"/></td>';
		     '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_login'] . "</td>";
		    echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['notification'] . "</td>";
		    echo "</tr>";
		    $tags_index ++;
		}
		echo '</table></div></div>';
		echo '<div style="border-top:2px solid #ddd;width:100%;"><div style="margin:10px;float:right;">
			    <button class="btn" name="tags_popup_confirm" onclick="rollbackListener(this.name)">Confirm</button><button class="btn" name="tags_popup_cancel" onclick="rollbackListener(this.name)">Cancel</button>
			</div></div></div>';
		
		
		
		
		
		echo '<div id="notification2" style="display:none;padding:10px;background-color:#f5f5f5;position:absolute;top: 40%;left: 30%;width:500px;min-height:250px;height:auto;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
			<div id="title_noti_wrap" style="display:none;margin-top:18px;"><div style="padding:5px;padding-left:10px;width:100%;height:40px;"><h4 style="">Reasons why you change TITLE?</h4></div>
			<textarea placeholder="say something.." id="title_noti" style="width:460px;height:80px;margin:10px;margin-top:5px;"></textarea></div>
			
			<div id="des_noti_wrap" style="display:none;margin-top:18px;"><div style="padding:5px;padding-left:10px;width:100%;height:40px;"><h4 style="">Reasons why you change DESCRIPTION?</h4></div>
			<textarea placeholder="say something.." id="des_noti" style="width:460px;height:80px;margin:10px;margin-top:5px;"></textarea></div>

			<div id="category_noti_wrap" style="display:none;margin-top:18px;"><div style="padding:5px;padding-left:10px;width:100%;height:40px;"><h4 style="">Reasons why you change CATEGORY?</h4></div>
			<textarea placeholder="say something.." id="category_noti" style="width:460px;height:80px;margin:10px;margin-top:5px;"></textarea></div>
			
			<div id="tags_noti_wrap" style="display:none;margin-top:18px;"><div style="padding:5px;padding-left:10px;width:100%;height:40px;"><h4 style="">Reasons why you change TAG?</h4></div>
			<textarea placeholder="say something.." id="tags_noti" style="width:460px;height:80px;margin:10px;margin-top:5px;"></textarea></div>
			
			<div id="noti_buttons" style="margin:15px;float:right;">
			    <button class="btn" id="noti_submit">Submit</button><button class="btn" id="noti_cancel">Cancel</button>
			</div>
		    </div>
		<!-- history popup end -->';
		
		
		echo '<!-- remove attachment popup -->
		
		    <div id="attach_remove_noti_wrap" style="display:none;padding:10px;background-color:#f5f5f5;position:absolute;top: 350px;left: 30%;width:500px;min-height:200px;height:auto;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 3px;border-radius: 3px;">
			<div style="margin-top:18px;"><div style="padding:5px;padding-left:10px;width:100%;height:40px;"><h4 style="">Reasons why you remove this FILE?</h4></div>
			<textarea placeholder="say something.." id="attach_remove_noti" style="width:460px;height:100px;margin:10px;margin-top:5px;"></textarea></div>
			<div id="attach_remove_noti_buttons" style="margin:15px;float:right;">
			    <button class="btn" id="attach_remove_noti_submit">Submit</button><button class="btn" id="attach_remove_noti_cancel">Cancel</button>
			</div></div>';
		
		
	    
echo '
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    <h3 id="myModalLabel">modify History</h3></div>';

            echo '<div style="width:100%;height:360px;overflow:scroll;"><table class="table" style="width:100%;">';
                    $sql_select = "SELECT r.user_id, r.timestamp, r.value, r.notification, r.comment  
                               FROM record_history_{$link_id} AS r 
                                ORDER BY timestamp";
                   $sql_select = "SELECT value,timestamp,notification,comment,cid FROM record_history_{$link_id} ORDER BY timestamp";
                   $result = mysql_query($sql_select);
                    echo '<tr><th>timestamp</th><th>value</th><th>notification</th><th>comment</th><th>cid</th></tr>';

                    while($row = mysql_fetch_array($result)) 
                    {
                        echo '<tr>';
                            echo '<td>' . $row['timestamp'] . "</td>";
                            echo '<td>' . $row['value'] . "</td>";
                            echo '<td>' . $row['notification'] . "</td>";
                            echo '<td>' . $row['comment'] . "</td>";
                            echo '<td>' . $row['cid'] . "</td>";
                            echo "</tr>";
                    }
                        echo '</table></div></div>';






	        
	echo '

	    
	    <span id="edit_button" style="float:right;padding:3px;padding-right:20px;"><a>[edit]</a></span>
	    <span id="cancel_button" style="float:right;padding:3px;padding-right:20px;"><a>[cancel]</a></span>
	    <span id="save_button" style="float:right;padding:3px;"><a>[save]</a></span>

            <span style="font-weight:bold;padding-left:10px;">Dataset Title: </span>
            <span id="dataset_title">'.nl2br(htmlentities($s->Title)).'</span>              
                <br />
                <span style="font-weight:bold;padding-left:10px;">Submit by:</span> '
                .$u->user_login.
                '<br />
                    <span style="font-weight:bold;padding-left:10px;">Date Submitted:</span> '
                .$s->EntryDate.
                '<br />
                <span style="font-weight:bold;padding-left:10px;float:left;">Description: </span>
                <span id="profile_datasetDescription">'.$s->link_content.'</span><br/>
		<span style="font-weight:bold;padding-left:10px;float:left;margin-right:10px;">Category: </span>
                <span id="dataset_category">'.$link_category.'</span><br/>
		<span style="font-weight:bold;padding-left:10px;float:left;margin-right:10px;">Tags: </span>
                <span id="dataset_tags" >'.htmlentities($s->link_tags).'</span><br/>'
                ."\n";
?>