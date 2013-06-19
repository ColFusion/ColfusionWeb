
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

function drawMap(){
	$.ajax({
		type: 'POST',
		url: "getMap.php",
		data: {'latitude':latitude, 'longitude':longitude, 'mapTooltip':mapTooltip, 'titleNo':titleNo, 'where':where},
		success: function(JSON_Response){
			var JSONResponse = JSON_Response;
			data = new google.visualization.DataTable();
			data.addColumn('number', latitude);
			data.addColumn('number', longitude);
			data.addColumn('string', 'Tooltip');
			for(i=0 ; JSONResponse[i]!=null ; i++){
				data.addRow();
				data.setCell(i, 0, parseFloat(String(JSONResponse[i]["latitude"])));
				data.setCell(i, 1, parseFloat(String(JSONResponse[i]["longitude"])));
				var tips = "";
				for(k=0; k<mapTooltip.length; k++){
					tips += mapTooltip[k] + ": " + String(JSONResponse[i][mapTooltip[k]]);
					tips += "<br>";
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

function createNewMap(){
    var d = new Date();
    var ranNum = 1 + Math.floor(Math.random() * 100);
    gadgetID = d.getTime() + ranNum + "";
    
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
        $(this).parent().parent().hide();
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
}