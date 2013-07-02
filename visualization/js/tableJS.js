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

function drawTable(){
	createNewTable();
	JSON_Response = result;
	var queryResult = JSON_Response["queryResult"];
	totalPage = queryResult["Control"]["totalPage"];
	var color = queryResult["Control"]["color"];
	var resulData = queryResult["data"];
	data = new google.visualization.DataTable();
	var tableColumns = queryResult['column'];
	for(i=0; i<tableColumns.length; i++){
		data.addColumn('string', tableColumns[i]);
	}
	for(i=0 ; resulData[i]!=null ; i++){
		data.addRow();
		data.setCell(i, 0, String(resulData[i]["rownum"]));
		for(k=0; k<tableColumns.length; k++) {
			data.setCell(i, k, String(resulData[i][tableColumns[k]]));
		}
	}
	tabledata = data;
	$("#tableResult" + gadgetID).height($("#" + gadgetID).height() - 100);	
	gadgetProcess(gadgetID,result['cid'],result['name'],result['top'],result['left'],result['height'],result['width'],result['depth'],result['type'],result['note'],'datainfo');
	generateTable(gadgetID,color);
	initPageSelect();
	$("div[name='tableDivs']").resize(function() {
		tempid = $(this).attr("id");
		$("#tableResult" + tempid).height($("#" + tempid).height() - 100);
        generateTable(tempid);
	});			
	
}

function initPageSelect() {
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

function changePage(page,vid){
	gadgetID = vid;
	settings = $('#setting' + gadgetID).val();
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
	
	drawTable();
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

function createNewTable(){
	var d = new Date();
	var ranNum = 1 + Math.floor(Math.random() * 100);
	gadgetID = d.getTime() + ranNum + "";
	
	var gadget = "<div name='tableDivs' class='gadget' id='" + gadgetID + "' style='top: 50px; left:0px; width:1160px; height: 500px' type='table'>";
	gadget += "<div class='gadget-header'>Table" + gadgetID;
	gadget += "<div class='gadget-close'><i class='icon-remove'></i></div>";
	gadget += "<div class='gadget-edit edit-table'><a href='#editTable' data-toggle='modal'><i class='icon-edit'></i></a></div> </div>";
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
	
	activatePageSelect(gadgetID);
	
	$('.edit-table').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
	})
	
	$('#editTableSave').click(function() {
		loadTableData(3,editGadgetID);
	});	
	
	var dropdown = "<li class='view' id='view" + gadgetID + "'><a href='#' data-toggle='modal'>'table' "+gadgetID+"</a></li>";
	$("#chartview").append(dropdown);
	return gadgetID;
	
}

function activatePageSelect(ID){
	gadgetID = ID;
	$("#pages"+gadgetID).change(function() {
		changePage($(this).val(), gadgetID);
	})
	
	$("#prePage"+gadgetID).click(function() {
		var oldPageNO = parseInt($("#pages"+gadgetID).val());
		var newPageNO = oldPageNO - 1;
		$("#pages"+gadgetID).val(newPageNO)
		changePage(newPageNO, gadgetID);
	})
	
	$("#nextPage"+gadgetID).click(function() {
		var oldPageNO = parseInt($("#pages"+gadgetID).val());
		var newPageNO = oldPageNO + 1;
		$("#pages"+gadgetID).val(newPageNO)
		changePage(newPageNO, gadgetID);	
	})
}

function addTableChart() {
    var gadgetID = vid;
	var titleNo = $("#titleNo").val();
	var where = $("#where").val();
	var settings = "";
	var perPage = "";
        var color = "";
        var currentPage = "";
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
	
	
	var datainfo = {'tableColumns':tableColumns, 'perPage':perPage, 'currentPage':currentPage, 'titleNo':titleNo, 'where':where};
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
		    //$('#setting' + gadgetID).val(settings);
		    JSONResponse = jQuery.parseJSON(JSON_Response);
		    var cid = JSONResponse['cid'];
		    var queryResult = JSONResponse['queryResult'];
		    result = JSONResponse;
		    drawTable();
		    $('#addTable').modal('hide');
		    }
		})	
}