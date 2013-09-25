google.load('visualization', '1.0', {'packages':['corechart']});
//google.setOnLoadCallback(drawCombo);
    
gadgetID = 0;

function loadCombos() {
	combos = document.getElementsByName("comboDivs");
	gadgetIDs = new Array();
    for(comboNum=0 ; comboNum<combos.length ; comboNum++){
        theCombo = combos[comboNum];
		gadgetIDs.push(theCombo.id);
        drawComboo(2,gadgetIDs[comboNum]);
    }
}

/****************
type
1: initial creation of combo chart
2: reload combo chart from database
3: edit existing combo chart
*****************/

/*function drawComboo(type,vid){
	gadgetID = vid;
	titleNo = $('#titleNo').val();
	where = $("#where").val();	
	comboColumnCat = "";
	comboColumnAgg = "";
	//comboAggType = new Array();
	settings = "";
	
	if(type == 1){
		createNewCombo();
		comboColumnCat = $('#comboColumnCat').val();
		comboColumnAgg = $('#comboColumnAgg').val();
		settings = comboColumnCat + ";" + comboColumnAgg + ";";
		$('#setting' + gadgetID).val(settings);
	}
	else if(type == 2){
		settings = $('#setting' + gadgetID).val();
		var n = settings.split(";");
		comboColumnCat = n[0];
		comboColumnAgg = n[1];
	}
	if(type == 3){
		comboColumnCat = $('#comboColumnCatEdit').val();
		comboColumnAgg = $('#comboColumnAggEdit').val();
		settings = comboColumnCat + ";" + comboColumnAgg + ";";
	    $('#setting' + gadgetID).val(settings);
	}

   var  datainfo = {'comboColumnCat':comboColumnCat,'comboColumnAgg':comboColumnAgg,'titleNo':titleNo,'where':where};
    	
    	
	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {action: 'addChart',
              name: 'bdfdfd',
              vid: $('#vid').val(),
              type: 'combo',
              width: 1200,
              height: 600,
              depth: maxDepth++,
              top: 50,
              left: 0,
              note: 'dfdff',
              datainfo: datainfo},
		success: function(JSON_Response){

		
		
		var JSONResponse = JSON_Response['queryResult'];
		
			//document.getElementById('comboResult').innerHTML = JSON.stringify(JSONResponse);
			data = new google.visualization.DataTable();
			data.addColumn('string','Type');
			for(i=0; JSONResponse[i]!=null ; i++)
			{
				data.addColumn('number',String(JSONResponse[i]['Category']));
			}
			//data.addColumn('number', 'AVG');
			//data.addColumn('number', 'MAX');
			//data.addColumn('number', 'MIN');
			
			for(i=0 ; i<3; i++){
				data.addRow();
			}
			data.setCell(0,0,'AVG');
			data.setCell(1,0,'MAX');
			data.setCell(2,0,'MIN');
			
			var colIndex = 1;
			for(i=0 ; JSONResponse[i]!=null ; i++){
				//data.addRow();
				data.setCell(0,colIndex,parseFloat(String(JSONResponse[i]['AVG'])));
				data.setCell(1,colIndex,parseFloat(String(JSONResponse[i]['MAX'])));
				data.setCell(2,colIndex,parseFloat(String(JSONResponse[i]['MIN'])));
				//data.setCell(i,1,parseFloat(String(JSONResponse[i].AVG)));
				//data.setCell(i,2,parseFloat(String(JSONResponse[i].MAX)));
				//data.setCell(i,3,parseFloat(String(JSONResponse[i].MIN)));
				
				colIndex++;
			}
			$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			generateCombo(gadgetID);
		},
		dataType: 'json',
		async:false
	});
	
    // $("#" + gadgetID).resize(function() {
        // $("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
        // generateCombo();
    // });		
	
	//$(".gadget").resize(function(){	
	$("div[name='comboDivs']").resize(function() {
		tempid = $(this).attr("id")
		$("#comboResult" + tempid).height($("#" + tempid).height() - $(".gadget-header").height() - 20);
		generateCombo(tempid);
	})
	
	if(type == 1){
	$('#addCombo').modal('hide');}
	else if (type == 3){
		$('#editCombo').modal('hide');
	}
}
*/
$(document).ready(function (){
	$('#editCombo').on('hidden', function () {
		clearComboEditForm();
		})
	})
