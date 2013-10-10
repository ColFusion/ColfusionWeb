<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/NotificationDAO.php');

 global $current_user;
/*
header('Content-type: text/html; charset=utf-8');
if(isset($_GET["action"])){
    $action = $_GET["action"];
    $action();
}

// Expects sid in post
function allUserNTF() {
    $notificationDAO = new NotificationDAO();

    echo json_encode($notificationDAO->allUserNTF($_POST["sid"]));
}
*/


	include('../config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    //include(mnminclude.'smartyvariables.php');

   
	
	$links = $db->get_results($sql="SELECT C.user_login AS sender, A.ntf_id AS ntf_id, A.action AS action, B.receiver_id AS receiver_id, D.link_title AS target
		FROM colfusion_notifications A, colfusion_notifications_unread B, colfusion_users C, colfusion_links D
		WHERE C.user_id = A.sender_id AND A.ntf_id = B.ntf_id AND D.link_id = A.target_id AND B.receiver_id=".$current_user->user_id);
	echo json_encode($links);
	
?>