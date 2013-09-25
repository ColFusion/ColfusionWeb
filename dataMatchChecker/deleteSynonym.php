<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/DataMatchingCheckerDAO.php';

if (!$current_user->authenticated)
    die('Please login to use this function.');
$userId = $current_user->user_id;
$synId = $_POST['synId'];

try {
    $dao = new DataMatchingCheckerDAO();
    $dao->deleteSynonym($synId, $userId);
    $jsonResult["isSuccessful"] = true;
}
catch (Exception $e) {
    $jsonResult["isSuccessful"] = false;
    $jsonResult["message"] = $e->getMessage();
}

echo json_encode($jsonResult);

?>