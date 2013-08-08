google.load('visualization', '1', {packages: ['table']});

var JSONResponse;
currentPage = 0;
prePage = 0;
nextPage = 0;
totalPage = 0;
var tabledata;

function loadTables(){
    tables = document.getElementsByName("tableDivs");
    gadgetIDs = new Array();
    for(tableNum=0 ; tableNum<tables.length ; tableNum++){
        theTable = tables[tableNum];
        gadgetIDs.push(theTable.id);
        loadTableData(2,gadgetIDs[tableNum]);
    }
}

/****************
type
1: initial creation of table
2: reload table from database
3: edit existing table
*****************/
/*
function loadTableData(type, vid){
    gadgetID = vid;
    titleNo = $("#titleNo").val();
    where = $("#where").val();
	settings = "";
	perPage = "";
	color = "";
	currentPage = "";
	
	if(type == 1) {//initial creation of table
        createNewTable();
		perPage = $('input:radio[name="page"]:checked').val(); // number of turples per page
		color = $('input:radio[name="color"]:checked').val(); // color of the new table		
		currentPage = $('input:hidden[name="currentPage"]').val();
		//display = $('input:radio[name="display"]:checked').val();
		tableColumns = new Array();
		$.each($("input[name='tableColumns']:checked"), function(){
			tableColumns.push($(this).val()); // columns to show
			settings += "," + $(this).val();
		});		
        settings = settings.substring(1) + ";";	
        settings += perPage + ";";
        settings += color + ";";
		$('#setting' + gadgetID).val(settings);
	}
	else if(type == 2) {//reload created table
		settings = $('#setting' + gadgetID).val();
		var n = settings.split(";");
		columns = n[0].split(",");
		tableColumns = new Array();
		for(i=0 ; i<columns.length ; i++) {
			tableColumns.push(columns[i]);
		}
		perPage = n[1];// number of turples per page
		color = n[2];// color of the new table
		//currentPage = $('input:hidden[name="currentPage"]').val();
		currentPage = 1;
	}
	else if(type == 3) {//edit table
		settings = "";
		perPage = $('input:radio[name="pageEdit"]:checked').val(); // number of turples per page
		color = $('input:radio[name="colorEdit"]:checked').val(); // color of the new table		
		currentPage = $('input:hidden[name="currentPage"]').val();
		//display = $('input:radio[name="display"]:checked').val();
		tableColumns = new Array();
		$.each($("input[name='tableColumnsEdit']:checked"), function(){
			tableColumns.push($(this).val()); // columns to show
			settings += "," + $(this).val();
		});		
        settings = settings.substring(1) + ";";	
        settings += perPage + ";";
        settings += color + ";";
		$('#setting' + gadgetID).val(settings);	
	}

	drawTable();
	
	if(type == 1) {
		$('#addTable').modal('hide');
	}
	else if(type == 3) {
		$('#editTable').modal('hide');
	}
  
}
*/


function initPageSelect(gadgetID,totalPage,currentPage) {
    var pageSelect = document.getElementById("pages" + gadgetID);
    while (pageSelect.hasChildNodes()) {
        pageSelect.removeChild(pageSelect.lastChild);
    }	
    for(n=1 ; n<=totalPage ; n++){
        var page = document.createElement("option");
        page.innerHTML = n;
        pageSelect.appendChild(page);
    }
	if(currentPage == '1'){
		$("#prePage"+gadgetID).hide();
	}
	else{
		$("#prePage"+gadgetID).show();
	}
	if(currentPage == totalPage){
		$("#nextPage"+gadgetID).hide();
	}
	else {
		$("#nextPage"+gadgetID).show();
	}
	$('#pages'+gadgetID).val(currentPage);
}
function activatePageSelect(gadgetID){
	$("#pages"+gadgetID).change(function (){
	    changePage(this);
	    });
	$("#prePage"+gadgetID).click(function(gadgetID) {
	    changePage(this);
	    });
	$("#nextPage"+gadgetID).click(function() {
		changePage($(this))
	    });
}

