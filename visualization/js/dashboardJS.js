var xmlHttp;
var d = new Date();
var vYear = d.getFullYear();
var vMon = d.getMonth() + 1;
var vDay = d.getDate();
var completeResult;
var authorizationLevel=-1;

var CHARTS ={};
var CANVAS ={};


function Canvas(vid,name,privilege,authorization,mdate,cdate,note) {
	this.vid = vid;
	this.name = name;
	this.privilege = privilege;
	this.authorization = authorization;
	this.mdate = mdate;
	this.cdate = cdate;
	this.note = note;
	this.selectedChart = null;
	this.stories = new Array();
	this.isSave = false;
}
//use sid to get story name and tables in the story
Canvas.prototype.addStory = function(sid,sname,callback) {
	
	$.ajax({
		type: 'POST',
		url: 'control.php',
		data: {
			action: 'getStory',
			sid: sid,
			sname: sname
			},
		async:false,
		success: function(JSON_Response) {
			JSON_Response = jQuery.parseJSON(JSON_Response);
			if(JSON_Response['status'] == 'success'){
				/*var sid = JSON_Response['sid'];
				var sname = JSON_Response['sname'];
				var tables = JSON_Response['tables'];*/
				$('#chart-dropdown').show();
				var story = JSON_Response['story'];
				var sid = story.sid;
				CANVAS.stories[sid] = story;
			}else{
				
			}
			if (callback!=null) {
				callback(JSON_Response);
			}
			
		}
		
		})
}
//get the story name and tables in the a story
Canvas.prototype.getStory = function(sid) {
	return CANVAS.stories[sid];
}
//get all the story names and tables 
Canvas.prototype.getStories = function() {
	return CANVAS.stories;
}

//get related charts to sid in 'charts'
Canvas.prototype.getStoryRelatedCharts = function(sid) {
	var rst = new Array();
	var chart;
	for (chart in CHARTS) {
		if (CHARTS[chart].getSid() == sid) {
			rst.push(CHARTS[chart]);
		}
	}
	return rst;
}
//get table related charts
Canvas.prototype.getTableRelatedCharts = function(sid,table) {
	var rst = new Array();
	var chart;
	for (chart in CHARTS) {
		if (CHARTS[chart].getSid() == sid && CHARTS[chart].getTable() == table) {
			rst.push(CHARTS[chart]);
		}
	}
	return rst;
	
}
//get the columns in one table in one story
Canvas.prototype.getColumns = function(sid,table){
	
}
var CANVAS = new Canvas();
var CHARTS ={};
function Chart(cid,name,type,top,left,height,width,depth,note,datainfo,queryResult,gadgetID) {
	this.cid = cid;
	this.name = name;
	this.type = top;
	this.left = left;
	this.height = height;
	this.width = width;
	this.depth = depth;
	this.note = note;
	this.datainfo = datainfo;
	this.queryResult = queryResult;
	this.gadgetID = gadgetID;
	CANVAS.addStory(this.getSid(),this.getSname());
}
//get the sid from the chart datainfo
Chart.prototype.getSid = function() {
	return this.datainfo.sid;
}
//get the table from the chart datainfo
Chart.prototype.getTable = function() {
	return this.datainfo.table;
}
Chart.prototype.getSname = function() {
	return this.datainfo.sname;
}
function addStory() {
	var sid = datasetSearcher.sid;
	var sname = datasetSearcher.datasetName;	
	CANVAS.addStory(sid,sname);
	showNote("flag");
}

function saveConfig(){
	var aut = $("#shareAuthorization").val();
}

function showNote(refresh){
	if (refresh==null||refresh==""){
		if (!$("#viewChartsNote").hasClass("active")){
			$("#viewChartsNote").addClass("active");
			$("#note_section").animate({
				marginLeft:"0%"
			});
		}
		else {
			$("#viewChartsNote").removeClass("active");
			$("#note_section").animate({
				marginLeft:"-30%"
			});
		}
	}
	
	var noteStr = "";
	var noteObj = CANVAS.getStories();
	
	for(var temp in noteObj){
		
		var tableStr ="";
		var story = noteObj[temp];
		noteStr += "<li id = "+story['sid']+"storiesTable class='unfold' onclick = 'StoryHighlight("+story['sid']+")'><a href ='#'>"+story["sid"]+":"+story["sname"]+"&nbsp&nbsp<i class='icon-plus' onclick = 'showRelatedTables("+story['sid']+")'></i></a></li>";

		
		for (var TempTable in story['tables']){
			TempTable = TempTable.split(".");
			TempTable = TempTable[0]+TempTable[1];
			noteStr += "<li id = "+story['sid']+TempTable+" class = "+story['sid']+"StoriesChildren onclick = TableHighlight("+story['sid']+",'"+TempTable+"') style = 'display:none'><a href = '#' ><i class='icon-arrow-right'></i>"+TempTable+"</a></li>";
		}
	}
	
	
	$("#selector_part").html('<li class="nav-header">CHARTS SELECTOR:</li>'+ noteStr);
}


