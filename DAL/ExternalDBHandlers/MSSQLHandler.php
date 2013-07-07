<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");

class MSSQLHandler extends DatabaseHandler {

    public function __construct($user, $password, $database, $host, $port = 1433) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function getConnection() {
        $pdo = new PDO("sqlsrv:host=$this->host;dbname=$this->database", $this->user, $this->password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $con->exec('SET QUOTED_IDENTIFIER ON');
        $con->exec('SET ANSI_WARNINGS ON');
        $con->exec('SET ANSI_PADDING ON');
        $con->exec('SET ANSI_NULLS ON');
        $con->exec('SET CONCAT_NULL_YIELDS_NULL ON');
        return $pdo;
    }

    public function importSqlFile($sid, $filePath) {
        ;
    }

    public function loadTables() {
        $pdo = $this->GetConnection();

        $stmt = $pdo->prepare("select table_schema, table_name from information_schema.tables");
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
            $stmt = $pdo->prepare("select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = ?");
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

        $sql = $this->wrapInLimit($pageNo, $perPage, $table_name);

        $res = $pdo->query($sql);
        foreach ($res->fetchAll() as $row) {
            $result[] = $row;
        }

        return $result;
    }

    private function wrapInLimit($startPoint, $perPage, $table) {
        $startPoint = $startPoint - 1;
        $top = $startPoint + $perPage;

        $query = <<<EOQ
SELECT * FROM
(
    SELECT TOP $top *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum
    FROM $table
) a
WHERE rnum > $startPoint
EOQ;
        return $query;
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