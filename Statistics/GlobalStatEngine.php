<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');

class GlobalStatEngine {

	private $statisticsDAO;

	function __construct() {
		$this->statisticsDAO = new StatisticsDAO();
	}

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

}

?>