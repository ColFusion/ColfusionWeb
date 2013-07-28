<?php

include_once(realpath(dirname(__FILE__)) . '/../config.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
ini_set('display_errors', 1);


$from = new stdClass;
$from->sid = 751;
$from->tableName = "Extra-State War Participants (V";
$from->links = array("cid(593)", "cid(594)"); // size of this array should be equal to the size of array in To

$searchTerms = array("cid(593)" => "30", "cid(594)" => "00.");

$queryEngine = new QueryEngine();

echo json_encode($queryEngine->GetDistinctForColumns($from, 10, 1, $searchTerms));
?>	