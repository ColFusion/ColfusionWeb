<?php

require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

$relId = $_POST['relId'];
$relationshipDAO = new RelationshipDAO();

try {
    $relationship = $relationshipDAO->getRelationship($relId);
    echo json_encode($relationship);
} catch (Exception $e) {
    die($e->getMessage());
}
?>
