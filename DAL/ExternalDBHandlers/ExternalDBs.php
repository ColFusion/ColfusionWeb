<?php

include_once("ExternalMySQL.php");
include_once("ExternalMSSQL.php");

//TODO: make exception class for  this class and instead of doing echo and die, throw appropriate exceptions.
//TODO: close connections in test connection method.

class ExternalDBs {
	
 	public static function TestConnection($serverName, $userName, $password, $port, $driver, $database) {
	   	  
	    if (empty($serverName) || empty($serverName)) {
	    	echo json_encode("Fail to connect.");
	    	die();
	    }
	    else {
	      	$con = ExternalDBs::GetConnection($serverName, $userName, $password, $port, $driver, $database);
	    }

		echo json_encode("Connected successfully");	
	}
	
	public static function GetConnection($serverName, $userName, $password, $port, $driver, $database) {
	
		switch ($driver) {
			case '0':
				return ExternalMySQL::GetConnection($serverName, $userName, $password, $port, $database);
	
			case '1':
				return ExternalMSSQL::GetConnection($serverName, $userName, $password, $port, $database);
					
			default:
				echo json_encode ('No driver selected');
				die();
		}
	}	
	
	public static function LoadDatabaseTables($serverName, $userName, $password, $port, $driver, $database) {
		// get submitted form information from dashboard.php
		 
		switch ($driver) {
			case '0':
				return ExternalMySQL::LoadTables($serverName, $userName, $password, $port, $database);
	
			case '1':
				return ExternalMSSQL::LoadTables($serverName, $userName, $password, $port, $database);
					
			default:
				echo json_encode ('No driver selected');
				die();
		}
	}
	
	public static function GetColumnsForSelectedTables($serverName, $userName, $password, $port, $driver, $database, $selectedTables) {
		
		switch ($driver) {
			case '0':
				return ExternalMySQL::GetColumnsForSelectedTables($serverName, $userName, $password, $port, $database, $selectedTables);
		
			case '1':				
				return ExternalMSSQL::GetColumnsForSelectedTables($serverName, $userName, $password, $port, $database, $selectedTables);
					
			default:
				echo json_encode ('No driver selected');
				die();
		}
	}
	
	public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
		switch ($externalDBCredentials->driver) {
			case '0':
				return ExternalMySQL::GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials);
		
			case '1':
				return ExternalMSSQL::GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials);
					
			default:
				echo json_encode ('No driver selected');
				die();
		}
	}
	
	public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
		switch ($externalDBCredentials->driver) {
			case '0':
				return ExternalMySQL::GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials);
		
			case '1':
				return ExternalMSSQL::GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials);
				
			default:
				echo json_encode ('No driver selected');
				die();
		}
	}
}

?>