function comboFormToDatainfo() {
	var sid = $("#addComboSid").val();
	var sname = $('#addComboSid').find("option:selected").text();
	var where;
	var table = $("#addComboTable").val();
	var comboAggType = new Array();
	$('input:checkbox[name="comboAggType"]:checked').each(function(){
		comboAggType.push($(this).val());
		});
	var cid = $('#comboColumnCat').val();
	var columnName = $('#comboColumnCat').find('option:selected').text();
	var comboColumnCat = {cid:cid, columnName:columnName};
	cid = $('#comboColumnAgg').val();
	columnName = $('#comboColumnAgg').find('option:selected').text();
	var comboColumnAgg = {cid:cid, columnName:columnName};
	if (comboAggType.length == 0) {
	    $("#add-combo-info").show().text("Please select at least one column.");
	    $("#add-combo-info").addClass("alert-error");
	    return null;
	}
	return new ComboDatainfo(comboColumnCat,comboColumnAgg,comboAggType,sid,sname,table,where);
}
function editComboFormToDatainfo() {
	var sid = $("#editComboSid").val();
	var sname = $('#editComboSid').find("option:selected").text();
	var table = $("#editComboTable").val();
	var where;
	var comboAggType = new Array();
	$('input:checkbox[name="comboAggTypeEdit"]:checked').each(function(){
		comboAggType.push($(this).val());
		});
	var cid = $('#comboColumnCatEdit').val();
	var columnName = $('#comboColumnCatEdit').find('option:selected').text();
	var comboColumnCat = {cid:cid, columnName:columnName};
	cid = $('#comboColumnAggEdit').val();
	columnName = $('#comboColumnAggEdit').find('option:selected').text();
	var comboColumnAgg = {cid:cid, columnName:columnName};
	comboColumnCat = $('#comboColumnCatEdit').val();
	comboColumnAgg = $('#comboColumnAggEdit').val();
	if (comboAggType.length == 0) {
	    $("#edit-combo-info").show().text("Please select at least one column.");
	    $("#edit-combo-info").addClass("alert-error");
	    return null;
	}
	return new ComboDatainfo(comboColumnCat,comboColumnAgg,comboAggType,sid,sname,table,where);
}

