<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/StatisticsDAO.php');

class GlobalStatEngine {

	private $statisticsDAO;

	function __construct() {
		$statisticsDAO = new StatisticsDAO();
	}

	public function GetNumberOfStories() {
		return $statisticsDAO->GetNumberOfStories();
	}

	function getNumberOfRelationships() {

	}
}

?>