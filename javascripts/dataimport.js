function selectChange(event){
	var selValue=$(event).val();
	if(selValue=="STRING"){
		
		$("#unit_number").hide();
		$("#unit_date").hide();
		$("[name='number_unit']").hide();
		$("[name='date_type']").hide();
	}
	if(selValue=="INT"){
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
	
}
$(document).ready(function(){
	$("#unit_number").hide();
	$("#unit_date").hide();
	$("[name='date_type']").hide();
	$("[name='date_type']").hide();
});