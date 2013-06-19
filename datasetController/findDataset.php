<?php
require_once '../DAL/DatasetFinder.php';

$searchTerm = $_GET['searchTerm'];
$datasetFinder = new DatasetFinder();
$datasetsInfo = $datasetFinder->findDatasetInfoBySidOrName($searchTerm);

foreach($datasetsInfo as $datasetInfo){
    $datasetInfo->link_key = $datasetInfo->link_title . "#" . $datasetInfo->link_id;
}

echo json_encode($datasetsInfo);
?>
