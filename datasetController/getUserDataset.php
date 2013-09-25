<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/DatasetFinder.php';
require_once(realpath(dirname(__FILE__)) . "/../DataImportWizard/ExecutionManager.php");

if(!$current_user->authenticated){
    die('Access Denied');
}

$userId = $current_user->user_id;

$datasetFinder = new DatasetFinder();
$datasetsInfo = $datasetFinder->findDatasetInfoByUserId($userId);

foreach($datasetsInfo as $datasetInfo){
    $datasetInfo->description = $datasetInfo->description == null ? 'This dataset has no description' : $datasetInfo->description; 
    // $datasetInfo->status = getDatasetStatus($datasetInfo->sid);
}

echo json_encode($datasetsInfo);

function getDatasetStatus($sid){
    return ExecutionManager::getExecutionStatus($sid);
}

?>