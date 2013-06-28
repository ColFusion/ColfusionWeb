var result;
currentPage = 0;
prePage = 0;
nextPage = 0;
totalPage = 0;
var tabledata;
function openCharts(vid,vname){
	$("#filter_section").children("div").hide();
	$("#charts_section").show();
	$("#openbutton_section").html('<button id="openButton" class="btn btn-info" type="button" onclick="openCanvas('+vid+')"> OpenCanvas </button>')
	$(".alert-info").html("<strong>How To Add Charts To Your Own Canvas:</strong> Drag the charts to the canvas on the left (Click the text input box to go back to filter state). ");

	$.ajax(
			{
				url:"control.php",
				data:{vid:vid,action:'openCanvas'},
				success:function(data){

				    var _data = jQuery.parseJSON(data);
				    var number = 0;
				    $("#display_charts").html('<ul class="nav nav-list"><li class="nav-header">Charts In '+vname+' :</li>');
				    for(var i in _data['charts']){
				    	var temp = _data['charts'][i];
				    	result = temp;
				    		$("#charts_section ul").append('<li><a href="#openchart" data-toggle="modal">'+temp['name']+'</a></li>');
				    }
				    $("#charts_section li").last().append('</ul>');
				}
			}
		 ).done(function(){
			 $("#charts_section li").click(
						function(){
							if (!$(this).hasClass("active")){
								$("ul li[class='active']").removeClass("active");
								$(this).addClass("active");
							}	
							
						}
			)
		 })
}

function returnNormal(){
	$("#charts_section").hide();
	$("#authorization_filter").show();
	$("#date_filter").show();
	$(".alert-info").html("<strong>How To Use Search:</strong>Use the initial letters of CANVAS NAME , OWNER'S NAME or OWNER'S NAME + CANVAS NAME of THAT OWNER to filter.   ");
}
function openCanvas(vid){
	
	var s = confirm("Save The Current Canvas????");
	$("#open").modal('hide');
	clearScreen();
	$.ajax(
		{
			url:"control.php",
			data:{vid:vid,s:s,action:'openCanvas'},
			success:function(data){
				
			
			  /*  google.setOnLoadCallback(drawPie);*/
				
			    var _data = jQuery.parseJSON(data);
				
				for (var i in _data['charts']){
					
					result =  _data['charts'][i];
					
					switch (result['type']){
					case 'pie':
						drawPies();
						break;
					case 'motion':
						drawMotions();
						break;
					case 'map':
						drawMaps();
						break;
					case 'table':
						drawTables();
						break;
					case 'combo':
						drawCombos();
						break;
					case 'column':
						drawColumns();
						break;
					}
				}
				$('#testSave').show();
				$('#file-dropdown').show();
				$('#chart-dropdown').show();
				$('#view-dropdown').show();
				$('#newCanvas').modal('hide');
				$('#vid').val(_data['vid']);
				$('#canvasName').val(_data['name']);
				$('#privilege').val(_data['privilege']);
				$('#authorization').val(_data['authorization']);
				$('#mdate').val(_data['mdate']);
				$('#cdate').val(_data['cdate']);
				$('#note').val(_data['note']);
				$('#brand').text(_data['name']);
			}	 
		});
	}
/*function openCanvas(vid){
	
	var s = confirm("Save The Current Canvas????");
	
	clearScreen();
	
	$.ajax(
		{
			url:"control.php",
			data:{vid:vid,s:s,action:'openCanvas'},
			success:function(data){
				
			
			  // google.setOnLoadCallback(drawPie);
				
			    var _data = jQuery.parseJSON(data);
				
				for (var i in _data['charts']){
					
					result =  _data['charts'][i];
					
					switch (result['type']){
					case 'pie':
						drawPies();
						break;
					case 'motion':
						drawMotions();
						break;
					case 'map':
						drawMaps();
						break;
					case 'table':
						drawTables(2,vid);
						break;
					case 'combo':
						drawCombos();
						break;
					case 'column':
						drawColumns();
						break;
					}
				}
			}	 
		});
	}
*/

