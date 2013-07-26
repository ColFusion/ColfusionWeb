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

$queryEngine = new QueryEngine();
echo json_encode($queryEngine->CheckDataMatching($from, $to));
?>	