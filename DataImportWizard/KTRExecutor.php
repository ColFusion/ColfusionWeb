<?php

include_once '../config.php';
require_once realpath(dirname(__FILE__)) . '/../RESTCaller/CurlCaller.php';
require_once realpath(dirname(__FILE__)) . '/../conf/ColFusion_JAVA_REST_API.php';
require_once(realpath(dirname(__FILE__)) . '/../Classes/PHPExcel.php');
require_once(realpath(dirname(__FILE__)) . "/../DAL/QueryEngine.php");
require_once(realpath(dirname(__FILE__)) . "/KTRManager.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/KTRExecutorDAO.php");

/**
 * Execute ktr transformation from KTRManager
 */
class KTRExecutor
{
    private $sid; //sid for which the data will be loaded.
    private $userId; //user id who triggered the transformation.
    private $ktrManager; //ktr manager which holds all information about the transformation.

    private $ktrExecutorDAO;

    /**
     * Sets some private variables and initialize dao.
     * @param         $sid        sid for which the data will be loaded.
     * @param         $userId     user id who triggered the transformation.
     * @param KTRManager $ktrManager ktr manager which holds all information about the transformation.
     */
    public function __construct($sid, $userId, KTRManager $ktrManager)
    {
        $this->sid = $sid;
        $this->userId = $userId;
        $this->ktrManager = $ktrManager;
        $this->ktrExecutorDAO = new KTRExecutorDAO();
    }

    /**
     * Exectue pan script with tranformation stored in ktr manager
     */
    public function execute()
    {
        $logID = $this->ktrExecutorDAO->addExecutionInfoTuple($this->sid, $this->ktrManager->getTableName(), $this->userId);

        $command = $this->getCommand($logID);

        $this->ktrExecutorDAO->updateExecutionInfoTupleCommand($logID, $command);   // loggin to db
        
        $databaseConnectionInfo = $this->createTargetDatabaseAndTable($logID);

        $this->addMetaDataAboutTargetDatabase($logID, $databaseConnectionInfo);
        
        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "in progress");  // loggin to db

        // ACTUALL PAN SCRIPT EXECUTION
        //exec($command . "2>&1", $outA, $returnVar);
        $databaseConnectionInfo = $this->ktrManager->getConnectionInfo();
     //   $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID,$this->ktrManager->getConnectionInfo()->database); 
     //   $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, $this->ktrManager->getTableName()); 
        $file = $this->ktrManager->getFilePaths(); 
        //$this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, $file[0]);

        $sheetNamesRowsColumns = array(); 
        $sheetNamesRowsColumns = $this->ktrManager->getSheetNamesRowsColumns();
        for ($i = 0; $i < count($sheetNamesRowsColumns[0]); $i++) {
            $sheetNamesRowsColumns[2][$i] = PHPExcel_Cell::columnIndexFromString($sheetNamesRowsColumns[2][$i]) . "";
        }
        $sheetNamesRowsColumnsJson = json_encode($sheetNamesRowsColumns);

        $updatedColAndStreamNames = $this->ktrManager->getColumns();
        $updatedColAndStreamNamesArray = array();
        for ($i = 0; $i < count($updatedColAndStreamNames); $i++)
        {
            array_push($updatedColAndStreamNamesArray, $updatedColAndStreamNames[$i]["originalDname"]);
        }
        $updatedColAndStreamNamesJson = json_encode($updatedColAndStreamNamesArray);
        $fileActualPath = "/RESTfulProject/REST/Submit/SaveExcelToMysql";
        $curlCaller = new CurlCaller();
        $data = array(
                "databaseName" => $this->ktrManager->getConnectionInfo()->database,
                "tableName" => $this->ktrManager->getTableName(),
                "filePath" => $file[0],
                "engine" => $databaseConnectionInfo->engine,
                "username" => $databaseConnectionInfo->username,
                "password" => $databaseConnectionInfo->password,
                "server" => $databaseConnectionInfo->server,
                "port" => $databaseConnectionInfo->port,

                "sid" => $this->sid,
                "xmlPath" => $this->ktrManager->getKtrFilePath(),
                "user_id" => $this->userId,
                "columns" => $sheetNamesRowsColumnsJson,
                "condition" => "unknown",
                "updatedColAndStreamNamesJson" => $updatedColAndStreamNamesJson,
        );