function changePage(obj){
    var div = $(obj).parent().parent().parent();
    var cid = $(div).find('.chartID').val();
    var gadgetID = $(div).attr('id');
    var chart = CHARTS[cid];
    var datainfo = chart.datainfo;
    if ($(obj).val()=='Next'){
	datainfo.currentPage = parseInt(datainfo.currentPage)+1;
    }else if($(obj).val()=='Previous'){
	datainfo.currentPage = parseInt(datainfo.currentPage)-1;
    }else{
	datainfo.currentPage = $(obj).val();
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
		    drawTable(queryResult,'tableResult'+gadgetID);
	    }
    })
    /*var settings = $('#setting' + gadgetID).val();
    var n = settings.split(";");
    columns = n[0].split(",");
	tableColumns = new Array();
    for(i=0 ; i<columns.length ; i++) {
        tableColumns.push(columns[i]);
    }
    perpage = n[1];// number of turples per page
    color = n[2];// color of the new table
	currentPage = $('#pages'+gadgetID).val();

	if(currentPage == '1'){
		$("#prePage"+gadgetID).hide();
	}
	else {
		$("#prePage"+gadgetID).show();
	}
	if(currentPage == totalPage){
		$("#nextPage"+gadgetID).hide();
	}
	else {
		$("#nextPage"+gadgetID).show();
	}
	
	drawTable();*/
}

