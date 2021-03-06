<?php

require_once(realpath(dirname(__FILE__)) . '/../config.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
require_once(realpath(dirname(__FILE__)) . '/ExecutionManager.php');

$action = $_GET["action"];

$action();

exit;

// Expects sid in post
function MineRelationships() {

    $queryEngine = new QueryEngine();

    $perPage = $_POST["perPage"];
    $pageNo = $_POST["pageNo"];

    $result = $queryEngine->MineRelationships($_POST["sid"]);
    $columns = NULL;

    if($result != null){

        foreach ($result as $r) {
            $json_array["data"][] = $r;

            if ($columns === NULL) {
                if (is_array($r))
                    $columns = implode(",", array_keys($r));
                else
                    $columns = implode(",", array_keys(get_object_vars($r)));
            }
        }
    }
    
    $json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = 40;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["cols"] = $columns;

    echo json_encode($json_array);
}

/**
 * Returns status of the story by sid. Excepts sid in POST
 *
 * Takes status value from execinfo table and put it together with relevant information
 */
function GetStoryStatus() {

    $sid = $_POST["sid"];

    $result = ExecutionManager::getExecutionStatus($sid);

    echo json_encode($result);
}

?>