function showRelatedTables(sid){
	if ($("#"+sid+"storiesTable").hasClass("unfold")){
		
		$("#"+sid+"storiesTable i").removeClass('icon-plus');
		$("#"+sid+"storiesTable i").addClass('icon-minus');
		
		$("."+sid+"StoriesChildren").show(500);
		$("#"+sid+"storiesTable").removeClass("unfold");
	}
	else {
		$("#"+sid+"storiesTable i").removeClass('icon-minus');
		$("#"+sid+"storiesTable i").addClass('icon-plus');
		
		$("#"+sid+"storiesTable").addClass("unfold");
		$("."+sid+"StoriesChildren").hide(500);
	}
}

function lostFocus(){
	for (var chart in CHARTS){
		var G = CHARTS[chart]['gadgetID'].split('Result');
		var gid = G[1];
		$("#"+gid).animate({
			opacity:1.0
		});
	}
	if ($(".container").hasClass("blueflag")){
		$(".container").removeClass("blueflag")
	}
	else
		$("#note_section li").removeClass("blueDecoration");
}

function StoryHighlight(sid){
	$("#focus_recorder").val(sid);
	for (var chart in CHARTS){
	    var compare = CHARTS[chart].getSid();
		
		if (compare!=sid){
			var G = CHARTS[chart]['gadgetID'].split('Result');
			var gid = G[1];
			$("#"+gid).animate({
				opacity:0.2
			});
		}
		else {
			var G = CHARTS[chart]['gadgetID'].split('Result');
			var gid = G[1];
			$("#"+gid).animate({
				opacity:1.0
			});
		}
		
	}
}


function TableHighlight(sid,tablename){
	
	$("#focus_recorder").val(sid+"&"+tablename);
	
	for (var chart in CHARTS){
		var compareSid = CHARTS[chart].getSid();
		var compareTname = CHARTS[chart].getTable();
		compareTname = compareTname.split(".");
		compareTname = compareTname[0]+compareTname[1];
		if (compareSid!=sid||compareTname!=tablename){
			var G = CHARTS[chart]['gadgetID'].split('Result');
			var gid = G[1];
			$("#"+gid).animate({
				opacity:0.2
			});
		}
		else {
			var G = CHARTS[chart]['gadgetID'].split('Result');
			var gid = G[1];
			$("#"+gid).animate({
				opacity:1.0
			});
		}
		
	}
	
}

function CurCanId(id){
	$("#shareWith").attr("name",id);
}

function openShareModal(vid) {
	$("#forShare").val(vid);
	$('#shareWith').modal("show");
}
function shareCanvas(){
	var vid = $("#forShare").val();
	var authorization = $("#autSele").val();
	var NameEmail = $("#NameEmail").val();
	$.ajax({
		type: 'POST',
		url: 'control.php',
		data: {
			action: 'shareCanvas',
			vid: vid,
			authorization: authorization,
			shareTo:NameEmail
		},
		success:function(JSON_Response) {
			JSON_Response = jQuery.parseJSON(JSON_Response);
			if (JSON_Response['status'] == '0') {
				$('#share-info').text(JSON_Response['msg']);
				$('#share-info').addClass('info-err');
			}else{
				$("#shareWith").modal('hide');
			}
			
		}
		})

}
function showChart(type){

	$("#openchart").modal("hide");
	
	switch (type){
	case 'pie':
		drawPies("");
		break;
	case 'motion':
		drawMotions("");
		break;
	case 'map':
		drawMaps("");
		break;
	case 'table':
		drawTable(2,vid);
		break;
	case 'combo':
		drawCombos();
		break;
	case 'column':
		drawColumns("");
		break;
	}
}
function showHint(str,currentPage){
	
	$("#note_section").show();
	$("#note_section li").removeClass("blueDecoration");
	if (currentPage>0&&currentPage!=null)
		authorizationLevel=-1;
	else if (currentPage<0)
		currentPage *= -1;
	
	$("#authorization_filter li").removeClass('active');
	if (currentPage!=null&&currentPage!="")
		$("#hiddenPageCount").val(currentPage);
	else 
		currentPage = $("#hiddenPageCount").val();

	xmlHttp=new XMLHttpRequest();
	var url="contentResponse.php";
	url=url+"?content="+str+"&columnNum="+(COLUMNNUM-1)+"&currentPage="+currentPage+"&authorizationLevel="+authorizationLevel;
	xmlHttp.onreadystatechange=stateChanged;
	xmlHttp.open("GET",url,true);
	xmlHttp.send(null);
	
}


