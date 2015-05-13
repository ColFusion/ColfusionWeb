<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

$relId = $_POST['relId'];
$simThreshold = $_POST['simThreshold'];
$userName = $current_user->user_login;
$relationshipDAO = new RelationshipDAO();

try {
    $relationship = $relationshipDAO->getRelationship($relId, $simThreshold);
    $relationship->isOwned = $relationship->creator == $userName;
    $relationship->simThreshold = $simThreshold;
    echo json_encode($relationship);
} catch (Exception $e) {
    die($e->getMessage());
}
?>
