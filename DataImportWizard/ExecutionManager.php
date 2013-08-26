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
        // create socket for calling child script
        $socketToChild = fsockopen("localhost", 80);

        $base = my_pligg_base;

        // HTTP-packet building; header first
        $msgToChild = "POST $base/DataImportWizard/execute_ktr_parallel.php?&sid=$sid&userID=$userID HTTP/1.0\n";
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
        $data = fread($socketToChild, 5000);//stream_get_contents($socketToChild);

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