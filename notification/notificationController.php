<?php
include_once(realpath(dirname(__FILE__)) . '/../DAL/NotificationDAO.php');

include_once('../config.php');
include_once(mnminclude.'html1.php');
include_once(mnminclude.'link.php');

global $current_user;

header('Content-type: text/html; charset=utf-8');

if(isset($_GET["action"])){
    $action = $_GET["action"];
    $action();
}

function getNTFnum() {
	$notificationDAO = new NotificationDAO();

    echo $notificationDAO->getNTFnum();
}

function allUserNTF() {
    $notificationDAO = new NotificationDAO();
 
    echo $notificationDAO->allUserNTF();
}

function removeNTF() {
	$notificationDAO = new NotificationDAO();
    $ntfID = $_GET["ntf_id"];

    echo $notificationDAO->removeNTF($ntfID);
}

function seeAll() {
    $notificationDAO = new NotificationDAO();

    echo $notificationDAO->seeAll();
}

	
?>