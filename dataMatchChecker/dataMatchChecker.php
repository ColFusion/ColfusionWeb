<?php

require_once(realpath(dirname(__FILE__)) . '/../config.php');
require_once(realpath(dirname(__FILE__)) . '/../OriginalSmarty/OriginalSmarty.class.php');

global $current_user;
if (!$current_user->authenticated)
    die('Please login to use this function.');

// Assign model to template. 
$smarty = new OriginalSmarty();
$smarty->display('dataMatchChecker.tpl');
?>
