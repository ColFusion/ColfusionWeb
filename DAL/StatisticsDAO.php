<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

class StatisticsDAO {

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

    public function GetNumberOfStories() {
        
        $sql = "SELECT count(*) as storiesNumber FROM `colfusion_sourceinfo` WHERE status = 'queued'";

        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow->storiesNumber;
    }



    public function GetNumberOfDvariables() {
        
        $sql = "SELECT count(distinct cid) as dvariables FROM `colfusion_dnameinfo` ";

        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> dvariables;
    }

    public function GetNumberOfRelationships() {
        
        $sql = "SELECT count(*) as relationshipNumber FROM `colfusion_relationships` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> relationshipNumber;
    }

    public function GetNumberOfRecords() {
        
        $sql = "SELECT sum(RecordsProcessed) as recordnumber FROM `colfusion_executeinfo` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> recordnumber;
    }

    public function GetNumberOfUsers() {
        
        $sql = "SELECT count(user_id) as usernumber FROM `colfusion_users` ";
        $countRow = $this->ezSql->get_row($sql);
        
        return $countRow-> usernumber;
    }
}

?>