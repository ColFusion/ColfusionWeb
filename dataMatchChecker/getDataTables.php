<?php

header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

include_once(realpath(dirname(__FILE__)) . '/../config.php');
include_once(realpath(dirname(__FILE__)) . '/DataMatcher.php');
include_once(realpath(dirname(__FILE__)) . '/DataMatcherLinkOnePart.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/TransformationHandler.php');

if (!$current_user->authenticated)
    die('Please login to use this function.');

$fromSid = $_POST["fromSid"];
$fromTable = $_POST["fromTable"];
$toSid = $_POST["toSid"];
$toTable = $_POST["toTable"];
$fromTransInput = $_POST["fromTransInput"]; //TODO FIXME this is not correct, we shoudl send tranformation values e.g. cid(), not decoded values, because what is there is a formula?Or make sure this approach works
$toTransInput = $_POST["toTransInput"];  //TODO FIXME this is not correct, we shoudl send tranformation values e.g. cid(), not decoded values, because what is there is a formula?
$action = $_POST["action"];

//print_r($_POST);

$transHandler = new TransformationHandler();
$encodedFromTrans = $transHandler->encodeTransformationInput($fromSid, $fromTable, $fromTransInput);
//$fromCids = $transHandler->getWrappedCids($encodedFromTrans);
$encodedToTrans = $transHandler->encodeTransformationInput($toSid, $toTable, $toTransInput);
//$toCids = $transHandler->getWrappedCids($encodedToTrans);

$from = new DataMatcherLinkOnePart();
$from->sid = $fromSid;
$from->tableName = $fromTable;
$from->transformation = $encodedFromTrans;

$to = new DataMatcherLinkOnePart();
$to->sid = $toSid;
$to->tableName = $toTable;
$to->transformation = $encodedToTrans;

// $from = new stdClass;
// $from->sid = $fromSid;
// $from->tableName = $fromTable;
// $from->links = $fromCids; // size of this array should be equal to the size of array in To

// $to = new stdClass;
// $to->sid = $toSid;
// $to->tableName = $toTable;
// $to->links = $toCids;

// Params for data-tables server-side processing.
$pageLength = $_POST['pageLength'];
$page = $_POST['page'];

$action($from, $to);//, $page, $pageLength);

function getDifferentAndSameValueTables($from, $to) {

    $dataMatcher = new DataMatcher();
    echo json_encode($dataMatcher->CheckDataMatching($from, $to));
}

function getDistinctFromTable($from, $to) {
    getDistinctTable($from);
}

function getDistinctToTable($from, $to) {
    getDistinctTable($to);
}

function getDistinctTable($dataMatcherLinkOnePart) {

    $pageLength = $_POST['iDisplayLength'];
    $page = ($_POST['iDisplayStart'] / $pageLength) + 1;
    $searchTerm = $_POST['sSearch'];

    //foreach ($dataMatcherLinkOnePart->transformation as $transformation) {
        $cidSearchTerm[$dataMatcherLinkOnePart->transformation] = $searchTerm;
    //}

    $dataMatcher = new DataMatcher();
    $distinctTable = $dataMatcher->GetDistinctForColumns($dataMatcherLinkOnePart, $pageLength, $page, $cidSearchTerm);

    $tableRows = array();

    if (isset($distinctTable)) {
        if ($distinctTable->rows != null) {
            foreach ($distinctTable->rows as $rowObj) {
                $tableRow = array();
                foreach ($distinctTable->columns as $column) {
                    if (is_object($rowObj)) { //TODO: this need to be fixed. There should only one format of returned data. All should be accociated array
                        $tableRow[] = $rowObj->$column;
                    }
                    else {
                        $tableRow[] = $rowObj[$column];
                    }                    
                }
                $tableRows[] = $tableRow;
            }
        } else {
            $tableRows = array();
        }
    }

    $jsonResult['aaData'] = $tableRows;
    $jsonResult['aoColumns'] = $distinctTable->columns;
    // $jsonResult['mData'] = $distinctTable->rows;

    if (is_object($distinctTable->totalRows[0])) { // TODO FIXME.
        $jsonResult["iTotalRecords"] = $distinctTable->totalRows[0]->ct;
        $jsonResult["iTotalDisplayRecords"] = $distinctTable->totalRows[0]->ct;
    }
    else {
        $jsonResult["iTotalRecords"] = $distinctTable->totalRows[0]['ct'];
        $jsonResult["iTotalDisplayRecords"] = $distinctTable->totalRows[0]['ct'];
    }

   

    echo json_encode($jsonResult);
}

?>	