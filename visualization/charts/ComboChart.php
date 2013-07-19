<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class ComboChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query(null);
    }
    function query($_datainfo){
        /*
         * Here implement the query code;
         */
        
        if($_datainfo == null){
            $_datainfo = $this->datainfo;
            $temp;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
        }else{
            $temp;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
            $this->datainfo = $_datainfo;
        }
	$sid = $_datainfo->sid;
        $table = $_datainfo->table;
	$comboColumnCat = $_datainfo->comboColumnCat;
	$comboColumnAgg = $_datainfo->comboColumnAgg;
        $comboAggType = $_datainfo->comboAggType;
        $from = (object) array('sid' => $sid, 'tableName' => $table);
        $fromArray = array($from);	
	$select = "SELECT `" . $comboColumnCat . "` AS 'Category', ";
	$select .= "MAX(`" . $comboColumnAgg . "`) AS 'MAX', ";
	$select .= "AVG(`" . $comboColumnAgg . "`) AS 'AVG', ";
	$select .= "MIN(`" . $comboColumnAgg . "`) AS 'MIN' ";			
	$groupby .= " GROUP BY `" . $comboColumnCat . "` ";
        $queryEngine = new QueryEngine();
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, $groupby, null, null, null);
        //rst['content'] =  json_decode('[{"Category":"aaa","AVG":"13","MAX":"18","MIN":"12"},{"Category":"bbb","AVG":"14","MAX":"16","MIN":"11"},{"Category":"ccc","AVG":"10","MAX":"14","MIN":"6"},{"Category":"ddd","AVG":"43","MAX":"45","MIN":"14"}]');
        $this->queryResult = $rst;
        return $rst;
    }
}
