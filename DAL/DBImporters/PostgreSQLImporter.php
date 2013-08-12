<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class PostgreSQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 5432, $engine = "postgresql") {
        parent::__construct($user, $password, $database, $host, $port, $engine);
    }

    public function importSqlFile($filePath) {      
        $dbh = new PDO("pgsql:host={$this->host};port={$this->port};dbname=postgres", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE $this->database;");
        $dbh = new PDO("pgsql:host={$this->host};port={$this->port};dbname={$this->database}", $this->user, $this->password);
        $this->execImportQuery($filePath, $dbh);
    }

}

?>
