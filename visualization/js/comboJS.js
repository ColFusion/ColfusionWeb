google.load('visualization', '1.0', {'packages':['corechart']});
//google.setOnLoadCallback(drawCombo);
    
gadgetID = 0;

function loadCombos() {
	combos = document.getElementsByName("comboDivs");
	gadgetIDs = new Array();
    for(comboNum=0 ; comboNum<combos.length ; comboNum++){
        theCombo = combos[comboNum];
		gadgetIDs.push(theCombo.id);
        drawCombo(2,"comboResult"+gadgetIDs[comboNum]);
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
	data.addColumn('string','Type');
	for(i=0; souceData[i]!=null ; i++)
	{
		data.addColumn('number',String(souceData[i]['Category']));
	}
	
	for(i=0 ; i<3; i++){
		data.addRow();
	}
	data.setCell(0,0,'AVG');
	data.setCell(1,0,'MAX');
	data.setCell(2,0,'MIN');
	
	var colIndex = 1;
	for(i=0 ; souceData[i]!=null ; i++){
		data.setCell(0,colIndex,parseFloat(String(souceData[i]['AVG'])));
		data.setCell(1,colIndex,parseFloat(String(souceData[i]['MAX'])));
		data.setCell(2,colIndex,parseFloat(String(souceData[i]['MIN'])));
		colIndex++;
	}
	var options={
		title: 'Combo Chart for '+ comboColumnCat,
		vAxis: {title : comboColumnAgg + " value"},
		hAxis: {title : "Aggregation Type"},
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
	gadget +=  "<div class='gadget-header'>Combo Chart" + gadgetID;
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-combo'><a href='#editCombo' data-toggle='modal'><i class='icon-edit'></i></a></div> </div>";
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
		drawCombo(3,"comboResult"+editGadgetID);
	});
	return gadgetID;
}
//create new combo chart
function addComboChart() {
	var gadgetID = vid;
	var titleNo = $('#titleNo').val();
	var where = $("#where").val();	
	var comboColumnCat = "";
	var comboColumnAgg = "";
	var settings = "";
	var  datainfo = {'comboColumnCat':comboColumnCat,'comboColumnAgg':comboColumnAgg,'titleNo':titleNo,'where':where};
	comboColumnCat = $('#comboColumnCat').val();
	comboColumnAgg = $('#comboColumnAgg').val();
	settings = comboColumnCat + ";" + comboColumnAgg + ";";
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
			drawCombo(queryResult,"comboResult"+gadgetID);
			gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
			$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
			$('#addCombo').modal('hide');
		}
		})
}
//Load existing chart.
function loadComboChart(sourceData) {
	var gadgetID = createNewComboGadget();
	var queryResult = sourceData['queryResult'];
	drawCombo(queryResult,"comboResult"+gadgetID);
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	$("#comboResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
}