function tableFormToDatainfo() {
	var sid = $("#addTableSid").val();
	var sname = $('#addTableSid').find("option:selected").text();
	var where;
	var table = $("#addTableTable").val();
	var perPage = $('input:radio[name="page"]:checked').val(); // number of turples per page
	var color = $('input:radio[name="color"]:checked').val(); // color of the new table		
	var currentPage = $('input:hidden[name="currentPage"]').val();
	var tableColumns = new Array();
	$.each($("#addTable .columnSelection").find("input:checked"), function(){
	        var cid = $(this).val();
		var columnName = $(this.nextSibling).text();
		tableColumns.push({cid:cid,columnName:columnName}); // columns to show
	});
	if (tableColumns.length == 0) {
	    $("#add-table-info").show().text("Please select at least one column.");
	    $("#add-table-info").addClass("alert-error");
	    return null;
	}
	return new TableDatainfo(tableColumns,perPage,color,currentPage,sid,sname,table,where);
}
function editTableFormToDatainfo() {
	var sid = $("#editTableSid").val();
	var sname = $('#editTableSid').find("option:selected").text();
	var where;
	var table = $("#editTableTable").val();
	var perPage = $('input:radio[name="pageEdit"]:checked').val(); // number of turples per page
	var color = $('input:radio[name="colorEdit"]:checked').val(); // color of the new table		
	var currentPage = $('input:hidden[name="currentPageEdit"]').val();
	var tableColumns = new Array();
	$.each($("#editTable .columnSelection").find("input:checked"), function(){
		var cid = $(this).val();
		var columnName = $(this.nextSibling).text();
		tableColumns.push({cid:cid,columnName:columnName}); // columns to show
	});
	if (tableColumns == null) {
	    $("#edit-table-info").show().text("Please select at least one column.");
	    $("#edit-table-info").addClass("alert-error");
	    return null;
	}
	return new TableDatainfo(tableColumns,perPage,color,currentPage,sid,sname,table,where);
}
function TableDatainfo(tableColumns,perPage,color,currentPage,sid,sname,table,where) {
	this.tableColumns = tableColumns;
	this.perPage = perPage;
	this.color = color;
	this.currentPage = currentPage;
	this.sid = sid;
	this.sname = sname;
	this.table = table;
	this.where = where;
	this.inputObj = CANVAS['stories'][sid]['inputObj'];
}
function tableDataInfoToForm(tableDatainfo) {
	clearTableEditForm();
	var sid = tableDatainfo.sid;
	var sname =tableDatainfo.sname;
	var where = tableDatainfo.where;
	var table = tableDatainfo.table;
	var tableColumns = tableDatainfo.tableColumns;
	var perPage = tableDatainfo.perPage;
	var currentPage = tableDatainfo.currentPage;
	var color = tableDatainfo.color;
	$('#editTableSid').val(sid);
	$('#editTableSid').find("option:selected").text(sname);
	$('#editTableTable').val(table);
	$('#editTableTable').change();
	$('input:radio[name="pageEdit"][value="'+perPage+'"]').prop('checked','checked');
	$('input:radio[name="colorEdit"][value="'+color+'"]').prop('checked','checked');
	$('input:hidden[name="currentPageEdit"]').val(currentPage);
	if (tableColumns!=null) {
	    for (var i = 0;i<tableColumns.length;i++) {
		    //var value = tableColumns[i];
		    var obj = $("#editTable .columnSelection input:checkbox[value='"+tableColumns[i].cid+"']");
		    obj.prop('checked','checked');
	    }
	}
	
}
function clearTableEditForm() {
	$('input:checkbox[name="pageEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
	$('input:checkbox[name="colorEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
	$('input:checkbox[name="tableColumnsEdit"]').each(function() {
	    $(this).removeAttr('checked');
	})
}

function generateTable(a,_color){
    //alert("generate" + a);
    var googleTable = {
        'headerRow': 'header-row',
        'tableRow': 'table-row',
        'oddTableRow': 'odd-table-row-' + _color,
        'selectedTableRow': 'selected-table-row-' + _color,
        'hoverTableRow': 'hover-table-row',
        'headerCell': 'header-cell-' + _color,
        'tableCell': 'table-cell-' + _color,
        'rowNumberCell': 'row-number-cell'};
	var options = {'showRowNumber': false, 'allowHtml': true, 'cssClassNames': googleTable};
	var table = new google.visualization.Table(document.getElementById('tableResult' + a));
	table.draw(tabledata, options);
	
	/*
	$("div[name='tableDivs']").resize(function() {
        $("#tableResult" + a).height($("#" + a).height() - 100);
        table.draw(tabledata, options);
    });*/
	
}

function createNewTableGadget(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random() * 100);
	var gadgetID = d.getTime() + ranNum + "";
	
	var gadget = "<div name='tableDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:1160px; height: 500px' type='table'>";
	gadget += "<div class='gadget-header'><div class='gadget-title'>Table" + gadgetID+"</div>";
	gadget +=  "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-pie'><i class='icon-edit'></i></div>";
	gadget += "<div class='gadget-normal' style = 'display:none'><i class='icon-resize-small'></i></div>";
	gadget += "<div class='gadget-max'><i class='icon-resize-full'></i></div>";
	gadget += "<div class='gadget-min'><i class='icon-minus'></i></div> </div>";
	gadget += "<input type='hidden' id='setting" + gadgetID + "' value='' />";
	gadget += "<div class='gadget-content'>";
	gadget += "<div id='tableControl" + gadgetID + "' style='width:100%; '>";
	gadget += "<select id='pages" + gadgetID + "' style='width: 100px; margin-top: 10px;'></select> ";
	gadget += "<input type='button' id='prePage" + gadgetID + "' class='btn' value='Previous' style='margin-left:20px' />";
	gadget += "<input type='button' id='nextPage" + gadgetID + "' class='btn' value='Next' style='margin-left:20px' /></div>";
	gadget += "<div class='test2' id='tableResult" + gadgetID + "' style='width:100%;'></div></div></div>";

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
	$("#"+gadgetID+' .edit-table').click(function(){
		var editGadgetID = $(this).parent().parent().attr('id');
		var cid = $("#"+editGadgetID+" .chartID").val();
		resetEditFormSidTable("editTableSid",'editTableTable');
		tableDataInfoToForm(CHARTS[cid]['datainfo']);
		$('#editTable').modal('show');
		CANVAS.selectedChart = cid;
	});
	$("#"+gadgetID).resize(function() {
		var cid = $(this).find('.chartID').val();
		var gadgetID = $(this).attr('id');
		var chart = CHARTS[cid];
		$("#tableResult" + gadgetID).height($("#" + gadgetID).height() - 100);
		refreshTable(chart.chartData,chart.queryResult,"tableResult"+gadgetID);
	})
	var dropdown = "<li class='view' id='view" + gadgetID + "'><a href='#' data-toggle='modal'>'table' "+gadgetID+"</a></li>";
	$("#chartview").append(dropdown);
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


function drawTable(sourceData,gadgetID){
	totalPage = sourceData["totalPage"];
	var color = sourceData["color"];
	var resulData = sourceData["content"];
	var data = new google.visualization.DataTable();
	var tableColumns = sourceData['tableColumns'];
	var returnedColumns = sourceData['returnedColumns'];
	//data.addColumn('string','rownum');
	for(i=0; i<tableColumns.length; i++){
		data.addColumn('string', tableColumns[i]['columnName']);
	}
	for(i=0 ; resulData[i]!=null ; i++){
		data.addRow();
	//	data.setCell(i, 0, String(i+1));
		var temp = 0;
		for(k=0; k<tableColumns.length; k++) {
			data.setCell(i, temp++, String(resulData[i][returnedColumns[k]]));
		}
	}
	var arr = gadgetID.split('Result');
	var id;
	if (arr.length > 1) {
	    id = arr[1];
	}else{
	    id = gadgetID;
	}
	initPageSelect(id,sourceData['totalPage'],sourceData['currentPage']);
    	var googleTable = {
	    'headerRow': 'header-row',
	    'tableRow': 'table-row',
	    'oddTableRow': 'odd-table-row-' + color,
	    'selectedTableRow': 'selected-table-row-' + color,
	    'hoverTableRow': 'hover-table-row',
	    'headerCell': 'header-cell-' + color,
	    'tableCell': 'table-cell-' + color,
	    'rowNumberCell': 'row-number-cell'};
	var options = {'showRowNumber': false, 'allowHtml': true, 'cssClassNames': googleTable};
	var table = new google.visualization.Table(document.getElementById(gadgetID));
	table.draw(data, options);
	return data;
	/*$("div[name='tableDivs']").resize(function() {
		tempid = $(this).attr("id");
		$("#tableResult" + tempid).height($("#" + tempid).height() - 100);
	    
	});*/		
	
}

//refresh table without loading new data.
function refreshTable(data, sourceData,gadgetID) {
	var googleTable = {
	    'headerRow': 'header-row',
	    'tableRow': 'table-row',
	    'oddTableRow': 'odd-table-row-' + sourceData['color'],
	    'selectedTableRow': 'selected-table-row-' + sourceData['color'],
	    'hoverTableRow': 'hover-table-row',
	    'headerCell': 'header-cell-' + sourceData['color'],
	    'tableCell': 'table-cell-' + sourceData['color'],
	    'rowNumberCell': 'row-number-cell'};
	var options = {'showRowNumber': false, 'allowHtml': true, 'cssClassNames': googleTable};
	var table = new google.visualization.Table(document.getElementById(gadgetID));
	table.draw(data, options);
}
function addTableChart() {
	var datainfo = tableFormToDatainfo();
	if (datainfo == null) {
	    return;
	}
	var gadgetID = createNewTableGadget();
	$.ajax({
		type: 'POST',
		url: "control.php",
		data:{
		action: 'addChart',
		name: 'TableChart',
		vid: $('#vid').val(),
		type: 'table',
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
		    CHARTS[JSON_Response['cid']] = new Chart(JSON_Response['cid'],JSON_Response['name'],JSON_Response['type'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['note'],JSON_Response['datainfo'],JSON_Response['queryResult'],"tableResult" + gadgetID)
		    gadgetProcess(gadgetID,JSON_Response['cid'],JSON_Response['name'],JSON_Response['top'],JSON_Response['left'],JSON_Response['height'],JSON_Response['width'],JSON_Response['depth'],JSON_Response['type'],JSON_Response['note'],'datainfo');
		    $("#tableResult" + gadgetID).height($("#" + gadgetID).height() - 100);
		    CHARTS[JSON_Response['cid']].chartData = drawTable(queryResult,'tableResult'+gadgetID);
		    activatePageSelect(gadgetID);
		    $('#addTable').modal('hide');
		    $("#"+gadgetID).find('.gadget-title').text("Table chart in "+CHARTS[JSON_Response['cid']].getSname() + ":" + CHARTS[JSON_Response['cid']].getTable());
		    }
		})	
}
//Load existing chart.
function loadTableChart(sourceData) {
	var gadgetID = createNewTableGadget();
	var queryResult = sourceData['queryResult'];
	gadgetProcess(gadgetID,sourceData['cid'],sourceData['name'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['type'],sourceData['note'],'datainfo');
	CHARTS[sourceData['cid']] = new Chart(sourceData['cid'],sourceData['name'],sourceData['type'],sourceData['top'],sourceData['left'],sourceData['height'],sourceData['width'],sourceData['depth'],sourceData['note'],sourceData['datainfo'],sourceData['queryResult'],"tableResult" + gadgetID)
	$("#tableResult" + gadgetID).height($("#" + gadgetID).height() - 100);
	CHARTS[sourceData['cid']].chartData = drawTable(queryResult,'tableResult'+gadgetID);
	$("#"+gadgetID).find('.gadget-title').text("Table chart in "+CHARTS[sourceData['cid']].getSname() + ":" + CHARTS[sourceData['cid']].getTable());
	activatePageSelect(gadgetID);
}
//update the chart
function updateTableResult(cid) {
	var chart = CHARTS[cid];
	var gadgetID = CHARTS[cid].gadgetID;
	var datainfo = editTableFormToDatainfo();
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
			drawTable(queryResult,gadgetID);
			$('#editTable').modal('hide');
		}
		})
}
