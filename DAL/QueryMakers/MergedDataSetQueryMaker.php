<?php


include_once(realpath(dirname(__FILE__)) . "/FromFileQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/FromLinkedServerQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/../DALUtils.php");
include_once(realpath(dirname(__FILE__)) . '/../TransformationHandler.php');
include_once(realpath(dirname(__FILE__)) . '/../RelationshipDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../CachedQueryDAO.php');

class MergedDataSetQueryMaker {

    private $select;
    private $inputObj;
    private $where;
    private $groupby;
    private $perPage;
    private $pageNo;

    public function __construct($select, $inputObj, $where, $groupby, $perPage, $pageNo) {
      
        $this->select = $select; // either * or cid() with optional alias
        $this->inputObj = $inputObj;
        $this->where = $where;
        $this->groupby = $groupby;
        $this->perPage = $perPage;
        $this->pageNo = $pageNo;

        if ($select === "select * ") {
            $this->select = $this->replaceStartWithCids($this->select);   
        }
    }

    private function replaceStartWithCids($select) {
        $cids = array();
        foreach ($this->inputObj->allColumns as $key => $column) {
            $cids[] = "cid({$column->cid}) as [cid({$column->cid})]";
        }

        return str_replace("*", implode(",", $cids), $select);
    }

    public function GetQuery() {

        $allPartsOfQuery = $this->getAllPartsOfQuery();
        
//var_dump($allPartsOfQuery);

        $result = $this->getActualQuery($allPartsOfQuery);

        if (isset($this->perPage) && isset($this->pageNo)) {

           $result->finalQuery = $this->wrapInLimit($this->pageNo, $this->perPage, "(" . $result->finalQuery . ") as b");
        }

        return $result;
    }

    private function getActualQuery($allPartsOfQuery) {
        $cachedQueryDAO = new CachedQueryDAO();

        $fromAndWherePart = $allPartsOfQuery->fromQuery . $allPartsOfQuery->whereJoinQuery;

        $cachedQueryInfo = $cachedQueryDAO->getCacheQueryInfoByQuery($fromAndWherePart);

        if (isset($cachedQueryInfo)) {
            return $this->setActualQueryResult($allPartsOfQuery, $cachedQueryInfo);
        }
        else {
                          
            $selectPart =  MergedDataSetQueryMaker::DecodeStringWithCids($this->replaceStartWithCids("select * "));

            $cachedQueryInfo = $cachedQueryDAO->addCacheQuery($fromAndWherePart, $selectPart);

            if (isset($cachedQueryInfo)) {
                return $this->setActualQueryResult($allPartsOfQuery, $cachedQueryInfo);
            }
            else {
                throw new Exception("Error Processing Request. Could not add cached query", 1);    
            }
            
        }
    }

    private function setActualQueryResult($allPartsOfQuery, $cachedQueryInfo) {
        $result = new stdClass();

        $allPartsOfQuery->selectQuery = str_replace("].[", ".", $allPartsOfQuery->selectQuery);
        $allPartsOfQuery->groupbyQuery = str_replace("].[", ".", $allPartsOfQuery->groupbyQuery);

        $finalQuery = "{$allPartsOfQuery->selectQuery} from [{$cachedQueryInfo->database}].[dbo].[{$cachedQueryInfo->tableName}] {$allPartsOfQuery->whereUserConditions} {$allPartsOfQuery->groupbyQuery}"; 

        $serverInfo = new stdClass();
        $serverInfo->server_address = $cachedQueryInfo->server_address;
        $serverInfo->port = $cachedQueryInfo->port;
        $serverInfo->driver = $cachedQueryInfo->driver;
        $serverInfo->user_name = $cachedQueryInfo->user_name;
        $serverInfo->password = $cachedQueryInfo->password;
        $serverInfo->database = $cachedQueryInfo->database;

        $result->finalQuery = $finalQuery;
        $result->serverInfo = $serverInfo;

        return $result;
    }

    private function getAllPartsOfQuery() {
        $result = new stdClass();

        $result->selectQuery = MergedDataSetQueryMaker::DecodeStringWithCids($this->select);

        $sidsAndTablesNeeded = $this->GetAssociateArrayOfSidsAndTablesNeeded($this->inputObj->relationships);

       // var_dump($sidsAndTablesNeeded);

        $result->fromQuery = " from " . $this->GetFromPartBySidAndTableArray($sidsAndTablesNeeded);


        $result->whereJoinQuery = " where " . $this->GetWherePartFromRelationshipsArray($this->inputObj->relationships);

        $result->whereUserConditions = "";

        $result->groupbyQuery = "";

        if (isset($this->groupby)) {
            $result->groupbyQuery = MergedDataSetQueryMaker::DecodeStringWithCids($this->groupby);
        }

        return $result;
    }

    public static function DecodeStringWithCids($stringToDecode) {

       // var_dump($stringToDecode);

        $transHandler = new TransformationHandler();
        return $transHandler->decodeTransformationInputWithPrefix($stringToDecode, array("tableName", "sid"));
    }


