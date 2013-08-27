<?php

require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/DBImporters/DatabaseImporterFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/KTRExecutorDAO.php");

$sid = $_GET["sid"];
$userId = $_GET["userID"];
$dbHandler = unserialize($_POST["dbHandler"]);
$dumpFilePath = $_POST["dumpFilePath"];

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
echo "OKKKK";

//var_dump($sid,$logId,$ktrManager, $db);

// push buffer to parent
ob_flush();
flush();

// parent gets our answer and disconnects
// but we can work "in background" :)

importDataFromDumpFile($sid, $dbHandler, $userId, $dumpFilePath);

function importDataFromDumpFile($sid, DatabaseHandler $dbHandler, $userId, $filePath){

    $ktrExeDao = new KTRExecutorDAO();
    $tables = $dbHandler->loadTables();

    $logIds = array();
    foreach($tables as $table){
        $logIds[] = $ktrExeDao->addExecutionInfoTuple($sid, $table, $userId);
    }

    try{
        echo "start import</br>";
        
        $dbImporter = DatabaseImporterFactory::createDatabaseImporter($dbHandler->getDriver(), $sid, "colfusion");
        $dbImporter->importDbData($filePath);
    
        echo "finish import</br>";
        foreach($logIds as $logId){
            $ktrExeDao->updateExecutionInfoTupleStatus($logId, 'success');
        }
    }
    catch(Exception $e){
        var_dump($e->getMessage());
        foreach($logIds as $logId){
            $ktrExeDao->updateExecutionInfoTupleStatus($logId, 'error');
            $ktrExeDao->updateExecutionInfoErrorMessage($logId, $e->getMessage());
        }
    }

    foreach($logIds as $logId){
        $ktrExeDao->updateExecutionInfoTimeEnd($logId);
    }
}

?>