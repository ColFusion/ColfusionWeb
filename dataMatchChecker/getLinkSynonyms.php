<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/DataMatchingCheckerDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');
$userId = $current_user->user_id;

$fromSid = $_POST['fromSid'];
$fromTableName = $_POST['fromTableName'];
$fromTransInput = $_POST['fromTransInput']; 
$toSid = $_POST['toSid']; 
$toTableName = $_POST['toTableName']; 
$toTransInput = $_POST['toTransInput'];

$dao = new DataMatchingCheckerDAO();
$synonyms = $dao->getLinkSynonyms($fromSid, $fromTableName, $fromTransInput, $toSid, $toTableName, $toTransInput);
$synonyms = ($synonyms == null) ? array() : $synonyms;
foreach($synonyms as $synonym){
    $synonym->isOwned = $synonym->userId == $userId;
}

echo json_encode($synonyms);

?>