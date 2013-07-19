<?php

require_once(realpath(dirname(__FILE__)) . '/../config.php');
require_once(realpath(dirname(__FILE__)) . '/../OriginalSmarty/OriginalSmarty.class.php');

global $current_user;
if (!$current_user->authenticated)
    die('Please login to use this function.');

$fromSid = $_POST['fromSid'];
$toSid = $_POST['toSid'];
$fromTable = $_POST['fromTable'];
$toTable = $_POST['toTable'];

if(empty($fromSid) || empty($toSid) || empty($fromTable) || empty($toTable)){
    die("Invalid argument");
}

// Assign model to template. 
$smarty = new OriginalSmarty();
$smarty->assign('fromSid', $fromSid);
$smarty->assign('toSid', $toSid);
$smarty->assign('fromTable', $fromTable);
$smarty->assign('toTable', $toTable);
$smarty->display('dataMatchChecker.tpl');

?>
