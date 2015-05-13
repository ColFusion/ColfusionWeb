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
            INNER JOIN `colfusion_columnTableInfo` cti ON di.cid = cti.cid 
            WHERE sid = $sid AND tableName = '$tableName'";
        
        foreach($this->ezSql->get_results($allColsSql) as $row){
            $columns[$row->cid] = $row->dname_chosen;
        }
        
        return $columns;
    }

    public function getCidBySidTableNameColumName($sid, $tableName, $columnName) {
        
        $tableName = mysql_real_escape_string($tableName);
        $columnName = mysql_real_escape_string($columnName);
        $query = "SELECT di.cid as cid FROM `colfusion_dnameinfo` di 
            INNER JOIN `colfusion_columnTableInfo` cti ON di.cid = cti.cid 
            WHERE sid = $sid AND tableName = '$tableName' AND dname_chosen = '$columnName'";

        return $this->ezSql->get_row($query)->cid;
    }

    public function getTableNameByCid($cid) {
        
        $tableName = mysql_real_escape_string($cid);
        $query = "SELECT tableName FROM `colfusion_columnTableInfo` 
            WHERE cid = $cid";
        
       return $this->ezSql->get_row($query)->tableName;
    }

    public function getSidByCid($cid) {
        
        $cid = mysql_real_escape_string($cid);
        $query = "SELECT sid FROM `colfusion_dnameinfo` 
            WHERE cid = $cid";
        
        return $this->ezSql->get_row($query)->sid;
    }

    public function GetColumnsSourceInfo($cid) {
        $cid = mysql_real_escape_string($cid);
        $query = "SELECT si.* FROM colfusion_dnameinfo as di join colfusion_sourceinfo as si on di.sid = si.sid 
            WHERE cid = $cid";
        
        return $this->ezSql->get_row($query);
    }

    public function saveProvenanceXML($sid, $provenance) {

        $provenance = mysql_real_escape_string($provenance);

        $query = "UPDATE colfusion_sourceinfo set provenance = '$provenance' where sid = $sid";
        //$query = "INSERT INTO colfusion_sourceinfo(sid,provenance) VALUES ($sid,'$provenance')";
        
//var_dump($query);

        $this->ezSql->query($query);
    }
}

?>
