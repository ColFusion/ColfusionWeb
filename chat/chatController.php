<?php
include_once(realpath(dirname(__FILE__)) . '/../DAL/ChatDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/IndexchatDAO.php');
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

function setStatus(){
    $indexchatDAO = new IndexchatDAO();
    if(isset($_POST["status"])){
        if($_POST["status"] == "online"){
            $chat_status = "online";
            $offlineshift = 0; 
        }else{
            $chat_status = "offline";
            $offlineshift = time() + 10; 
        }                                
        echo $indexchatDAO->setStatus($chat_status, $offlineshift);                                 
    }else if (isset($_POST["chatbox_status"])) {
        $_SESSION["chatbox_status"] = $_POST["chatbox_status"];
    } else {
        unset($_SESSION["chatbox_status"]);
    }
}

function sendMessage(){
    $indexchatDAO = new IndexchatDAO();
    $to_id = $_GET["to_id"];
    $message = $_GET["message"];
    echo $indexchatDAO->sendMessage($to_id, $message);
}

function loadMessage(){
    $indexchatDAO = new IndexchatDAO();
    $partner_id = $_GET["partner_id"];
    $is_typing = $_GET["is_typing"];
    echo $indexchatDAO->loadMessage($partner_id, $is_typing);
}

function isTyping(){
    $indexchatDAO = new IndexchatDAO();
    $partner_id = $_GET["partner_id"];
    echo $indexchatDAO->isTyping($partner_id);
}

function loadPopupMessage(){
    $indexchatDAO = new IndexchatDAO();
    echo $indexchatDAO->loadPopupMessage();
}

?>