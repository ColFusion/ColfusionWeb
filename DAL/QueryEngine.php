<?php

require_once(realpath(dirname(__FILE__)) . "/../config.php");
require_once('SimpleQuery.php');
require_once('ExternalDBHandlers/ExternalDBs.php');

require_once(realpath(dirname(__FILE__)) . '/QueryMakers/MergedDataSetQueryMaker.php');

require_once(realpath(dirname(__FILE__)) . '/DALUtils.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/LinkedServerCred.php');
require_once(realpath(dirname(__FILE__)) . '/TransformationHandler.php');
require_once(realpath(dirname(__FILE__)) . '/RelationshipDAO.php');

require_once(realpath(dirname(__FILE__)) . '/Neo4JDAO.php');
require_once(realpath(dirname(__FILE__)) . '/../dataMatchChecker/DataMatcher.php');

class QueryEngine {

    public $simpleQuery;

    public function __construct() {
        $this->simpleQuery = new SimpleQuery();
    }

    // select - valid sql select part
    // from - array of following obejects {sid: , tableName: , alias: }
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    public function doQuery($select, $from, $where, $groupby, $relationships, $perPage, $pageNo) {

        //TODO: fix it, transformation should also accept sybmols in which to enclose table and column names

        $transHandler = new TransformationHandler();

        if (count($from) == 1) { // then we don't need to do any joins.

            $dataset = $from[0];
            //TODO seems like inputObj is an array. This need to be fixed

            if (is_array($dataset->inputObj)) {
                $dataset->inputObj = json_decode(json_encode($dataset->inputObj));
            }

            if (isset($dataset->inputObj->oneSid)) {
                if ($dataset->inputObj->oneSid === "true" || $dataset->inputObj->oneSid === true) { //onde story

                    $datasetObj = (object) array('sid' => $dataset->inputObj->sid, 'tableName' => $dataset->tableName);

                    //NOTE: $select, $where and $group cannot have [] sybmols comming directly from column or table name
                    $select =  $transHandler->decodeTransformationInput($select, true);
                    $where =  $transHandler->decodeTransformationInput($where, true);
                    $groupby =  $transHandler->decodeTransformationInput($groupby, true);

                    return $this->prepareAndRunQuery($select, $datasetObj, $where, $groupby, $perPage, $pageNo);
                }
                else {
                    //merged stories.
                    return $this->prepareAndRunMergedDatasetQuery($select, $dataset->inputObj, $where, $groupby, $perPage, $pageNo);
                }
            }
            else {

                //NOTE: $select, $where and $group cannot have [] sybmols comming directly from column or table name
                $select =  $transHandler->decodeTransformationInput($select, true);
                $where =  $transHandler->decodeTransformationInput($where, true);
                $groupby =  $transHandler->decodeTransformationInput($groupby, true);

                return $this->prepareAndRunQuery($select, $dataset, $where, $groupby, $perPage, $pageNo);

                //TODO: fix it, transformation should also accept sybmols in which to enclose table and column names




            }
        } else { // need to do joins
            // TODO: implement
        }
    }

