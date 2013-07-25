<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/DataMatchingCheckerDAO.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

if (!$current_user->authenticated)
    die('Please login to use this function.');
$userId = $current_user->user_id;

$sidFrom = $_POST["sidFrom"];
$sidTo = $_POST["sidTo"];
$tableFrom = $_POST["tableFrom"];
$tableTo = $_POST["tableTo"];
$fromTransInput = $_POST["fromTransInput"];
$toTransInput = $_POST["toTransInput"];
$synFrom = $_POST["synFrom"];
$synTo = $_POST["synTo"];

$dao = new DataMatchingCheckerDAO();
try {
    $dao->storeSynonym($sidFrom, $tableFrom, $fromTransInput, $synFrom, $sidTo, $tableTo, $toTransInput, $synTo, $userId);
    $jsonResult["isSuccessful"] = true;
} catch (Exception $e) {
    $jsonResult["isSuccessful"] = false;
}

echo json_encode($jsonResult);
?>
