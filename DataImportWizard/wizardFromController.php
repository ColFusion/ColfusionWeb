<?php

include_once('../config.php');
include_once('../DAL/QueryEngine.php');

$action = $_GET["action"];
$action($sid, $dbHandler, $userId);
exit;

function GetUnits() {

    $type = $_POST["type"];

    $queryEngine = new QueryEngine();

    $units = $queryEngine->simpleQuery->getUnits($type);
    
    //$units = "blbalbalbalbalbalbal $type";

    //return $units;
     //echo json_encode($type);
     echo json_encode($units);

}
function GetTypes() {

    $type = $_POST["type"];

    $queryEngine = new QueryEngine();

    $units = $queryEngine->simpleQuery->getUnits($type);
    
    echo json_encode($units);

}
function GetDescriptions() {

    $type = $_POST["type"];

    $queryEngine = new QueryEngine();

    $units = $queryEngine->simpleQuery->getAllDescriptions($type);

    $similarityHtml = calculateSimilarity($type, $units);
    
    echo json_encode($similarityHtml);

}
function calculateSimilarity($description, $descriptions) {
    $similarityHtml = "";
    foreach($descriptions as $each) {
       	similar_text($description, $each->dname_value_description, $percent);
        if($percent>80)
        {
            $similarityHtml = $similarityHtml . "<option value=" . $each->dname_chosen . ">" . $each->dname_chosen . "</option>";
        } 
    }
    return $similarityHtml;
}
?>