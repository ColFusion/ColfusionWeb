<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

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
    $resultJson->isSuccessful = true;
}else{
    $resultJson->isSuccessful = false;
}
echo json_encode($resultJson);

function addComment() {
    global $relId, $userId, $confidence, $comment;
    return $dao->addComment($relId, $userId, $confidence, $comment);
}

function updateComment() {
    global $relId, $userId, $confidence, $comment;
    return $dao->updateComment($relId, $userId, $confidence, $comment);
}

function removeComment() {
    global $relId, $userId;
    return $dao->removeComment($relId, $userId);
}

?>
