<?php

set_time_limit(0);
include(realpath(dirname(__FILE__)) . '/../config.php');
include(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

$action = $_GET["action"];

$action();

exit;

// Expects sid in post
function GetTablesList() {
    $queryEngine = new QueryEngine();

    echo json_encode($queryEngine->GetTablesList($_POST["sid"]));
}

// Simple case, expects sid and table_name in post
// also numberof tuples per page: perPage
// and page number: pageNo
function GetTableDataBySidAndName() {
    $queryEngine = new QueryEngine();

    $sid = $_POST["sid"];
    $table_name = $_POST["table_name"];
    $perPage = $_POST["perPage"];
    $pageNo = $_POST["pageNo"];

    $result = $queryEngine->GetTableDataBySidAndName($sid, $table_name, $perPage, $pageNo);

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

    $totalTuple = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, $table_name);
    $totalPage = ceil($totalTuple / $perPage);

    $json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = $totalPage;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["cols"] = $columns;

    echo json_encode($json_array);
}

function GetTableInfo(){
	
	
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    $tableName = $_POST["table_name"];
    
    $result = $queryEngine->GetTablesInfo($sid);
   
    echo json_encode($result[$tableName]);
}

function GetTablesInfo(){
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    
    $result = $queryEngine->GetTablesInfo($sid);
    echo json_encode($result);
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

function CheckDataMatching() {
	$from = $_POST["from"];
	$to = $_POST["to"];
	
	$queryEngine = new QueryEngine();
	
	echo json_encode($queryEngine->CheckDataMatching($from, $to));
}

// Expects in POST:
// sid(s) - could be comma separated sids
// For each sid provide following data strucutre:
// sid: {[
//        table_name : [columns],
//		 ]},
// where: condition here in form:
//                  column: value
//                  operator: value
//                  expression: value
// perPage: value,
// pageNo: value
//function GetTableDataBySidAndName() {
//	$queryEngine = new QueryEngine();
//
	//	echo json_encode($queryEngine->GetTableDataBySidAndName($_POST["sid"], $_POST["table_name"]));
//}
?>	