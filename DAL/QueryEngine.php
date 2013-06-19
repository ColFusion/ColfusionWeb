<?php

//include_once('../config.php');
include_once(realpath(dirname(__FILE__)) . "/../config.php");
include_once('SimpleQuery.php');
include_once('ExternalDBHandlers/ExternalDBs.php');

class QueryEngine {

    public $simpleQuery;

    public function __construct() {
        $this->simpleQuery = new SimpleQuery();
    }

    public function doQuery($select, $from, $where, $groupby, $limit) {

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
        //   } else {
        //       return $this->GetFileNameBySid($sid);
        //   }
    }

    // Get tables and their columns' info of a sid.
    // Return data type should be:
    /*
     * [
     *      tableName =>
     *      [
     *         {
     *            cid:
     *            dname_chosen:
     *            other fields mapped to DB...
     *          }
     *      ]
     * ]
     */
    public function GetTablesInfo($sid) {
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

            $tables[$row->tableName][] = $col;
        }

        return $tables;
    }

    public function GetTableDataBySidAndName($sid, $table_name, $perPage, $pageNo) {
        global $db;

        if ($this->GetSourceType($sid) == "database") {
            return $this->GetTableDataBySidAndNameFromExternalDB($sid, $table_name, $perPage, $pageNo);
        } else {
            return $this->GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo);
        }
    }

    function GetTableDataBySidAndNameFromExternalDB($sid, $table_name, $perPage, $pageNo) {
        $externalDBCredentials = $this->GetExternalDBCredentialsBySid($sid);

        //TODO: implement
        return ExternalDBs::GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials);
    }

    function GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo) {
        if (strlen(strstr(my_base_url, 'localhost')) > 0) {
            global $db;

            $res = $db->query("call doJoinWithTime('" . $sid . "')");

            $sql = "SELECT * FROM resultDoJoin ";
            $startPoint = ($pageNo - 1) * $perPage;
            $sql .= " LIMIT " . $startPoint . "," . $perPage;

            $rst = $db->get_results($sql);
            return $rst;
        } else {
            return ExternalMSSQL::GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo);
        }
    }

    public function GetTotalNumberTuplesInTableBySidAndName($sid, $table_name) {
        global $db;

        if ($this->GetSourceType($sid) == "database") {
            return $this->GetTotalNumberTuplesInTableBySidAndNameFromExternalDB($sid, $table_name);
        } else {
            return $this->GetTotalNumberTuplesInTableBySidAndNameFromFile($sid);
        }
    }

    public function GetTotalNumberTuplesInTableBySidAndNameFromFile($sid) {
        global $db;

        $res = $db->query("call doJoinWithTime('" . $sid . "')");
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
        global $db;

        $sql = "SELECT * FROM colfusion_sourceinfo_DB where sid = $sid";
        $res = $db->get_results($sql);

        if (isset($res))
            return $res[0];
        else
        //TODO: throw error here
            die('Source not found GetExternalDBCredentialsBySid');
    }

    function GetSourceType($sid) {
        global $db;

        $sql = "select source_type from colfusion_sourceinfo where sid = $sid";

        $res = $db->get_results($sql);

        if (isset($res))
            return $res[0]->source_type;
        else
        //TODO: throw error here
            die('Source not found GetSourceType');
    }

    function GetFileNameBySid($sid) {
        global $db;

        $sql = "SELECT raw_data_path FROM colfusion_sourceinfo where sid = $sid";

        $res = $db->get_results($sql);

        if (isset($res))
            return array($res[0]->raw_data_path);
        else
        //TODO: throw error here
            die('Source not found GetFileNameBySid');
    }

    //TODO: look at timeout issue which might appear here when the realtionshp mining store procedure might take long time.
    public function MineRelationships($sid) {
        global $db;

        $res = $db->query("call doRelationshipMining('" . $sid . "')");


        $query = <<< EOQ
SELECT rel.rel_id, rel.name, rel.description, rel.creator, rel.creation_time as creationTime, u. user_login as creatorLogin,
		rc.cl_from as cidFrom, rc.cl_to as cidTo, 
		relFrom.dname_chosen as newDnameFrom, relTo.dname_chosen as newDnameTo,
		relFrom.dname_original_name as originalDnameFrom, relTo.dname_original_name as originalDnameTo,
		siFrom.sid as sidFrom, siTo.sid as sidTo,
		siFrom.Title as titleFrom, siTo.Title as titleTo,
		ctiFrom.tableName as tableNameFrom, ctiTo.tableName as tableNameTo,
		statOnVerdicts.numberOfVerdicts, statOnVerdicts.numberOfApproved, statOnVerdicts.numberOfReject,
		statOnVerdicts.numberOfNotSure, statOnVerdicts.avgConfidence

FROM colfusion_relationships as rel, colfusion_relationships_columns as rc,

	colfusion_dnameinfo as relFrom, colfusion_dnameinfo relTo, 

	colfusion_users as u,

	colfusion_columnTableInfo as ctiFrom, colfusion_columnTableInfo as ctiTo, 
		
	colfusion_sourceinfo as siFrom, colfusion_sourceinfo as siTo,

	statOnVerdicts
where 
		rel.rel_id = rc.rel_id 
		and rc.cl_from = relFrom.cid and rc.cl_to = relTo.cid      

		and rel.creator = u.user_id

		and rel.rel_id = statOnVerdicts.rel_id

		and relFrom.cid = ctiFrom.cid
		and relTo.cid = ctiTo.cid

		and relFrom.sid = siFrom.Sid
		and relTo.sid = siTo.Sid
		
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
    }

    public function CheckDataMatching($from, $to) {
        global $db;

        if ($this->GetSourceType($from["sid"]) == "database") {
            $externalDBCredentials = $this->GetExternalDBCredentialsBySid($sid);

            //TODO: implement
            $resultFrom = ExternalDBs::GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials);
        } else {
            $resultFrom = $this->GetDistinctValueForGivenColumnsFromFromFile($sid, $columns);
        }

        if ($this->GetSourceType($to["sid"]) == "database") {
            $resultTo = $this->GetDistinctValueForGivenColumnsFromExternalDB($sid, $columns);
        } else {
            $resultTo = $this->GetDistinctValueForGivenColumnsFromFromFile($sid, $columns);
        }
    }

}

?>