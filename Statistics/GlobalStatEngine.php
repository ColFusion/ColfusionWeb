<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');

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

}

?>