function returnNormal(){
	$("#charts_section").hide(1000);
	$("#authorization_filter").show(1000);
	$("#date_filter").show(1000);
}

function stateChanged(){
	if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
	 { 
	 document.getElementById("display_section").innerHTML=xmlHttp.responseText;

	 

		$("td.tableadjust").mouseover(function(){
			$(this).parent().children("td").css({"background-color":"#0088CC","color":"white"});
		}).mouseout(function(){
			$(this).parent().children("td").css({"background-color":"#F5F5F5","color":"#0088CC"});
		}).click(function(){
			var vid = $(this).parent().attr('id').split("**")[0];
			var vname = $(this).parent().attr('name');
			openCharts(vid,vname);
		});
		
		returnNormal();

	 }

}

$(document).ready(function(){
	if($('#vid').val()==null||$("#vid").val()==''){
		$("#testSave").hide();
		$("#chart-dropdown").hide();
		$("#view-dropdown").hide();
	}
})

function autFilter(id){
	
	authorizationLevel = id;
	var currentSearchText = $("#button_section input[type='text']").val();
	showHint(currentSearchText,-1);
}

function pickDate(){
	
	var str = vMon+"/"+vDay+"/"+vYear;
	
	$(this).dialog({
		 open: function() {
             $('#myDate').datepicker({title:'Test Dialog'}).blur();
         },
         close: function() {
             $('#myDate').datepicker('destroy');
         }
	});
	
}

function overCanvasEffect(id){
	$("#"+id).css({"background-color":"#0088CC","color":"white"});
}

function outCanvasEffect(id){
	$("#"+id).css({"background-color":"#F5F5F5","color":"#0088CC"});
}

