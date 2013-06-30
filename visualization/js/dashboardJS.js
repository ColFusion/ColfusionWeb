var xmlHttp;
var d = new Date();
var vYear = d.getFullYear();
var vMon = d.getMonth() + 1;
var vDay = d.getDate();


function saveConfig(){
	var aut = $("#shareAuthorization").val();
	
}

function everyUser(){
	
}

function showChart(type){

	$("#openchart").modal("hide");
	
	switch (type){
	case 'pie':
		drawPies("");
		break;
	case 'motion':
		drawMotions("");
		break;
	case 'map':
		drawMaps("");
		break;
	case 'table':
		drawTable(2,vid);
		break;
	case 'combo':
		drawCombos();
		break;
	case 'column':
		drawColumns("");
		break;
	}
}

function showHint(str){
	
	$("#authorization_filter li").removeClass('active');
	xmlHttp=new XMLHttpRequest();
	var url="contentResponse.php";
		url=url+"?content="+str;
	xmlHttp.onreadystatechange=stateChanged;
	xmlHttp.open("GET",url,true);
	xmlHttp.send(null);
}

function stateChanged(){
	if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
	 { 
	 document.getElementById("display_section").innerHTML=xmlHttp.responseText;
	 }
	
	$("td.tableadjust").mouseover(function(){
		$(this).parent().children("td").css({"background-color":"#0088CC","color":"white"});
	}).mouseout(function(){
		$(this).parent().children("td").css({"background-color":"#F5F5F5","color":"#0088CC"});
	}).click(function(){
		var vid = $(this).parent().attr('id').split("**")[0];
		var vname = $(this).parent().attr('name');
		openCharts(vid,vname);
	});
	
	returnNormal();

}

$(document).ready(function(){
	if($('#vid').val()==null||$("#vid").val()==''){
		$("#testSave").hide();
		$("#chart-dropdown").hide();
		$("#view-dropdown").hide();
	}
})
function autFilter(id){
	$("#result_table tbody tr").hide();
	$(".authorizationLevel"+id).show();
	
}

function pickDate(){
	
	var str = vMon+"/"+vDay+"/"+vYear;
	
	$(this).dialog({
		 open: function() {
             $('#myDate').datepicker({title:'Test Dialog'}).blur();
         },
         close: function() {
             $('#myDate').datepicker('destroy');
         }
	});
	
}

function overCanvasEffect(id){
	$("#"+id).css({"background-color":"#0088CC","color":"white"});
}

function outCanvasEffect(id){
	$("#"+id).css({"background-color":"#F5F5F5","color":"#0088CC"});
}

