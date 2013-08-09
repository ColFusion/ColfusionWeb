<?php

abstract class DatabaseHandler {

    protected $host;
    protected $port;
    protected $user;
    protected $password;
    protected $database;
    protected $driver;

    public function __construct($user, $password, $database, $host, $port, $driver) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->database = $database;
        $this->password = $password;   
        $this->driver = $driver;
    }
    
    public function setDriver($driver){
        $this->driver = $driver;
    }

    abstract public function getConnection();

    abstract public function loadTables();

    abstract public function getColumnsForSelectedTables($selectedTables);

    abstract public function getTableData($table_name, $perPage, $pageNo);

    abstract public function getTotalNumberTuplesInTable($table_name);

    // select - valid sql select part
    // from - tableName with alias if specified
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    abstract public function prepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo);

    abstract public function ExecuteQuery($query);

    abstract public function ExecuteCTASQuery($selectPart, $tableNameToCreate, $whatToInsert);
    
    public function getDriver(){
        return $this->driver;
    }
    
    public function getPort() {
        return $this->port;
    }

    public function getHost() {
        return $this->host;
    }

    public function getUser() {
        return $this->user;
    }

    public function getDatabase() {
        return $this->database;
    }

    public function getPassword() {
        return $this->password;
    }

}

?>
