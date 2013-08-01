<?php

include_once(realpath(dirname(__FILE__)) . '/../config.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/TransformationHandler.php');

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

function getDistinctFromTable($from) {
    getDistinctTable($from);
}

function getDistinctToTable($to) {
    getDistinctTable($to);
}

function getDistinctTable($tableParams) {
    $pageLength = $_POST['iDisplayLength'];
    $page = ($_POST['iDisplayStart'] / $pageLength) + 1;
    $searchTerm = $_POST['sSearch'];

    foreach ($tableParams->links as $link) {
        $cidSearchTerm[$link] = $searchTerm;
    }

    $queryEngine = new QueryEngine();
    $distinctTable = $queryEngine->GetDistinctForColumns($tableParams, $pageLength, $page, $cidSearchTerm);

    if ($distinctTable->rows != null) {
        foreach ($distinctTable->rows as $rowObj) {
            $tableRow = array();
            foreach ($distinctTable->columns as $column) {
                $tableRow[] = $rowObj->$column;
            }
            $tableRows[] = $tableRow;
        }
    } else {
        $tableRows = [];
    }

    $jsonResult['aaData'] = $tableRows;
    $jsonResult['aoColumns'] = $distinctTable->columns;
    // $jsonResult['mData'] = $distinctTable->rows;
    $jsonResult["iTotalRecords"] = $distinctTable->totalRows[0]->ct;
    $jsonResult["iTotalDisplayRecords"] = $distinctTable->totalRows[0]->ct;

    echo json_encode($jsonResult);
}

?>	