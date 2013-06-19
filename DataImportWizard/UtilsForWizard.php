<?php

error_reporting(E_ALL ^ E_NOTICE);
include_once('../DAL/QueryEngine.php');

class UtilsForWizard {

	public static function PrintTableForSchemaMatchingStep($data) {
		$result = "";
		
		$result .= "<div class=\"wizard-input-section\">";
		$result .= "<table border=\"0\">";
		
		$optionsPart = UtilsForWizard::makeOptionsPart($data);
		
		$result .= UtilsForWizard::printSchemaMatchingStepRow("Spd", $optionsPart, "Source Publication Date");
		$result .= UtilsForWizard::printSchemaMatchingStepRow("Drd", $optionsPart, "Data Record Date");
		$result .= UtilsForWizard::printSchemaMatchingStepRow("Start", $optionsPart, "Start");
		$result .= UtilsForWizard::printSchemaMatchingStepRow("End", $optionsPart, "End");
		$result .= UtilsForWizard::printSchemaMatchingStepRow("Location", $optionsPart, "Location");
		$result .= UtilsForWizard::printSchemaMatchingStepRow("AggrType", $optionsPart, "Aggregation Type");
		$result .= "</table>";
		
		return $result;
	}
	
	static function makeOptionsPart($data) {
	//	$result = "<option value= -1>----</option>";
		
		$result = "<option value='other' selected>Enter constant</option>";
		
		foreach ($data as $optGroupKey => $optGroupValue) {
			if (count($data) > 1)
				$result .= '<optgroup label="' . $optGroupKey . '">';
	
			foreach($optGroupValue as $key => $value){
				$result .= '<option value="' . $optGroupKey . '.' . $value .'">' . $value . '</option>';
			}
	
			if (count($data) > 1)
				$result .= '</optgroup>';
		}
			
		return $result;
	}
	
  	static function printSchemaMatchingStepRow($name, $optionsPart, $long_name){
  	 	$result = "";
  	 	
		$result .= "<tr><td> <strong>". $long_name ."</strong></td><td>";
		$result .= "<span id='star'>*</span> <select id=\"".$name."\"  onChange='importWizard.checkToEnableInputByUserOnSchemaMatchingStep(this.id);' onClick='importWizard.checkToEnableNextButtonOnSchemaMatchinStep();'>";
		$result .= $optionsPart;
		$result .= "</select></td>";
		$result .= "<td></td>";

		$value = "";

		if ($name != "Location" && $name != "AggrType")  {
                $value = date("Y/m/d");
            }

		$result .= "<td><input type='text' id='" . $name . "2' value = '$value'/></td></tr>";
		
		return $result;
	}
	
	public static function PrintTableForDataMatchingStep($data) {
		$result = "";

	
		
		foreach ($data as $oneTableName => $oneTableColumns) {
			if (count($data) > 1) 
				$result .= '<div> <span>' . $oneTableName . '</span>';

			$result .= UtilsForWizard::printDataMatchingStepOneTable($oneTableName, $oneTableColumns);

			if (count($data) > 1)
				$result .= '</div>';
		}		
			
		return $result;
	}
	
	static function printDataMatchingStepOneTable($oneTableName, $oneTableColumns){
		global $db;
		
		$result = "";
		
		$result .= "<table border=\"1\" id=\"norm\"><thead class='head'><tr ><th class='thw'> Field name </th><th class='thw'> Matching </th></tr></thead>";//<th> Field name </th><th> Type </th>";
		
		$tableColumns = array_values($oneTableColumns);
		
		for($i = 0; $i < count($tableColumns); $i++){
			$edited_array_word[$i] = explode(" ", $tableColumns[$i]);
			
			$result .= "<tr>";
			$result .= "<td> <div><label style='display: inline;'><input type=\"checkbox\" name=\"columns[]\" value='$oneTableName.$tableColumns[$i]'>$tableColumns[$i]</label><input type='button' value='...' id='more$i' onClick='return $(\"#inDiv$i\").toggle();' /><img src='help.png' width='15' height='15' title='Click here to complete your definition about this dname.'/>";
			$result .= "<div id='inDiv$i' style='display:none;'><label for='Dtype'>Corresponding value type:<img src='help.png' width='15' height='15' title='Data type of the header.'/></label><select name='dname_value_type'><option value='STRING' selected>STRING</option><option value='INT'>INT</option><option value='DATE'>DATE</option></select>";
			$result .= "<label>Unit:<img src='help.png' width='15' height='15' title='Unit for measuring the header.'/></label><input type='text' name='dname_value_unit'/>";
			$result .= "<label>Description: <img src='help.png' width='15' height='15' title='More description the header.'/></label><input type='text' name='dname_value_description'/></div></div></td>";
			$result .= "<td><div ><input type='text' value='$tableColumns[$i]' id='suggestmatch$i' name=\"Dname\" onClick=''/>";
			
	//		<input type='button' value='...' id='more2$i' onClick='return $(\"#suggested$i\").toggle();' />
	//		<img src='help.png' width='15' height='15' title='Type a new Dname in the input box if you want to change the original one and optionally click ... button to make some data matching.'/>";
	//		echo "<div id='suggested$i' style='display:none;' >";
			
	//		$cat = array ("country","city","province","aggrtype");
	
// 			for($j=0;$j<count($cat);$j++){
// 				echo "<input type='checkbox' value='".$cat[$j]."' name=\"match_checkbox$i\"></input>".$cat[$j];
// 				$flag="";
// 				for($k=0;$k<count($edited_array_word[$i]);$k++){
// 					$sql="select distinct(type) from ".table_prefix."dname_meta_data where value='".$edited_array_word[$i][$k]."'";
// 					$results[$i][$k]=$db->get_results($sql,ARRAY_N);
	
// 					if($results[$i][$k][0][0]!=""){
							
// 						foreach($results[$i][$k][0] as $value){
// 							if($cat[$j]==$value){
									
// 								echo "<input name=\"suggest_from_user$i\" type=\"text\" value='".$edited_array_word[$i][$k]."'></input><br/>";
// 								$flag="ok";
// 							}
								
// 						}
							
// 					}
	
// 				}	if($flag!="ok")
// 					echo "<input name=\"suggest_from_user$i\" type=\"text\"></input><br/>";
					
// 			}
	
			$result .= "</td></tr>";
	
		}
		$result .= "</table>";
		
		return $result;
	}
	
	
	public static function stripWordUntilFirstDot($value) {
		return substr($value,  stripos($value, '.') + 1);
	}
	