    // $from is excepcted to be sid here.
    public function doQueryOld($select, $from, $where, $groupby, $limit) {

        global $db;

        if ($this->GetSourceType($from) == "data file") {

            $sql = "select * from colfusion_sourceinfo_DB where sid = $from";
            $rst = $db->get_results($sql);

            $mysqli = new mysqli($rst[0]->server_address, $rst[0]->user_name, $rst[0]->password, $rst[0]->source_database);
            if ($mysqli->connect_errno) {
                echo json_encode("Fail to connect");
            } else {
                $sql = "select distinct tableName from colfusion_columnTableInfo where cid in (SELECT cid FROM colfusion_dnameinfo where sid = $from)";
                $rst = $db->get_results($sql);

                $sql = $select . " from " . $rst[0]->tableName;

                $res = $mysqli->query($sql);

                if ($select === "SELECT COUNT(*)") {
                    for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
                        $res->data_seek($row_no);
                        $row = $res->fetch_assoc();
                        $rst = array_values($row);
                        $rst = $rst[0];
                    }
                } else {
                    for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
                        $res->data_seek($row_no);
                        $row = $res->fetch_assoc();
                        $json_array["data"][] = $row;
                    }

                    $rst = $json_array["data"];
                }
            }
        } else {
            $res = $db->query("call doJoin('" . $from . "')");

            $sql = $select . " from resultDoJoin";

            if ($select === "SELECT COUNT(*)")
                $rst = $db->get_var($sql);
            else
                $rst = $db->get_results($sql);
        }

        return $rst;
    }

    public function GetTablesList($sid) {
        global $db;

        $query = "SELECT distinct tableName FROM colfusion_columnTableInfo natural join colfusion_dnameinfo where sid = $sid";
        $rst = $db->get_results($query);

        foreach ($rst as $row) {
            if (!empty($row->tableName)) {
                $result[] = $row->tableName;
            }
        }

        return $result;
    }


    //TODO: refactor so the input is send as an objec as for visualization with oneSid atribute included
    // input can be a s simple number or as an object which comes from visualization
    public function GetTablesInfo($sid) {

        if (is_object($sid)) {
            if (isset($sid->oneSid)) {
                if ($sid->oneSid) {
                    return $this->GetTablesInfoBySid($sid->sid);
                }
                else {
                    return $this->GetTablesInfoForMergedDataset($sid);
                }
            }
            else {
                throw new Exception("Object is missing oneSid", 1);
            }
        }
        else {
            return $this->GetTablesInfoBySid($sid);
        }

    }

    public function UpdateColumnMetaData($sid,$oldname,$name,$variableValueType,$description,$variableMeasuringUnit,$variableValueFormat,$missingValue){
        global $db;
        mysql_select_db("colfusion", $con);
         $query = "UPDATE colfusion_dnameinfo SET dname_chosen='$name', dname_value_type='$variableValueType', dname_value_description='$description', dname_value_unit='$variableMeasuringUnit', dname_value_format='$variableValueFormat', missing_value='$missingValue' WHERE sid=$sid AND dname_chosen='$oldname'";
         $db->query($query);
    }



    public function GetTablesInfoForMergedDataset($mergedDataSet) {
        // for now merged databset should have all columns already, so I will return it back.

        //TODO: add table name of each column

        $result["mergedTable"] = $mergedDataSet->allColumns;

        return $result;
    }

    public function GetTablesInfoBySid($sid) {
        global $db;

        $query = "SELECT * FROM colfusion_columnTableInfo natural join colfusion_dnameinfo where sid = $sid";

        $rst = $db->get_results($query);
        foreach ($rst as $row) {
            $col = new stdClass;
            $col->cid = $row->cid;
            $col->dname_chosen = $row->dname_chosen;
            $col->dname_value_type = $row->dname_value_type;
            $col->dname_value_unit = $row->dname_value_unit;
            $col->dname_value_description = $row->dname_value_description;
            $col->dname_original_name = $row->dname_original_name;

            $tables[$row->tableName][] = $col;
        }

        return $tables;
    }



    public function GetTableDataBySidAndName($sid, $table_name, $perPage, $pageNo) {

        if (is_array($sid) || is_object($sid)) {

            if (is_array($sid)) {
                $sid = json_decode(json_encode($sid));
            }

            //TODO: refactor wrapping table name in [], it is done in several places, should be done in one place.
            $from = (object) array('inputObj' => $sid, 'tableName' => "{{$sid->tableName}]");
            $fromArray = array($from);
            $select = "select * ";// . implode(", ", $selectAr);

            return $this->doQuery($select, $fromArray, null, null, null, $perPage, $pageNo);
        }
        else {
            if ($this->GetSourceType($sid) == "data file") {
                return $this->GetTableDataBySidAndNameFromExternalDB($sid, $table_name, $perPage, $pageNo);
            } else {
                return $this->GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo);
            }
        }
    }

    function GetTableDataBySidAndNameFromExternalDB($sid, $table_name, $perPage, $pageNo) {
        $externalDBCredentials = $this->GetExternalDBCredentialsBySid($sid);
        return ExternalDBs::GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials);
    }

    // select - valid sql select part
    // from - array of following obejects {sid: , tableName: , alias: }
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    function prepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo) {

        if ($this->GetSourceType($from->sid) == "data file") {
            $externalDBCredentials = $this->GetExternalDBCredentialsBySid($from->sid);

            $tableName = $from->tableName;

            if (isset($from->alias))
                $tableName .= ' as ' . $from->alias;

            return ExternalDBs::PrepareAndRunQuery($select, $tableName, $where, $groupby, $perPage, $pageNo, $externalDBCredentials);
        } else {
            return $this->prepareAndRunQueryFromFile($select, $from, $where, $groupby, $perPage, $pageNo);
        }
    }

    function prepareAndRunQueryFromFile($select, $from, $where, $groupby, $perPage, $pageNo) {

        $select = str_replace("[", "`", $select);
        $select = str_replace("]", "`", $select);

        $query = $select;
        $query .= ' from resultDoJoin ';

        if (isset($from->alias))
            $query .= ' as `' . $from->alias . '` ';

        if (isset($where)) {

            $where = str_replace("[", "`", $where);
            $where = str_replace("]", "`", $where);

            $query .= ' ' . $where . ' ';
        }

        if (isset($groupby)) {

            $groupby = str_replace("[", "`", $groupby);
            $groupby = str_replace("]", "`", $groupby);

            $query .= ' ' . $groupby . ' ';
        }

        if (isset($perPage) && isset($pageNo)) {

            $startPoint = ($pageNo - 1) * $perPage;
            $query .= " LIMIT " . $startPoint . "," . $perPage;
        }

        return $this->runQuerySingleSidTableFromFile($query, $from->sid, $from->tableName);
    }

    function runQuerySingleSidTableFromFile($query, $sid, $tableName) {
        global $db;

        $tableName = str_replace("[", "", $tableName);
        $tableName = str_replace("]", "", $tableName);

        $doJoinQuery = "call doJoinWithTime('" . $sid . "','" . mysql_real_escape_string($tableName) . "')";

        $res = $db->query($doJoinQuery);
        $rst = $db->get_results($query);

        return $rst;
    }

    function prepareAndRunMergedDatasetQuery($select, $inputObj, $where, $groupby, $perPage, $pageNo){
        $mergedDatasetQuery = new MergedDataSetQueryMaker($select, $inputObj, $where, $groupby, $perPage, $pageNo);

        $queryInfo = $mergedDatasetQuery->GetQuery();

        $externalDBCredentials = new stdClass();

        $externalDBCredentials->driver = $queryInfo->serverInfo->driver;
        $externalDBCredentials->user_name = $queryInfo->serverInfo->user_name;
        $externalDBCredentials->password = $queryInfo->serverInfo->password;
        $externalDBCredentials->source_database = $queryInfo->serverInfo->database;
        $externalDBCredentials->server_address = $queryInfo->serverInfo->server_address;
        $externalDBCredentials->port = $queryInfo->serverInfo->port;
        $externalDBCredentials->is_local = null;
        $externalDBCredentials->linked_server_name = null;

        return ExternalDBs::ExecuteQuery($queryInfo->finalQuery, $externalDBCredentials);
    }

    function GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo) {
        $from = (object) array('sid' => $sid, 'tableName' => $table_name);
        return $this->prepareAndRunQueryFromFile("SELECT * ", $from, null, null, $perPage, $pageNo);
    }

    public function GetTotalNumberTuplesInTableBySidAndName($sid, $table_name) {
        if (is_array($sid) || is_object($sid)) {

            if (is_array($sid)) {
                $sid = json_decode(json_encode($sid));
            }

            $from = (object) array('inputObj' => $sid, 'tableName' => "[{$sid->table_name}]");
            $fromArray = array($from);
            $select = "select count(*) as ct";// . implode(", ", $selectAr);

            $result = $this->doQuery($select, $fromArray, null, null, null, null, null);

            return $result->ct;
        }
        else {
            return $this->GetTotalNumberTuplesInTableBySidAndNameFromExternalDB($sid, $table_name);
        }
    }
 
    public function GetTotalNumberTuplesInTableBySidAndNameFromExternalDB($sid, $table_name) {
        $externalDBCredentials = $this->GetExternalDBCredentialsBySid($sid);

        //TODO: implement
        return ExternalDBs::GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials);
    }

    function GetExternalDBCredentialsBySid($sid) {
        return DALUtils::GetExternalDBCredentialsBySid($sid);
    }

    function GetSourceType($sid) {
        return DALUtils::GetSourceType($sid);
    }

    function GetFileNameBySid($sid) {
        return DALUtils::GetFileNameBySid($sid);
    }

    /**
     * Mine new relationships for given sid and returns all inforamtion about all realtiosnhips for given sid.
     * Also after mining new relatiosnhips are added into neo4j and triggers background calculation of datamathcing ratios for newsly mined relationships.
     *   
     * @param [type] $sid sid of the story for which mining should be performed.
     */
    public function MineRelationships($sid) {
        $relationshipDao = new RelationshipDAO();

        // get ids of relationships which were minded (not existed before) for given sid.
        $newRelsMined = $relationshipDao->mineRelationships($sid);

//var_dump($newRelsMined);

        // if there were any new raltiosnihps mined, we need to add them to Neo4j and trigger background computation of datamatching ratios.
        if (isset($newRelsMined)) {

            // add those just mined relationships to neo4j
            $neo4JDAO = new Neo4JDAO();           
            $neo4JDAO->addRelationshipsByRelIds($newRelsMined);

            // triger background execution of data matching ration calcualtion.
//            $dataMatcher = new DataMatcher();
//            $dataMatcher->calculateDataMatchingRatios($newRelsMined);
        }

        // get info to display in Relatiosnhips table of all relationships for given sid.
        $res = $relationshipDao->getAllRelationshipInfoBySid($sid);

        return $res;
    }

    /**
     * Adds colfusion relationship between two stories. Also addes neo4j relationship and nodes if needed. And trigres backgroun computatio of datamatching ratios.
     * @param [type] $user_id     id of the user who adds new relationships.
     * @param [type] $name        name of the relationship.
     * @param [type] $description short textual description for new relationship.
     * @param [type] $from        object containing info about From dataset sid and columns of the relationships from From dataset. TODO: create a class for that object.
     * @param [type] $to          object containing info about To dataset sid and columns of the relationships from To dataset. TODO: the class class as for From should be used.
     * @param [type] $confidence  confidence value for the relationship.
     * @param [type] $comment     shor textual comment for the relationship.
     */
    public function AddRelationship($user_id, $name, $description, $from, $to, $confidence, $comment) {
        // Add new relationshp in to colfusion
        $relationshipDao = new RelationshipDAO();
        $rel_id = $relationshipDao->addRelationship($user_id, $name, $description, $from, $to, $confidence, $comment);

        // add newly created relationshiop to neo4j.
        $neo4JDAO = new Neo4JDAO();
        $neo4JDAO->addRelationshipByRelId($rel_id);

        // triger background execution of data matching ration calcualtion.
        $dataMatcher = new DataMatcher();
        $dataMatcher->calculateDataMatchingRatios(array($rel_id));
    }
}

?>