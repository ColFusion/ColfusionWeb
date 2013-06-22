<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');

$relId = $_POST['relId'];
$relId = 1457;
$relationshipDAO = new RelationshipDAO();

echo json_encode($relationshipDAO->getComments($relId));
?>