	public static function getWordUntilFirstDot($value) {
		return substr($value,  0, stripos($value, '.'));
	}
	
	
	public static function processSchemaMatchingUserInputsStoreDB($sid, $schemaMatchingUserInputs){
		$spd = $schemaMatchingUserInputs["spd"];
		$drd = $schemaMatchingUserInputs["drd"];
		$start = $schemaMatchingUserInputs["start"];
		$end = $schemaMatchingUserInputs["end"];
		$location = $schemaMatchingUserInputs["location"];
		$aggrtype = $schemaMatchingUserInputs["aggrtype"];
	
		if ($spd != "" && $spd != "other"){
			UtilsForWizard::processOneColumn($sid, $spd, "Spd", "date", "yyyy/mm/dd", "source publication date", null);
		}
		else {
			$value = $schemaMatchingUserInputs["spd2"];
			UtilsForWizard::processOneConstantColumn($sid, "Spd", "date", "yyyy/mm/dd", "source publication date", $value);
		}
	
		if ($drd != "" && $drd != "other"){
			UtilsForWizard::processOneColumn($sid, $drd, "Drd", "date", "yyyy/mm/dd", "date record date", null);
		}
		else {
			$value = $schemaMatchingUserInputs["drd2"];
			UtilsForWizard::processOneConstantColumn($sid, "Drd", "date", "yyyy/mm/dd", "date record date", $value);
		}
	
		if ($start != "" && $start != "other"){
			UtilsForWizard::processOneColumn($sid, $start, "Start", "date", "yyyy/mm/dd", "start time of the data", null);
		}
		else {
			$value = $_POST["schemaMatchingUserInputs"]["start2"];
			UtilsForWizard::processOneConstantColumn($sid, "Start", "date", "yyyy/mm/dd", "start time of the data", $value);
		}
			
		if ($end != "" && $end != "other"){
			UtilsForWizard::processOneColumn($sid, $end, "End", "date", "yyyy/mm/dd", "end time of the data", null);
		}
		else {
			$value = $schemaMatchingUserInputs["end2"];
			UtilsForWizard::processOneConstantColumn($sid, "End", "date", "yyyy/mm/dd", "end time of the data", $value);
		}
			
		if ($location != "" && $location != "other"){
			UtilsForWizard::processOneColumn($sid, $location, "Location", "String", "", "location of the event", null);
		}
		else {
			$value = $schemaMatchingUserInputs["location2"];
			UtilsForWizard::processOneConstantColumn($sid, "Location", "String", "", "location of the event", $value);
		}
	
		if ($aggrtype != "" && $aggrtype != "other") {
			UtilsForWizard::processOneColumn($sid, $aggrtype, "Aggrtype", "String", "", "Type of aggregation appplied to values", null);
		}
		else {
			$value = $schemaMatchingUserInputs["aggrtype2"];
			UtilsForWizard::processOneConstantColumn($sid, "Aggrtype", "String", "", "Type of aggregation appplied to values", $value);
		}
	}
	
	public static function processDataMatchingUserInputsStoreDB($sid, $dataMatchingUserInputs){
		foreach ($dataMatchingUserInputs as $value) {
			UtilsForWizard::processOneColumn($sid, $value["originalDname"], $value["newDname"], $value["type"], $value["unit"], $value["description"], $value["metadata"]);
		}
	}
	
	static function processOneColumn($sid, $originalDname, $newDname, $type, $unit, $description, $metadata) {
	
		$queryEngine = new QueryEngine();
	
		$originalDnameStripped = UtilsForWizard::stripWordUntilFirstDot($originalDname);
		$cid = $queryEngine->simpleQuery->addColumnInfo($sid, $newDname, $type, $unit, $description, $originalDnameStripped);
			
		$tableName = UtilsForWizard::getWordUntilFirstDot($originalDname);
		$queryEngine->simpleQuery->addColumnTableInfo($cid, $tableName);
			
		if (!($metadata === NULL)) {
			foreach ($metadata as $value2) {
				$queryEngine->simpleQuery->addColumnDataMatchingInfo($sid, $cid, $value2["category"], $value2["suggestedValue"]);
			}
		}
	}
	
	static function processOneConstantColumn($sid, $newDname, $type, $unit, $description, $value) {
		$queryEngine = new QueryEngine();
		$queryEngine->simpleQuery->addConstantColumnInfo($sid, $newDname, $type, $unit, $description, "user input constant", $value);
	}
}

?>