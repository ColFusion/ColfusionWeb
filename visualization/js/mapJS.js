
google.load("visualization", "1", {packages:["map"]});

var mapdata;

/****************
type
1: initial creation of geo chart
2: reload geo chart from database
*****************/

function loadMap(type,vid){
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
function drawMap(souceData,gadgetID){
	var data = new google.visualization.DataTable();
	data.addColumn('number', 'latitude');
	data.addColumn('number', 'longitude');
	data.addColumn('string', 'Tooltip');
	for(i=0 ; souceData[i]!=null ; i++){
		data.addRow();
		data.setCell(i, 0, parseFloat(String(souceData[i]["la"])));
		data.setCell(i, 1, parseFloat(String(souceData[i]["long"])));
		var tips = "";
		/*
		for(k=0; k<mapTooltip.length; k++){
			tips += mapTooltip[k] + ": " + String(JSONResponse[i][mapTooltip[k]]);
			
		}*/
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
	$("#"+gadgetID).height($("#"+gadgetID).parent().height()-20);
	
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
            + "<div class='gadget-edit edit-map'><a href='#editMap' data-toggle='modal'><i class='icon-edit'></i></a></div> </div>"
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

    //$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height());

    //edit geo chart
    $('.edit-map').click(function() {
        editGadgetID = $(this).parent().parent().attr('id');
    });

    //edit motion save
    $('#editMapSave').click(function() {
        loadMap(3,editGadgetID);
    });
    return gadgetID;
}
function addMapChart() {
	var titleNo = $('#titleNo').val();
	var where = $("#where").val();	
	var settings = "";
	var mapTooltip = new Array();
	var latitude = "";
	var longitude = "";	
	var datainfo = {'latitude':latitude,'longitude':longitude,'maptooltip':mapTooltip};
	var gadgetID = createNewMapGadget();
	latitude = $("#latitude").val();
	longitude = $("#longitude").val();
        $.each($("input[name='mapTooltip']:checked"), function(){
            mapTooltip.push($(this).val()); // columns to show in tooltip
            settings += "," + $(this).val();
        });
	settings = settings.substring(1);
	settings = latitude + ";" + longitude + ";" + settings + ";";
	$('#setting' + gadgetID).val(settings);	
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
			gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
			$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
			drawMap(queryResult,'mapResult'+gadgetID);
			$('#addMap').modal('hide');
		}
		})
}
//Load existing map chart
function loadMapChart(sourceData) {
	var gadgetID = createNewMapGadget();
	var queryResult = sourceData['queryResult'];
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	$("#mapResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height()-20);
	drawMap(queryResult,'mapResult'+gadgetID);
}