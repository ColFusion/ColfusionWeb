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

function drawPie(type,vid){
	gadgetID = vid;
	titleNo = $('#titleNo').val(); 
	where = $("#where").val();	
	/*
	pieColumnCat = "";
	pieColumnAgg = "";
	pieAggType = "";
	settings = "";
	*/
	
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
			/*
			if(pieType == 'Count'){
				data.addColumn('number','Amount');
			}
			else{
				data.addColumn('number','Value');
			} */
			for(i=0 ; JSONResponse[i]!=null ; i++){
				data.addRow();
				data.setCell(i, 0, String(JSONResponse[i]["Category"]));
				data.setCell(i,1,parseFloat(String(JSONResponse[i]["AggValue"])));
				/*
				data.setCell(i,0,String(JSONResponse[i].Location));
				if(pieType == 'Count'){
					data.setCell(i,1,parseInt(String(JSONResponse[i].Amount)));
				}
				else{
					data.setCell(i,1,parseFloat(String(JSONResponse[i].Value)));
				} 
				*/
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
}

function createNewPie(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random()*100);
	gadgetID = d.getTime() + ranNum + "";

	var gadget = "<div name='pieDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:400px; height: 300px' type='pie'>";
	gadget +=  "<div class='gadget-header'>Pie Chart" + gadgetID;
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-pie'><a href='#editPie' data-toggle='modal'><i class='icon-edit'></i></a></div> </div>";
	gadget += "<input type='hidden' id='setting"+gadgetID+"' value='' />";  
	gadget += "<div class='gadget-content'>";
	gadget += "<div id='pieResult" + gadgetID + "' style='width:100%;'></div></div></div>";
	
	$('.chart-area').append(gadget);
	$( ".gadget" )
	  .draggable({ handle: ".gadget-header" })
	  .resizable();
	    $(".gadget-close").click(function() {   
		    $(this).parent().parent().remove();
	    })
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
		drawPie(3,editGadgetID);
	});
}