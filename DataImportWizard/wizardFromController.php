<?php

include_once('../config.php');
include_once('../DAL/QueryEngine.php');

$action = $_GET["action"];
$action($sid, $dbHandler, $userId);
exit;

function GetUnits() {

    $type = $_POST["type"];

    $queryEngine = new QueryEngine();

   // $units = $queryEngine->simpleQuery->getUnits($type);
    
    $units = "blbalbalbalbalbalbal $type";

    echo json_encode($units);
}

?>