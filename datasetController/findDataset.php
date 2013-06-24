<?php

require_once realpath(dirname(__FILE__)) . '/../DAL/DatasetFinder.php';

$searchTerm = $_GET['searchTerm'];
$datasetFinder = new DatasetFinder();
$datasetsInfo = $datasetFinder->findDatasetInfoBySidOrName($searchTerm);

foreach($datasetsInfo as $datasetInfo){
    $datasetInfo->source_key = $datasetInfo->title . "#" . $datasetInfo->sid;
    $datasetInfo->content = $datasetInfo->content == null ? 'This dataset has no description' : $datasetInfo->content; 
}

echo json_encode($datasetsInfo);
?>
