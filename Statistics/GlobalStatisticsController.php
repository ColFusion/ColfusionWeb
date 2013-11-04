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
   
    // returned value from Engine, saved into variables in result
    $results = $globalStatEngine->GetGlobalStatisticsSummary();
  
    echo json_encode($results);
}

function storyStatisticsSummary(){
	$globalStatEngine = new GlobalStatEngine();

	$sid =  $_POST["sid"];
	$tableName = $_POST["table_name"]; 

	$startTime = $globalStatEngine->CheckStartTime($sid,$tableName);
	$finishTime = $globalStatEngine->CheckFinishTime($sid,$tableName);
	if ($startTime==""){
		$results = $globalStatEngine->GetStoryStatisticsSummary($sid, $tableName);
	}

	else if ($finishTime != "") {
		$results = $globalStatEngine->DisplayStatisticsSummary($sid, $tableName);
	}

	

	echo json_encode($results);
}
?>