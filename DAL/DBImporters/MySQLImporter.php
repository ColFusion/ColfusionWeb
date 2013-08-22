<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class MySQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306, $engine = "mysql") {
        parent::__construct($user, $password, $database, $host, $port, $engine);
    }

    public function importSqlFile($filePath) {      
        $dbh = new PDO("mysql:host=$this->host;port=$this->port", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE IF NOT EXISTS `$this->database`;USE `$this->database`;");
        $this->execImportQuery($filePath, $dbh);
    }

 }

?>
