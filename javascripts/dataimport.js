function selectChange(event){

    var i=(event.id).substr(16);//(event.name).length-1);
	var selValue=$(event).val();
    var optionString="<option value='0' selected>please choose unit of the type</option>";
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
        $("#dname_value_unit"+i).html(optionString);
           
        }
    });

}
function similaritySelectChange(event){

    var i=(event.id).substr(18);//(event.name).length-1);
	var selValue=$(event).val();
	$("#suggestmatch"+i).val(selValue);
}
function similarityDescription(event){

    var i=(event.id).substr(23);//(event.name).length-1);
	var selValue=$(event).val();
	var optionString="";
	$.ajax({
        url: my_pligg_base + '/DataImportWizard/wizardFromController.php?action=GetDescriptions',
        data: { type: selValue },
        type: "POST",
        dataType: "json",
        success: function(data){
            for(key in data)
            {
            	var dataValue=data[key];
            	optionString+=dataValue;
            }
            //alert(data);
            $("#suggestmatchSelect"+i).html(($("#suggestmatchSelect"+i).html()+optionString));
        }
    });
}
$(document).ready(function(){
	$("#unit_number").hide();
	$("#unit_date").hide();
	$("[name='date_type']").hide();
	$("[name='date_type']").hide();
});

