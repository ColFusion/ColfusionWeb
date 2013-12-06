<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/index_chat/jquery.ajax_chat.js?<?php echo $rndnumber; ?>"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/index_chat/own_id.inc.php"></script>
{php}
	require_once realpath(dirname(dirname(__DIR__))) . '/chat/indexchat_config.php';
	require_once realpath(dirname(dirname(__DIR__))) . '/DAL/IndexchatDAO.php';
	$indexchatDAO = new IndexchatDAO();
    $indexchatDAO->addNewUser();
    
	global $current_user;
	if($current_user->user_login != null){
		$_SESSION['username'] = $current_user->user_login; 
		$_SESSION['user_id'] = $current_user->user_id;
		$own_id = $_SESSION['user_id'];

		//load users from database
		$users = mysql_query("SELECT id,username FROM `".CHAT_DB."`.`index_users` WHERE id!='".$_SESSION['user_id']."' HAVING id IN (SELECT `friend_to` FROM `colfusion`.`colfusion_friends` WHERE `friend_from`=".$_SESSION['user_id'].")");
		print '<div class="chat_user_bg">Friends<div>';
		if(mysql_num_rows($users) > 0){
			while($user = mysql_fetch_assoc($users)){
			//ALT tag contains user ID and user name 
				print '<div class="chat_user_bg hasFriends"><a href="#" alt="'.$user['id'].'|'.$user['username'].'" class="chat_user">'.$user['username'].'</a></div>';
			}
		}
		else
			print '<div class="chat_user_bg">You do not have any friend yet.<div>';
	}
	if (isset($_SESSION['chatbox_status'])) {
		print '<script type="text/javascript">';
		print '$(function() {';
			foreach ($_SESSION['chatbox_status'] as $openedchatbox) {
				print 'PopupChat('.$openedchatbox['partner_id'].',"'.$openedchatbox['partner_username'].'",'.$openedchatbox['chatbox_status'].');';
			}
			print "});";
	print '</script>';
	}

{/php}