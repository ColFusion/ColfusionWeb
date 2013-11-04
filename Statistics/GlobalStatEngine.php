<?php
require_once realpath(dirname(__FILE__)) . '/../config.php';
include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/DatasetDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

class GlobalStatEngine {

	private $statisticsDAO;

	function __construct() {
		global $db;
		$this->statisticsDAO = new StatisticsDAO();
	}

	// call functions from statisticsDAO
	public function GetNumberOfStories() {
		return $this->statisticsDAO->GetNumberOfStories();
	}

	public function GetNumberOfDvariables() {
		return $this->statisticsDAO->GetNumberOfDvariables();
	}

	public function GetNumberOfRelationships() {
        return  $this->statisticsDAO->GetNumberOfRelationships();
    }

    public function GetNumberOfRecords() {
        return  $this->statisticsDAO->GetNumberOfRecords();

    }

    public function GetNumberOfUsers() {
		return  $this->statisticsDAO->GetNumberOfUsers();

	}
// for side bar
	public function GetGlobalStatisticsSummary() {
    
	    $result = new stdClass();
	    // returned value from Engine, saved into variables in result
	    $result->numberOfStories = $this->GetNumberOfStories();
	    $result->numberOfDvariables = $this->GetNumberOfDvariables();
	    $result->numberOfRelationships = $this->GetNumberOfRelationships();
	    $result->numberOfRecords = $this->GetNumberOfRecords();
	    $result->numberOfUsers = $this->GetNumberOfUsers();

	    return $result;
	}

	// check if statistics already being calculated in colfusion database
	public function CheckStartTime($sid,$tableName){
		
		return $this->statisticsDAO->CheckStartTime($sid, $tableName);
	}

	// check if statistics already exist in colfusion database
	public function CheckFinishTime($sid,$tableName){
		
		return $this->statisticsDAO->CheckFinishTime($sid, $tableName);
	}

	// Display statistics in database
	public function DisplayStatisticsSummary($sid, $tableName){

		$datasetDAO = new DatasetDAO();

		$columns = $datasetDAO->getTableColumns($sid, $tableName);

		$oneRow = array();
		$result = array();
		$oneRow["statistics"] = "count";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "count");
			$oneRow[$columnName] = $temp;
		}
		$result[0] = $oneRow;

		$oneRow["statistics"] = "distinctCount";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "distinctCount");
			$oneRow[$columnName] = $temp;
		}
		$result[1] = $oneRow;

		$oneRow["statistics"] = "sum";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "sum");
			$oneRow[$columnName] = $temp;
		}
		$result[2] = $oneRow;

		$oneRow["statistics"] = "max";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "max");
			$oneRow[$columnName] = $temp;
		}
		$result[3] = $oneRow;

		$oneRow["statistics"] = "min";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "min");
			$oneRow[$columnName] = $temp;
		}
		$result[4] = $oneRow;

		$oneRow["statistics"] = "avg";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "avg");
			$oneRow[$columnName] = $temp;
		}
		$result[5] = $oneRow;

		$oneRow["statistics"] = "missing";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "missing");
			$oneRow[$columnName] = $temp;
		}
		$result[6] = $oneRow;

		$columns = NULL;
	    foreach ($result as $r) {
	        $json_array["data"][] = $r;
	        if ($columns === NULL) {
	            if (is_array($r))
	                $columns = implode(",", array_keys($r));
	            else
	                $columns = implode(",", array_keys(get_object_vars($r)));
	        }
	    }

	    $json_array["Control"]["cols"] = $columns;
    
		return $json_array;

	}

	/**
	 * [GetStoryStatisticsSummary description]
	 * @param [type] $sid       [description]
	 * @param [type] $tableName [description]
	 */
	public function GetStoryStatisticsSummary($sid, $tableName){

		$datasetDAO = new DatasetDAO();
		//TODO: get cids of all column in the table by sid and tableName

		$columns = $datasetDAO->getTableColumns($sid, $tableName);

		$result = array();

		$oneRow = array();

	    $startTime = date ("Y-m-d H:i:s" , mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y'))) ; 
	    $this->statisticsDAO->WriteStatisticsTime($sid,$tableName,$startTime, null);

		// Count tuples in each column
		$oneRow["statistics"] = "count";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$select = "SELECT count($columnName) AS 'CountValue' ";
			$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
			$fromArray = array($from);
        	$obj = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
			$oneRow[$columnName] = $obj[0]["CountValue"];

			$this->statisticsDAO->WriteStatistics($cid,$sid,"count",$oneRow[$columnName]);
		}

		

		$result[0] = $oneRow;

		// Count distinct tuples in each column
		$oneRow["statistics"] = "distinctCount";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$select = "SELECT count( DISTINCT $columnName) AS 'DistinctCount' ";
			$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
			$fromArray = array($from);
			//$where = " WHERE $cid = '1'";
        	$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
			$oneRow[$columnName] = $obj[0]["DistinctCount"];

			$this->statisticsDAO->WriteStatistics($cid,$sid,"distinctCount",$oneRow[$columnName]);
		}

		
		$result[1] = $oneRow;

		// Sum tuples in each columns if can be cast into INTEGER
		$oneRow["statistics"] = "sum";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {

			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if ($cidType == "STRING" || $cidType == "DATE"){
				$oneRow[$columnName] = "--";
				continue;
			}
			else {
				$select = "SELECT ROUND(sum($columnName),2) AS 'SumValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["SumValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"sum",$oneRow[$columnName]);
		}

		
		$result[2] = $oneRow;

		// Get Max value in each columns
		$oneRow["statistics"] = "max";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if ($cidType == "STRING"){
				$oneRow[$columnName] = "--";
				continue;
			}
			else {
				$select = "SELECT MAX($columnName) AS 'MaxValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["MaxValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"max",$oneRow[$columnName]);
		}

		
		$result[3] = $oneRow;

		// Get Min value in each columns
		$oneRow["statistics"] = "min";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if ($cidType == "STRING"){
				$oneRow[$columnName] = "--";
				continue;
			}
			else {
				$select = "SELECT MIN($columnName) AS 'MinValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["MinValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"min",$oneRow[$columnName]);
		}

		
		$result[4] = $oneRow;

		// Get Ave value in each columns
		$oneRow["statistics"] = "avg";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if ($cidType == "STRING" || $cidType == "DATE"){
				$oneRow[$columnName] = "--";
				continue;
			}
			else {
				$select = "SELECT ROUND(AVG($columnName),2) AS 'AvgValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["AvgValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"avg",$oneRow[$columnName]);
		}

		
		$result[5] = $oneRow;

		// Get Count of Missing Values 
		$oneRow["statistics"] = "missing";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			//$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if ($missValue == ""){
				$oneRow[$columnName] = "--";
				continue;
			}
			else {
				$select = "SELECT count($columnName) AS 'MissValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName = $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["MissValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"missing",$oneRow[$columnName]);
		}

		
		$finishTime = date ("Y-m-d H:i:s" , mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y'))) ; 

		$this->statisticsDAO->UpdateStatisticsTime($sid,$tableName,$startTime,$finishTime);

		$result[6] = $oneRow;

		
		// write to database
//		foreach ($result as $values)


	    $columns = NULL;
	    foreach ($result as $r) {
	        $json_array["data"][] = $r;
	        if ($columns === NULL) {
	            if (is_array($r))
	                $columns = implode(",", array_keys($r));
	            else
	                $columns = implode(",", array_keys(get_object_vars($r)));
	        }
	    }

	    $json_array["Control"]["cols"] = $columns;
    
		return $json_array;
	}

}

?>