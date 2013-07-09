<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class OracleImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function importSqlFile($filePath) {      
        $dbh = new PDO("oci:host=$this->host;port=$this->port;dbname=OracleDB", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        
         $dbh->exec("CREATE DATABASE $this->database;");
        $dbh = new PDO("oci:host=$this->host;port=$this->port;dbname=$this->database", $this->user, $this->password);
        $this->execImportQuery($filePath, $dbh);
    }
}

?>
