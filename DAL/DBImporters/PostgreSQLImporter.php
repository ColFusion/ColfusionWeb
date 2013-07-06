<?php

class PostgreSQLImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function importSqlFile($sid, $filePath) {
        $user = DatabaseHandler::$importSettings["postgresql"]['user'];
        $password = DatabaseHandler::$importSettings["postgresql"]['password'];
        $port = DatabaseHandler::$importSettings["postgresql"]['port'];

        $dbh = new PDO("pgsql:host=$this->localhost;port=$this->port;dbname=postgres", $this->user, $this->password);
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $dbh->exec("CREATE DATABASE colfusion_externalDB_$sid;");
        $dbh = new PDO("pgsql:host=localhost;port=$port;dbname=colfusion_externaldb_$sid", $user, $password);
        $this->execImportQuery($sid, $filePath, $dbh);
    }

}

?>
