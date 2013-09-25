<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class MySQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306, $engine = "mysql") {
        parent::__construct($user, $password, $database, $host, $port, $engine);
    }
    
    public function importDbSchema($filePath, $sqlDelimiter = "/;/"){

        $dbh = new PDO("mysql:host=$this->host;port=$this->port", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE IF NOT EXISTS `$this->database`;USE `$this->database`;");

        $sql_query = $this->parseSqlCommands($filePath, '/(CREATE TABLE .*;)/i', $sqlDelimiter);

        $this->execImportQuery($sql_query, $dbh);
    }

    public function importDbData($filePath, $sqlDelimiter = "/;/"){
        
        if(empty($filePath) || !file_exists($filePath)){
            throw new Exception('File not found');
        }
        
        $dbh = new PDO("mysql:host=$this->host;port=$this->port;dbname=$this->database;charset=utf8;", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $sql_query = $this->parseSqlCommands($filePath, '/(INSERT INTO .*;)/i', $sqlDelimiter);
        $this->execImportQuery($sql_query, $dbh);
    }
}

?>