$(document).ready(function() {

	var oriTableHeight = parseInt($("#display_section").css("height").split("px")[0]);
	var actTableHeight = (oriTableHeight%37>18)?oriTableHeight+(37-(oriTableHeight%37)):oriTableHeight-(oriTableHeight%37);
	$("#display_section").css("height",actTableHeight+"px");
	COLUMNNUM = actTableHeight/37;
	
	var vids=new Array();
	$("#deleteButton").click(
			function(){
				$("[name='deleteItem']").each(function(){
					 if($(this).is(":checked"))
					   {
						$itemId = $(this).parent().parent().attr("id");
						$itemId = $itemId.split("**")[0];
					    $(this).removeAttr("checked");
					    vids.push($itemId);
					   }
				})
				
				$.ajax({
				  type: "POST",
				  url: "control.php",
				  data:{
					  action:'deleteCanvas',
					  vids:vids  
				  },
				  async:true,
				}).done(function(){
					showHint("");
				})
					
				}
					
			)
	

			
	
	
	$(".gadget" )
		.draggable({ handle: ".gadget-header" })
		.resizable()
		.css("min-height", "250px")
		.css("min-width", "300px")
		
	$(".gadget").resizable({
		resize: function(e, ui) {
			var gadgetID = $(this).attr('id');
			$("#tableResult"+gadgetID).height(
				$(this).height()-100
			)
		}
	})
		
	$(".gadget-close").click(function() {	
		$(this).parent().parent().hide();
	})
	
	$("#save").click(function() {
		var saveSuccess = 1;
		$( ".gadget" ).each(function (i) {
			var height = $(this).height();
			var width = $(this).width();
			var left = $(this).position().left;
			var top = $(this).position().top;
			var gadgetID = $(this).attr('id');
			var type = $(this).attr('type');
			var setting = $('#setting'+gadgetID).val();
			var userid = $('#userid').val();
			var titleNo = $('#titleNo').val();
			var data = {"vid": gadgetID, "type": type, "height": height, "width": width, "left": left, "top": top, "setting": setting, "userid": userid, "titleNo": titleNo };
			$.ajax({
			  type: "POST",
			  url: "setVisGadget.php",
			  async:false,
			  data: data
			}).done(function( msg ) {
			  if(msg != "success") {
			    saveSuccess = 0;
			  }
			});		
	    });
		if(saveSuccess == 1){
			alert("Dashboard saved");
		}
		else {
			alert("Save failed. Please retry later.");
		}
	})
	
	//show and hide gadgets
	$('li.view').click(function() {
		viewId = $(this).attr('id').substring(4);
		if(viewId!='none'){
			$('#'+viewId).toggle();
		}
	});
	
	//edit table
	$('.edit-table').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		
		/*
		var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		//alert(editGadgetID + "  " + oldSettings);
		
		var n = oldSettings.split(";");
	
		var oldTablePages = n[1];// number of turples per page
		$("input:radio[name='pageEdit']").each(function(j){
			if($(this).val() == oldTablePages) {
				$(this).attr('checked', true);
			}
		});
				
		var oldColor = n[2];// color of the new table
		$("input:radio[name='colorEdit']").each(function(j){
			if($(this).val() == oldColor) {
				$(this).attr('checked', true);
			}
		});		
		
		var oldDisplay = n[3];// sql style table or excel style table
		$("input:radio[name='displayEdit']").each(function(j){
			if($(this).val() == oldDisplay) {
				$(this).attr('checked', true);
			}
		});	
		if(oldDisplay == 'sqlStyle') {
			$('#sqlStyleColumnsEdit').show();
			$('#excelStyleColumnsEdit').hide();
		}
		else {
			$('#sqlStyleColumnsEdit').hide();
			$('#excelStyleColumnsEdit').show();	
		}	

		var equal = 0;
		var oldColumns = n[0].split(",");	
		if(oldDisplay == "sqlStyle") {
			$( "input[name='sqlcolumnEdit[]']").each(function (j){
				for(i=0;i<oldColumns.length;i++) {			
					if($(this).val() == oldColumns[i]) {
						equal = 1;
						break;
					}
				}
				if(equal == 1) {
					$(this).attr('checked', true);
				}
				else {
					$(this).removeAttr('checked');
				}
				equal = 0;			
			});
			$( "input[name='excelcolumnEdit[]']").each(function (j){
				$(this).removeAttr('checked');
			});
		}
		else { //excel style
			$( "input[name='excelcolumnEdit[]']").each(function (j){
				for(i=0;i<oldColumns.length;i++) {			
					if($(this).val() == oldColumns[i]) {
						equal = 1;
						break;
					}
				}
				if(equal == 1) {
					$(this).attr('checked', true);
				}
				else {
					$(this).removeAttr('checked');
				}
				equal = 0;			
			});	
			$( "input[name='sqlcolumnEdit[]']").each(function (j){
				$(this).removeAttr('checked');
			});
		}
		
		//reset table edit modal tabs
		$('#columnsEdit').addClass('active');
		$('#pageEdit').removeClass('active');
		$('#styleEdit').removeClass('active');
		$('#columnEditTab').addClass('active');
		$('#pageEditTab').removeClass('active');
		$('#styleEditTab').removeClass('active');	
		*/
	});
	
	//edit table save
	$('#editTableSave').click(function() {
		updateTableResult(CANVAS.selectedChart);
	});
	
	$('input[name="display"]').click(function() {
		if($(this).val() == 'sqlStyle') {
			$('#sqlStyleColumns').show(200);
			$('#excelStyleColumns').hide(200);
		}
		else {
			$('#sqlStyleColumns').hide(200);
			$('#excelStyleColumns').show(200);	
		}
	});	

	$('input[name="displayEdit"]').click(function() {
		if($(this).val() == 'sqlStyle') {
			$('#sqlStyleColumnsEdit').show(200);
			$('#excelStyleColumnsEdit').hide(200);
		}
		else {
			$('#sqlStyleColumnsEdit').hide(200);
			$('#excelStyleColumnsEdit').show(200);	
		}
	});	
	$('input[name="maplocation"]').click(function() {
		if($(this).val() == 'geocode'){
			$('#geocode').show(200);
			$('#address').hide(200);
		}
		else{
			$('#geocode').hide(200);
			$('#address').show(200);
		
		}
	});
	
	$("#motionColumns label:first-child input").attr('checked', true);	
	
	//edit motion
	$('.edit-motion').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		//alert(editGadgetID);
		var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		oldColumn = oldSettings;
		$("input:radio[name='motionColumnEdit[]']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});				
	});

	//edit motion save
	$('#editMotionSave').click(function() {
		updateMotionResult(CANVAS.selectedChart);
	});
	
	//edit column chart
	$('.edit-column').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		alert(editGadgetID);
		//old settings of gadget
		var oldSettings = $('#setting'+editGadgetID).val(); 
		var n = oldSettings.split(";");
	
		var oldColumn = n[1];// column
		$("input:radio[name='chartColumnEdit']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});
		
		var oldType = n[2]; //aggregation type
		$("input:radio[name='columnTypeEdit']").each(function(j){
			if($(this).val() == oldType) {
				$(this).attr('checked', true);
			}
		});				
	});	

	//edit motion save
	$('#editColumnSave').click(function() {
		updateColumnResult(CANVAS.selectedChart);
	});
	
	//edit geo chart
	$('.edit-map').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');		
	});

	//edit motion save
	$('#editMapSave').click(function() {
		updateMapResult(CANVAS.selectedChart);
		
	});	

    //edit pie chart
	$('.edit-pie').click(function(){
		editGadgetID = $(this).parent().parent().attr('id');
		var oldSettings = $('#setting'+editGadgetID).val(); 
		var n = oldSettings.split(";");
	
		var oldColumn = n[1];// column
		$("input:radio[name='pieColumnEdit']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});
		var oldType = n[2]; //aggregation type
		$("input:radio[name='pieTypeEdit']").each(function(j){
			if($(this).val() == oldType) {
				$(this).attr('checked', true);
			}
	});
   });

	$('#editPieSave').click(function(){
		updatePieResult(CANVAS.selectedChart);
	});
	
    //edit combo chart
	$('.edit-combo').click(function(){
		editGadgetID = $(this).parent().parent().attr('id');
		var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		oldColumn = oldSettings;
		$("input:radio[name='comboColumnEdit[]']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});	
	});
	$('#editComboSave').click(function(){
		updateComboResult(CANVAS.selectedChart);
	});
	
	//make modal active the first table after being hidden;
	$('.modal').on('hidden', function () {
		$(this).find('.nav-tabs a:first').tab('show');
	});
	
	//When open add chart modal
	$('.addChartModal').on('show',function(e) {
		var target = $(e.target);
		if ($(e.target).hasClass('addChartModal')) {
			$(this).find('.story-list').html('');
			$(this).find('.table-list').html('');
			var stories = CANVAS.getStories();
			var firstSid;
			var firstTname;
			var i = 0;
			for (var sid in stories) {
				if (i++ == 0) {
					firstSid = sid;
				}
				var story = stories[sid];
				var sname =story['sname'];
				$(this).find('.story-list').append('<option value="'+sid+'">'+sname+'</option>');
			}
			$(this).find('.story-list').change();
		}
	})
	//When canvas setting modal show
	$("#canvas-setting").on("show",function(){
		$("#canvas-setting-name").val(CANVAS.sname);	
		
	})
	//When share modal shows
	$('#shareWith').on('hide',function(e) {
		$('#NameEmail').val("");
		$("#forShare").val("");
		$("#share-info").text('');
	})
	$('.story-list').change(function() {
		var sid = $(this).val();
		var story = CANVAS.getStory(sid);
		var tables = story['tables'];
		$(this).parent().find('.table-list').html('');
		for (var tname in tables) {
			$(this).parent().find('.table-list').append('<option value="'+tname+'">'+tname+'</option>');
		}
		$(this).parent().find('.table-list').change();
		$(this).parent().find('.table-list').val(1);
	
		
	})
	$('.table-list').change(function() {
		var tname =$(this).val();
		var sid = $(this).parent().find('.story-list').val();
		var story = CANVAS.getStory(sid);
		var columns = story['tables'][tname]['columns'];
		$(this).parent().parent().find('select.table-column').each(function() {
			$(this).html('');
			for (var i = 0;i<columns.length;i++) {
				$(this).append('<option value="'+columns[i]+'">'+columns[i]+'</option>');
			}
			})
		$(this).parent().parent().find('.columnSelection').each(function() {
			$(this).html('');
			for (var i = 0;i<columns.length;i++) {
				$(this).append('<p><lable class="checkbox table-column" style="padding: 0px;"><input value="'+columns[i]+'" type="checkbox" class="check-columns">'+columns[i])+'</lable></p>';
			}
			})
	})
});
function resetEditFormSidTable(editSID,editTable) {
	$('.edit-chart .story-list').html('');
	$('.edit-chart .table-list').html('');
	var stories = CANVAS.getStories();
	var firstSid;
	var i = 0;
	for (var sid in stories) {
		if (i++ == 0) {
			firstSid = sid;
		}
		var story = stories[sid];
		var sname =story['sname'];
		$('#'+editSID).append('<option value="'+sid+'">'+sname+'</option>');
	}
	$('#'+editSID).change();
}

