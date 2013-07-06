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

    public function importSqlFile($sid, $filePath) {
        $user = DatabaseHandler::$importSettings["mysql"]['user'];
        $password = DatabaseHandler::$importSettings["mysql"]['password'];
        $port = DatabaseHandler::$importSettings["mysql"]['port'];

        $dbh = new PDO("mysql:host=localhost;port=$port", $user, $password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $dbh->exec("CREATE DATABASE IF NOT EXISTS `colfusion_externalDB_$sid`;USE `colfusion_externalDB_$sid`;");
        $this->execImportQuery($sid, $filePath, $dbh);
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
        $pdo = $this->GetConnection();

        $sql = "SELECT * FROM $table_name ";
        $startPoint = ($pageNo - 1) * $perPage;
        $sql .= " LIMIT " . $startPoint . "," . $perPage;

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

}

?>