        $res = $curlCaller->CallAPI("POST", REST_HOST . ":" . REST_PORT . $fileActualPath, $data);
        if($res="sucess")
        {
            $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "pan finished");  // loggin to db

            $this->processExecutionResultMessage($logID, 0, $outA);
        }
        else
        {
            $this->processExecutionResultMessage($logID, 0, $outA);
            $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "pan error");
        }
    }

    //TODO: refactor this code. Our ktr template doesn't need sid and logid param.
    /**
     * Get the shell command to execute pan.
     * @param      $logID of the tuple in the exectueinfo table
     * @return [type] [description]
     */
    private function getCommand($logID)
    {
        $ktrFilePath = $this->ktrManager->getKtrFilePath();

        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            $locationOfPan = mnmpath . 'kettle-data-integration\\Pan_WHDV.bat';
            $command = 'cmd.exe /C ' . $locationOfPan . ' /file:"' . $ktrFilePath . '" ' . '"-param:Sid=' . $this->sid . '"' . ' "-param:Eid=' . $logID . '"';
        } else {
            $locationOfPan = mnmpath . 'kettle-data-integration/pan.sh';
            $command = 'sh ' . $locationOfPan . ' -file="' . $ktrFilePath . '" ' . '-param:Sid=' . $this->sid . ' -param:Eid=' . $logID;
        }

        return $command;
    }

    /**
     * Create if not exist target database and target table.
     * @param        $logID eid of execution info table to update status
     * @return stdClass target database connection info
     */
    private function createTargetDatabaseAndTable($logID)
    {
        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "creating database if needed");  // loggin to db

        // KTR manager has target database info.
        $databaseConnectionInfo = $this->ktrManager->getConnectionInfo();

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "creating table if needed before handler");

        $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($databaseConnectionInfo->engine, $databaseConnectionInfo->username, $databaseConnectionInfo->password, null, $databaseConnectionInfo->server, $databaseConnectionInfo->port, null, null);

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "creating table if needed after handler");

        // DATABASE
        $dbHandler = $dbHandler->createDatabaseIfNotExist($databaseConnectionInfo->database);

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "creating table if needed");    // loggin to db

        // KTR manager also has target table name and columns which that table needs to have
        $tableName = $this->ktrManager->getTableName();
        $columns = $this->ktrManager->getColumns();

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "number of columns: " . count($columns));

        // TABLE
        $dbHandler->createTableIfNotExist($tableName, $columns);

        //by this po everything went fine, so not just need to return target database connection info for future use
        return $databaseConnectionInfo;
    }

    /**
     * Add target database connection info o our database and also linked server will be created automatically.
     * @param       $logID                  eid of execution info table to update status
     * @param   stdClass $databaseConnectionInfo target database connection info
     */
    public function addMetaDataAboutTargetDatabase( $logID, $databaseConnectionInfo)
    {
        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "adding meta data about target database and creating linked server");  // loggin to db

        $queryEngine = new QueryEngine();

        $queryEngine->simpleQuery->addSourceDBInfo($this->sid, $databaseConnectionInfo->server, $databaseConnectionInfo->port, $databaseConnectionInfo->username, $databaseConnectionInfo->password, $databaseConnectionInfo->database, $databaseConnectionInfo->engine, 1, $databaseConnectionInfo->database);

        // TODO: I don't know why I do it here.
        $queryEngine->simpleQuery->setSourceTypeBySid($this->sid, 'database');
    }

    /**
     * Logs final messages to the execute info table depending on the returned value from pan execution
     * @param    $logID     eid of execution info table to update status
     * @param    $returnVar pan returned status number
     * @param  array $outA      log of pan execution
     */
    public function processExecutionResultMessage($logID,  $returnVar, $outA)
    {
        if ($returnVar != 0) {
            $num = 0;

            $this->ktrExecutorDAO->updateExecutionInfoTupleAfterPanTerminated($logID, $returnVar, mysql_real_escape_string(implode("\n", $outA)), $num, "failure");    // loggin to db
        } else {
            $lastLine = $outA[count($outA) - 1];
            preg_match("/d+\s{1}[0-9]+\s{1}l+/", $lastLine, $matches);
            $match = explode(' ', $matches[0]);
            $numProcessed = $match[1];

            $this->ktrExecutorDAO->updateExecutionInfoTupleAfterPanTerminated($logID, $returnVar, "", $numProcessed, "success");    // loggin to db
        }
    }
}
