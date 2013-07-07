<?php

require_once realpath(dirname(__FILE__)) . '/DatabaseImporter.php';

class OracleImporter extends DatabaseImporter {

    public function __construct($user, $password, $database, $host, $port = 3306) {
        parent::__construct($user, $password, $database, $host, $port);
    }

    public function importSqlFile($filePath) {      
        
    }
}

?>
