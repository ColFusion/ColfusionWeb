<?php

//include_once('../config.php');
include_once(realpath(dirname(__FILE__)) . "/../config.php");
include_once('SimpleQuery.php');
include_once('ExternalDBHandlers/ExternalDBs.php');

include_once(realpath(dirname(__FILE__)) . '/QueryMakers/CheckDataMatchingQueryMaker.php');
include_once(realpath(dirname(__FILE__)) . '/QueryMakers/MergedDataSetQueryMaker.php');

include_once(realpath(dirname(__FILE__)) . '/DALUtils.php');
include_once(dirname(__FILE__) . '/../DAL/LinkedServerCred.php');
include_once(realpath(dirname(__FILE__)) . '/TransformationHandler.php');
include_once(realpath(dirname(__FILE__)) . '/RelationshipDAO.php');

require(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

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


                //var_dump($dataset->inputObj->oneSid);

                if ($dataset->inputObj->oneSid === "true" || $dataset->inputObj->oneSid === true) { //onde story

                   //var_dump($dataset->inputObj->oneSid);

                    $datasetObj = (object) array('sid' => $dataset->inputObj->sid, 'tableName' => $dataset->tableName);

                    //var_dump($datasetObj);

                    //NOTE: $select, $where and $group cannot have [] sybmols comming directly from column or table name
                    $select =  $transHandler->decodeTransformationInput($select);
                    $where =  $transHandler->decodeTransformationInput($where);
                    $groupby =  $transHandler->decodeTransformationInput($groupby);

                    return $this->prepareAndRunQuery($select, $datasetObj, $where, $groupby, $perPage, $pageNo);                
                }
                else {
                    //merged stories.
                    return $this->prepareAndRunMergedDatasetQuery($select, $dataset->inputObj, $where, $groupby, $perPage, $pageNo);
                }
            }
            else {

                //NOTE: $select, $where and $group cannot have [] sybmols comming directly from column or table name
                $select =  $transHandler->decodeTransformationInput($select);
                $where =  $transHandler->decodeTransformationInput($where);
                $groupby =  $transHandler->decodeTransformationInput($groupby);
                
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

// 		$sql = "select source_type from colfusion_sourceinfo where sid = $from";
// 		$rst = $db->get_results($sql);

        if ($this->GetSourceType($from) == "database") {

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

        //  if ($this->GetSourceType($sid) == "database") {
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

            $from = (object) array('inputObj' => $sid, 'tableName' => $sid->tableName);
            $fromArray = array($from);
            $select = "select * ";// . implode(", ", $selectAr);

            return $this->doQuery($select, $fromArray, null, null, null, null, null);      
        }
        else {
            if ($this->GetSourceType($sid) == "database") {
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
        
        if ($this->GetSourceType($from->sid) == "database") {
            $externalDBCredentials = $this->GetExternalDBCredentialsBySid($from->sid);

            $tableName = $from->tableName;

            if (isset($from->alias))
                $tableName .= ' as ' . $from->alias;

            ExternalDBs::PrepareAndRunQuery($select, $tableName, $where, $groupby, $perPage, $pageNo, $externalDBCredentials);
        } else {
            return $this->prepareAndRunQueryFromFile($select, $from, $where, $groupby, $perPage, $pageNo);
        }
    }

    function prepareAndRunQueryFromFile($select, $from, $where, $groupby, $perPage, $pageNo) {
//        var_dump($select);


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

//var_dump ($query);

        return $this->runQuerySingleSidTableFromFile($query, $from->sid, $from->tableName);
    }

    function runQuerySingleSidTableFromFile($query, $sid, $tableName) {
        global $db;
        $doJoinQuery = "call doJoinWithTime('" . $sid . "','" . mysql_real_escape_string($tableName) . "')";

//var_dump ($doJoinQuery);

        $res = $db->query($doJoinQuery);
        $rst = $db->get_results($query);

        return $rst;
    }

    function prepareAndRunMergedDatasetQuery($select, $inputObj, $where, $groupby, $perPage, $pageNo){
        $mergedDatasetQuery = new MergedDataSetQueryMaker($select, $inputObj, $where, $groupby, $perPage, $pageNo);
        
        $query = $mergedDatasetQuery->GetQuery();

        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

        $result = $MSSQLHandler->ExecuteQuery($query);

        return $result;
    }

    function GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo) {
        $from = (object) array('sid' => $sid, 'tableName' => $table_name);
        return $this->prepareAndRunQueryFromFile("SELECT * ", $from, null, null, $perPage, $pageNo);
    }

    public function GetTotalNumberTuplesInTableBySidAndName($sid, $table_name) {
        global $db;

        if ($this->GetSourceType($sid) == "database") {
            return $this->GetTotalNumberTuplesInTableBySidAndNameFromExternalDB($sid, $table_name);
        } else {
            return $this->GetTotalNumberTuplesInTableBySidAndNameFromFile($sid, $table_name);
        }
    }

    public function GetTotalNumberTuplesInTableBySidAndNameFromFile($sid, $table_name) {
        global $db;

        $res = $db->query("call doJoinWithTime('" . $sid . "','" . mysql_real_escape_string($table_name) . "')");
        $sql = "SELECT COUNT(*) FROM resultDoJoin ";
        $totalTuple = $db->get_var($sql);

        return $totalTuple;
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

    //TODO: look at timeout issue which might appear here when the realtionshp mining store procedure might take long time.
    public function MineRelationships($sid) {
        global $db;

        $relationshipDao = new RelationshipDAO();
    
        $relsForCurrentSidBeforeMining = $relationshipDao->getRelIdsForSid($sid);

        if (!isset($relsForCurrentSidBeforeMining))
            $relsForCurrentSidBeforeMining = array ();

        $res = $db->query("call doRelationshipMining('" . $sid . "')");

        $relsForCurrentSidAfterMining = $relationshipDao->getRelIdsForSid($sid);
        if (!isset($relsForCurrentSidAfterMining))
            $relsForCurrentSidAfterMining = array ();

        $diff = array_diff($relsForCurrentSidAfterMining, $relsForCurrentSidBeforeMining);

        $this->AddRelationshipsToNeo4jFromRelIdsArr($diff);

        $query = <<< EOQ
                SELECT rel.rel_id, rel.name, rel.description, rel.creator, rel.creation_time as creationTime, u. user_login as creatorLogin,
	   siFrom.sid as sidFrom, siTo.sid as sidTo,
	   siFrom.Title as titleFrom, siTo.Title as titleTo,
	   rel.tableName1 as tableNameFrom, rel.tableName2 as tableNameTo,
	   statOnVerdicts.numberOfVerdicts, statOnVerdicts.numberOfApproved, statOnVerdicts.numberOfReject,
	   statOnVerdicts.numberOfNotSure, statOnVerdicts.avgConfidence

FROM 
	colfusion_relationships as rel, 
	colfusion_users as u,		
	colfusion_sourceinfo as siFrom, 
	colfusion_sourceinfo as siTo,
	statOnVerdicts
	
where    
		rel.creator = u.user_id
		and rel.rel_id = statOnVerdicts.rel_id
		and rel.sid1 = siFrom.Sid
		and rel.sid2 = siTo.Sid		
		and (rel.sid1 = $sid or rel.sid2 = $sid)
EOQ;



        $res = $db->get_results($query);

        return $res;
    }

    public function AddRelationship($user_id, $name, $description, $from, $to, $confidence, $comment) {
        global $db;

        $sql = "INSERT INTO %srelationships (name, description, creator, creation_time, sid1, sid2, tableName1, tableName2) VALUES ('%s', '%s', %d, CURRENT_TIMESTAMP, %d, %d, '%s', '%s')";
        $sql = sprintf($sql, table_prefix, $name, $description, $user_id, $from["sid"], $to["sid"], $from["tableName"], $to["tableName"]);
        $rs = $db->query($sql);

        $rel_id = mysql_insert_id();

        $countTotal = count($from["columns"]);

        for ($i = 0; $i < $countTotal; $i++) {
            $sql = "INSERT INTO %srelationships_columns (rel_id, cl_from, cl_to) VALUES (%d, '%s', '%s')";

            $fromCol = mysql_real_escape_string($from["columns"][$i]);
            $toCol = mysql_real_escape_string($to["columns"][$i]);

            $sql = sprintf($sql, table_prefix, $rel_id, $fromCol, $toCol);
            $rs = $db->query($sql);
        }

        $sql = "INSERT INTO %suser_relationship_verdict (rel_id, user_id, confidence, comment, `when`) VALUES (%d, %d, %f, '%s', CURRENT_TIMESTAMP)";
        $sql = sprintf($sql, table_prefix, $rel_id, $user_id, $confidence, $comment);
        $rs = $db->query($sql);

        $this->AddRelationshipToNeo4J($from["sid"], $to["sid"], $rel_id, $confidence);
    }

    // TODO: move to Neo4J Handler
    public function AddRelationshipToNeo4J($sidFrom, $sidTo, $rel_id, $confidence) {
        // Connecting to the default port 7474 on localhost
        $client = new Everyman\Neo4j\Client();

        $sourceIndex = new Everyman\Neo4j\Index\NodeIndex($client, 'sources');
        
     //   var_dump($sidFrom);
     //   var_dump($sidTo);
     //   var_dump($rel_id);
     //   var_dump($confidence);

        $sourceFrom = $sourceIndex->queryOne("sid:$sidFrom");

     //   var_dump($sourceFrom);

        if (!isset($sourceFrom)) {
            $sourceFrom = $client->makeNode();
            $sourceFrom->setProperty('sid', $sidFrom)->save();
            $sourceIndex->add($sourceFrom, 'sid', $sourceFrom->getProperty('sid'));
            $sourceIndex->save();
        }

    //    var_dump($sourceFrom);

        $sourceTo = $sourceIndex->queryOne("sid:$sidTo");

    //    var_dump($sourceTo);

        if (!isset($sourceTo)) {
            $sourceTo = $client->makeNode();
            $sourceTo->setProperty('sid', $sidTo)->save();
            $sourceIndex->add($sourceTo, 'sid', $sourceTo->getProperty('sid'));
            $sourceIndex->save();
        }

      //  var_dump($sourceTo);

        if (!isset($sourceFrom) || !isset($sourceTo))
            throw new Exception("Cannot add relationship on neo4j, one of the nodes is null", 1);

        $sourceFrom->relateTo($sourceTo, 'RELATED_TO')
                    ->setProperty('rel_id', $rel_id)
                    ->setProperty('confidence', $confidence)
                    ->save();
    }

    //TODO: move to neo4j handler
    private function AddRelationshipsToNeo4jFromRelIdsArr($rel_ids) {
        if (!isset($rel_ids))
            return;

        //var_dump($rel_ids);

        $relationshipDao = new RelationshipDAO();

        foreach ($rel_ids as $key => $rel_id) {
            $relstionship = $relationshipDao->getRelationship($rel_id);
            $this->AddRelationshipToNeo4J($relstionship->fromDataset->sid, $relstionship->toDataset->sid, $rel_id, 0);
        }
    }

    public function CheckDataMatching($from, $to) {
        
        $checkDataMatchingQueryMaker = new CheckdataMatchingQueryMaker($from, $to);

        $notMatchedInFrom = $checkDataMatchingQueryMaker->getNotMachedInFromQuery();
        $notMatchedInTo = $checkDataMatchingQueryMaker->getNotMachedInToQuery();
        $countOfMached = $checkDataMatchingQueryMaker->getCountOfMached();
        $countOfTotalDistinct = $checkDataMatchingQueryMaker->getCountOfTotalDistinct();
        
        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

        $result = new stdClass;

        $result->notMatchedInFrom = $notMatchedInFrom;
        $result->notMatchedInTo = $notMatchedInTo;
        $result->countOfMached = $countOfMached;
        $result->countOfTotalDistinct = $countOfTotalDistinct;


        $columnsFrom = $checkDataMatchingQueryMaker->GetColumnsFromSource($from);
        $columnsTo = $checkDataMatchingQueryMaker->GetColumnsFromSource($to);

        $result->notMatchedInFromData = new stdClass;

        $ar = array("[", "]");
        $columnNames = str_replace($ar, "", $columnsFrom->columnNames);


        $result->notMatchedInFromData->columns = explode(",", $columnNames);
        $result->notMatchedInFromData->columnsAliases = explode(",", $columnsFrom->columnAliases);
        $result->notMatchedInFromData->rows = $MSSQLHandler->ExecuteQuery($notMatchedInFrom);

        $columnNames = str_replace($ar, "", $columnsTo->columnNames);


        $result->notMatchedInToData = new stdClass;
        $result->notMatchedInToData->columns = explode(",", $columnNames);
        $result->notMatchedInToData->columnsAliases = explode(",", $columnsTo->columnAliases);
        $result->notMatchedInToData->rows = $MSSQLHandler->ExecuteQuery($notMatchedInTo);

        $result->countOfMachedData = new stdClass;
        $result->countOfMachedData->columns = array("ct");
        $result->countOfMachedData->rows = $MSSQLHandler->ExecuteQuery($countOfMached);

        $result->countOfTotalDistinctData = new stdClass;
        $result->countOfTotalDistinctData->columns = array("ct");
        $result->countOfTotalDistinctData->rows = $MSSQLHandler->ExecuteQuery($countOfTotalDistinct);

        return $result;
    }

    // source is an object {sid:, tableName, links:[]}
    // links are columns or transformations
    // $searchTerms is an associated array where keys are the links and values are search terms for associated links.
    public function GetDistinctForColumns($source, $perPage, $pageNo, $searchTerms = null) {
   
        $from = (object) array('sid' => $source->sid, 'tableName' => $source->tableName);
        $fromArray = array($from);
    
        $transHandler = new TransformationHandler();       

        $columnNames = array();

        $whereArray = array();

        foreach ($source->links as $key=>$link) {
           
            $column = $transHandler->decodeTransformationInput($link);
            $columnNames[] = $column;

            if (isset($searchTerms)) {
                if (isset($searchTerms[$link])) {
                    $whereArray[] = " $column like '%" . $searchTerms[$link] . "%' ";
                }
            }
        }
 
        $columns = implode(",", array_values($columnNames));
       
        
        $where = null;

        if (count($whereArray) > 0)
            $where = "where " . implode(" and ", array_values($whereArray));

        $result = new stdClass;
        $result->columns = explode(",", $columns);
        $result->rows = $this->doQuery("SELECT distinct $columns", $fromArray, $where, null, null, $perPage, $pageNo);     
        $result->totalRows = $this->doQuery("SELECT COUNT(*) as ct", $fromArray, $where, null, null, null, null); 

        return $result;
    }
}

?>