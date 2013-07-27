<?php

include_once(realpath(dirname(__FILE__)) . '/../config.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/TransformationHandler.php');

error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
ini_set('display_errors', 1);

if (!$current_user->authenticated)
    die('Please login to use this function.');

$fromSid = $_POST["fromSid"];
$fromTable = $_POST["fromTable"];
$toSid = $_POST["toSid"];
$toTable = $_POST["toTable"];
$fromTransInput = $_POST["fromTransInput"];
$toTransInput = $_POST["toTransInput"];
$action = $_POST["action"];

$transHandler = new TransformationHandler();
$encodedFromTrans = $transHandler->encodeTransformationInput($fromSid, $fromTable, $fromTransInput);
$fromCids = $transHandler->getWrappedCids($encodedFromTrans);
$encodedToTrans = $transHandler->encodeTransformationInput($toSid, $toTable, $toTransInput);
$toCids = $transHandler->getWrappedCids($encodedToTrans);

$from = new stdClass;
$from->sid = $fromSid;
$from->tableName = $fromTable;
$from->links = $fromCids; // size of this array should be equal to the size of array in To

$to = new stdClass;
$to->sid = $toSid;
$to->tableName = $toTable;
$to->links = $toCids;

// Params for data-tables server-side processing.
$pageLength = $_POST['pageLength'];
$page = $_POST['page'];

$action($from, $to, $page, $pageLength);

function getDifferentAndSameValueTables($from, $to) {
    $queryEngine = new QueryEngine();
    echo json_encode($queryEngine->CheckDataMatching($from, $to));
}

function getDistinctValueTable($from, $to, $page = 1, $pageLength = 10) {
    $queryEngine = new QueryEngine();
    $jsonResult["distinctFromTable"] = $queryEngine->GetDistinctForColumns($from, $pageLength, $page);
    $jsonResult["distinctToTable"] = $queryEngine->GetDistinctForColumns($to, $pageLength, $page);
    echo json_encode($jsonResult);
}

function getDistinctFromTable($from) {
    getDistinctTable($from);
}

function getDistinctToTable($to) {
    getDistinctTable($to);
}

function getDistinctTable($tableParams) {
    $pageLength = $_POST['iDisplayLength'];
    $page = ($_POST['iDisplayStart'] / $pageLength) + 1;

    $queryEngine = new QueryEngine();
    $distinctTable = $queryEngine->GetDistinctForColumns($tableParams, $pageLength, $page);

    foreach ($distinctTable->rows as $rowObj) {
        $tableRow = array();
        foreach ($distinctTable->columns as $column) {
            $tableRow[] = $rowObj->$column;
        }
        $tableRows[] = $tableRow;
    }
    
    $jsonResult['aaData'] = $tableRows;
    $jsonResult['aoColumns'] = $distinctTable->columns;
    // $jsonResult['mData'] = $distinctTable->rows;
    $jsonResult["iTotalRecords"] = $distinctTable->totalRows[0]->ct;
    $jsonResult["iTotalDisplayRecords"] = $distinctTable->totalRows[0]->ct;
    $jsonResult["er"] = $distinctTable->totalRows;

    echo json_encode($jsonResult);
}

?>	