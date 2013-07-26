<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class MSSQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306, $engine = "mssql") {
        parent::__construct($user, $password, $database, $host, $port, $engine);
    }

//TODO: look into this
    public function importSqlFile($filePath) {
        $dbh = new PDO("sqlsrv:Server=$this->host,$this->port;Database=master", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE [$this->database];");
        $dbh->exec("USE [$this->database]");
        $this->execImportQuery($filePath, $dbh, "/\bGO\b/i");
    }

}

?>
