<?php

set_time_limit(0);
include_once(realpath(dirname(__FILE__)) . '/../config.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

Logger::configure(realpath(dirname(__FILE__)) . '/../conf/log4php.xml');

$logger = Logger::getLogger("generalLog");

header('Content-type: text/html; charset=utf-8');
if(isset($_GET["action"])){
    $action = $_GET["action"];
    $action();
}

// Expects sid in post
function GetTablesList() {
    $queryEngine = new QueryEngine();

    echo json_encode($queryEngine->GetTablesList($_POST["sid"]));
}

function GetTableDataBySidAndName(){



    $sid = $_POST["sid"];
    $table_name = $_POST["table_name"];
    $perPage = $_POST["perPage"];
    $pageNo = $_POST["pageNo"];

    //$logger->info("In GetTableDataBySidAndName for sid = $sid, tableName = $table_name, perPage = $perPage, pageNo = $pageNo");

    
    if (is_string($sid)) {
        $sid = json_decode($sid);
    }
    
    echo json_encode(GetTableData($sid, $table_name, $perPage, $pageNo));
}

// Simple case, expects sid and table_name in post
// also numberof tuples per page: perPage
// and page number: pageNo
function GetTableData($sid, $table_name, $perPage, $pageNo) {
    
    $queryEngine = new QueryEngine();
    $result = $queryEngine->GetTableDataBySidAndName($sid, "[$table_name]", $perPage, $pageNo);

    $columns = NULL;
    foreach ($result as $r) {
        $json_array["data"][] = $r;

        if ($columns === NULL) {
            if (is_array($r))
                $columns = implode(",", array_keys($r));
            else
                $columns = implode(",", array_keys(get_object_vars($r)));
        }
    }

    $totalTuple = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, "[$table_name]");
    $totalPage = ceil($totalTuple / $perPage);

    $json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = $totalPage;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["cols"] = $columns;
    
    return $json_array;
}

//TODO: refactor so the input is send as an objec as for visualization with oneSid atribute included
function GetTableInfo(){
	
	
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    $tableName = $_POST["table_name"];
    
    $result = $queryEngine->GetTablesInfo($sid);
   
    echo json_encode($result[$tableName]);
}

//TODO: refactor so the input is send as an objec as for visualization with oneSid atribute included
function GetTablesInfo(){
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    
    $result = $queryEngine->GetTablesInfo($sid);
    echo json_encode($result);
}

function UpdateColumnMetaData(){
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    $oldname = $_POST["oldname"];
    $name = $_POST["name"];
    $variableValueType = $_POST["variableValueType"];
    $originalName = $_POST["originalName"];
    $description = $_POST["description"];
    $variableMeasuringUnit = $_POST["variableMeasuringUnit"];
    $variableValueFormat = $_POST["variableValueFormat"];
    $missingValue = $_POST["missingValue"];



    $queryEngine->UpdateColumnMetaData($sid,$oldname,$name,$variableValueType,$originalName,$description,$variableMeasuringUnit,$variableValueFormat,$missingValue);

}


function AddRelationship() {
	global $current_user;

	$name = $_POST["name"];
	$description = $_POST["description"];
	$from = $_POST["from"];
	$to = $_POST["to"];

	$confidence = $_POST["confidence"];
	$comment = $_POST["comment"];

	$queryEngine = new QueryEngine();

	echo json_encode($queryEngine->AddRelationship($current_user->user_id, $name, $description, $from, $to, $confidence, $comment));
}

//TODO, FIXME: why is here?
function CheckDataMatching() {
	$from = $_POST["from"];
	$to = $_POST["to"];
	
	$queryEngine = new QueryEngine();
	
	echo json_encode($queryEngine->CheckDataMatching($from, $to));
}
?>	