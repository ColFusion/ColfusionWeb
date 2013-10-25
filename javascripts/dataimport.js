function selectChange(event){

    var i=(event.name).substr(16);//(event.name).length-1);
	var selValue=$(event).val();
    var optionString="<option value=value='0' selected>please choose unit of the type</option>";
	$.ajax({
        url: my_pligg_base + '/DataImportWizard/wizardFromController.php?action=GetUnits',
        data: { type: selValue },
        type: "POST",
        dataType: "json",
        success: function(data){
            for(key in data)
            {
            	var dataValue=data[key];
            	optionString+="<option value="+dataValue.dname_value_unit+">"+dataValue.dname_value_unit+"</option>";
            }
            //alert(data);
        $("[name='dname_value_unit"+i+"']").html(optionString);
           
        }
    });
}
/*	if(selValue=="STRING"){
		
		$("#unit_number").hide();
		$("#unit_date").hide();
		$("[name='number_unit']").hide();
		$("[name='date_type']").hide();
	}
	if(selValue=="NUMBER"){
		$("#unit_number").show();
		$("#unit_date").hide();
		$("[name='number_unit']").show();
		$("[name='date_type']").hide();
		}
	if(selValue=="DATE"){
		$("#unit_number").hide();
		$("#unit_date").show();
		$("[name='number_unit']").hide();
		$("[name='date_type']").show();
		}
*/	


$(document).ready(function(){
	$("#unit_number").hide();
	$("#unit_date").hide();
	$("[name='date_type']").hide();
	$("[name='date_type']").hide();
});