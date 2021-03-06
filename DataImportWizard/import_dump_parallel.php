<?php

require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/DBImporters/DatabaseImporterFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/KTRExecutorDAO.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");
require_once(realpath(dirname(__FILE__)) . "/../settings.php");

$sid = $_POST["sid"];
$userId = $_POST["userID"];
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

importDataFromDumpFile($sid, $dbHandler, $userId, $dumpFilePath, $my_pligg_base_no_slash);

function importDataFromDumpFile($sid, DatabaseHandler $dbHandler, $userId, $filePath, $my_pligg_base_no_slash){

    $ktrExeDao = new KTRExecutorDAO();
    $tableNames = $dbHandler->loadTables();

    $logIds = array();
    foreach($tableNames as $tableName){
        $logIds[$tableName] = $ktrExeDao->addExecutionInfoTuple($sid, $tableName, $userId);
    }

    try{     
        $dbImporter = DatabaseImporterFactory::createDatabaseImporter($dbHandler->getDriver(), $sid, $my_pligg_base_no_slash);
        $dbImporter->importDbData($filePath);
    
        foreach($logIds as $logId){
            $ktrExeDao->updateExecutionInfoStatus($logId, 'success');
        }
    }
    catch(Exception $e){
        foreach($logIds as $logId){
            $ktrExeDao->updateExecutionInfoStatus($logId, 'error');
            $ktrExeDao->updateExecutionInfoErrorMessage($logId, $e->getMessage());
        }
    }
    
    $queryEngine = new QueryEngine();
    foreach($logIds as $tableName => $logId){
        $numProcessed = $queryEngine->GetTotalNumberTuplesInTableBySidAndNameFromExternalDB($sid, $tableName);
        $ktrExeDao->updateExecutionInfoTupleAfterPanTerminated($logId, 0, '', $numProcessed, 'success');
    }
}

?>