<?php

class MySQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function importSqlFile($sid, $filePath) {      
        $dbh = new PDO("mysql:host=$this->localhost;port=$this->port", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE IF NOT EXISTS `colfusion_externalDB_$sid`;USE `colfusion_externalDB_$sid`;");
        $this->execImportQuery($sid, $filePath, $dbh);
    }

}

?>
