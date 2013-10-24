<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

class StatisticsDAO {

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

    // Number of datasets submitted by counting tuples with "queued" status in sourceinfo table
    public function GetNumberOfStories() {
        
        $sql = "SELECT count(*) as storiesNumber FROM `colfusion_sourceinfo` WHERE status = 'queued'";

        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow->storiesNumber;
    }

    // Number of columns (distinct column names) by counting distinct tuples in dnameinfo table
    public function GetNumberOfDvariables() {
        
        $sql = "SELECT count(distinct cid) as dvariables FROM `colfusion_dnameinfo` ";

        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> dvariables;
    }

    // Number of relationships by counting tuples in relationships table
    public function GetNumberOfRelationships() {
        
        $sql = "SELECT count(*) as relationshipNumber FROM `colfusion_relationships` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> relationshipNumber;
    }

    // Number of records by summing values in execution info able, records processed column
    public function GetNumberOfRecords() {
        
        $sql = "SELECT sum(RecordsProcessed) as recordnumber FROM `colfusion_executeinfo` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> recordnumber;
    }

    // Number of users by count tuples in users table
    public function GetNumberOfUsers() {
        
        $sql = "SELECT count(user_id) as usernumber FROM `colfusion_users` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> usernumber;
    }

    // Type of each column
    public function GetColumnType($cid){
        // return the types of each column
        $sql = "SELECT dname_value_type as cidType FROM `colfusion_dnameinfo` WHERE cid = $cid ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> cidType;
    }

    // Missing Value
    public function GetMissingValue($cid){
        // return missing value 
        $sql = "SELECT missing_value as missValue FROM `colfusion_dnameinfo` WHERE cid = $cid ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> missValue;
    }
}

?>