$(function() {
	
	var vids=new Array();
	$("#deleteButton").click(
			function(){
				$("[name='deleteItem']").each(function(){
					 if($(this).is(":checked"))
					   {
						$itemId = $(this).parent().parent().attr("id");
						$itemId = $itemId.split("**")[0];
					    $(this).removeAttr("checked");
					    vids.push($itemId);
					   }
				})
				
				$.ajax({
				  type: "POST",
				  url: "control.php",
				  data:{
					  action:'deleteCanvas',
					  vids:vids  
				  },
				  async:true,
				}).done(function(){
					showHint("");
				})
					
				}
					
			)
	


	
	
	$(".gadget" )
		.draggable({ handle: ".gadget-header" })
		.resizable()
		.css("min-height", "250px")
		.css("min-width", "300px")
		
	$(".gadget").resizable({
		resize: function(e, ui) {
			var gadgetID = $(this).attr('id');
			$("#tableResult"+gadgetID).height(
				$(this).height()-100
			)
		}
	})
		
	$(".gadget-close").click(function() {	
		$(this).parent().parent().hide();
	})
	
	$("#save").click(function() {
		var saveSuccess = 1;
		$( ".gadget" ).each(function (i) {
			var height = $(this).height();
			var width = $(this).width();
			var left = $(this).position().left;
			var top = $(this).position().top;
			var gadgetID = $(this).attr('id');
			var type = $(this).attr('type');
			var setting = $('#setting'+gadgetID).val();
			var userid = $('#userid').val();
			var titleNo = $('#titleNo').val();
			var data = {"vid": gadgetID, "type": type, "height": height, "width": width, "left": left, "top": top, "setting": setting, "userid": userid, "titleNo": titleNo };
			$.ajax({
			  type: "POST",
			  url: "setVisGadget.php",
			  async:false,
			  data: data
			}).done(function( msg ) {
			  if(msg != "success") {
			    saveSuccess = 0;
			  }
			});		
	    });
		if(saveSuccess == 1){
			alert("Dashboard saved");
		}
		else {
			alert("Save failed. Please retry later.");
		}
	})
	
	//show and hide gadgets
	$('li.view').click(function() {
		viewId = $(this).attr('id').substring(4);
		if(viewId!='none'){
			$('#'+viewId).toggle();
		}
	});
	
	//edit table
	$('.edit-table').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		
		/*
		var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		//alert(editGadgetID + "  " + oldSettings);
		
		var n = oldSettings.split(";");
	
		var oldTablePages = n[1];// number of turples per page
		$("input:radio[name='pageEdit']").each(function(j){
			if($(this).val() == oldTablePages) {
				$(this).attr('checked', true);
			}
		});
				
		var oldColor = n[2];// color of the new table
		$("input:radio[name='colorEdit']").each(function(j){
			if($(this).val() == oldColor) {
				$(this).attr('checked', true);
			}
		});		
		
		var oldDisplay = n[3];// sql style table or excel style table
		$("input:radio[name='displayEdit']").each(function(j){
			if($(this).val() == oldDisplay) {
				$(this).attr('checked', true);
			}
		});	
		if(oldDisplay == 'sqlStyle') {
			$('#sqlStyleColumnsEdit').show();
			$('#excelStyleColumnsEdit').hide();
		}
		else {
			$('#sqlStyleColumnsEdit').hide();
			$('#excelStyleColumnsEdit').show();	
		}	

		var equal = 0;
		var oldColumns = n[0].split(",");	
		if(oldDisplay == "sqlStyle") {
			$( "input[name='sqlcolumnEdit[]']").each(function (j){
				for(i=0;i<oldColumns.length;i++) {			
					if($(this).val() == oldColumns[i]) {
						equal = 1;
						break;
					}
				}
				if(equal == 1) {
					$(this).attr('checked', true);
				}
				else {
					$(this).removeAttr('checked');
				}
				equal = 0;			
			});
			$( "input[name='excelcolumnEdit[]']").each(function (j){
				$(this).removeAttr('checked');
			});
		}
		else { //excel style
			$( "input[name='excelcolumnEdit[]']").each(function (j){
				for(i=0;i<oldColumns.length;i++) {			
					if($(this).val() == oldColumns[i]) {
						equal = 1;
						break;
					}
				}
				if(equal == 1) {
					$(this).attr('checked', true);
				}
				else {
					$(this).removeAttr('checked');
				}
				equal = 0;			
			});	
			$( "input[name='sqlcolumnEdit[]']").each(function (j){
				$(this).removeAttr('checked');
			});
		}
		
		//reset table edit modal tabs
		$('#columnsEdit').addClass('active');
		$('#pageEdit').removeClass('active');
		$('#styleEdit').removeClass('active');
		$('#columnEditTab').addClass('active');
		$('#pageEditTab').removeClass('active');
		$('#styleEditTab').removeClass('active');	
		*/
	});
	
	//edit table save
	$('#editTableSave').click(function() {
		loadTableData(3,editGadgetID);
	});
	
	$('input[name="display"]').click(function() {
		if($(this).val() == 'sqlStyle') {
			$('#sqlStyleColumns').show(200);
			$('#excelStyleColumns').hide(200);
		}
		else {
			$('#sqlStyleColumns').hide(200);
			$('#excelStyleColumns').show(200);	
		}
	});	

	$('input[name="displayEdit"]').click(function() {
		if($(this).val() == 'sqlStyle') {
			$('#sqlStyleColumnsEdit').show(200);
			$('#excelStyleColumnsEdit').hide(200);
		}
		else {
			$('#sqlStyleColumnsEdit').hide(200);
			$('#excelStyleColumnsEdit').show(200);	
		}
	});	
	$('input[name="maplocation"]').click(function() {
		if($(this).val() == 'geocode'){
			$('#geocode').show(200);
			$('#address').hide(200);
		}
		else{
			$('#geocode').hide(200);
			$('#address').show(200);
		
		}
	});
	
	$("#motionColumns label:first-child input").attr('checked', true);	
	
	//edit motion
	$('.edit-motion').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		//alert(editGadgetID);
		var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		oldColumn = oldSettings;
		$("input:radio[name='motionColumnEdit[]']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});				
	});

	//edit motion save
	$('#editMotionSave').click(function() {
		//alert(editGadgetID);
		drawMotion(3,editGadgetID);
	});
	
	//edit column chart
	$('.edit-column').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		alert(editGadgetID);
		//old settings of gadget
		var oldSettings = $('#setting'+editGadgetID).val(); 
		var n = oldSettings.split(";");
	
		var oldColumn = n[1];// column
		$("input:radio[name='chartColumnEdit']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});
		
		var oldType = n[2]; //aggregation type
		$("input:radio[name='columnTypeEdit']").each(function(j){
			if($(this).val() == oldType) {
				$(this).attr('checked', true);
			}
		});				
	});	

	//edit motion save
	$('#editColumnSave').click(function() {
		//alert(editGadgetID);
		drawColumn(3,editGadgetID);
	});
	
	//edit geo chart
	$('.edit-map').click(function() {
		//get ID of the gadget user selects to edit
		editGadgetID = $(this).parent().parent().attr('id');
		//alert(editGadgetID);
		/*var oldSettings = $('#setting'+editGadgetID).val(); //old settings of gadget
		oldColumn = oldSettings;
		$("input:radio[name='motionColumnEdit[]']").each(function(j){
			if($(this).val() == oldColumn) {
				$(this).attr('checked', true);
			}
		});*/
	});

	//edit motion save
	$('#editMapSave').click(function() {
		// alert(editGadgetID);
		loadMap(3,editGadgetID);
	});	

    //edit pie chart
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
	
    //edit combo chart
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
	
});

