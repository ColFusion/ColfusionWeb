<?php

require_once(realpath(dirname(__FILE__)) .  '/../config.php');
require_once(realpath(dirname(__FILE__)) . "/../DAL/KTRExecutorDAO.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");

require_once(realpath(dirname(__FILE__)) . '/../dataMatchChecker/DataMatcherLinkOnePart.php');

/**
 * Run ktr and db import scripts in parallel.
 * TODO: probably should be moved to other place and used as a mechanism to do parallel exicutions. For example caching distinct values for column is done in parallel too.
 */
class ExecutionManager
{
    public static function callChildProcessToExectueOneKTRTransformation($sid, $userID, $ktrManager)
    {
        $script_url = my_pligg_base . '/DataImportWizard/execute_ktr_parallel.php';
        $vars = array("sid" => $sid, "userID" => $userID, "ktrManager" => serialize($ktrManager));
        
        ExecutionManager::callChildProcess($script_url, $vars);
    }

    public static function callChildProcessToImportDumpFile($sid, $userID, DatabaseHandler $dbHandler, $dumpFilePath)
    {
        $script_url = my_pligg_base . '/DataImportWizard/import_dump_parallel.php';
        $vars = array("sid" => $sid, "userID" => $userID, "dbHandler" => serialize($dbHandler), "dumpFilePath" => $dumpFilePath);
       
        ExecutionManager::callChildProcess($script_url, $vars);
    }

    //TODO: this is called from DAL, see the comment for this class above about moving this whole class into other place
    public static function callChildProcessToCacheDistinctColumnValues(DataMatcherLinkOnePart $dataMatcherLinkOnePartFrom, DataMatcherLinkOnePart $dataMatcherLinkOnePartTo)
    {
        $script_url = my_pligg_base . '/dataMatchChecker/execute_cachingDistinctColumnValues_parallel.php';
        $vars = array("dataMatcherLinkOnePartFrom" => serialize($dataMatcherLinkOnePartFrom), 'dataMatcherLinkOnePartTo' => serialize($dataMatcherLinkOnePartTo));
       
        ExecutionManager::callChildProcess($script_url, $vars);
    }

    public static function callChildProcess($script_url, $vars)
    {
        $postData = http_build_query($vars);

        // create socket for calling child script
        $socketToChild = fsockopen("localhost", 80);

        // HTTP-packet building; header first
        $msgToChild = "POST $script_url HTTP/1.0\n";
        $msgToChild .= "Host: localhost\n";

        $msgToChild .= "Content-Type: application/x-www-form-urlencoded\r\n";
        $msgToChild .= "Content-Length: ".strlen($postData)."\n\n";

        // header done, glue with data
        $msgToChild .= $postData;

        // send packet no oneself www-server - new process will be created to handle our query
        fwrite($socketToChild, $msgToChild);

        // wait and read answer from child
        $data = fread($socketToChild, 50000);
        // echo stream_get_contents($socketToChild);

//var_dump($data);

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

        if (!isset($tuplesFromExecuteInfoTable) || count($tuplesFromExecuteInfoTable) == 0) {
            $tuplesFromExecuteInfoTable = array();
            $tables = $queryEngine->GetTablesList($sid);

            // Add table into exec info.
            foreach ($tables as $key => $tableName) {
                $rec = new stdClass();
                $rec->tableName = $tableName;
                $rec->status = "end";
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

        foreach ($tuplesFromExecuteInfoTable as $i => $tupleFromExecuteInfoTable) {
           
            if($tupleFromExecuteInfoTable->status == 'end' || $tupleFromExecuteInfoTable->status == 'error'){                
                $tupleFromExecuteInfoTable->numberProcessRecords = $tupleFromExecuteInfoTable->RecordsProcessed;
            }else{                
                //TODO FIXME: table name should not be wrapped into [] at this spet. Need global refactoring to move wrapping table into brackets closer to the query execution
                $tupleFromExecuteInfoTable->numberProcessRecords = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, "[{$value->tableName}]");
            }

            $result[] = $tupleFromExecuteInfoTable;
        }

        return $result;
    }

    public static function getExecutionStatusForOneTable($sid, $tableName) {
        $res = self::getExecutionStatus($sid);

        foreach ($res as $key => $oneTableInfo) {
            if ($oneTableInfo->tableName == $tableName)
                return $oneTableInfo;
        }
    }
}

?>