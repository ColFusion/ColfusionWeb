<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class OracleImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306, $engine = "oracle") {
        parent::__construct($user, $password, $database, $host, $port, $engine);
    }

    public function importSqlFile($filePath) {      
        $dbh = new PDO("oci:host=$this->host;port=$this->port;dbname=OracleDB", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        
         $dbh->exec("CREATE DATABASE $this->database;");
        $dbh = new PDO("oci:host=$this->host;port=$this->port;dbname=$this->database", $this->user, $this->password);
        $this->execImportQuery($filePath, $dbh);
    }
    
    public function importDbSchema($filePath, $sqlDelimiter = "/;/"){

        $dbh = new PDO("mysql:host=$this->host;port=$this->port", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE IF NOT EXISTS `$this->database`;USE `$this->database`;");

        $sql_query = $this->parseSqlCommands($filePath, '/(CREATE TABLE .*;)/i', $sqlDelimiter);
        $this->execImportQuery($sql_query, $dbh);
    }

    public function importDbData($filePath, $sqlDelimiter = "/;/"){

        $dbh = new PDO("mysql:host=$this->host;port=$this->port", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $sql_query = $this->parseSqlCommands($filePath, '/(INSERT INTO .*;)/i', $sqlDelimiter);
        $this->execImportQuery($sql_query, $dbh);
    }
}

?>
