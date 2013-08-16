<?php

include('../config.php');

require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");
require_once(realpath(dirname(__FILE__)) . "/UtilsForWizard.php");
require_once(realpath(dirname(__FILE__)) . "/KTRManager.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");

$sid = $_GET["sid"];
$logID = $_GET["logId"];
$ktrManager = unserialize($_POST["ktrManager"]);

// "disable partial output" or 
// "enable buffering" to give out all at once later
ob_start();

// "say hello" to client (parent script in this case) disconnection
// before child ends - we need not care about it
ignore_user_abort(1);

// we will work forever
set_time_limit(0);

// we need to say something to parent to stop its waiting
// it could be something useful like client ID or just "OK"
echo "OK";

//var_dump($sid,$logId,$ktrManager, $db);

// push buffer to parent
ob_flush();


flush();
// parent gets our answer and disconnects
// but we can work "in background" :)


//sleep(60);

global $db;

$sql = "UPDATE " . table_prefix . "executeinfo SET status='in progress' WHERE Eid=" . $logID;
$rs = $db->query($sql);



$pentaho_err_code = array(
    0 => 'The transformation ran without a problem',
    1 => "Errors occurred during processing",
    2 => "An unexpected error occurred during loading / running of the transformation",
    3 => "Unable to prepare and initialize this transformation",
    7 => "The transformation couldn't be loaded from XML or the Repository",
    8 => "Error loading steps or plugins (error in loading one of the plugins mostly)",
    9 => "Command line usage printing",
    10 => "Errors occur when storing source information"
);



    $ktrFilePath = $ktrManager->getKtrFilePath();

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        $locationOfPan = mnmpath . 'kettle-data-integration\\Pan_WHDV.bat';
        $command = 'cmd.exe /C ' . $locationOfPan . ' /file:"' . $ktrFilePath . '" ' . '"-param:Sid=' . $sid . '"' . ' "-param:Eid=' . $logID . '"';
    } else {
        $locationOfPan = mnmpath . 'kettle-data-integration/pan.sh';
        $command = 'sh ' . $locationOfPan . ' -file="' . $ktrFilePath . '" ' . '-param:Sid=' . $sid . ' -param:Eid=' . $logID;
    }

    $sql = "UPDATE " . table_prefix . "executeinfo SET pan_command='$command' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

	$sql = "UPDATE " . table_prefix . "executeinfo SET status='creating database if needed' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

    $databaseConnectionInfo = $ktrManager->getConnectionInfo();

    $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($databaseConnectionInfo->engine, $databaseConnectionInfo->username, $databaseConnectionInfo->password, null, $databaseConnectionInfo->server, $databaseConnectionInfo->port);

    $dbHandler = $dbHandler->createDatabaseIfNotExist($databaseConnectionInfo->database);

    $tableName = $ktrManager->getTableName();

    $columns = $ktrManager->getColumns();

    $sql = "UPDATE " . table_prefix . "executeinfo SET status='creating table if needed' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

    $dbHandler->createTableIfNotExist($tableName, $columns);



	$queryEngine = new QueryEngine();

    $sql = "UPDATE " . table_prefix . "executeinfo SET status='adding database info and linked server' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

    $queryEngine->simpleQuery->addSourceDBInfo($sid, $databaseConnectionInfo->server, $databaseConnectionInfo->port, $databaseConnectionInfo->username, $databaseConnectionInfo->password, $databaseConnectionInfo->database, $databaseConnectionInfo->engine);

    $queryEngine->simpleQuery->setSourceTypeBySid($sid, 'database');

    $sql = "UPDATE " . table_prefix . "executeinfo SET status='success' WHERE Eid=" . $logID;
	$rs = $db->query($sql);



    $sql = "UPDATE " . table_prefix . "executeinfo SET status='executing transformation' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

    $ret = exec($command, $outA, $returnVar);

    $sql = "UPDATE " . table_prefix . "executeinfo SET status='finished transformation' WHERE Eid=" . $logID;
	$rs = $db->query($sql);

    if ($returnVar != 0) {
        $num = 0;
        $sql = "UPDATE " . table_prefix . "executeinfo SET ExitStatus=$returnVar, ErrorMessage='" . mysql_real_escape_string(implode("\n", $outA)) . "', RecordsProcessed='" . $num . "', TimeEnd=CURRENT_TIMESTAMP WHERE EID=" . $logID;
        $rs = $db->query($sql);

        $sql = "UPDATE " . table_prefix . "executeinfo SET status='transformation failed' WHERE Eid=" . $logID;
		$rs = $db->query($sql);

        $error = implode("<br />", $outA);

        $errora = array();
        $errorb = array();
        $re1 = '(at)';
        $re2 = '( )';

        for ($i = 0; $i < count($outA); $i++) {
            if (strstr($outA[$i], 'ERROR') != false) {
                break;
            }
        }

        $n = $i;
        for ($j = $n + 1; $j < count($outA); $j++) {
            if ($c = preg_match_all("/" . $re1 . $re2 . '/is', $outA[$j], $matches)) {
                break;
            }
        }
        for ($i; $i < $j; $i++) {
            array_push($errora, $outA[$i]);
        }

        for ($o = 0; $o < count($outA); $o++) {
            if ($c = preg_match_all("/" . $re1 . $re2 . '/is', $outA[$o], $matches)) {
                array_push($errorb, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" . $outA[$o]);
            }
        }
     
        $msg = '<p class="error">Error Message:<br />' . $pentaho_err_code[$returnVar] . '</p>';

        $result = new stdClass;
        $result->isSuccessful = false;
        $result->message = $msg;
        $result->pentaho_cmd = $commands;
        $result->exeCode = $returnVar;
        echo json_encode($result);

        exit;
    } else {
        //TODO parse msg to get num inserted
        $lastLine = $outA[count($outA) - 1];
        preg_match("/d+\s{1}[0-9]+\s{1}l+/", $lastLine, $matches);
        $m = explode(' ', $matches[0]);
        $numProcessed = $m[1];

        $sql = "UPDATE " . table_prefix . "executeinfo SET ExitStatus=0, RecordsProcessed='" . $numProcessed . "', TimeEnd=CURRENT_TIMESTAMP WHERE EID=" . $logID;
        $rs = $db->query($sql);

        $sql = "UPDATE " . table_prefix . "executeinfo SET status='transformation finished successfully' WHERE Eid=" . $logID;
		$rs = $db->query($sql);

       // $sid = getSid();

        

//         $dnamelistquery = "SELECT DISTINCT Dname FROM " . table_prefix . "temporary WHERE Sid = $sid";
//         $dnamelist = $db->get_results($dnamelistquery);
//         $num = count($dnamelist);

//         $query = "UPDATE `colfusion_temporary` AS t, 
//        (SELECT @rownumN:=@rownumN+1 as rownumN, `Tid`, `rownum`
//         FROM `colfusion_temporary`, (select @rownumN := -1) rn
//         where `Sid` = $sid
//        ) AS r
// SET t.`rownum` = r.rownumN DIV $num + 1
// WHERE t.`Tid` = r.`Tid`";
//         $db->query($query);

//         $query = "UPDATE `colfusion_temporary` AS t, 
//        (SELECT @rownumN:=@rownumN+1 as rownumN, `Tid`, `rownum`
//         FROM `colfusion_temporary`, (select @rownumN := -1) rn
//         where `Sid` = $sid
//        ) AS r
// SET t.`columnnum` = r.rownumN % $num + 1
// WHERE t.`Tid` = r.`Tid`";
//         $db->query($query);

//         UtilsForWizard::insertCidToNewData($sid, $filename);
    }




exit;



?>