google.load('visualization', '1.0', {'packages':['corechart']});
//google.setOnLoadCallback(drawCombo);
    
gadgetID = 0;

function loadCombos() {
	combos = document.getElementsByName("comboDivs");
	gadgetIDs = new Array();
    for(comboNum=0 ; comboNum<combos.length ; comboNum++){
        theCombo = combos[comboNum];
		gadgetIDs.push(theCombo.id);
        drawCombo(2,gadgetIDs[comboNum]);
    }
}

/****************
type
1: initial creation of combo chart
2: reload combo chart from database
3: edit existing combo chart
*****************/

function drawCombo(type,vid){
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
		/*
		$.each($("input[name='comboAggType']:checked"), function(){
			comboAggType.push($(this).val());
			settings += "," + $(this).val();
		});
		*/
		//settings = settings.substring(1);
		//settings = comboColumnCat + ";" + comboColumnAgg + ";" + settings + ";";
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

	$.ajax({
		type: 'POST',
		url: "getCombo.php",
		data: {'comboColumnCat':comboColumnCat,'comboColumnAgg':comboColumnAgg,'titleNo':titleNo,'where':where},
		success: function(JSON_Response){

		var JSONResponse = JSON_Response;
			//document.getElementById('comboResult').innerHTML = JSON.stringify(JSONResponse);
			data = new google.visualization.DataTable();
			data.addColumn('string','Type');
			for(i=0; JSONResponse[i]!=null ; i++)
			{
				data.addColumn('number',String(JSONResponse[i].Category));
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
				data.setCell(0,colIndex,parseFloat(String(JSONResponse[i].AVG)));
				data.setCell(1,colIndex,parseFloat(String(JSONResponse[i].MAX)));
				data.setCell(2,colIndex,parseFloat(String(JSONResponse[i].MIN)));
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

function createNewCombo(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random()*100);
	gadgetID = d.getTime() + ranNum + "";

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
        $(this).parent().parent().hide();
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
		drawCombo(3,editGadgetID);
	});
}
