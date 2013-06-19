<?php

//TODO: make exception class for  this class and instead of doing echo and die, throw appropriate exceptions.
//TODO: close connections in test connection method.

class ExternalMySQL {
	
 	public static function TestConnection($serverName, $userName, $password, $port, $driver, $database) {
	   	  
	    if (empty($serverName) || empty($serverName)) {
	    	echo json_encode("Fail to connect.");
	    	die();
	    }
	    else {
	      	$con = ExternalMySQL::GetConnection($serverName, $userName, $password, $port, $driver, $database);
	    }

		echo json_encode("Connected successfully");	
	}
	
	public static function GetConnection($serverName, $userName, $password, $port, $database) {
	
		$mysqli = new mysqli($serverName, $userName, $password, $database);
		 
		if ($mysqli->connect_errno) {
			echo json_encode("Fail to connect");
			die();
		}
		else {
			return $mysqli;
		}
	}
	
	public static function GetConnectionFromCreds($externalDBCredentials) {
	
		return ExternalMySQL::GetConnection($externalDBCredentials->server_address, $externalDBCredentials->user_name, 
				$externalDBCredentials->password, $externalDBCredentials->port, $externalDBCredentials->source_database);
	}
	
	public static function LoadTables($serverName, $userName, $password, $port, $database) {
		$mysqli = ExternalMySQL::GetConnection($serverName, $userName, $password, $port, $database);
	
		$res = $mysqli->query("SHOW TABLES FROM $database");
	
		for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
			$res->data_seek($row_no);
			$row = $res->fetch_assoc();
			$json_array["data"][] = array_values($row);
		}
	
		return $json_array;
	}
	
	public static function GetColumnsForSelectedTables($serverName, $userName, $password, $port, $database, $selectedTables) {
		$mysqli = ExternalMySQL::GetConnection($serverName, $userName, $password, $port, $database);
		
		foreach ($selectedTables as $selectedTable) {
			$res = $mysqli->query("SHOW COLUMNS FROM $selectedTable");
			
			for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
				$res->data_seek($row_no);
				$row = $res->fetch_assoc();
				$json_array[$selectedTable][] = $row["Field"];
			}
		}
		
		return $json_array;
	}
	
	public static function GetTableDataBySidAndName($table_name, $perPage, $pageNo, $externalDBCredentials) {
		$mysqli = ExternalMySQL::GetConnectionFromCreds($externalDBCredentials);
		
		$sql = "SELECT * FROM $table_name ";
		$startPoint = ($pageNo - 1) * $perPage;
		$sql .= " LIMIT " . $startPoint . "," . $perPage;
		
		$res = $mysqli->query($sql);
		
		for ($row_no = 0; $row_no < $res->num_rows; $row_no++) {
			$res->data_seek($row_no);
			$row = $res->fetch_assoc();
			$result[] = $row;
		}
		
		return $result;
	}
	
	public static function GetTotalNumberTuplesInTableBySidAndName($table_name, $externalDBCredentials) {
		$mysqli = ExternalMySQL::GetConnectionFromCreds($externalDBCredentials);
				
		$sql = "SELECT COUNT(*) as ct FROM $table_name ";
		$res = $mysqli->query($sql);
		$row = $res->fetch_assoc();
		
		if (isset($row))
			return $row["ct"];
		else
			//TODO: throw error here
			die('Table not found');	
	}
}

?>