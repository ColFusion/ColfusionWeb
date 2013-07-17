google.load('visualization', '1.0', {'packages':['corechart']});
//google.setOnLoadCallback(drawPie);

gadgetID = 0;
var tempid = 0;
var piedata;


function loadPies() {
	pies = document.getElementsByName("pieDivs");
	gadgetIDs = new Array();
    for(pieNum=0 ; pieNum<pies.length ; pieNum++){
        thePie = pies[pieNum];
		gadgetIDs.push(thePie.id);
        drawPie(2,gadgetIDs[pieNum]);
    }
}

/****************
type
1: initial creation of pie chart
2: reload pie chart from database
3: edit existing pie chart
*****************/
/*
function drawPie(type,vid){
	gadgetID = vid;
	titleNo = $('#titleNo').val(); 
	where = $("#where").val();		
	if(type == 1){
		createNewPie();
		pieColumnCat = $('#pieColumnCat').val();
		pieColumnAgg = $('#pieColumnAgg').val();
		pieAggType = $('input:radio[name="pieAggType"]:checked').val();
		settings = pieColumnCat + ";" + pieColumnAgg + ";" + pieAggType + ";";
		$('#setting' + gadgetID).val(settings); 
	}
	else if(type == 2){
		settings = $('#setting' + gadgetID).val();
		var n = settings.split(";");
		pieColumnCat = n[0];
		pieColumnAgg = n[1];
		pieAggType = n[2];
	}
	else if(type == 3){
		pieColumnCat = $('#pieColumnCatEdit').val();
		pieColumnAgg = $('#pieColumnAggEdit').val();
		pieAggType = $('input:radio[name="pieAggTypeEdit"]:checked').val();
		settings = pieColumnCat + ";" + pieColumnAgg + ";" + pieAggType + ";";
		$('#setting' + gadgetID).val(settings); 		
	}

	$.ajax({
		type: 'POST',
		//url: "getPie.php",
		url: "control.php",
		//data: {'pieColumnCat':pieColumnCat, 'pieColumnAgg':pieColumnAgg, 'pieAggType':pieAggType, 'titleNo':titleNo, 'where':where},
		data:{
			action: 'addChart',
			name: 'bdfdfd',
			vid: 1,
			type: 'pie',
			width: 400,
			height: 300,
			depth: 2,
			top: 50,
			left: 0,
			note: 'dfdff',
			datainfo: 'hgdsdgfds'
		},
		success: function(JSON_Response){
			
			var JSONResponse = eval(JSON_Response);
			//document.getElementById('pieResult').innerHTML = JSON.stringify(JSONResponse);
			data = new google.visualization.DataTable();
			data.addColumn('string', pieColumnCat);
			data.addColumn('number', pieAggType);
			for(i=0 ; JSONResponse[i]!=null ; i++){
				data.addRow();
				data.setCell(i, 0, String(JSONResponse[i]["Category"]));
				data.setCell(i,1,parseFloat(String(JSONResponse[i]["AggValue"])));
			}
			$("#pieResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			piedata = data;
			generatePie(gadgetID);
			
			
		},
		dataType: 'json',
		async:false
	});
    // $("#" + gadgetID).resize(function() {
        // $("#pieResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
        // generatePie();
    // });
	
	$("div[name='pieDivs']").resize(function() {
		tempid = $(this).attr("id");
		$("#pieResult" + tempid).height($("#" + tempid).height() - $(".gadget-header").height() - 20);
		generatePie(tempid);
	})
	
	
    if(type == 1){
		$('#addPie').modal('hide');
    }
	else if(type == 3){
		$('#editPie').modal('hide');
	}
}

function generatePie(b){
    var options = {'title':'Pie Chart for ' + pieColumnAgg + ' ' + pieAggType + ' based on ' + pieColumnCat,
              width: "90%",
              height: "90%"
             };
	var chart = new google.visualization.PieChart(document.getElementById('pieResult'+b));
    chart.draw(piedata,options);
}*/
$(document).ready(function (){
	$('#editPie').on('hidden', function () {
		clearPieEditForm();
		})
	
	})
