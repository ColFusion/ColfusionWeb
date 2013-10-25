<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/DatasetDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

class GlobalStatEngine {

	private $statisticsDAO;

	function __construct() {
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
		}

		
		$result[0] = $oneRow;

		// Count distinct tuples in each column
		$oneRow["statistics"] = "distintCount";

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
		}

		
		$result[4] = $oneRow;

		// Get Ave value in each columns
		$oneRow["statistics"] = "Avg";

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
		}

		
		$result[5] = $oneRow;

		// Get Count of Missing Values 
		$oneRow["statistics"] = "Missing";

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
		}

		
		$result[6] = $oneRow;

		
		// $result["mean"] = array("statistics" => "mean", "var1" => 10, "var2" => 11, "var3" => 12);
		// $result["stdev"] = array("statistics" => "stdev", "var1" => 20, "var2" => 21, "var3" => 22);
		// $result["count"] = array("statistics" => "count", "var1" => 100, "var2" => 101, "var3" => 102);

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