    public function GetAssociateArrayOfSidsAndTablesNeeded($relationships) {
        $result = array();

        //var_dump($relationships);

        foreach ($relationships as $key => $relationship) {
            $result = $this->addSidAndTableToNeededArrayIfWasNotAdded($result, $relationship->sidFrom);
            $result = $this->addSidAndTableToNeededArrayIfWasNotAdded($result, $relationship->sidTo);
        }

        return $result;
    }

    private function addSidAndTableToNeededArrayIfWasNotAdded($sidsAndTablesNeeded, $source) {

        if (!$this->wasSidAndTableAddedToNeededArray($sidsAndTablesNeeded, $source->sid, $source->tableName)) {
            $newSidAndTable = new stdClass();
            $newSidAndTable->sid = $source->sid;
            $newSidAndTable->tableName = $source->tableName;

            $sidsAndTablesNeeded[] = $newSidAndTable;
        }

        return $sidsAndTablesNeeded;
    }

    private function wasSidAndTableAddedToNeededArray($sidsAndTablesNeeded, $newSid, $newTable) {
        if (count($sidsAndTablesNeeded) == 0)
            return false;


        foreach ($sidsAndTablesNeeded as $key => $sidAndTable) {
            if  ($sidAndTable->sid == $newSid && $sidAndTable->tableName == $newTable) {
                return true;
            }
        }

        return false;
    }

    public function GetFromPartBySidAndTableArray($sidsAndTables) {

        $result = array();

        foreach ($sidsAndTables as $key => $sidAndTable) {
           if (DALUtils::GetSourceType($sidAndTable->sid) == "database"){
                $result[] = $this->getFromPartAsFromDatabase($sidAndTable);
            }
            else {
                $result[] = $this->getFromPartAsFromFile($sidAndTable);
            }
        }

        return implode(",", $result);
    }

    public function GetWherePartFromRelationshipsArray($relationships) {
        $conditionsArr = array();

        foreach ($relationships as $key => $relationship) {
            $conditionsArr[] = $this->GetCondisionsByRelationship($relationship);
        }

        return implode(" and ", $conditionsArr);
    }

    public function GetCondisionsByRelationship($relationship) {
        $relstionshipDAO = new RelationshipDAO();
        $links = $relstionshipDAO->GetLinksByRelId($relationship->relId);

        $conditionsArr = array();

        foreach ($links as $key => $link) {
            $conditionsArr[] = " [{$relationship->sidFrom->tableName}{$relationship->sidFrom->sid}].[{$link->fromPart}] = [{$relationship->sidTo->tableName}{$relationship->sidTo->sid}].[{$link->toPart}] ";
        }

        return implode(" and ", $conditionsArr);
    }

    private function getFromPartAsFromDatabase($sidAndTable) {
        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = " . $sidAndTable->sid;

        $result = $db->get_row($query);

        $linkedServerName = $result->source_database;
  
        if ($result->server_address === "tycho.exp.sis.pitt.edu") {
            return " [$linkedServerName].[dbo].[{$sidAndTable->tableName}] as [{$sidAndTable->tableName}{$sidAndTable->sid}] ";
        }
        else {
            switch ($result->driver) {
                case 'mysql':
                    return " (select * from OPENQUERY([$linkedServerName], 'select * from `{$sidAndTable->tableName}`')) as [{$sidAndTable->tableName}{$sidAndTable->sid}] ";

                case 'postgresql':
                    return " (select * from OPENQUERY([$linkedServerName], 'select * from \"{$sidAndTable->tableName}\"')) as [{$sidAndTable->tableName}{$sidAndTable->sid}] ";

                case 'mssql':
                    return " [$linkedServerName]...[{$sidAndTable->tableName}] as [{$sidAndTable->tableName}{$sidAndTable->sid}] ";

                default:
                    throw new Exception("Error Processing Request. DBMS engine is not recognized", 1);
                    
                    break;
            }
            
        }
    }

    private function getFromPartAsFromFile($sidAndTable) {

        $cidsAndColumnNames = $this->getCidsAndColumnNames($sidAndTable->sid, $sidAndTable->tableName); 

        $cids = implode(",", array_keys($cidsAndColumnNames));
        $columnNames = implode("],[", array_values($cidsAndColumnNames));

        $linkedServerName = my_pligg_base_no_slash;

        $query = <<<EOQ
         (
            select *
            from
                (
                    select rownum, Dname, Value from [$linkedServerName]...colfusion_temporary where cid in ($cids)
                ) as T
            pivot
                (
                    max(T.VALUE)
                    for T.Dname in ([$columnNames])
                ) as P
        ) as [{$sidAndTable->tableName}{$sidAndTable->sid}] 
EOQ;

        return $query;
    }

    private function getCidsAndColumnNames($sid, $tableName) {
        global $db;
        
        $result = array();

        $query = "SELECT * FROM colfusion_columnTableInfo natural join colfusion_dnameinfo where sid = $sid and tableName = '$tableName'";

        $rst = $db->get_results($query);
        foreach ($rst as $row) {
            $result[$row->cid] = $row->dname_chosen;
        }

        return $result;
    }

    private function wrapInLimit($startPoint, $perPage, $table) {
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