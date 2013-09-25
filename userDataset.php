<?php

include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'group.php');
include(mnminclude.'smartyvariables.php');
include_once(mnminclude.'user.php');

global $current_user;

// Reuqest user to login.
if($current_user->authenticated != TRUE)
{
	$vars = '';
	check_actions('anonymous_story_user_id', $vars);
	if ($vars['anonymous_story'] != true)
		force_authentication();
}

$main_smarty->assign('tpl_center', $the_template . '/userDataset');
$main_smarty->display($the_template . '/pligg.tpl');

?>