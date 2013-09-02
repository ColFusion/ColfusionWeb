<?php

include_once(realpath(dirname(__FILE__)) . "/../../config.php");
include_once(realpath(dirname(__FILE__)) . '/../../dataMatchChecker/DataMatcherLinkOnePart.php');
include_once(realpath(dirname(__FILE__)) . '/../DataMatchingCheckerDAO.php');
require_once(realpath(dirname(__FILE__)) . "/../CachedServersCred.php");
require_once(realpath(dirname(__FILE__)) . "/../ExternalDBHandlers/DatabaseHandlerFactory.php");

class FromLinkedServerQueryMaker {
   
    private $source;
    private $columnsToSelect;
    private $mssqlTableNameForCachedValues = MSSQL_RC_DB_TABLENAME;

    public function __construct(DataMatcherLinkOnePart $source, $columnsToSelect) {
       $this->source = $source;
       $this->columnsToSelect = $columnsToSelect;
    }

    // columnsToSelect - array of following objects {cid: cid,columnName: columnName, columnAlias: columnAlias}
    public function MakeQueryOneTable() {

        $wasCached = $this->checkIfWasChachedAlready();

        if (!$wasCached) {
            $this->cacheDistinctValues();
        }

        return $this->getQuery();
    }
    
    private function getQuery()
    {
        $database = MSSQL_RC_DB_DATABASE;

        $query = "select value as {$this->columnsToSelect->columnNameAndAlias} from [$database].[dbo].[$this->mssqlTableNameForCachedValues] where transformation = '{$this->source->transformation}'";

        return $query;
    }

    private function checkIfWasChachedAlready()
    {
        $dataMatchingCheckerDAO = new DataMatchingCheckerDAO();

        $execInfo = $dataMatchingCheckerDAO->getRelationshipColumnCachingExecutionInfo($this->source->transformation);

        if (!isset($execInfo)) {
            // was not cached yet
                
            $dataMatchingCheckerDAO->setStartedRelationshipColumnCaching($this->source->transformation);

            return false;
        }
        else {//TODO: move strings to dao as constants
$counter = 0;

            while ($execInfo->status == DataMatchingCheckerDAO::RelColCachExecInfoSt_InProgress) {
                sleep(10);

                $execInfo = $dataMatchingCheckerDAO->getRelationshipColumnCachingExecutionInfo($this->source->transformation);

                //TODO: add a check here if the start time is more than an hour ago, then just fail that execution
                
            //    $counter += 1;

                if ($counter > 2)
                    break;
            }

            if ($execInfo->status == DataMatchingCheckerDAO::RelColCachExecInfoSt_Success) {
                return true;
            }
            else {
                $dataMatchingCheckerDAO->setStartedRelationshipColumnCaching($this->source->transformation);

                return false;
            }
        }
    }

    private function cacheDistinctValues() {
        $queryToCleanCach = $this->prepareQueryToCleanCacheDistinctValues();
        $queryToCach = $this->prepareQueryToCacheDistinctValues();

        $dbHandler = DatabaseHandlerFactory::createDatabaseHandler("mssql", MSSQL_CQS_DB_USER, MSSQL_CQS_DB_PASSWORD, MSSQL_RC_DB_DATABASE, MSSQL_CQS_DB_HOST, MSSQL_CQS_DB_PORT);

//var_dump($queryToCleanCach, $queryToCach, $dbHandler);

        $dataMatchingCheckerDAO = new DataMatchingCheckerDAO();

        try {
            $dbHandler->ExecuteNonQuery($queryToCleanCach);

            $dbHandler->ExecuteNonQuery($queryToCach);

            $dataMatchingCheckerDAO->setSuccessRelationshipColumnCaching($this->source->transformation);
        } catch (Exception $e) {
            $dataMatchingCheckerDAO->setFailureRelationshipColumnCaching($this->source->transformation, $e->getMessage());
        }
    }

    private function prepareQueryToCleanCacheDistinctValues()
    {
        $query = "delete from {$this->mssqlTableNameForCachedValues} where transformation = '{$this->source->transformation}'";

        return $query;
    }

    private function prepareQueryToCacheDistinctValues() 
    {
        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = " . $this->source->sid;

        $result = $db->get_row($query);

        $linkedServerName = $result->source_database;

        $cids = $this->columnsToSelect->cids;
        $columnNameAndAlias = $this->columnsToSelect->columnNameAndAlias;
        $columnNames = $this->columnsToSelect->columnNames;
        
        $tableName = $this->source->tableName;

        $selectPart = " insert into {$this->mssqlTableNameForCachedValues} select distinct '{$this->source->transformation}', $columnNameAndAlias ";
        $fromParm = " from ";

        if ($result->server_address === "tycho.exp.sis.pitt.edu") {
            $fromParm .= " [$linkedServerName].[dbo].[{$tableName}] as [{$tableName}{$this->source->sid}] ";
        }
        else {
            switch ($result->driver) {
                case 'mysql':
                    $fromParm .= " (select * from OPENQUERY([$linkedServerName], 'select * from `{$tableName}`')) as [{$tableName}{$this->source->sid}] ";
                    break;

                case 'postgresql':
                    $fromParm .= " (select * from OPENQUERY([$linkedServerName], 'select * from \"{$tableName}\"')) as [{$tableName}{$this->source->sid}] ";
                    break;

                case 'mssql':
                    $fromParm .= " [$linkedServerName]...[{$tableName}] as [{$tableName}{$this->source->sid}] ";
                    break;
                    
                default:
                    throw new Exception("Error Processing Request. DBMS engine is not recognized", 1);
                    
                    break;
            }
            
        }

        return $selectPart . $fromParm;
    }

    private static function wrapInLimit($startPoint, $perPage, $table) {
        $startPoint = $startPoint - 1;
        $top = $startPoint + $perPage;

        $query = <<<EOQ
SELECT * FROM
(
    SELECT TOP $top *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum
    FROM $table
) a
WHERE rnum > $startPoint
EOQ;
        return $query;
    }




}

?>