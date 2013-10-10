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
}

?>