<?php

abstract class DatabaseHandler {

    protected $host;
    protected $port;
    protected $user;
    protected $password;
    protected $database;
    public static $importSettings = array(
        "mysql" => array('user' => 'root', 'password' => '', 'port' => 3306),
        "mssql" => array('user' => 'ExternalConnTester', 'password' => 'gz3000gz3000', 'port' => 1433),
        "postgresql" => array('user' => 'ImportTester', 'password' => 'importtester', 'port' => 5432)
    );

    public function __construct($user, $password, $database, $host, $port) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->database = $database;
        $this->password = $password;
    }

    abstract public function getConnection();

    abstract public function loadTables();

    abstract public function getColumnsForSelectedTables($selectedTables);

    abstract public function getTableData($table_name, $perPage, $pageNo);

    abstract public function getTotalNumberTuplesInTable($table_name);

}

?>