function ComboDatainfo(comboColumnCat,comboColumnAgg,comboAggType,sid,sname,table,where){
	this.comboColumnCat = comboColumnCat;
	this.sname = sname;
	this.comboColumnAgg = comboColumnAgg;
	this.comboAggType = comboAggType;
	this.sid = sid;
	this.table = table;
	this.where = where;
	this.inputObj = CANVAS['stories'][sid]['inputObj'];
}
function comboDataInfoToForm(comboDatainfo) {
	clearComboEditForm();
	var sid = comboDatainfo.sid;
	var sname = comboDatainfo.sname;
	var table = comboDatainfo.table;
	var where = comboDatainfo.where;
	var comboColumnCat = comboDatainfo.comboColumnCat;
	var comboColumnAgg = comboDatainfo.comboColumnAgg;
	var comboAggType = comboDatainfo.comboAggType;
	$('#editComboSid').val(sid);
	$('#editComboSid').find("option:selected").text(sname);
	$('#editComboTable').val(table);
	$('#editComboTable').change();
	$('#comboColumnCatEdit').val(comboColumnCat.cid);
	$('#comboColumnAggEdit').val(comboColumnAgg.cid);
	if (comboAggType!=null) {
		for (var i = 0; i<comboAggType.length;i++) {
			var value = comboAggType[i]
			$('input:checkbox[name="comboAggTypeEdit"][value="'+value+'"]').prop('checked','checked');
		}
	}

}
function clearComboEditForm() {
	$('#comboColumnCatEdit').val(1);
	$('#comboColumnAggEdit').val(1);
	$('input:checkbox[name="comboAggTypeEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
}
function generateCombo(a){
	var options={
		title: 'Combo Chart for '+ comboColumnCat,
		vAxis: {title : comboColumnAgg + " value"},
		hAxis: {title : "Aggregation Type"},
		height: $("#comboResult"+a).height(),
		seriesType: "bars"
	};
	var chart = new google.visualization.ComboChart(document.getElementById('comboResult'+a));
	chart.draw(data,options);
}
//draw the combo chart in the gadget
function drawCombo(souceData,gadgetID) {
	var data = new google.visualization.DataTable();
	data.addColumn('string','Category');
	for (var i = 0; i < souceData['comboAggType'].length; i++) {
		data.addColumn('number',souceData['comboAggType'][i]);
	}
	/*for(i=0; souceData['content'][i]!=null ; i++)
	{
		data.addColumn('number',String(souceData['content'][i]['Category']));
	}
	
	for(i=0 ; i<3; i++){
		data.addRow();
	}
	for (var i = 0; i < souceData['comboAggType'].length; i++) {
		data.setCell(0,0,souceData['comboAggType'][i]);
	}*/
	var colIndex = 0;
	for(i=0 ; souceData['content'][i]!=null ; i++){
		data.addRow();
		data.setCell(colIndex,0,String(souceData['content'][i]['Category']));
		for (var j = 0; j < souceData['comboAggType'].length;j++) {
			data.setCell(colIndex,j+1,parseFloat(String(souceData['content'][i][souceData['comboAggType'][j]])));
		}
		/*data.setCell(1,colIndex,parseFloat(String(souceData['content'][i][souceData['comboAggType'][i]])));
		data.setCell(2,colIndex,parseFloat(String(souceData['content'][i][souceData['comboAggType'][i]])));*/
		colIndex++;
	}
	var options={
		title: 'Combo Chart for '+ souceData['comboColumnCat'],
		vAxis: {title : souceData['comboColumnAgg'] + " value"},
		hAxis: {title : souceData['comboColumnCat']},
		height: $("#"+gadgetID).height(),
		seriesType: "bars"
	};
	var chart = new google.visualization.ComboChart(document.getElementById(gadgetID));
	chart.draw(data,options);
	return data;

}

//refresh chart without loading new data.
function refreshCombo(data,sourceData,gadgetID) {
	var options={
		title: 'Combo Chart for '+ sourceData['comboColumnCat'],
		vAxis: {title : sourceData['comboColumnAgg'] + " value"},
		hAxis: {title : "Aggregation Type"},
		height: $("#"+gadgetID).height(),
		seriesType: "bars"
	};
	var chart = new google.visualization.ComboChart(document.getElementById(gadgetID));
	chart.draw(data,options);
}
//create the gadget for combo chart
function createNewComboGadget(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random()*100);
	var gadgetID = d.getTime() + ranNum + "";

	var gadget = "<div name='comboDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:400px; height: 300px' type='combo'>";
	gadget +=  "<div class='gadget-header'><div class='gadget-title'>Combo chart " + gadgetID+"</div>";
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-pie'><i class='icon-edit'></i></div>";
	gadget += "<div class='gadget-normal' style = 'display:none'><i class='icon-resize-small'></i></div>";
	gadget += "<div class='gadget-max'><i class='icon-resize-full'></i></div>";
	gadget += "<div class='gadget-min'><i class='icon-minus'></i></div> </div>";
	gadget += "<input type='hidden' id='setting"+gadgetID+"' value='' />"; 	
	gadget += "<div class='gadget-content'>";
	gadget += "<div id='comboResult" + gadgetID + "' style='width:100%;'></div></div></div>";
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
	$('#'+gadgetID+' .edit-combo').click(function(){
		var editGadgetID = $(this).parent().parent().attr('id');
		var cid = $("#"+editGadgetID+" .chartID").val();
		resetEditFormSidTable("editComboSid",'editComboTable');
		comboDataInfoToForm(CHARTS[cid]['datainfo']);
		$('#editCombo').modal('show');
		CANVAS.selectedChart = cid;
	});
	$("#"+gadgetID).resize(function() {
		var cid = $(this).find('.chartID').val();
		var gadgetID = $(this).attr('id');
		var chart = CHARTS[cid];
		$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
		refreshCombo(chart.chartData,chart.queryResult,"comboResult"+gadgetID);
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
//create new combo chart
function addComboChart() {
	var datainfo = comboFormToDatainfo();
	if (datainfo == null) {
		return;
	}
	var gadgetID = createNewComboGadget();
	$.ajax({
		type: 'POST',
		url: "control.php",
		data: {action: 'addChart',
		name: 'ComboChart',
		vid: $('#vid').val(),
		type: 'combo',
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
			CHARTS[JSON_Response['cid']] = new Chart(JSON_Response['cid'],JSON_Response['name'],JSON_Response['type'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['note'],JSON_Response['datainfo'],JSON_Response['queryResult'],"comboResult" + gadgetID);
			gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
			$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			CHARTS[JSON_Response['cid']].chartData = drawCombo(queryResult,'comboResult'+gadgetID);
			$("#"+gadgetID).find('.gadget-title').text("Combo chart in "+CHARTS[JSON_Response['cid']].getSname() + ":" + CHARTS[JSON_Response['cid']].getTable());
			$('#addCombo').modal('hide');
		}
		})
}
//Load existing chart.
function loadComboChart(sourceData) {
	var gadgetID = createNewComboGadget();
	var queryResult = sourceData['queryResult'];
	CHARTS[sourceData['cid']] = new Chart(sourceData['cid'],sourceData['name'],sourceData['type'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['note'],sourceData['datainfo'],sourceData['queryResult'],"comboResult" + gadgetID)
	$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
	CHARTS[sourceData['cid']].chartData =  drawCombo(queryResult,'comboResult'+ gadgetID);
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	$("#"+gadgetID).find('.gadget-title').text("Combo chart in "+CHARTS[sourceData['cid']].getSname() + ":" + CHARTS[sourceData['cid']].getTable());
}
//Update the chart
function updateComboResult(cid) {
	var chart = CHARTS[cid];
	var gadgetID = CHARTS[cid].gadgetID;
	var datainfo = editComboFormToDatainfo();
	if (datainfo == null) {
		return;
	}
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
			drawCombo(queryResult,gadgetID);
			$('#editCombo').modal('hide');
		}
		})
}