function pieFormToDatainfo() {
	var sid = $("#addPieSid").val();
	var sname = $('#addPieSid').find("option:selected").text();
	var where;
	var table = $("#addPieTable").val();
	var pieColumnCat = $('#pieColumnCat').val();
	var pieColumnAgg = $('#pieColumnAgg').val();
	var pieAggType = $('input:radio[name="pieAggType"]:checked').val();
	return new PieDatainfo(pieColumnCat,pieColumnAgg,pieAggType,sid,sname,table,where);
}
function editPieFormToDatainfo() {
	var sid = $("#editPieSid").val();
	var sname = $('#editPieSid').find('option:selected').text();
	var table = $("#editPieTable").val();
	var where;
	var pieColumnCat = $('#pieColumnCatEdit').val();
	var pieColumnAgg = $('#pieColumnAggEdit').val();
	var pieAggType = $('input:radio[name="pieAggTypeEdit"]:checked').val();
	return new PieDatainfo(pieColumnCat,pieColumnAgg,pieAggType,sid,sname,table,where);
}
function PieDatainfo(pieColumnCat,pieColumnAgg,pieAggType,sid,sname,table,where) {
	this.pieColumnCat = pieColumnCat;
	this.pieColumnAgg = pieColumnAgg;
	this.pieAggType = pieAggType;
	this.sid = sid;
	this.sname = sname;
	this.table = table;
	this.where = where;
}
function pieDataInfoToForm(pieDatainfo) {
	var sid = pieDatainfo.sid;
	var sname = pieDatainfo.sname;
	var table = pieDatainfo.table;
	var where = pieDatainfo.where;
	var pieColumnCat = pieDatainfo.pieColumnCat;
	var pieColumnAgg = pieDatainfo.pieColumnAgg;
	var pieAggType = pieDatainfo.pieAggType;
	$('#editPieSid').val(sid);
	$('#editPieSid').find('option:selected').text(sname);
	$('#editPieTable').val(table);
	$('#editPieTable').change();
	$('#pieColumnCatEdit').val(pieColumnCat);
	$('#pieColumnAggEdit').val(pieColumnAgg);
	$('input:radio[name="pieAggTypeEdit"][value="'+pieAggType+'"]').attr('checked',true);
}
function clearPieEditForm() {
	$('#pieColumnCatEdit').val(1);
	$('#pieColumnAggEdit').val(1);
	$('input:checkbox[name="pieAggTypeEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
}
function createNewPieGadget(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random()*100);
	var gadgetID = d.getTime() + ranNum + "";

	var gadget = "<div name='pieDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:400px; height: 300px' type='pie'>";
	gadget +=  "<div class='gadget-header'>Pie Chart" + gadgetID;
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-pie'><i class='icon-edit'></i></div> </div>";
	gadget += "<input type='hidden' id='setting"+gadgetID+"' value='' />";  
	gadget += "<div class='gadget-content'>";
	gadget += "<div id='pieResult" + gadgetID + "' style='width:100%;'></div></div></div>";
	
	$('.chart-area').append(gadget);
	$( ".gadget" ).draggable({ handle: ".gadget-header" }).resizable();
	$(".gadget-close").click(function() {   
		    $(this).parent().parent().remove();
	})
	$('#'+gadgetID+' .edit-pie').click(function(){
		var editGadgetID = $(this).parent().parent().attr('id');
		var cid = $("#"+editGadgetID+" .chartID").val();
		$('#pieColumnAgg').val('long');
		resetEditFormSidTable("editPieSid",'editPieTable');
		pieDataInfoToForm(CHARTS[cid]['datainfo']);
		$('#editPie').modal('show');
		CANVAS.selectedChart = cid;
       });
	$("#"+gadgetID).resize(function() {
		var cid = $(this).find('.chartID').val();
		var gadgetID = $(this).attr('id');
		var chart = CHARTS[cid];
		refreshPie(chart.chartData,chart.queryResult,"pieResult"+gadgetID);
	})
	return gadgetID;
	
}

function addPieChart() {
	var gadgetID = createNewPieGadget();
	var datainfo = pieFormToDatainfo();
	$.ajax({
	    type: 'POST',
		    //url: "getPie.php",
	    url: "control.php",
		    //data: {'pieColumnCat':pieColumnCat, 'pieColumnAgg':pieColumnAgg, 'pieAggType':pieAggType, 'titleNo':titleNo, 'where':where},
	    data:{
		action: 'addChart',
		name: 'PieChart',
		vid: $('#vid').val(),
		type: 'pie',
		width: 400,
		height: 300,
		depth: ++maxDepth,
		top: 50,
		left: 0,
		note: 'dfdff',
		datainfo: datainfo
	    },
	    success:function(JSON_Response){
		JSON_Response = jQuery.parseJSON(JSON_Response);
		var queryResult = JSON_Response['queryResult'];
		CHARTS[JSON_Response['cid']] = new Chart(JSON_Response['cid'],JSON_Response['name'],JSON_Response['type'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['note'],JSON_Response['datainfo'],JSON_Response['queryResult'],"pieResult" + gadgetID)
		gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
		$("#pieResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
		CHARTS[JSON_Response['cid']].chartData = drawPie(queryResult,"pieResult"+gadgetID);
		$('#addPie').modal('hide');
	    }
	})
}
function editPieChart(cid) {
	
}
function drawPie(sourceData,gadgetID) {
	google.load("visualization", "1", {packages:["corechart"]});
	var data = new google.visualization.DataTable();
	data.addColumn('string', sourceData['pieColumnCat']);
	data.addColumn('number', sourceData['pieAggType']);
	var q = sourceData['content'];
	for(i=0 ;q[i]!=null ; i++){
		data.addRow();
		data.setCell(i, 0, String(q[i]["Category"]));
		data.setCell(i, 1 ,parseFloat(String(q[i]["AggValue"])));
	}
	var options = {
    	      'title':'Pie Chart for ' + sourceData['string'] + ' based on ' + sourceData['number']
    	};
	var chart = new google.visualization.PieChart(document.getElementById(gadgetID));
	chart.draw(data, options);
	return data;
}
function refreshPie(data,sourceData,gadgetID) {
	var options = {
    	      'title':'Pie Chart for ' + sourceData['string'] + ' based on ' + sourceData['number']
    	};
	var chart = new google.visualization.PieChart(document.getElementById(gadgetID));
	chart.draw(data, options);
}
//Load existing chart.
function loadPieChart(sourceData) {
	var gadgetID = createNewPieGadget();
	var queryResult = sourceData['queryResult'];
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	CHARTS[sourceData['cid']] = new Chart(sourceData['cid'],sourceData['name'],sourceData['type'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['note'],sourceData['datainfo'],sourceData['queryResult'],"pieResult" + gadgetID)
	$("#pieResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
	CHARTS[sourceData['cid']].chartData = drawPie(queryResult,'pieResult'+gadgetID);
}
//Update the chart
function updatePieResult(cid) {
	var chart = CHARTS[cid];
	var gadgetID = CHARTS[cid].gadgetID;
	var datainfo = editPieFormToDatainfo();
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
			drawPie(queryResult,gadgetID);
			$('#editPie').modal('hide');
		}
		})
}