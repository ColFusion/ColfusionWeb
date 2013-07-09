google.load('visualization', '1', {'packages':['motionchart']});
//google.setOnLoadCallback(drawMotion);

var motiondata;

function loadMotions() {
	motions = document.getElementsByName("motionDivs");
	gadgetIDs = new Array();
    for(motionNum=0 ; motionNum<motions.length ; motionNum++){
        theMotion = motions[motionNum];
        gadgetIDs.push(theMotion.id);
        drawMotion(2,'motionResult'+gadgetIDs[motionNum]);
    }
}

/****************
type
1: initial creation of motion chart
2: reload motion chart from database
3: edit existing motion
*****************/
/*function drawMotion(type, vid) {
	gadgetID = vid;
	titleNo = $('#titleNo').val();  
	where = $("#where").val();
	otherColumns = new Array();	
	
	if(type == 1){ //initial creation of motion chart
		createNewMotion();
		firstColumn = $('#motionFirstColumn').val();
		dateColumn = $('#motionDate').val();
		
		settings = "";
		otherColCount = 0;
		$.each($("input[name='motionOtherColumn[]']:checked"), function(){
			otherColumns.push($(this).val());
			settings += "," + $(this).val();
			otherColCount++;
		});
		settings = settings.substring(1) + ";";
		settings = firstColumn + ';' + dateColumn + ';' + settings;

		$('#setting' + gadgetID).val(settings);	

	}//end of type 1
	else if(type == 2) {//reload motion chart from database
		settings = $('#setting' + gadgetID).val();
		//alert(settings);
		var n = settings.split(";");
		firstColumn = n[0];
		dateColumn = n[1];
		cols = new Array();
		cols = n[2].split(",");
		otherColCount = cols.length;
		for(i=0;i<otherColCount;i++) {
			otherColumns.push(cols[i]);
		}
	}//end of type 2
	else if(type == 3) {//edit existing motion chart
		firstColumn = $('#motionFirstColumnEdit').val();
		dateColumn = $('#motionDateEdit').val();
		
		settings = "";
		otherColCount = 0;
		$.each($("input[name='motionOtherColumnEdit[]']:checked"), function(){
			otherColumns.push($(this).val());
			settings += "," + $(this).val();
			otherColCount++;
		});
		settings = settings.substring(1) + ";";
		settings = firstColumn + ';' + dateColumn + ';' + settings;

		$('#setting' + gadgetID).val(settings);	
	}

	data = new google.visualization.DataTable();

	data.addColumn('string', 'Disease');
  	data.addColumn('date', 'Date');
  	data.addColumn('number', 'Number of disease cases');
  	data.addColumn('number', 'Precipitation');
  	data.addColumn('string', 'State');

//	data.addColumn('string', firstColumn);
//	data.addColumn('number', 'Date');
		
//	for(i=0 ; otherColumns[i]!=null ; i++){
 //       data.addColumn('number',otherColumns[i]);
//    }

    var  datainfo = {"firstColumn":firstColumn,"dateColumn":dateColumn,"otherColumns":otherColumns};

	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {
			action: 'addChart',
			name: 'bddfasfd',
			vid: $('#vid').val(),
			type: 'motion',
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
			for(i=0; JSONResponse[i]!=null; i++) {
				data.addRow();
				data.setCell(i, 0, String(JSONResponse[i]["disease"]));
				data.setCell(i, 1, new Date(JSONResponse[i]["year"], JSONResponse[i]["month"], 1));
				data.setCell(i, 2, parseInt(JSONResponse[i]["numberOfCases"]));
				data.setCell(i, 3, parseInt(JSONResponse[i]["precipitation"]));
				data.setCell(i, 4, JSONResponse[i]["state"]);
			}		
			$("#motionResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			motiondata = data;
			generateMotion(gadgetID);
		},
		dataType:'json',
		async:false
	});
	
	$("div[name='motionDivs']").resize(function() {
		tempid = $(this).attr("id")
		$("#motionResult" + tempid).height($("#" + tempid).height() - $(".gadget-header").height() - 20);
		generateMotion(tempid);
	})
	
	if(type == 1) {
		$('#addMotion').modal('hide');		
	}
	else if(type == 3){
		$('#editMotion').modal('hide');		
	}
}*/
function drawMotion(sourceData,gadgetID) {
	var data = new google.visualization.DataTable();
	data.addColumn('string', 'Disease');
  	data.addColumn('date', 'Date');
  	data.addColumn('number', 'Number of disease cases');
  	data.addColumn('number', 'Precipitation');
  	data.addColumn('string', 'State');
	for(i=0; sourceData[i]!=null; i++) {
		data.addRow();
		data.setCell(i, 0, String(sourceData[i]["disease"]));
		data.setCell(i, 1, new Date(sourceData[i]["year"], sourceData[i]["month"], 1));
		data.setCell(i, 2, parseInt(sourceData[i]["numberOfCases"]));
		data.setCell(i, 3, parseInt(sourceData[i]["precipitation"]));
		data.setCell(i, 4, sourceData[i]["state"]);
	}
	var chart = new google.visualization.MotionChart(document.getElementById(gadgetID));
	chart.draw(data, {width: "100%", height:"100%"});
}
function generateMotion(a) {
	var chart = new google.visualization.MotionChart(document.getElementById('motionResult'+gadgetID));
	//chart.draw(data, {width: 600, height:300});	
	chart.draw(motiondata, {width: "100%", height:"100%"});
}
   
