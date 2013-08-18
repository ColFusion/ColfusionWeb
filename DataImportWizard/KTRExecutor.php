<?php

include_once '../config.php';

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
        
        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "executing pan");  // loggin to db

        // ACTUALL PAN SCRIPT EXECUTION
        exec($command, $outA, $returnVar);

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "pan finished");  // loggin to db

        $this->processExecutionResultMessage($logID, $returnVar, $outA);
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

        $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($databaseConnectionInfo->engine, $databaseConnectionInfo->username, $databaseConnectionInfo->password, null, $databaseConnectionInfo->server, $databaseConnectionInfo->port);

        // DATABASE
        $dbHandler = $dbHandler->createDatabaseIfNotExist($databaseConnectionInfo->database);

        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "creating table if needed");    // loggin to db

        // KTR manager also has target table name and columns which that table needs to have
        $tableName = $this->ktrManager->getTableName();
        $columns = $this->ktrManager->getColumns();

        // TABLE
        $dbHandler->createTableIfNotExist($tableName, $columns);

        //by this po everything went fine, so not just need to return target database connection info for future use
        return $databaseConnectionInfo;
    }

    /**
     * Add target database connection info o our database and also linked server will be created automatically.
     * @param       $logID                  eid of execution info table to update status
     * @param stdClass $databaseConnectionInfo target database connection info
     */
    public function addMetaDataAboutTargetDatabase( $logID, $databaseConnectionInfo)
    {
        $this->ktrExecutorDAO->updateExecutionInfoTupleStatus($logID, "adding meta data about target database and creating linked server");  // loggin to db

        $queryEngine = new QueryEngine();

        $queryEngine->simpleQuery->addSourceDBInfo($this->sid, $databaseConnectionInfo->server, $databaseConnectionInfo->port, $databaseConnectionInfo->username, $databaseConnectionInfo->password, $databaseConnectionInfo->database, $databaseConnectionInfo->engine);

        // TODO: I don't know why I do it here.
        $queryEngine->simpleQuery->setSourceTypeBySid($this->sid, 'database');
    }

    /**
     * Logs final messages to the execute info table depending on the returned value from pan execution
     * @param    $logID     eid of execution info table to update status
     * @param    $returnVar pan returned status number
     * @param array $outA      log of pan execution
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

    /**
     * Returns execution status with additional information like how many records were processed.
     * @param   $sid sid of the story
     * @return stdClass      info about the status
     */
    public static function getExecutionStatus($sid)
    {
        $ktrExecutorDAO = new KTRExecutorDAO();

        $tuplesFromExecuteInfoTable = $ktrExecutorDAO->getTuplesBySid($sid);

        if (!isset($tuplesFromExecuteInfoTable) || count($tuplesFromExecuteInfoTable) == 0)
            return "success";

        $result = array();

        $queryEngine = new QueryEngine();

        foreach ($tuplesFromExecuteInfoTable as $key => $value) {

            $res = $value;

            $res->numberProcessRecords = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, $value->tableName);

            $result[] = $res;
        }

        return $result;
    }
}