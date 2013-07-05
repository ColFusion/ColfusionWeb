<?php

abstract class DatabaseHandler {

    protected $host;
    protected $port;
    protected $user;
    protected $password;
    protected $database;

    public function __construct($user, $password, $database, $host, $port) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->database = $database;
        $this->password = $password;
    }

    abstract protected function GetConnection();

    abstract public function LoadTables();

    abstract public function GetColumnsForSelectedTables($selectedTables);

    abstract public function GetTableData($table_name, $perPage, $pageNo);

    abstract public function GetTotalNumberTuplesInTable($table_name);
}

?>
