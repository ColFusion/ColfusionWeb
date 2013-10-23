<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/Neo4JDAO.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/NotificationDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');

$relId = $_POST['relId'];
$userId = $current_user->user_id;
$relationshipDAO = new RelationshipDAO();

$notificationDAO = new NotificationDAO();
$notificationDAO->addNTFtoDB($relId, "removeRelationship");

$jsonResult = new stdClass();
try {
    $relationshipDAO->deleteRelationship($relId, $userId);
    $n4jDao = new Neo4JDAO();
    $n4jDao->deleteRelationshipByRelId($relId);
    
    $jsonResult->isSuccessful = true;
} catch (Exception $e) {
    $jsonResult->isSuccessful = false;
}

echo json_encode($jsonResult);
?>
