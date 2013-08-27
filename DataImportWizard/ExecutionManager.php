<?php

include_once '../config.php';
require_once(realpath(dirname(__FILE__)) . "/../DAL/KTRExecutorDAO.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");

/**
 * Run ktr and db import scripts in parallel
 */
class ExecutionManager
{
    public static function callChildProcessToExectueOneKTRTransformation($sid, $userID, $ktrManager)
    {     
        $script_url = my_pligg_base . '/DataImportWizard/execute_ktr_parallel.php';
        $vars = array("ktrManager" => serialize($ktrManager));
        $postData = http_build_query($vars);
        
        ExecutionManager::callChildProcess($script_url, $sid, $userID, $postData);      
    }

    public static function callChildProcessToImportDumpFile($sid, $userID, DatabaseHandler $dbHandler, $dumpFilePath)
    {        
        $script_url = my_pligg_base . '/DataImportWizard/import_dump_parallel.php';
        $vars = array("dbHandler" => serialize($dbHandler), "dumpFilePath" => $dumpFilePath);
        $postData = http_build_query($vars);
        
        ExecutionManager::callChildProcess($script_url, $sid, $userID, $postData);   
    }

    public static function callChildProcess($script_url, $sid, $userId, $postData)
    {
        // create socket for calling child script
        $socketToChild = fsockopen("localhost", 80);

        $base = my_pligg_base;

        // HTTP-packet building; header first
        $msgToChild = "POST $script_url?&sid=$sid&userID=$userId HTTP/1.0\n";
        $msgToChild .= "Host: localhost\n";
        
        $msgToChild .= "Content-Type: application/x-www-form-urlencoded\r\n";
        $msgToChild .= "Content-Length: ".strlen($postData)."\n\n";

        // header done, glue with data
        $msgToChild .= $postData;

		//var_dump($socketToChild);

        // send packet no oneself www-server - new process will be created to handle our query
        fwrite($socketToChild, $msgToChild);

        // wait and read answer from child
        $data = fread($socketToChild, 5000);
        // echo stream_get_contents($socketToChild);

        // close connection to child
        fclose($socketToChild);
    }


    /**
     * Returns execution status with additional information like how many records were processed.
     * @param   $sid sid of the story
     * @return stdClass      info about the status
     */
    public static function getExecutionStatus($sid)
    {
        $ktrExecutorDAO = new KTRExecutorDAO();

        $tuplesFromExecuteInfoTable = $ktrExecutorDAO->getTuplesBySid($sid);

        $queryEngine = new QueryEngine();

        // TODO: need to make import from dump file work in parallel
        if (!isset($tuplesFromExecuteInfoTable) || count($tuplesFromExecuteInfoTable) == 0) {
            $tuplesFromExecuteInfoTable = array();
            $tables = $queryEngine->GetTablesList($sid);

            foreach ($tables as $key => $tableName) {
                $rec = new stdClass();
                $rec->tableName = $tableName;
                $rec->status = "success";
                $rec->Eid = "NA";
                $rec->ErrorMessage = "";
                $rec->RecordsProcessed = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, "[$tableName]");
                $rec->Sid = $sid;
                $rec->TimeEnd = "2013-08-18 12:21:19"; //FIXME
                $rec->TimeStart = "2013-08-18 12:21:19";
                $rec->UserId = "NA";

                $tuplesFromExecuteInfoTable[] = $rec;
            }
        }

        $result = array();

        foreach ($tuplesFromExecuteInfoTable as $key => $value) {

            $res = $value;
            //TODO FIXME table name should not be wrapped into [] at this spet. Need global refactoring to move wrapping table into brackets closer to the query execution
            $res->numberProcessRecords = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, "[{$value->tableName}]");

            $result[] = $res;
        }

        return $result;
    }
}

?>