<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");

class MSSQLHandler extends DatabaseHandler {

    public function __construct($user, $password, $database, $host = 'localhost', $port = 1433) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    protected function GetConnection() {
        $pdo = new PDO("sqlsrv:host=$this->host;dbname=$this->database", $this->user, $this->password);
        return $pdo;
    }

    public function LoadTables() {
        $pdo = $this->GetConnection();

        $stmt = $pdo->prepare("SHOW TABLES FROM `$this->database`");
        $stmt->execute();

        foreach ($stmt->fetchAll() as $row) {
            $tableNames[] = $row[0];
        }
        $stmt->closeCursor();

        return $tableNames;
    }

    public function GetColumnsForSelectedTables($selectedTables) {
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

    public function GetTableData($table_name, $perPage = 10, $pageNo = 1) {
        $pdo = $this->GetConnection();

        $sql = "SELECT * FROM $table_name ";
        $startPoint = ($pageNo - 1) * $perPage;
        $sql .= " LIMIT " . $startPoint . "," . $perPage;

        $res = $pdo->query($sql);
        foreach($res->fetchAll() as $row){
            $result[] = $row;
        }
      
        return $result;
    }

    public function GetTotalNumberTuplesInTable($table_name) {
        $pdo = $this->GetConnection();
        $stmt = $pdo->prepare("SELECT COUNT(*) as ct FROM `$table_name`");
        $stmt->execute();      
        $row = $stmt->fetch(PDO::FETCH_BOTH);
        $tupleNum = (int)$row[0];
        $stmt->closeCursor();
        return $tupleNum;
    }  
}

?>
