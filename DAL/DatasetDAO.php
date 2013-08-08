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

    public function getTableNameByCid($cid) {
        
        $tableName = mysql_real_escape_string($cid);
        $query = "SELECT tableName FROM `colfusion_columnTableInfo` 
            WHERE cid = $cid";
        
       return $this->ezSql->get_row($query)->tableName;
    }

    public function getSidByCid($cid) {
        
        $tableName = mysql_real_escape_string($cid);
        $query = "SELECT sid FROM `colfusion_dnameinfo` 
            WHERE cid = $cid";
        
       return $this->ezSql->get_row($query)->sid;
    }

}

?>
