<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class ComboChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
    }
    function query($_datainfo){
        /*
         * Here implement the query code;
         */
        
        if(is_null($_datainfo)){
            $_datainfo = $this->datainfo;
            $temp = new stdClass;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
        }else{
            $temp = new stdClass;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
            $this->datainfo = $_datainfo;
        }
	$sid = $_datainfo->sid;
        $table = $_datainfo->table;
        $inputObj = $_datainfo->inputObj;
	$comboColumnCat = $_datainfo->comboColumnCat;
	$comboColumnAgg = $_datainfo->comboColumnAgg;
        $comboAggType = $_datainfo->comboAggType;
        $from = (object) array('inputObj' => $inputObj, 'tableName' => $table);
        $fromArray = array($from);	
	$select = "SELECT `" . $comboColumnCat . "` AS 'Category' ";
        for($i = 0; $i < sizeof($comboAggType); $i++){
            $select .= ", ".$comboAggType[$i]."(`" . $comboColumnAgg . "`) AS '".$comboAggType[$i]."' ";
        }
	/*$select .= "MAX(`" . $comboColumnAgg . "`) AS 'MAX', ";
	$select .= "AVG(`" . $comboColumnAgg . "`) AS 'AVG', ";
	$select .= "MIN(`" . $comboColumnAgg . "`) AS 'MIN' ";	*/		
	$groupby = " GROUP BY `" . $comboColumnCat . "` ";
        $queryEngine = new QueryEngine();
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, $groupby, null, null, null);
        $rst['comboAggType'] = $comboAggType;
        $rst['comboColumnCat'] = $comboColumnCat;
        $rst['comboColumnAgg'] = $comboColumnAgg;
        $rst['sid'] = $sid;
        $rst['table'] = $table;
        //rst['content'] =  json_decode('[{"Category":"aaa","AVG":"13","MAX":"18","MIN":"12"},{"Category":"bbb","AVG":"14","MAX":"16","MIN":"11"},{"Category":"ccc","AVG":"10","MAX":"14","MIN":"6"},{"Category":"ddd","AVG":"43","MAX":"45","MIN":"14"}]');
        $this->queryResult = $rst;
        return $rst;
    }
}
