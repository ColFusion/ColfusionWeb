<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class MSSQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function importSqlFile($filePath) {
        $dbh = new PDO("sqlsrv:Server=$this->host;Database=master", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // $dbh->exec("CREATE DATABASE [$this->database];");       
        $dbh->exec("USE [$this->database]");
        $this->execImportQuery($filePath, $dbh, "/\bGO\b/i");
    }

}

?>
