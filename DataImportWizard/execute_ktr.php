<?php

include_once '../config.php';
include_once(mnminclude . 'user.php');

require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");
require_once(realpath(dirname(__FILE__)) . "/UtilsForWizard.php");
require_once(realpath(dirname(__FILE__)) . "/KTRManager.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");

// parent sript, called by user request from browser

$sid = getSid();

global $current_user, $db;

$author = $current_user->user_id;

$ktrManagers = unserialize($_SESSION["ktrArguments_$sid"]["ktrManagers"]);

foreach ($ktrManagers as $filename => $ktrManager) {

    $sql = "INSERT INTO " . table_prefix . "executeinfo (Sid, Userid, TimeStart, status)VALUES ($sid, $author, CURRENT_TIMESTAMP, 'started');";
    $rs = $db->query($sql);

    //get eid returned from the insert
    $logID = mysql_insert_id();

    callChildProcessToExectueOneKTRTransformation($sid, $logID, $ktrManager);
}

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

function callChildProcessToExectueOneKTRTransformation($sid, $logId, $ktrManager)
{
    // create socket for calling child script
    $socketToChild = fsockopen("localhost", 80);

    $base = my_pligg_base;

    // HTTP-packet building; header first
    $msgToChild = "POST $base/DataImportWizard/execute_ktr_parallel.php?&sid=$sid&logId=$logId HTTP/1.0\n";
    $msgToChild .= "Host: localhost\n";

    $vars = array("ktrManager" => serialize($ktrManager));

    $postData = http_build_query($vars);
    $msgToChild .= "Content-Type: application/x-www-form-urlencoded\r\n";
    $msgToChild .= "Content-Length: ".strlen($postData)."\n\n";

    // header done, glue with data
    $msgToChild .= $postData;

//var_dump($socketToChild);
//var_dump($msgToChild);

    // send packet no oneself www-server - new process will be created to handle our query
    fwrite($socketToChild, $msgToChild);

    // wait and read answer from child
    $data = fread($socketToChild, 100);//stream_get_contents($socketToChild);

//var_dump($data);

    // close connection to child
    fclose($socketToChild);
}
