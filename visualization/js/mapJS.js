
google.load("visualization", "1", {packages:["map"]});

//var mapdata;

/****************
type
1: initial creation of geo chart
2: reload geo chart from database
*****************/

/*function loadMap(type,vid){
    gadgetID = vid;
    titleNo = $("#titleNo").val();
    where = $("#where").val();	
	settings = "";
	mapTooltip = new Array();
	latitude = "";
	longitude = "";	
	
    if(type == 1){
        createNewMap();
        settings = "";
        mapTooltip = new Array();
		latitude = $("#latitude").val();
		longitude = $("#longitude").val();
        $.each($("input[name='mapTooltip']:checked"), function(){
            mapTooltip.push($(this).val()); // columns to show in tooltip
            settings += "," + $(this).val();
        });
		settings = settings.substring(1);
		settings = latitude + ";" + longitude + ";" + settings + ";";
		$('#setting' + gadgetID).val(settings);
		
        $('#addMap').modal('hide');
    }
    if(type == 2){
        settings = $('#setting' + gadgetID).val();
        mapTooltip = new Array();

        var n = settings.split(";");
        latitude = n[0];
        longitude = n[1];
        mapTooltip = n[2].split(",");

    }
    if(type == 3){
        settings = "";
        mapTooltip = new Array();
		latitude = $("#latitudeEdit").val();
		longitude = $("#longitudeEdit").val();
        $.each($("input[name='mapTooltipEdit']:checked"), function(){
            mapTooltip.push($(this).val()); // columns to show in tooltip
            settings += "," + $(this).val();
        });
		settings = settings.substring(1);
		settings = latitude + ";" + longitude + ";" + settings + ";";
		$('#setting' + gadgetID).val(settings);
	
        $('#editMap').modal('hide');
    }
    
	drawMap();
}
*/
/*
function drawMap(){
	
    var  datainfo = {'latitude':latitude,'longitude':longitude,'maptooltip':mapTooltip};
  	
	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {
			action: 'addChart',
			name: 'bdasdfd',
			vid: $('#vid').val(),
			type: 'map',
			width: 400,
			height: 300,
			depth: 2,
			top: 50,
			left: 0,
			note: 'dfdff',
			datainfo: datainfo
		},
		success: function(JSON_Response){
			var JSONResponse = JSON_Response['queryResult'];
			data = new google.visualization.DataTable();
			data.addColumn('number', latitude);
			data.addColumn('number', longitude);
			data.addColumn('string', 'Tooltip');
			for(i=0 ; JSONResponse[i]!=null ; i++){
				data.addRow();
				data.setCell(i, 0, parseFloat(String(JSONResponse[i]["la"])));
				data.setCell(i, 1, parseFloat(String(JSONResponse[i]["long"])));
				var tips = "";
				for(k=0; k<mapTooltip.length; k++){
					tips += mapTooltip[k] + ": " + String(JSONResponse[i][mapTooltip[k]]);
					
				}
				data.setCell(i, 2, tips);
			}
			mapdata = data;
			//alert(mapdata.toJSON());
			$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
			generateMap(gadgetID);
		},
		dataType: 'json',
		async:false
	});
	
	$("div[name='mapDivs']").resize(function() {
		tempid = $(this).attr("id");
        $("#mapResult" + tempid).height($("#" + tempid).height() - $(".gadget-header").height()-20);
        generateMap(tempid);
    });
}*/
$(document).ready(function (){
	$('#editMap').on('hidden', function () {
		clearMapEditForm();
		})
	})
