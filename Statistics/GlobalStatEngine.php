<?php
require_once realpath(dirname(__FILE__)) . '/../config.php';
include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/DatasetDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

require_once(realpath(dirname(__FILE__)) . '/../visualization/charts/PieChart.php');
require_once(realpath(dirname(__FILE__)) . '/../visualization/charts/ColumnChart.php');

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
		$oneRow["statistics"] = "Total Values";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "count");
			$oneRow[$columnName] = $temp;
		}
		$result[0] = $oneRow;

		$oneRow["statistics"] = "Total Distinct Values";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "distinctCount");
			$oneRow[$columnName] = $temp;
		}
		$result[1] = $oneRow;

		$oneRow["statistics"] = "Sum";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "sum");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[2] = $oneRow;

		$oneRow["statistics"] = "Maximum";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "max");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[3] = $oneRow;

		$oneRow["statistics"] = "Minimum";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "min");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[4] = $oneRow;

		$oneRow["statistics"] = "Average";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "avg");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[5] = $oneRow;

		$oneRow["statistics"] = "Standard Deviation";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "stdev");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[6] = $oneRow;

		$oneRow["statistics"] = "Median";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "med");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[7] = $oneRow;

		$oneRow["statistics"] = "Missing Values";

		foreach($columns as $cid => $columnName) {
			$temp = $this->statisticsDAO->DisplayStatisticsSummary($cid, "missing");
			if ($temp == ''){
				$temp = '--';
			}
			$oneRow[$columnName] = $temp;
		}
		$result[8] = $oneRow;

		// $row = 9;
		// $keys = array_keys($columns);
		// $values = array_values($columns);
		
		// for($i = 0; $i < sizeof($keys); $i++){
		// 	$cidi = $keys[$i];
		// 	$columnNamei = $values[$i];
		// 	$oneRow["statistics"] = "Correlation " . (string)$columnNamei;
		// 	for($j = 0; $j < sizeof($keys); $j++){
		// 		$cidj = $keys[$j];
		// 		$columnNamej = $values[$j];
		// 		$temp = $this->statisticsDAO->DisplayStatisticsSummary($cidi, (string)$cidj);
		// 		if ($temp == ''){
		// 			$temp = '--';
		// 		}
		// 		$oneRow[$columnNamej] = $temp;
		// 	}
		// 	$result[$row] = $oneRow;			
		// 	$row++;
		// }

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
		$oneRow["statistics"] = "Total Values";

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
		$oneRow["statistics"] = "Total Distinct Values";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$select = "SELECT count( DISTINCT $columnName) AS 'DistinctCount' ";
			$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
			$fromArray = array($from);
			//$where = " WHERE $cid = '1'";
        	$obj = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
			$oneRow[$columnName] = $obj[0]["DistinctCount"];

			$this->statisticsDAO->WriteStatistics($cid,$sid,"distinctCount",$oneRow[$columnName]);
		}

		
		$result[1] = $oneRow;

		// Sum tuples in each columns if can be cast into INTEGER
		$oneRow["statistics"] = "Sum";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {

			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			// if (strtoupper($cidType) == "STRING" || $cidType == "DATE"){
			// 	$oneRow[$columnName] = "--";
			// 	//continue;
			// }
			if (strtoupper($cidType) == "NUMBER") {
				$select = "SELECT ROUND(sum($columnName),2) AS 'SumValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["SumValue"];
			}

			else{
				$oneRow[$columnName] = "--";
				//continue;
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"sum",$oneRow[$columnName]);
		}

		
		$result[2] = $oneRow;

		// Get Max value in each columns
		$oneRow["statistics"] = "Maximum";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if (strtoupper($cidType) == "STRING"){
				$oneRow[$columnName] = "--";
				//continue;
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
		$oneRow["statistics"] = "Minimum";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if (strtoupper($cidType) == "STRING"){
				$oneRow[$columnName] = "--";
				//continue;
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
		$oneRow["statistics"] = "Average";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if (strtoupper($cidType) == "STRING" || $cidType == "DATE"){
				$oneRow[$columnName] = "--";
				//continue;
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

		// Calculate Standard Deviation
		$oneRow["statistics"] = "Standard Deviation";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if (strtoupper($cidType) == "STRING" || $cidType == "DATE"){
				$oneRow[$columnName] = "--";
				//continue;
			}
			else {
				$select = "SELECT ROUND(STD($columnName),2) AS 'Stdev' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				//$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $null, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["Stdev"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"stdev",$oneRow[$columnName]);
		}

		
		$result[6] = $oneRow;

		// Get Ave value in each columns
		$oneRow["statistics"] = "Median";

		$queryEngine = new QueryEngine();
		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {
			$cidType = $this->statisticsDAO->GetColumnType($cid);
			$missValue = $this->statisticsDAO->GetMissingValue($cid);
			if ($missValue == ""){
				$missValue = "-99999999";
			}
			if (strtoupper($cidType) == "STRING" || $cidType == "DATE"){
				$oneRow[$columnName] = "--";
				//continue;
			}
			else {
				$select = "SELECT ROUND(MEDIAN($columnName),2) AS 'MedValue' ";
				$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
				$fromArray = array($from);
				$where = " WHERE $columnName <> $missValue";
        		$obj = $queryEngine->doQuery($select, $fromArray, $where, null, null, null, null);
				$oneRow[$columnName] = $obj[0]["MedValue"];
			}

			$this->statisticsDAO->WriteStatistics($cid,$sid,"med",$oneRow[$columnName]);
		}

		
		$result[7] = $oneRow;

		// Get Count of Missing Values 
		$oneRow["statistics"] = "Missing Values";

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
				//continue;
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

		$result[8] = $oneRow;


		// starts correlation calculation

		$row = 9;
		$keys = array_keys($columns);
		$values = array_values($columns);
		
		for($i = 0; $i < sizeof($keys); $i++){
			$queryEngine = new QueryEngine();
			$inputObj = new stdClass();
			$inputObj->sid = $sid;
			$cidi = $keys[$i];
			$columnNamei = $values[$i];
			$cidiType = $this->statisticsDAO->GetColumnType($cidi);
			$oneRow["statistics"] = "Correlation " . $columnNamei;
			for($j = 0; $j < sizeof($keys); $j++){
				$cidj = $keys[$j];
				$columnNamej = $values[$j];
				$cidjType = $this->statisticsDAO->GetColumnType($cidj);
				if (strtoupper($cidiType) == "STRING" || $cidiType == "DATE" || strtoupper($cidjType) == "STRING" || $cidjType == "DATE"){
					$oneRow[$columnNamej] = "--";
					//continue;
				}
				else {
					$select = "SELECT ROUND(CORR($values[$i], $values[$j]),2) AS 'Correlation' ";
					$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
					$fromArray = array($from);
        			$obj = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
					$oneRow[$columnNamej] = $obj[0]["Correlation"];
					//$oneRow[$columnNamej] = "--";
				}
				$this->statisticsDAO->WriteStatistics($cidi,$sid,(string)$cidj,$oneRow[$columnNamej]);
			}
			// $result[$row] = $oneRow;
			// $row++;
		}


		
		$finishTime = date ("Y-m-d H:i:s" , mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y'))) ; 

		$this->statisticsDAO->UpdateStatisticsTime($sid,$tableName,$startTime,$finishTime);

		

		
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

	public function GetStoryCorrelationSummary($sid, $tableName){
		$datasetDAO = new DatasetDAO();
		//TODO: get cids of all column in the table by sid and tableName

		$columns = $datasetDAO->getTableColumns($sid, $tableName);

		$result = array();

		$oneRow = array();



		$row = 0;
		$keys = array_keys($columns);
		$values = array_values($columns);
		
		for($i = 0; $i < sizeof($keys); $i++){
			$queryEngine = new QueryEngine();
			$inputObj = new stdClass();
			$inputObj->sid = $sid;
			$cidi = $keys[$i];
			$columnNamei = $values[$i];
			$cidiType = $this->statisticsDAO->GetColumnType($cidi);
			$oneRow["statistics"] = "Correlation " . $columnNamei;
			for($j = 0; $j < sizeof($keys); $j++){
				$cidj = $keys[$j];
				$columnNamej = $values[$j];
				$cidjType = $this->statisticsDAO->GetColumnType($cidj);
				if (strtoupper($cidiType) == "STRING" || $cidiType == "DATE" || strtoupper($cidjType) == "STRING" || $cidjType == "DATE"){
					$oneRow[$columnNamej] = "--";
					//continue;
				}
				else {
					$select = "SELECT ROUND(CORR($values[$i], $values[$j]),2) AS 'Correlation' ";
					$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
					$fromArray = array($from);
        			$obj = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
					$oneRow[$columnNamej] = $obj[0]["Correlation"];
					//$oneRow[$columnNamej] = "--";
				}
			}
			$result[$row] = $oneRow;
			$row++;
		}
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

	function getPieChart($sid, $tableName, $columnName) {
		$datasetDAO = new DatasetDAO();

		$cid = $datasetDAO->getCidBySidTableNameColumName($sid, $tableName, $columnName);
	
		$pieChartInput = new stdClass();

		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		$inputObj->oneSid = true;
		$inputObj->tableName = $tableName;
		$inputObj->title = 'pieChart';

		$pieChartInput->inputObj = $inputObj;

		$pieChartInput->table = $tableName;

		$columnObj = new stdClass();
		$columnObj->cid = $cid;

		$pieChartInput->pieColumnCat = $columnObj;
		$pieChartInput->pieColumnAgg = $columnObj;
		$pieChartInput->pieAggType = "Count";
		$pieChartInput->where = "";

		$pieChart = new PieChart(null, null, null, null, null, null, null, null, null, null, null);	 
		$pieData = $pieChart->query($pieChartInput);
		$chartId = str_replace(".", "dot", "$sid$tableName$columnName");

       	$pieData["chartId"] = $chartId;
       	$pieData["columnName"] = $columnName;

       	// foreach ($pieData["content"] as $key => $value) {
       	// 	SAVETODB($cid, $value->Category, $value->AggValue);
       	// 	//$value["Category"], $value["AggValue"]
       	// }


       	return $pieData;
	}

	function getColumnChart($sid, $tableName, $columnName) {
		$datasetDAO = new DatasetDAO();

		$cid = $datasetDAO->getCidBySidTableNameColumName($sid, $tableName, $columnName);
	
		$columnChartInput = new stdClass();

		$inputObj = new stdClass();
		$inputObj->sid = $sid;
		$inputObj->oneSid = true;
		$inputObj->tableName = $tableName;
		$inputObj->title = 'columnChart';

		$columnChartInput->inputObj = $inputObj;

		$columnChartInput->table = $tableName;

		$columnObj = new stdClass();
		$columnObj->cid = $cid;

		$columnChartInput->columnCat = $columnObj;
		$columnChartInput->columnAgg = $columnObj;
		$columnChartInput->columnAggType = "Count";
		$columnChartInput->where = "";

		$columnChart = new ColumnChart(null, null, null, null, null, null, null, null, null, null, null);	 
		$columnData = $columnChart->query($columnChartInput);
		$chartId = str_replace(".", "dot", "$sid$tableName$columnName");

       	$columnData["chartId"] = $chartId;
       	$columnData["columnName"] = $columnName;

       	return $columnData;
	}


}

?>