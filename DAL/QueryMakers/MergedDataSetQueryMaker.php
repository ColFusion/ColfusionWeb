<?php


include_once(realpath(dirname(__FILE__)) . "/FromFileQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/FromLinkedServerQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/../DALUtils.php");
include_once(realpath(dirname(__FILE__)) . '/../TransformationHandler.php');
include_once(realpath(dirname(__FILE__)) . '/../RelationshipDAO.php');

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
    }

    public function GetQuery() {
        $finalQuery = $this->DecodeStringWithCids($this->select);

        $sidsAndTablesNeeded = $this->GetAssociateArrayOfSidsAndTablesNeeded($this->inputObj->relationships);

       // var_dump($sidsAndTablesNeeded);

        $finalQuery .= " from " . $this->GetFromPartBySidAndTableArray($sidsAndTablesNeeded);
        $finalQuery .= " where " . $this->GetWherePartFromRelationshipsArray($this->inputObj->relationships);

         if (isset($groupby))
             $finalQuery = $this->DecodeStringWithCids($this->groupby);

        if (isset($perPage) && isset($pageNo)) {

           $finalQuery = $this->wrapInLimit($pageNo, $perPage, "(" . $finalQuery . ") as b");
        }

        return $finalQuery;
    }

    public function DecodeStringWithCids($stringToDecode) {

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
            $conditionsArr[] = " [{$relationship->sidFrom->tableName}{$relationship->sidFrom->sid}].[{$link->fromPart}] = [{$relationship->sidTo->tableName}{$relationship->sidTo->sid}.{$link->toPart}] ";
        }

        return implode(" and ", $conditionsArr);
    }

    private function getFromPartAsFromDatabase($sidAndTable) {
        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = " . $sidAndTable->sid;

        $linkedServerName = $db->get_row($query)->source_database;

        return " [$linkedServerName]...{$sidAndTable->tableName} as [{$sidAndTable->tableName}{$sidAndTable->sid}] ";
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