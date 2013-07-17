<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");

class MySQLHandler extends DatabaseHandler {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function getConnection() {
        $pdo = new PDO("mysql:host=$this->host;port=$this->port;dbname=$this->database", $this->user, $this->password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    }
   
    public function loadTables() {
        $pdo = $this->GetConnection();

        $stmt = $pdo->prepare("SHOW TABLES FROM `$this->database`");
        $stmt->execute();

        foreach ($stmt->fetchAll() as $row) {
            $tableNames[] = $row[0];
        }
        $stmt->closeCursor();

        return $tableNames;
    }

    public function getColumnsForSelectedTables($selectedTables) {
        $pdo = $this->GetConnection();

        foreach ($selectedTables as $selectedTable) {
            $stmt = $pdo->prepare("SHOW COLUMNS FROM `$selectedTable`");
            $stmt->execute();
            foreach ($stmt->fetchAll() as $row) {
                $columns[$selectedTable][] = $row[0];
            }
        }

        return $columns;
    }

    public function getTableData($table_name, $perPage = 10, $pageNo = 1) {
        
    	return $this->prepareAndRunQuery("select * ", "`$table_name`", null, null, null, $perPage, $pageNo);
    	
    	
//     	$pdo = $this->GetConnection();

//         $sql = "SELECT * FROM `$table_name` ";
//         $startPoint = ($pageNo - 1) * $perPage;
//         $sql .= " LIMIT " . $startPoint . "," . $perPage;
      
//         $res = $pdo->query($sql);
//         $result = array();
//         while(($row = $res->fetch(PDO::FETCH_ASSOC))) {
//             $result[] = $row;
//         }

//         return $result;
    }

    public function getTotalNumberTuplesInTable($table_name) {
        $pdo = $this->GetConnection();
        $stmt = $pdo->prepare("SELECT COUNT(*) as ct FROM `$table_name`");
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_BOTH);
        $tupleNum = (int) $row[0];
        $stmt->closeCursor();
        return $tupleNum;
    }
    
    // select - valid sql select part
    // from - tableName with alias if specified
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    public function prepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo) {
    	$pdo = $this->GetConnection();
    	
    	$query = $select . " from " . $from . " ";
    	
    	if (isset($where))
    		$query .= ' ' . $where . ' ';
    	 
    	if (isset($groupby))
    		$query .= ' '. $groupby . ' ';
    	
    	if (isset($perPage) && isset($pageNo)) {
    		 
    		$startPoint = ($pageNo - 1) * $perPage;
    		$query .= " LIMIT " . $startPoint . "," . $perPage;
    	}
    	    	    	
    	$res = $pdo->query($query);
    	$result = array();
    	while(($row = $res->fetch(PDO::FETCH_ASSOC))) {
    		$result[] = $row;
    	}
    	
    	return $result;
    }

}

?>
