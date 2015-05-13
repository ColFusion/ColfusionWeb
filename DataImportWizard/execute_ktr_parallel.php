<?php

require_once(realpath(dirname(__FILE__)) . "/KTRExecutor.php");

$sid = $_POST["sid"];
$userID = $_POST["userID"];
$ktrManager = unserialize($_POST["ktrManager"]);

// "disable partial output" or 
// "enable buffering" to give out all at once later
ob_start();

// "say hello" to client (parent script in this case) disconnection
// before child ends - we need not care about it
ignore_user_abort(1);

// we will work forever
//set_time_limit(0);

// we need to say something to parent to stop its waiting
// it could be something useful like client ID or just "OK"
echo "OKKKK";

// push buffer to parent
ob_flush();


flush();

// parent gets our answer and disconnects
// but we can work "in background" :)

$ktrExecutor = new KTRExecutor($sid, $userID, $ktrManager);
$ktrExecutor->execute();

exit;

?>