function mapFormToDatainfo() {
	var sid = $("#addMapSid").val();
	var sname = $('#addMapSid').find("option:selected").text();
	var where;
	var table = $("#addMapTable").val();
	var mapTooltip = new Array();
	var cid = $("#latitude").val();
	var columnName = $("#latitude").find("option:selected").text();
	var latitude = {cid:cid, columnName: columnName};
	cid = $("#longitude").val();
	columnName = $("#longitude").find("option:selected").text();
	var longitude = {cid:cid, columnName: columnName};
	$.each($("#addMap .columnSelection").find("input:checked"), function(){
	    	cid = $(this).val();
		columnName = $(this.nextSibling).text();
		mapTooltip.push({cid:cid,columnName:columnName});
	});	
	return new MapDatainfo(latitude,longitude,mapTooltip,sid,sname,table,where);
}
function editMapFormToDatainfo() {
	var sid = $("#editMapSid").val();
	var sname = $('#editMapSid').find("option:selected").text();
	var where;
	var table = $("#editMapTable").val();
	var mapTooltip = new Array();
	var cid = $("#latitudeEdit").val();
	var columnName = $("#latitudeEdit").find("option:selected").text();
	var latitude = {cid:cid, columnName: columnName};
	cid = $("#longitudeEdit").val();
	columnName = $("#longitudeEdit").find("option:selected").text();
	var longitude = {cid:cid, columnName: columnName};
	$.each($("#editMap .columnSelection").find("input:checked"), function(){
		cid = $(this).val();
		columnName = $(this.nextSibling).text();
		mapTooltip.push({cid:cid,columnName:columnName});
	});
	return new MapDatainfo(latitude,longitude,mapTooltip,sid,sname,table,where);
}
function MapDatainfo(latitude,longitude,mapTooltip,sid,sname,table,where) {
	this.latitude = latitude;
	this.longitude = longitude;
	this.mapTooltip = mapTooltip;
	this.sid = sid;
	this.sname = sname;
	this.table = table;
	this.where = where;
	this.inputObj = CANVAS['stories'][sid]['inputObj'];
}
function mapDataInfoToForm(mapDatainfo) {
	clearMapEditForm();
	var sid = mapDatainfo.sid;
	var sname = mapDatainfo.sname;
	var where = mapDatainfo.where;
	var table = mapDatainfo.table;
	var latitude = mapDatainfo.latitude;
	var longitude = mapDatainfo.longitude;
	var mapTooltip = mapDatainfo.mapTooltip;
	$('#editMapSid').val(sid);
	$('#editMapSid').find("option:selected").text(sname);
	$('#editMapTable').val(table);
	$('#editMapTable').change();
	$('#latitudeEdit').val(latitude);
	$('#longitudeEdit').val(longitude);
	if (mapTooltip!=null) {
	    for (var i = 0;i<mapTooltip.length;i++) {
		//var value = mapTooltip[i];
		var obj = $("#editMap .columnSelection input:checkbox[value='"+mapTooltip[i]['cid']+"']");
		obj.prop('checked','checked');
	    }
	}
	
}
function clearMapEditForm() {
	$('#latitudeEdit').val(1);
	$('#longitudeEdit').val(1);
	$('input:checkbox[name="mapTooltipEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
}
function drawMap(souceData,gadgetID){
	var data = new google.visualization.DataTable();
	data.addColumn('number', 'latitude');
	data.addColumn('number', 'longitude');
	data.addColumn('string', 'Tooltip');
	var mapTooltip = souceData['mapTooltip'];
	for(i=0 ; souceData['content'][i]!=null ; i++){
		data.addRow();
		data.setCell(i, 0, parseFloat(String(souceData['content'][i]["latitude"])));
		data.setCell(i, 1, parseFloat(String(souceData['content'][i]["longitude"])));
		var tips = "";
		
		for(var temp in mapTooltip){
			tips += "<b>"+mapTooltip[temp]['columnName']+"</b>" + ": " + String(souceData['content'][i][mapTooltip[temp]['columnName']])+"<br>";
			
		}
		data.setCell(i, 2, tips);
	}
	var options = {
		showTip: true, 
		mapType: 'normal', 
		enableScrollWheel: true,
		useMapTypeControl: true
	};
	var map = new google.visualization.Map(document.getElementById(gadgetID));
	map.draw(data, options);
	return data;
}

//refresh chart without loading new data.
function refreshMap(data,sourceData,gadgetID){
    	var options = {
		showTip: true, 
		mapType: 'normal', 
		enableScrollWheel: true,
		useMapTypeControl: true
	};
	var map = new google.visualization.Map(document.getElementById(gadgetID));
	map.draw(data, options);
}

function generateMap(a){
    var options = {
	    showTip: true, 
	    mapType: 'normal', 
	    enableScrollWheel: true,
	    useMapTypeControl: true
    };
    var map = new google.visualization.Map(document.getElementById('mapResult' + a));
    map.draw(mapdata, options);

}

function createNewMapGadget(){
    var d = new Date();
    var ranNum = 1 + Math.floor(Math.random() * 100);
    var gadgetID = d.getTime() + ranNum + "";
    
    var gadget = "<div name='mapDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:400px; height: 300px' type='map'>"
            + "<div class='gadget-header'><div class='gadget-title'>Map chart " + gadgetID+"</div>";
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-pie'><i class='icon-edit'></i></div>";
	gadget += "<div class='gadget-normal' style = 'display:none'><i class='icon-resize-small'></i></div>";
	gadget += "<div class='gadget-max'><i class='icon-resize-full'></i></div>";
	gadget += "<div class='gadget-min'><i class='icon-minus'></i></div> </div>";
        gadget += "<input type='hidden' id='setting" + gadgetID + "' value='' />"
        gadget += "<div class='gadget-content'>"
        gadget += "<div id='mapResult" + gadgetID + "' style='width:100%;'></div></div></div>";
    
	$('.chart-area').append(gadget);
    $( ".gadget" )
        .draggable({ handle: ".gadget-header" })
        .resizable();
    $(".gadget-close").click(function() {   
        $(this).parent().parent().remove();
    })
    $("#"+gadgetID+" .gadget-max").click(function() {
		$(this).parent().parent().find(".gadget-content").css("opacity","0.0");
		var chart = CHARTS[$("#"+gadgetID).find(".chartID").val()];
		chart.top = Math.round($("#"+gadgetID).position().top);
		chart.left = Math.round($("#"+gadgetID).position().left);
		chart.width = Math.round($("#"+gadgetID).width());
		chart.height = Math.round($("#"+gadgetID).height());
		$(this).parent().parent().animate({
			top: "40px",
			left:"0px",
			width: (parseFloat(window.innerWidth)-20)+"px",
			height: (parseFloat(window.innerHeight)-60)+"px"
			},500,null,function() {
				$("#"+gadgetID).find(".gadget-max").hide();
				$("#"+gadgetID).find(".gadget-normal").show();
				$("#"+gadgetID).resize();$(this).parent().parent().find(".gadget-content").css("opacity","1.0");
				})
		
		});
	$("#"+gadgetID+" .gadget-normal").click(function() {
		$(this).parent().parent().find(".gadget-content").css("opacity","0.0");
		var chart = CHARTS[$("#"+gadgetID).find(".chartID").val()];
		$(this).parent().parent().animate({
			top: chart.top+"px",
			left:chart.left+"px",
			width: chart.width+"px",
			height: chart.height+"px"
			},500,null,function() {
				$("#"+gadgetID).find(".gadget-normal").hide();
				$("#"+gadgetID).find(".gadget-max").show();
				$("#"+gadgetID).resize();$(this).parent().parent().find(".gadget-content").css("opacity","1.0");
				})
		
		});
    $("#"+gadgetID+' .edit-map').click(function(){
		var editGadgetID = $(this).parent().parent().attr('id');
		var cid = $("#"+editGadgetID+" .chartID").val();
		resetEditFormSidTable("editMapSid",'editMapTable');
		mapDataInfoToForm(CHARTS[cid]['datainfo']);
		$('#editMap').modal('show')
		CANVAS.selectedChart = cid;
	});
    	$("div[name='mapDivs']").resize(function() {
	   
	    var cid = $(this).find('.chartID').val();
	    var gadgetID = $(this).attr('id');
	    var chart = CHARTS[cid];
	     $("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
		refreshMap(chart.chartData,chart.queryResult,"mapResult"+gadgetID);
	});
    //edit geo chart
    $('.edit-map').click(function() {
        editGadgetID = $(this).parent().parent().attr('id');
    });
    $("#"+gadgetID+" .gadget-min").click(function() {
		var cid = $(this).find('.chartID').val();
		var gadgetID = $(this).parent().parent().attr("id");
		var chartID = $("#"+gadgetID).find(".chartID").val();
		var chart = CHARTS[$("#"+gadgetID).find(".chartID").val()];
		chart.top = Math.round($("#"+gadgetID).position().top);
		chart.left = Math.round($("#"+gadgetID).position().left);
		chart.width = Math.round($("#"+gadgetID).width());
		chart.height = Math.round($("#"+gadgetID).height());
		$(this).parent().parent().animate(
			{
			top:window.innerHeight+"px",
			left:"0px",
			opacity:"0"},320,null,function() {
				$(this).hide();
				$("#min-items").append("<li class='min-item' id = 'min"+gadgetID+"'onclick='showMin("+gadgetID+")'><p>"+$("#"+gadgetID).find(".gadget-title").text()+"</p></li>")
				$(".min-item").each(function() {
					$(this).hide();
					})
				$(".min-item").last().show();
				});
		});
    return gadgetID;
}
function addMapChart() {
	var datainfo = mapFormToDatainfo();
	var gadgetID = createNewMapGadget();
	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {action: 'addChart',
		name: 'MapChart',
		vid: $('#vid').val(),
		type: 'map',
		width: 1200,
		height: 600,
		depth: ++maxDepth,
		top: 50,
		left: 0,
		note: 'dfdff',
		datainfo: datainfo},
		success: function(JSON_Response){
			JSON_Response = jQuery.parseJSON(JSON_Response);
			var queryResult = JSON_Response['queryResult'];
			CHARTS[JSON_Response['cid']] = new Chart(JSON_Response['cid'],JSON_Response['name'],JSON_Response['type'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['note'],JSON_Response['datainfo'],JSON_Response['queryResult'],"mapResult" + gadgetID)
			gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
			$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
			CHARTS[JSON_Response['cid']].chartData = drawMap(queryResult,'mapResult' + gadgetID);
			$("#"+gadgetID).find('.gadget-title').text("Map chart in "+CHARTS[JSON_Response['cid']].getSname() + ":" + CHARTS[JSON_Response['cid']].getTable());
			$('#addMap').modal('hide');
		}
		})
}

//Load existing map chart
function loadMapChart(sourceData) {
	var gadgetID = createNewMapGadget();
	var queryResult = sourceData['queryResult'];
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	CHARTS[sourceData['cid']] = new Chart(sourceData['cid'],sourceData['name'],sourceData['type'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['note'],sourceData['datainfo'],sourceData['queryResult'],"mapResult" + gadgetID)
	$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
	CHARTS[sourceData['cid']].chartData = drawMap(queryResult,'mapResult' + gadgetID);
	$("#"+gadgetID).find('.gadget-title').text("Map chart in "+CHARTS[sourceData['cid']].getSname() + ":" + CHARTS[sourceData['cid']].getTable());
}
//update the chart
function updateMapResult(cid) {
	var chart = CHARTS[cid];
	var gadgetID = CHARTS[cid].gadgetID;
	var datainfo = editMapFormToDatainfo();
	$.ajax({
		type: 'POST',
		url: 'control.php',
		data: {
			vid: CANVAS.vid,
			action: 'updateChartResult',
			cid: cid,
			datainfo: datainfo,
			},
		success: function(JSON_Response) {
			JSON_Response = jQuery.parseJSON(JSON_Response);
			var queryResult = JSON_Response['queryResult'];
			CHARTS[cid].datainfo = datainfo;
			CHARTS[cid].queryResult = queryResult;
			drawMap(queryResult,gadgetID);
			$('#editMap').modal('hide');
		}
		})
}