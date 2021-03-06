<?php

include_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");

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
        //  $result = "<option value= -1>----</option>";

        $result = "<option value='other' selected>Enter constant</option>";

        foreach ($data as $optGroupKey => $optGroupValue) {
            if (count($data) > 1)
                $result .= '<optgroup label="' . $optGroupKey . '">';

            foreach ($optGroupValue as $key => $value) {
                $result .= '<option value="' . $optGroupKey . '.' . $value . '">' . $value . '</option>';
            }

            if (count($data) > 1)
                $result .= '</optgroup>';
        }

        return $result;
    }

    static function printSchemaMatchingStepRow($name, $optionsPart, $long_name) {
        $result = "";

        $result .= "<tr><td> <strong>" . $long_name . "</strong></td><td>";
        $result .= "<span id='star'>*</span> <select id=\"" . $name . "\" onChange='importWizard.checkToEnableInputByUserOnSchemaMatchingStep(this.id);' onClick='importWizard.checkToEnableNextButtonOnSchemaMatchinStep();'>";
        $result .= $optionsPart;
        $result .= "</select></td>";
        $result .= "<td></td>";

        $value = "";

        if ($name != "Location" && $name != "AggrType") {
            $value = date("Y/m/d");
        }

        $result .= "<td><input type='text' id='" . $name . "2' value = '$value'/></td></tr>";

        return $result;
    }

    public static function PrintTableForDataMatchingStep($data) {
        $result = "";
        
        foreach ($data as $oneTableName => $oneTableColumns) {
          //  if (count($data) > 1)
                $result .= '<div> <span>' . $oneTableName . '</span>';

            $result .= UtilsForWizard::printDataMatchingStepOneTable($oneTableName, $oneTableColumns);
            $result .= "<label style='display: inline;'>Missing value:</label><input type='text' id='missValue' name='missing_value' value='' onclick='' />";
            
            

            //if (count($data) > 1)
                $result .= '</div>';
        }



        return $result;
    }

    static function printDataMatchingStepOneTable($oneTableName, $oneTableColumns) {
        global $db;
        
        $result = "";

        $result .= "<table border=\"1\" id=\"norm\"><thead class='head'><tr ><th class='thw'> Field name </th><th class='thw'> Matching </th></tr></thead>"; //<th> Field name </th><th> Type </th>";

        $tableColumns = array_values($oneTableColumns);

        for ($i = 0; $i < count($tableColumns); $i++) {
            $edited_array_word[$i] = explode(" ", $tableColumns[$i]);
            $columnType = $_SESSION["columnType"];
            $selectedValue = $columnType[0][$i];
            $typesHtml = UtilsForWizard::getTypes($selectedValue);
            $unitsHtml = UtilsForWizard::getUnits($selectedValue);
            $similarityHtml = UtilsForWizard::getSuggestedColumnName($tableColumns[$i]);
            $result .= "<tr>";
            $result .= "<td> <div><label style='display: inline;'><input type=\"checkbox\" name=\"columns[]\" value='$oneTableName.$tableColumns[$i]' checked/>$tableColumns[$i]</label><input type='button' value='...' id='more$i' onClick='return $(\"#inDiv$i\").toggle();' /><img src='help.png' width='15' height='15' title='Click here to complete your definition about this dname.'/>";
            $result .= "<div id='inDiv$i' style='display:none;'><label for='Dtype'>Corresponding value type:<img src='help.png' width='15' height='15' title='Data type of the header.'/></label>
            <select name='dname_value_type' id='dname_value_type$i' onChange='selectChange(this);'>
            $typesHtml
            </select>";
            $result .= "<label style='display:none;'>Unit:<img src='help.png' width='15' height='15' title='Unit for measuring the header.'/></label>";//<input type='text' style='display:none;' name='dname_value_unit'/>";
            $result .= "
            <label id='unit_number' >Unit:<img src='help.png' width='15' height='15' title='Unit for measuring the header.'/></label>
            <select name='dname_value_unit' id='dname_value_unit$i' input type='text' >
            <option value='0' selected>please choose unit of the type</option>
            $unitsHtml
            </select>
            <label id='unit_date' style='display:none;'>Unit:<img src='help.png' width='15' height='15' title='Unit for measuring the header.'/></label>";
            $result .= "
            <label>Description: <img src='help.png' width='15' height='15' title='More description the header.'/></label>
            <input type='text' name='dname_value_description' id='dname_value_description$i' value='' onChange='similarityDescription(this);'/>
            <label>Constant value: <img src='help.png' width='15' height='15' title='The constant value of this file.'/></label>
            <input type='text' name='constant_value' id='constant_value$i' value=''/>
            </div></div></td>";
            $result .= "<td><div >
            <select name='suggestmatchSelect' id='suggestmatchSelect$i' onChange='similaritySelectChange(this);'>
            $similarityHtml
            </select>
            <input type='text' value='$tableColumns[$i]' id='suggestmatch$i' name=\"Dname\" onClick='' />
            <input type='hidden' name='dname_value_tableName' value='$oneTableName'>";

            $result .= "</td></tr>";
        }
        $result .= "</table>";
        return $result;
    }

    public static function getColumnType($columntype)
    {
        
    }

    public static function stripWordUntilFirstDot($value) {
        return substr($value, stripos($value, '.') + 1);
    }

    public static function getWordUntilFirstDot($value) {
        return substr($value, 0, stripos($value, '.'));
    }

    public static function processSchemaMatchingUserInputsStoreDB($sid, $schemaMatchingUserInputs) {
        $spd = $schemaMatchingUserInputs["spd"];
        $drd = $schemaMatchingUserInputs["drd"];
        $start = $schemaMatchingUserInputs["start"];
        $end = $schemaMatchingUserInputs["end"];
        $location = $schemaMatchingUserInputs["location"];
        $aggrtype = $schemaMatchingUserInputs["aggrtype"];

        if ($spd != "" && $spd != "other") {
            UtilsForWizard::processOneColumn($sid, $spd, "Spd", "date", "yyyy/mm/dd", "source publication date", null);
        } else {
            $value = $schemaMatchingUserInputs["spd2"];
            UtilsForWizard::processOneConstantColumn($sid, "Spd", "date", "yyyy/mm/dd", "source publication date", $value);
        }

        if ($drd != "" && $drd != "other") {
            UtilsForWizard::processOneColumn($sid, $drd, "Drd", "date", "yyyy/mm/dd", "date record date", null);
        } else {
            $value = $schemaMatchingUserInputs["drd2"];
            UtilsForWizard::processOneConstantColumn($sid, "Drd", "date", "yyyy/mm/dd", "date record date", $value);
        }

        if ($start != "" && $start != "other") {
            UtilsForWizard::processOneColumn($sid, $start, "Start", "date", "yyyy/mm/dd", "start time of the data", null);
        } else {
            $value = $_POST["schemaMatchingUserInputs"]["start2"];
            UtilsForWizard::processOneConstantColumn($sid, "Start", "date", "yyyy/mm/dd", "start time of the data", $value);
        }

        if ($end != "" && $end != "other") {
            UtilsForWizard::processOneColumn($sid, $end, "End", "date", "yyyy/mm/dd", "end time of the data", null);
        } else {
            $value = $schemaMatchingUserInputs["end2"];
            UtilsForWizard::processOneConstantColumn($sid, "End", "date", "yyyy/mm/dd", "end time of the data", $value);
        }

        if ($location != "" && $location != "other") {
            UtilsForWizard::processOneColumn($sid, $location, "Location", "String", "", "location of the event", null);
        } else {
            $value = $schemaMatchingUserInputs["location2"];
            UtilsForWizard::processOneConstantColumn($sid, "Location", "String", "", "location of the event", $value);
        }

        if ($aggrtype != "" && $aggrtype != "other") {
            UtilsForWizard::processOneColumn($sid, $aggrtype, "Aggrtype", "String", "", "Type of aggregation appplied to values", null);
        } else {
            $value = $schemaMatchingUserInputs["aggrtype2"];
            UtilsForWizard::processOneConstantColumn($sid, "Aggrtype", "String", "", "Type of aggregation appplied to values", $value);
        }
    }

    public static function processDataMatchingUserInputsStoreDB($sid, $dataMatchingUserInputs) {
        foreach ($dataMatchingUserInputs as $value) {
            UtilsForWizard::processOneColumn($sid, $value["originalDname"], $value["newDname"], $value["type"], $value["unit"], $value["description"], $value["metadata"], null, $value["constantValue"], $value["missingValue"]);
        }
    }

    public static function processDataMatchingUserInputsWithTableNameStoreDB($sid, $dataMatchingUserInputs) {
        foreach ($dataMatchingUserInputs as $value) {
            UtilsForWizard::processOneColumn($sid, $value["originalDname"], $value["newDname"], $value["type"], $value["unit"], $value["description"], $value["metadata"], $value["tableName"], $value["constantValue"], $value["missingValue"]);
        }
    }

    static function processOneColumn($sid, $originalDname, $newDname, $type, $unit, $description, $metadata, $tableName = null, $constantValue, $missingValue) {

//var_dump($sid, $originalDname, $newDname, $type, $unit, $description, $metadata, $tableName, $missingValue);

        $queryEngine = new QueryEngine();
        
        if (!isset($tableName)) {
            $tableName = UtilsForWizard::getWordUntilFirstDot($originalDname);
        }
        
        $originalDnameStripped = str_replace ($tableName.'.', '', $originalDname);
        $cid = $queryEngine->simpleQuery->addColumnInfo($sid, $newDname, $type, $unit, $description, $originalDnameStripped, $constantValue, $missingValue);

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

    public static function insertCidToNewData($sid, $tableName) {
        $queryEngine = new QueryEngine();
        $queryEngine->simpleQuery->addCidToNewData($sid, $tableName);
    }


    static function getSuggestedColumnName($columnName) {

        $queryEngine = new QueryEngine();
        $columnNames = $queryEngine->simpleQuery->getAllColumnNames($columnName);
        $similarityHtml = UtilsForWizard::calculateSimilarity($columnName,$columnNames);
        return $similarityHtml;
    }
    static function calculateSimilarity($columnName, $columnNames ) {
        $similarityHtml = "<option value='$selectedValue' selected>Choose from suggestion</option>";
        $arrayRepeat=array();
        foreach($columnNames  as $each) {
            $judge=1;
            similar_text($columnName, $each->dname_chosen, $percent);
            if($percent>80)
            {
                if(count($arrayRepeat)==0)
                {
                    array_push($arrayRepeat, $each->dname_chosen);
                    $similarityHtml = $similarityHtml . "<option value=" . $each->dname_chosen . ">" . $each->dname_chosen . "</option>";
                }
                else
                {
                    for($i=0;$i<count($arrayRepeat);$i++)
                    {
                        if($arrayRepeat[$i]==$each->dname_chosen)
                            {$judge=0;break;}
                    }   
                    if($judge)
                    {
                        array_push($arrayRepeat, $each->dname_chosen);
                        $similarityHtml = $similarityHtml . "<option value=" . $each->dname_chosen . ">" . $each->dname_chosen . "</option>"; 
                    }
                }
                 
            } 
        }
        return $similarityHtml;
    }


    static function getTypes($selectedValue) {

        $queryEngine = new QueryEngine();
        $types = $queryEngine->simpleQuery->getTypes($selectedValue);
        $typesHtml = UtilsForWizard::generateTypesInHtml($selectedValue,$types);
        return $typesHtml;
    }
    static function getUnits($selectedValue) {

        $queryEngine = new QueryEngine();
        $types = $queryEngine->simpleQuery->getUnits($selectedValue);
        $typesHtml = UtilsForWizard::generateUnitsInHtml($types);
        return $typesHtml;
    }


    static function generateUnitsInHtml($typesArray) {
        $typesHtml = "";
        foreach($typesArray as $types) {
            $typesHtml = $typesHtml . "<option value=" . $types->dname_value_unit . ">" . $types->dname_value_unit . "</option>";
        }
        return $typesHtml;
    }
    static function generateTypesInHtml($selectedValue,$typesArray) {
        $typesHtml = "<option value='$selectedValue' selected>" . $selectedValue . "</option>";
        foreach($typesArray as $types) {

            $typesHtml = $typesHtml . "<option value=" . $types->dname_value_type . ">" . $types->dname_value_type . "</option>";
        }
        return $typesHtml;
    }
}

?>