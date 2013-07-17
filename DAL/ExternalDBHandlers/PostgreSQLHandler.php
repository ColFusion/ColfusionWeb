<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");

class PostgreSQLHandler extends DatabaseHandler {

    public function __construct($user, $password, $database, $host, $port = 5432) {
        parent::__construct($user, $password, $database, $host, $port);
    }
       
    public function getConnection() {
        $pdo = new PDO("pgsql:host=$this->host;dbname=$this->database", $this->user, $this->password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    }
   
    public function loadTables() {
        $pdo = $this->GetConnection();

        $stmt = $pdo->prepare("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';");
        $stmt->execute();

        foreach ($stmt->fetchAll() as $row) {
            $tableNames[] = $row[0];
        }
        $stmt->closeCursor();
        return $tableNames;
    }

    public function getColumnsForSelectedTables($selectedTables) {
        $pdo = $this->GetConnection();
        $stmt = $pdo->prepare("SELECT column_name FROM information_schema.columns WHERE table_name = ?");

        foreach ($selectedTables as $selectedTable) {
            $stmt->execute(array($selectedTable));
            foreach ($stmt->fetchAll() as $row) {
                $columns[$selectedTable][] = $row[0];
            }
            $stmt->closeCursor();
        }

        return $columns;
    }

    public function getTableData($table_name, $perPage = 10, $pageNo = 1) {
        $pdo = $this->GetConnection();

        $sql = "SELECT * FROM $table_name ";
        $startPoint = ($pageNo - 1) * $perPage;
        $sql .= " LIMIT " . $startPoint . " OFFSET " . $perPage;

        $res = $pdo->query($sql);
        $result = array();

        foreach ($res->fetchAll() as $row) {
            $result[] = $row;
        }
        return $result;
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
    	 
    }
}

?>
