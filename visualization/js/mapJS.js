
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
	var latitude = $("#latitude").val();
	var longitude = $("#longitude").val();
	$.each($("#addMap .columnSelection").find("input:checked"), function(){
		mapTooltip.push($(this).val()); // columns to show
	});	
	return new MapDatainfo(latitude,longitude,mapTooltip,sid,sname,table,where);
}
function editMapFormToDatainfo() {
	var sid = $("#editMapSid").val();
	var sname = $('#editMapSid').find("option:selected").text();
	var where;
	var table = $("#editMapTable").val();
	var mapTooltip = new Array();
	var latitude = $("#latitudeEdit").val();
	var longitude = $("#longitudeEdit").val();
	$.each($("#editMap .columnSelection").find("input:checked"), function(){
		mapTooltip.push($(this).val()); // columns to show
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
		var value = mapTooltip[i];
		var obj = $("#editMap .columnSelection input:checkbox[value='"+value+"']");
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
	var mapTooltip = souceData['mapToolTip'];
	for(i=0 ; souceData['content'][i]!=null ; i++){
		data.addRow();
		data.setCell(i, 0, parseFloat(String(souceData['content'][i]["latitude"])));
		data.setCell(i, 1, parseFloat(String(souceData['content'][i]["longitude"])));
		var tips = "";
		
		for(var temp in mapTooltip){
			tips += temp + ": " + String(souceData['content'][i][mapTooltip[temp]]);
			
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
function refreshMap(sourceData,gadgetID) {
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
            + "<div class='gadget-header'>Map " + gadgetID
            + "<div class='gadget-close'><i class='icon-remove'></i></div>"
            + "<div class='gadget-edit edit-map'><i class='icon-edit'></i></div> </div>"
            + "<input type='hidden' id='setting" + gadgetID + "' value='' />"
            + "<div class='gadget-content'>"
            + "<div id='mapResult" + gadgetID + "' style='width:100%;'></div></div></div>";
    
	$('.chart-area').append(gadget);
    $( ".gadget" )
        .draggable({ handle: ".gadget-header" })
        .resizable();
    $(".gadget-close").click(function() {   
        $(this).parent().parent().remove();
    })
    $("#"+gadgetID+' .edit-map').click(function(){
		var editGadgetID = $(this).parent().parent().attr('id');
		var cid = $("#"+editGadgetID+" .chartID").val();
		resetEditFormSidTable("editMapSid",'editMapTable');
		mapDataInfoToForm(CHARTS[cid]['datainfo']);
		$('#editMap').modal('show')
		CANVAS.selectedChart = cid;
	});
    	$("div[name='mapDivs']").resize(function() {
	    $("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
	});
    //edit geo chart
    $('.edit-map').click(function() {
        editGadgetID = $(this).parent().parent().attr('id');
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