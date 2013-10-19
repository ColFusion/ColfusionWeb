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
		$oneRow["statistics"] = "count";

		$queryEngine = new QueryEngine();
$inputObj = new stdClass();
			$inputObj->sid = $sid;
		foreach ($columns as $cid => $columnName) {


			$select = "SELECT count(*) AS 'CountValue' ";
			$from = (object) array('sid' => $sid, 'tableName' => "[$tableName]");	
			$fromArray = array($from);




        	$obj = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);

        	//var_dump($obj);
        	//break;
			$oneRow[$columnName] = $obj[0]["CountValue"];
		}

		
		$result[] = $oneRow;



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