function createNewMotionGadget() {
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random() * 100);
	var gadgetID = d.getTime() + ranNum + "";

	var gadget = "<div name='motionDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:500px; height:320px' type='motion'>";
	gadget += "<div class='gadget-header'>Motion Chart " + gadgetID;
	gadget += "<div class='gadget-close'><i class='icon-remove'></i></div>"
	gadget += "<div class='gadget-edit edit-motion'><a href='#editMotion' data-toggle='modal'><i class='icon-edit'></i></a></div></div>";
	gadget += "<input type='hidden' id='setting" + gadgetID + "' value='' />";
	gadget += "<div class='gadget-content'>";
	gadget += "<div id='motionResult" + gadgetID + "' style='width:100%'></div></div></div>";

	$('.chart-area').append(gadget);
	$( ".gadget" )
		.draggable({ handle: ".gadget-header" })
		.resizable();
	
	$(".gadget-close").click(function() {	
		$(this).parent().parent().remove();
	})
	return gadgetID;

}
function addMotionChart() {
	var titleNo = $('#titleNo').val();
	var where = $("#where").val();	
	var settings = "";
	var otherColumns = new Array();
	var firstColumn = $('#motionFirstColumn').val();
	var dateColumn = $('#motionDate').val();
	var otherColCount = 0;
	var  datainfo = {"firstColumn":firstColumn,"dateColumn":dateColumn,"otherColumns":otherColumns};
	$.each($("input[name='motionOtherColumn[]']:checked"), function(){
		otherColumns.push($(this).val());
		settings += "," + $(this).val();
		otherColCount++;
	});
	settings = settings.substring(1) + ";";
	settings = firstColumn + ';' + dateColumn + ';' + settings;
	$('#setting' + gadgetID).val(settings);
	var gadgetID = createNewMotionGadget();
	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {action: 'addChart',
		name: 'MotionChart',
		vid: $('#vid').val(),
		type: 'motion',
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
			$("#motionResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			drawMotion(queryResult,'motionResult'+gadgetID);
			$('#addMotion').modal('hide');
		}
		})
}
//Load existing chart.
function loadMotionChart(sourceData) {
	var gadgetID = createNewMotionGadget();
	var queryResult = sourceData['queryResult'];
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	$("#motionResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
	drawMotion(queryResult,'motionResult'+gadgetID);
		
}
