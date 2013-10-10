<?php

include_once(realpath(dirname(__FILE__)) . '/GlobalStatEngine.php');

header('Content-type: text/html; charset=utf-8');
if(isset($_GET["action"])){
    $action = $_GET["action"];
    $action();
};

// Expects sid in post
function GetGlobalStatisticsSummary() {
    $globalStatEngine = new GlobalStatEngine();

    $result = new stdClass();
    $result->numberOfStories = $globalStatEngine->GetNumberOfStories();
    $result->numberOfDvariables = $globalStatEngine->GetNumberOfDvariables();
    $result->numberOfRelationships = $globalStatEngine->GetNumberOfRelationships();
    $result->numberOfRecords = $globalStatEngine->GetNumberOfRecords();
    $result->numberOfUsers = $globalStatEngine->GetNumberOfUsers();

    echo json_encode($result);
}
?>