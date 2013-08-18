<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");

class MySQLHandler extends DatabaseHandler
{
    public function __construct($user, $password, $database, $host, $port = 3306)
    {
        parent::__construct($user, $password, $database, $host, $port, 'myssql');
    }

    public function getConnection()
    {
        if (is_null($this->database))
        {
            $pdo = new PDO("mysql:host=$this->host;port=$this->port", $this->user, $this->password);
        }
        else {
            $pdo = new PDO("mysql:host=$this->host;port=$this->port;dbname=$this->database;charset=utf8;", $this->user, $this->password);
        }

        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        return $pdo;
    }

    public function loadTables()
    {
        $pdo = $this->GetConnection();

        $stmt = $pdo->prepare("SHOW TABLES FROM `$this->database`");
        $stmt->execute();

        foreach ($stmt->fetchAll() as $row) {
            $tableNames[] = $row[0];
        }
        $stmt->closeCursor();

        return $tableNames;
    }

    public function getColumnsForSelectedTables($selectedTables)
    {
        $pdo = $this->GetConnection();

        foreach ($selectedTables as $selectedTable) {
            $stmt = $pdo->prepare("SHOW COLUMNS FROM `$selectedTable`");
            $stmt->execute();
            foreach ($stmt->fetchAll() as $row) {
                $columns[$selectedTable][] = $row[0];
            }
        }

        return $columns;
    }

    public function getTableData($table_name, $perPage = 10, $pageNo = 1)
    {
        return $this->prepareAndRunQuery("select * ", "$table_name", null, null, $perPage, $pageNo);
    }

    public function getTotalNumberTuplesInTable($table_name)
    {
        
        $res = $this->prepareAndRunQuery("SELECT COUNT(*) as ct", "$table_name", null, null, null, null);

        if (is_object($res[0]))
            return $res[0]->ct;
        else
            return $res[0]["ct"];

        // $pdo = $this->GetConnection();
        // $stmt = $pdo->prepare("SELECT COUNT(*) as ct FROM `$table_name`");
        // $stmt->execute();
        // $row = $stmt->fetch(PDO::FETCH_BOTH);
        // $tupleNum = (int) $row[0];
        // $stmt->closeCursor();

        // return $tupleNum;
    }

    // select - valid sql select part
    // from - tableName with alias if specified
    // where - valid SQL where part
    // group by - valid SQL group by
    // relationships - list of realtionship which should be used. If empty, all relationships between dataset will be used
    public function prepareAndRunQuery($select, $from, $where, $groupby, $perPage, $pageNo)
    {
        //	$pdo = $this->GetConnection();

        $select = str_replace("[", "`", $select);
        $select = str_replace("]", "`", $select);

        $from = str_replace("[", "`", $from);
        $from = str_replace("]", "`", $from);

        $query = $select . " from " . $from . " ";

        if (isset($where)) {

            $where = str_replace("[", "`", $where);
            $where = str_replace("]", "`", $where);

            $query .= ' ' . $where . ' ';
        }

        if (isset($groupby)) {

            $groupby = str_replace("[", "`", $groupby);
            $groupby = str_replace("]", "`", $groupby);

            $query .= ' '. $groupby . ' ';
        }

        if (isset($perPage) && isset($pageNo)) {

            $startPoint = ($pageNo - 1) * $perPage;
            $query .= " LIMIT " . $startPoint . "," . $perPage;
        }

        //	$res = $pdo->query($query);
        //	$result = array();
        //	while (($row = $res->fetch(PDO::FETCH_ASSOC))) {
        //		$result[] = $row;
        //	}
        return $this->ExecuteQuery($query);
    }

    //TODO FIXME I think this place need reactoring, it is not efficient to loop through the whole result. Actually we can just use the same way as in MSSQL
    //but need to be carefull with refactoring, some code might be broken depending on what is returned (array or object). We need to unify it, e.g. returning
    // always array of objects.
    public function ExecuteQuery($query)
    {
        $pdo = $this->GetConnection();

        $res = $pdo->query($query);
        $result = array();
        while (($row = $res->fetch(PDO::FETCH_ASSOC))) {
            $result[] = $row;
        }

        return $result;
    }

    //TODO implement
    public function ExecuteCTASQuery($selectPart, $tableNameToCreate, $whatToInsert)
    {
    }

    /**
     * Create a database for given name is not exists yet.
     * @param  string $database name of the database
     * @return dbHandler           new dbHandler which uses newly created database
     */
    public function createDatabaseIfNotExist($database)
    {
        $pdo = $this->GetConnection();

        $pdo->exec("CREATE DATABASE IF NOT EXISTS `$database`;USE `$database`;");
        
        $this->database = $database;

        return $this;
    }

     // TODO: implement
    /**
     * Create a table for given table name if it does not exist yet. The columns of the created table are given by the columns array.
     * @param  string $tableName name of the table
     * @param  array $columns   array of stdClass which come all the way from generate ktr file. TODO need to use special class.
     * @return nothing            nothing
     * @throws PDOException If there are error runing the sql statement.
     */
    public function createTableIfNotExist($tableName, $columns)
    {
        $query = "CREATE TABLE IF NOT EXISTS `$tableName` ("; // will hold the complete create table statement.

        $columnsDefinition = array();

        foreach ($columns as $key => $column) {
            //FIXME: for now all columns are varchars, actually we could use the info provided by user abotu each column
            $columnsDefinition[] = " `{$column['originalDname']}` varchar(400) ";
        }

        $query .= implode(", ", $columnsDefinition) . " ); ";

// var_dump($columns);
        // var_dump($query);

        try {
            $pdo = $this->GetConnection();

            $pdo->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error Processing Request " . $e->getMessage(), 1);
        }
    }

}
