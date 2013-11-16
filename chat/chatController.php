<?php
include_once(realpath(dirname(__FILE__)) . '/../DAL/ChatDAO.php');

include_once('../config.php');
include_once(mnminclude.'html1.php');
include_once(mnminclude.'link.php');

global $current_user;

header('Content-type: text/html; charset=utf-8');

if(isset($_GET["action"])){
    $action = $_GET["action"];
    $action();
}

function addToOnline(){
	$chatDAO = new ChatDAO();
    $sid = $_GET["room"];
    echo $chatDAO->addToOnline();
}

function getAllOnlineUsers(){
    $chatDAO = new ChatDAO();
    $sid = $_GET["room"];
    echo $chatDAO->getAllOnlineUsers($sid);
}

function getChats(){
    $chatDAO = new ChatDAO();
    $lastID = $_GET["lastID"];
    $sid = $_GET["room"];
    echo $chatDAO->getChats($lastID, $sid);
}

function submitChat(){
    $chatDAO = new ChatDAO();
    $details = $_GET["details"];
    $sid = $_GET["room"];
    echo $chatDAO->submitChat($details, $sid);
}
	
function createRoomIfNeeded(){
    $chatDAO = new ChatDAO();
    $sid = $_GET["room"];
    echo $chatDAO->addToOnline($sid);
    echo $chatDAO->createChatRoomForStory($sid);
}

?>