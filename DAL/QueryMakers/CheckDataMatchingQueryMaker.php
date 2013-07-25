<?php


include_once(realpath(dirname(__FILE__)) . "/FromFileQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/../DALUtils.php");
require_once realpath(dirname(__FILE__)) . '/../TransformationHandler.php';

error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
ini_set('display_errors', 1);


class CheckdataMatchingQueryMaker {

    private $from;
    private $to;

    private $fromQuery;
    private $toQuery;

    public function __construct($from, $to) {
        if (count($from->links) != count($to->links)) {
            throw new Exception("Number of links in from and to are not the same.");
        }

        $this->from = $from;
        $this->to = $to;

        $this->fromQuery = $this->prepareOneQuery($this->from);
        $this->toQuery = $this->prepareOneQuery($this->to);
    }

    function prepareOneQuery($source) {

        $columns = $this->GetColumnsFromSource($source);

        if (DALUtils::GetSourceType($source->sid) == "database"){

            return "select from database";
        }
        else {

            return FromFileQueryMaker::MakeQueryToRotateTable($columns);            
        }
    }

    public function getIntersectionQuery($forseUpdate = false) {
        if (!isset($this->fromQuery) || $forseUpdate)
            $this->prepareOneQuery($this->from);

        if (!isset($this->toQuery) || $forseUpdate)
            $this->prepareOneQuery($this->to);

        return $this->fromQuery . " intersect " . $this->toQuery;
    }

