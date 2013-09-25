<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/Neo4JDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');

$userId = $current_user->user_id;
$relId = $_POST['relId'];
$comment = $_POST['comment'];
$confidence = $_POST['confidence'];
$action = $_POST['action'];
$dao = new RelationshipDAO();

$result = $action();
$resultJson = new stdClass();

if ($result !== false) {
    updateRelCostInNeo4J($relId, $dao);
    $resultJson->isSuccessful = true;
}else{
    $resultJson->isSuccessful = false;
}
echo json_encode($resultJson);

function addComment() {
    global $relId, $userId, $confidence, $comment, $dao;
    return $dao->addComment($relId, $userId, $confidence, $comment);
}

function updateComment() {
    global $relId, $userId, $confidence, $comment, $dao;
    return $dao->updateComment($relId, $userId, $confidence, $comment);
}

function removeComment() {
    global $relId, $userId, $dao;
    return $dao->removeComment($relId, $userId);
}

function updateRelCostInNeo4J($relId, $dao){
    $avgConfidence = $dao->getRelationshipAverageConfidenceByRelId($relId);
    $n4jDao = new Neo4JDAO();
    $n4jDao->updateCostByRelId($relId, 1-$avgConfidence);
}

?>
