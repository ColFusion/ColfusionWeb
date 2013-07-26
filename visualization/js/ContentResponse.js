var result;
currentPage = 0;
prePage = 0;
nextPage = 0;
totalPage = 0;
var tabledata;
var maxDepth;
var Canid;


function setChart(chart){
	
	switch (chart['type']){
	case 'pie':
		drawPie(chart['queryResult'],"displaychart");
		break;
	case 'motion':
		drawMotion(chart['queryResult'],"displaychart");
		break;
	case 'map':
		drawMap(chart['queryResult'],"displaychart");
		break;
	case 'table':
		drawTable(chart['queryResult'],"displaychart");
		break;
	case 'combo':
		drawCombo(chart['queryResult'],"displaychart");
		break;
	case 'column':
		drawColumn(chart['queryResult'],"displaychart");
		break;
	}
}

function openCharts(vid,vname){
	Canid = vid;
	$("#filter_section").children("div").hide(1000);
	$("#charts_section").show(1000);
	$("#openbutton_section").html('<button id="openButton" class="btn btn-info" type="button" onclick="openCanvas('+vid+')"> OpenCanvas </button>')

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
				    	var chartj = $.toJSON(temp);
				    		$("#charts_section ul").append("<li><a onclick = 'setChart("+chartj+")' href='#openchart' data-toggle='modal'>"+temp['name']+"</a></li>");
				    }
				    $("#charts_section li").last().append('</ul>');
				}
			}
		 ).done(function(){
			 $("#charts_section li").click(
						function(){
							if (!$(this).hasClass("active")){
								$("#charts_section ul li[class='active']").removeClass("active");
								$(this).addClass("active");
							}	
							
						}
			)
		 })
}



function openCanvas(vid){
	
	$("#open").modal('hide');
	clearScreen();
	$("#file_manager").hide();
	vid = vid;
	$("#viewChartsNote").show();
	$("#viewChartsNote").removeClass("active");
	$.ajax(
		{
			url:"control.php",
			data:{vid:vid,action:'openCanvas'},
			success:function(data){
				maxDepth = -1;
			
			  /*  google.setOnLoadCallback(drawPie);*/
				
				var _data = jQuery.parseJSON(data);
				CANVAS = new Canvas(_data['vid'],_data['name'],_data['privilege'],_data['authorization'],_data['mdate'],_data['cdate'],_data['note']);
				CANVAS.isSave = true;
				$('#chart-dropdown').hide();
				for (var i in _data['charts']){
					
					result =  _data['charts'][i];
					
					switch (result['type']){
					case 'pie':
						loadPieChart(result);
						break;
					case 'motion':
						loadMotionChart(result);
						break;
					case 'map':
						loadMapChart(result);
						break;
					case 'table':
   				        	loadTableChart(result);

						break;
					case 'combo':
						loadComboChart(result);
						break;
					case 'column':
						loadColumnChart(result);
						break;
					}
				}
				$('#testSave').show();
				$('#file-dropdown').show();
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
	gadgetProcess(gadgetID,result['cid'],result['name'],result['top'],result['left'],result['height'],result['width'],result['depth'],result['type'],result['note'],'datainfo');
}

function gadgetProcess(gadgetID,cid,name,top,left,height,width,depth,type,note,datainfo){
	$("#"+gadgetID).css({"position":"absolute","top":top+"px","left":left+"px","z-index":depth});
	$("#"+gadgetID).append("<input type='hidden' class='chartName' name = 'chartName 'value = '"+name+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='chartNote'name = 'chartNote 'value = '"+note+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='type' name = 'type 'value = '"+type+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='datainfo' name = 'datainfo 'value = '"+datainfo+"'>");
	$("#"+gadgetID).append("<input type='hidden' class='chartID' name = 'chartID 'value = '"+cid+"'>");
	$("#"+gadgetID).click(function (){
		$("#"+gadgetID).css({"z-index":++maxDepth});
		var chartID = $("#"+gadgetID+" input.chartID").val();
		var sid = CHARTS[chartID].getSid();
		var tablename = CHARTS[chartID].getTable();
		$(".container").addClass("blueflag");
		$("#note_section li").removeClass("blueDecoration");
		$("#"+sid+"storiesTable").addClass("blueDecoration");
		tablename = tablename.split(".");
		tablename = tablename[0]+tablename[1];
		$("#"+sid+tablename).addClass("blueDecoration");	
	})
	if (parseInt(depth)>maxDepth) {
		maxDepth = parseInt(depth);
	}
}

function drawColumns(){
	createNewColumn();
	
	var res = result['queryResult'];
	
	google.load("visualization", "1", {packages:["corechart"]});
    var data = new google.visualization.arrayToDataTable(res['content']);

    var options = {
    	      'title':'Column Chart for ' + res['cat'] + ' based on ' + res['agg']
    	};

    $("#columnResult" + gadgetID).height($("#" + gadgetID).height() - $(".gadget-header").height() - 20);
	
    var chart = new google.visualization.ColumnChart(document.getElementById('columnResult'+gadgetID));
    chart.draw(data, options);
    gadgetProcess(gadgetID,result['cid'],result['name'],result['top'],result['left'],result['height'],result['width'],result['depth'],result['type'],result['note'],'datainfo');
}


function clearScreen(){
	$(".gadget").remove();
}