    // source has sid, links (array of cids) and table name.
    function GetColumnsFromSource($source) {
        // get string names of columns which are involved in the links
   
        $transHandler = new TransformationHandler();

        $i = 0;

        $cidsArray = array();
        $columnNamesArray = array();
        $columnNameAndAliasArray = array();

        foreach ($source->links as $key=>$link) {
            //TODO: fix, currently only one column, no transformation is supported.
            $ar = array("cid(", ")");                
            $cidsArray[] = str_replace($ar, "", $link);
            $columnName = $transHandler->decodeTransformationInput($link); // DALUtils::decodeLinkPart($link, $usedColumnNames);
            $columnNamesArray[] = "[" . $columnName . "]";
            $columnAlias = "column$i";

            if (isset($columnAlias))
                $columnNameAndAliasArray[] = "[" . $columnName . "] as '" . $columnAlias . "'";
            else
                $columnNameAndAliasArray[] = "[" . $columnName . "]";
        }

        $result = new stdClass;
        $result->cids = implode(",", array_values($cidsArray));
        $result->columnNames = implode(",", array_values($columnNamesArray));
        $result->columnNameAndAlias = implode(",", array_values($columnNameAndAliasArray));

        return $result; 
    }


/*
    public static function TestConnection($serverName, $userName, $password, $port, $driver, $database) {

        if (empty($serverName) || empty($serverName)) {
            echo json_encode("Fail to connect.");
            die();
        } else {
            $con = ExternalMSSQL::GetConnection($serverName, $userName, $password, $port, $driver, $database);
        }

        echo json_encode("Connected successfully");
    }

    public static function GetConnection($serverName, $username, $password, $port, $database) {
        try {
            $con = new PDO("dblib:dbname=$database;host=$serverName:$port", $username, $password);

            $con->setAttribute(pdo::ATTR_ERRMODE, pdo:: ERRMODE_EXCEPTION);

            $con->exec('SET QUOTED_IDENTIFIER ON');
            $con->exec('SET ANSI_WARNINGS ON');
            $con->exec('SET ANSI_PADDING ON');
            $con->exec('SET ANSI_NULLS ON');
            $con->exec('SET CONCAT_NULL_YIELDS_NULL ON');


            return $con;
        } catch (PDOException $e) {
            echo json_encode('Failed to connect to database: ' . $e->getMessage() . "\n");
            exit;
        }
    }

    public static function GetConnectionFromCreds($externalDBCredentials) {

        return ExternalMSSQL::GetConnection($externalDBCredentials->server_address, $externalDBCredentials->user_name, $externalDBCredentials->password, $externalDBCredentials->port, $externalDBCredentials->source_database);
    }

    public static function LoadTables($serverName, $userName, $password, $port, $database) {
        $mssql = ExternalMSSQL::GetConnection($serverName, $userName, $password, $port, $database);

        $query = "select table_schema, table_name from information_schema.tables";
        $res = $mssql->query($query);



        //TODO: add support for table schema. Rightnow disabled because it will mess up with options on wizard pages
        foreach ($res as $row) {
            if ($row !== NULL && $row["table_name"] !== NULL)
                $json_array["data"][] = $row["table_name"]; //$row["table_schema"].".".$row["table_name"];
        }

        return $json_array;
    }

    public static function GetColumnsForSelectedTables($serverName, $userName, $password, $port, $database, $selectedTables) {
        $mssql = ExternalMSSQL::GetConnection($serverName, $userName, $password, $port, $database);

        foreach ($selectedTables as $selectedTable) {
            $query = "select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '$selectedTable'";

            $res = $mssql->query($query);

            foreach ($res as $row) {
                $json_array[$selectedTable][] = $row["COLUMN_NAME"];
            }
        }

        return $json_array;
    }

    public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
        $mssql = ExternalMSSQL::GetConnectionFromCreds($externalDBCredentials);

        $startPoint = ($pageNo - 1) * $perPage;

        $query = ExternalMSSQL::wrapInLimit($startPoint, $perPage, $table_name);

        $stmt = $mssql->prepare($query);

        $stmt->setFetchMode(PDO::FETCH_ASSOC);

        $stmt->execute();

        $arrValues = $stmt->fetchAll();

        //TODO: get rid ot rnum column
        foreach ($arrValues as $row) {
            $result[] = $row;
        }


// 		foreach ($res as $row) {
// 			$result[] =$row;
// 		}

        return $result;
    }

    public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
        $mssql = ExternalMSSQL::GetConnectionFromCreds($externalDBCredentials);


        $sql = "SELECT COUNT(*) as ct FROM $table_name ";
        $res = $mssql->query($sql);

        foreach ($res as $row) {
            if (isset($row))
                return $row["ct"];
            else
            //TODO: throw error here
                die('Table not found');
        }
    }

    public static function GetTableDataBySidAndNameFromFile($sid, $table_name, $perPage, $pageNo) {
        $query = ExternalMSSQL::wrapInLimit($pageNo, $perPage, "(" . ExternalMSSQL::makeQueryToRotateTable($sid, $table_name, "*") . ") as b");

        return ExternalMSSQL::runQueryWithLinkedServers($query);
    }

    public static function runQueryWithLinkedServers($query) {
        try {
            $mssql = ExternalMSSQL::GetConnectionFromCreds(ExternalMSSQL::getTychoCredentials());
        } catch (PDOException $e) {
            echo $e->getMessage();
            echo "connect problem";
            exit;
        }

        try {

            $mssql->setAttribute(pdo::ATTR_ERRMODE, pdo:: ERRMODE_EXCEPTION);

            $stmt = $mssql->prepare($query);

            $stmt->setFetchMode(PDO::FETCH_ASSOC);

            $stmt->execute();

            $arrValues = $stmt->fetchAll();
        } catch (PDOException $e) {
            echo $e->getMessage();
            exit;
        }

        //TODO: get rid of rnum column
        foreach ($arrValues as $row) {
            $result[] = $row;
        }

        return $result;
    }

    public static function getJoinQuery($sids, $cols, $perPage, $pageNo) {
        global $db;

        $finalQuery = "";
        $finalQueryJoinWherePart = "";



        if (count($sids) == 1) {
            $sid = UtilsForWizard::getWordUntilFirstDot($sids[0]);
            $tableName = UtilsForWizard::stripWordUntilFirstDot($sids[0]);

            $sourceType = ExternalMSSQL::GetSourceType($sid);

            if ($sourceType == "database") {
                return ExternalMSSQL::wrapInLimit($pageNo, $perPage, $tableName);
            } else {
                $colsString = "'" . implode("','", $cols) . "'";
                $query = ExternalMSSQL::makeQueryToRotateTable($sid, $tableName, $colsString);
                $finalQuery = $query;

                return ExternalMSSQL::wrapInLimit($pageNo, $perPage, "(" . $finalQuery . ") as b");
            }
        } else {
            for ($i = 0; $i < count($sids) - 1; $i++) {
                $sidFrom = UtilsForWizard::getWordUntilFirstDot($sids[$i]);
                $tableNameFrom = UtilsForWizard::stripWordUntilFirstDot($sids[$i]);

                $sourceTypeFrom = ExternalMSSQL::GetSourceType($sidFrom);

                if ($sourceTypeFrom == "database") {

                    $colsResult = ExternalMSSQL::getAllTableNameDotColumnsBySid($sidFrom, $tableNameFrom);

                    $colsRenamed = $colsResult->colsRenamed;

                    $finalQuery .= "(select $colsRenamed from $tableNameFrom) as rot$i, ";
                } else {
                    $colsString = "'" . implode("','", $cols) . "'";
                    $query = ExternalMSSQL::makeQueryToRotateTable($sidFrom, $tableNameFrom, $colsString, $perPage, $pageNo);
                    $finalQuery .= "($query) as rot$i, ";
                }



                $sidTo = UtilsForWizard::getWordUntilFirstDot($sids[$i + 1]);
                $tableNameTo = UtilsForWizard::stripWordUntilFirstDot($sids[$i + 1]);

                $sourceTypeTo = ExternalMSSQL::GetSourceType($sidTo);

                $finalQueryJoinWherePart .= ExternalMSSQL::getWhereJoinPart($i, $sidFrom, $tableNameFrom, $sidTo, $tableNameTo, $sourceTypeFrom, $sourceTypeTo);
            }

            $sidFrom = UtilsForWizard::getWordUntilFirstDot($sids[count($sids) - 1]);
            $tableNameFrom = UtilsForWizard::stripWordUntilFirstDot($sids[count($sids) - 1]);

            $sourceType = ExternalMSSQL::GetSourceType($sidFrom);

            if ($sourceType == "database") {
                $colsResult = ExternalMSSQL::getAllTableNameDotColumnsBySid($sidFrom, $tableNameFrom);

                $colsRenamed = $colsResult->colsRenamed;

                $finalQuery .= "(select $colsRenamed from $tableNameFrom) as rot" . (count($sids) - 1);
            } else {
                $colsString = "'" . implode("','", $cols) . "'";
                $query = ExternalMSSQL::makeQueryToRotateTable($sidFrom, $tableNameFrom, $colsString, $perPage, $pageNo);
                $finalQuery .= "($query) as rot" . (count($sids) - 1);
            }

            if ($finalQueryJoinWherePart != "") {
                $finalQueryJoinWherePart = substr($finalQueryJoinWherePart, 0, -4);
            }


            $finalQuery = "select * from $finalQuery where $finalQueryJoinWherePart";

            return ExternalMSSQL::wrapInLimit($pageNo, $perPage, "(" . $finalQuery . ") as b");
        }
    }

    private static function getWhereJoinPart($i, $sidFrom, $tableNameFrom, $sidTo, $tableNameTo, $sourceTypeFrom, $sourceTypeTo) {
        global $db;

        $query = <<<EOQ
select diFrom.dname_original_name as clFrom, diTo.dname_original_name as clTo
from colfusion_relationships r, colfusion_relationships_columns rc,
colfusion_dnameinfo diFrom, colfusion_dnameinfo diTo
where 
r.rel_id = rc.rel_id
and rc.cl_from = diFrom.cid and rc.cl_to = diTo.cid 
and sid1 = $sidFrom and tableName1 = '$tableNameFrom'
and sid2 = $sidTo and tableName2 = '$tableNameTo'

union

select diFrom.dname_original_name as clFrom, diTo.dname_original_name as clTo
from colfusion_relationships r, colfusion_relationships_columns rc,
colfusion_dnameinfo diFrom, colfusion_dnameinfo diTo
where 
r.rel_id = rc.rel_id
and rc.cl_from = diFrom.cid and rc.cl_to = diTo.cid 
and sid2 = $sidFrom and tableName2 = '$tableNameFrom'
and sid1 = $sidTo and tableName1 = '$tableNameTo'		
EOQ;
        $result = "";

        $res = $db->get_results($query);

//		if ($sourceTypeFrom == "database" && $sourceTypeTo == "database") {
//			foreach ($res as $row) {
//				$result .= " rot$i.[" . $row->clFrom . "] = rot" . ($i + 1) . ".[" . $row->clTo . "] and "; 
//			}
//		}
//		else if ($sourceTypeFrom != "database" && $sourceTypeTo == "database") {
//			foreach ($res as $row) {
//				$result .= " rot$i.[" . $tableNameFrom . "." . $row->clFrom . "] = rot" . ($i + 1) . ".[" . $row->clTo . "] and "; 
//			}
//		}
//		else if ($sourceTypeFrom == "database" && $sourceTypeTo != "database") {
//			foreach ($res as $row) {
//				$result .= " rot$i.[" .$row->clFrom . "] = rot" . ($i + 1) . ".[" . $tableNameTo . "." .  $row->clTo . "] and "; 
//			}
//		}
//		else {
        foreach ($res as $row) {
            $result .= " rot$i.[" . $tableNameFrom . "." . $row->clFrom . "] = rot" . ($i + 1) . ".[" . $tableNameTo . "." . $row->clTo . "] and ";
        }
//		}

        return $result;
    }

    // copy past for now, from query engine
    private static function GetSourceType($sid) {
        global $db;

        $sql = "select source_type from colfusion_sourceinfo where sid = $sid";

        $res = $db->get_results($sql);

        if (isset($res))
            return $res[0]->source_type;
        else
        //TODO: throw error here
            die('Source not found GetSourceType');
    }

    private static function getAllTableNameDotColumnsBySid($sid, $table_name) {
        global $db;


        //	if ($dnamesToInclude == "*")
        $query = "select dname_chosen from colfusion_dnameinfo where sid = $sid and dname_chosen not in ('Spd', 'Drd', 'Location', 'AggrType', 'Start', 'End')";
        //	else {
        //		$query = "select dname_chosen from colfusion_dnameinfo where sid = $sid and dname_chosen in ($dnamesToInclude)";
        //	}
        $rst = $db->get_results($query);
        foreach ($rst as $key => $row)
            $colsArray[] = "[" . $row->dname_chosen . "]";

        foreach ($rst as $key => $row)
            $colsArrayRenamed[] = "[" . $row->dname_chosen . "] as '" . $table_name . "." . $row->dname_chosen . "'";


        $cols = implode(",", array_values($colsArray));
        $colsRenamed = implode(",", array_values($colsArrayRenamed));

        $result->originalCols = $cols;
        $result->colsRenamed = $colsRenamed;

        return $result;
    }

    // $dnamesToInclude is a string variable, if it is * means inlcude all columns, if it has column names in single quotes comma separated, then reotated table will have only those columns
    private static function makeQueryToRotateTable($sid, $table_name, $dnamesToInclude) {

        $colsResult = ExternalMSSQL::getAllTableNameDotColumnsBySid($sid, $table_name);

        $colsRenamed = $colsResult->colsRenamed;
        $cols = $colsResult->originalCols;

        $query = <<<EOQ
    select $colsRenamed
		from
		(
			select *
			from
    			(select rownum, Dname, Value from [COLFUSIONDEV]...colfusion_temporary where sid = $sid) as T
				 pivot
				(
					max(T.VALUE)
					for T.Dname in ($cols)
				) as P
		) as rot 
EOQ;

        return $query;
    }

    private static function getTychoCredentials() {
        $result->server_address = "tycho.exp.sis.pitt.edu";
        $result->user_name = "remoteUserTest";
        $result->password = "LkzRjkam.;y20!#";
        $result->port = "1433";
        $result->source_database = "Tycho_0920";

        return $result;
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


*/

}

?>