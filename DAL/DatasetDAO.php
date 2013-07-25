<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/DatasetFinder.php';

class DatasetDAO {

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

    public function getTableColumns($sid, $tableName) {
        
        $tableName = mysql_real_escape_string($tableName);
        $allColsSql = "SELECT di.cid, sid, tableName, dname_chosen FROM `colfusion_dnameinfo` di 
            INNER JOIN `colfusion_columntableinfo` cti ON di.cid = cti.cid 
            WHERE sid = $sid AND tableName = '$tableName'";
        
        foreach($this->ezSql->get_results($allColsSql) as $row){
            $columns[$row->cid] = $row->dname_chosen;
        }
        
        return $columns;
    }

}

?>
