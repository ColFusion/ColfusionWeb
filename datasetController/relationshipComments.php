<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');

$relId = $_POST['relId'];
$userId = $current_user->user_id;
$relationshipDAO = new RelationshipDAO();

$comments = $relationshipDAO->getComments($relId);
for($i=0 ; $i<count($comments) ; $i++){
    if($comments[$i]->userId == $userId){
        $yourComment = $comments[$i];
        unset($comments[$i]);
        $comments = array_values($comments);
        break;
    }
}

$jsonResult = new stdClass();
$jsonResult->yourComment = $yourComment;
$jsonResult->comments = $comments;

echo json_encode($jsonResult);
?>
