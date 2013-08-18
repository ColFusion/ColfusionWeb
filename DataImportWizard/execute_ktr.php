<?php

include_once '../config.php';
include_once(mnminclude . 'user.php');
require_once(realpath(dirname(__FILE__)) . "/ExecutionManager.php");

// parent sript, called by user request from browser

$sid = getSid();

global $current_user, $db;

$author = $current_user->user_id;

$ktrManagers = unserialize($_SESSION["ktrArguments_$sid"]["ktrManagers"]);

foreach ($ktrManagers as $filename => $ktrManager) {
    ExecutionManager::callChildProcessToExectueOneKTRTransformation($sid, $author, $ktrManager);
}

// TODO: read output from the child process if it was started successfully.

$result = new stdClass;
$result->isSuccessful = true;
$result->message = 'Success!';
// $result->pentaho_cmd = $commands;
echo json_encode($result);

exit;

function getSid()
{
    // determine which step of the submit process we are on
    if (isset($_POST["sid"]))
        $sid = $_POST["sid"];
    else if (isset($_GET["sid"]))
        $sid = $_GET["sid"];
    else {
        echo json_encode("no sid");
        die();
    }

    return $sid;
}