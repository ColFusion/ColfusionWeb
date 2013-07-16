<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');

$relId = $_POST['relId'];
$userId = $current_user->user_id;
$relationshipDAO = new RelationshipDAO();


$jsonResult = new stdClass();
try {
    $relationshipDAO->deleteRelationship($relId, $userId);
    $jsonResult->isSuccessful = true;
} catch (Exception $e) {
    $jsonResult->isSuccessful = false;
}

echo json_encode($jsonResult);
?>