function drawPies(){
	createNewPie();
	var res;
	if (typeof(result['queryResult']) == 'string') {
		res = jQuery.parseJSON(result['queryResult']);
	}else{
		res = result['queryResult'];
	}
	google.load("visualization", "1", {packages:["corechart"]});
    var data = new google.visualization.DataTable();

    data.addColumn('string', res['string']);
	data.addColumn('number', res['number']);
     
	var q = res['content'];
	 
	for(i=0 ;q[i]!=null ; i++){
		
		data.addRow();
		data.setCell(i, 0, String(q[i]["Category"]));
		data.setCell(i, 1 ,parseFloat(String(q[i]["AggValue"])));
	}
	
	var options = {
    	      'title':'Pie Chart for ' + res['string'] + ' based on ' + res['number']
    	};

	$("#pieResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);

	var chart = new google.visualization.PieChart(document.getElementById('pieResult'+gadgetID));
	chart.draw(data, options);
	gadgetProcess(gadgetID,'peichart','pie','note','datainfo');
}

function gadgetProcess(gadgetID,name,type,note,datainfo){
	
	$("#"+gadgetID).css({"position":"absolute","top":result["top"]+"px","left":result["left"]+"px","z-index":result["depth"]});
	$("#"+gadgetID).append("<input type='hidden' class='chartName' name = 'chartName 'value = '"+name+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='chartNote'name = 'chartNote 'value = '"+note+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='type' name = 'type 'value = '"+type+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='datainfo' name = 'datainfo 'value = '"+datainfo+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='chartID' name = 'chartID 'value = '"+result['cid']+"'>");
}

function drawColumns(){
	createNewColumn();
	
	
	var res = result['queryResult'];
	
	google.load("visualization", "1", {packages:["corechart"]});
    var data = new google.visualization.DataTable();

    data.addColumn('string', res['string']);
	data.addColumn('number', res['number']);

     
	var q = res['content'];
	for(i=0 ;q[i]!=null ; i++){
		
		data.addRow();
		data.setCell(i, 0, String(q[i]["Category"]));
		data.setCell(i,1,parseFloat(String(q[i]["AggValue"])));
		
	}
	
    var options = {
    	      'title':'Column Chart for ' + res['string'] + ' based on ' + res['number']
    	};

    $("#columnResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
	
    var chart = new google.visualization.ColumnChart(document.getElementById('columnResult'+gadgetID));
    chart.draw(data, options);
    gadgetProcess(gadgetID);
}


function drawTables(){
			
			totalPage = result["totalPage"];
			var Columns = result["tableColumns"];
			data = new google.visualization.DataTable();
			
			for(i=0; i<Columns.length; i++){
				data.addColumn('string',Columns[i]);
			}
			for(i=0 ; result["data"][i]!=null ;i++){
				data.addRow();
				data.setCell(i, 0, String(result["data"][i][0]));
				for(k=1; k<result["data"][i].length; k++) {
					data.setCell(i, k, String(result[i][k]));
				}
			}

			tabledata = data;
			$("#tableResult" + gadgetID).height($("#" + gadgetID).height() - 100);				
			generateTable(gadgetID);
			initPageSelect();

}
function clearScreen(){
	$("#file_manager").hide();
	$(".gadget").remove();
}
function addPieChart() {
    $.ajax({
        type: 'POST',
		//url: "getPie.php",
	url: "control.php",
		//data: {'pieColumnCat':pieColumnCat, 'pieColumnAgg':pieColumnAgg, 'pieAggType':pieAggType, 'titleNo':titleNo, 'where':where},
	data:{
            action: 'addChart',
            name: 'bdfdfd',
            vid: $('#vid').val(),
            type: 'pie',
            width: 400,
            height: 300,
            depth: 2,
            top: 50,
            left: 0,
            note: 'dfdff',
            datainfo: 'I DONNOT KNOW WHAT IS THE QUERY'
	},
        success:function(JSON_Response){
            JSONResponse = jQuery.parseJSON(JSON_Response);
	    var cid = JSONResponse['cid'];
	    var queryResult = jQuery.parseJSON(JSONResponse['queryResult']);
	    result = JSONResponse;
	    drawPies();
	    $('#addPie').modal('hide');
        }
    })
}