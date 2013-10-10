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

	function getNumberOfRelationships() {

	}
}

?>