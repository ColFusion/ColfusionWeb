<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class PieChart extends Chart {
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        //$this->query(null);
    }
    function query($_datainfo){
        
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
        $inputObj = $_datainfo->inputObj;
        $sid = $_datainfo->sid;
        $table = $_datainfo->table;
        //$pieColumnCat = $_datainfo->pieColumnCat['columnName'];
        //$pieColumnAgg = $_datainfo->pieColumnAgg['text'];//$_datainfo->pieColumnAgg[key($_datainfo->pieColumnAgg)];
        $pieAggType = $_datainfo->pieAggType;
        $where = $_datainfo->where;
        $select = "SELECT cid(" . $_datainfo->pieColumnCat['cid'] . ") AS 'Category', ";
        switch($pieAggType) {
		case "Count":
			$select .= "COUNT(cid(" . $_datainfo->pieColumnAgg['cid'] . ")) AS 'AggValue' ";
			break;
		case "Sum":
			$select .= "SUM(cid(" . $_datainfo->pieColumnAgg['cid'] . ")) AS 'AggValue' ";
			break;	
		case "Avg":
			$select .= "AVG(cid(" . $_datainfo->pieColumnAgg['cid'] . ")) AS 'AggValue' ";
			break;
		case "Max":
			$select .= "MAX(cid(" . $_datainfo->pieColumnAgg['cid'] . ")) AS 'AggValue' ";
			break;
		case "Min":
			$select .= "MIN(cid(" . $_datainfo->pieColumnAgg['cid'] . ")) AS 'AggValue' ";
			break;
	}
        $from = (object) array('inputObj' => $inputObj, 'tableName' => $table);
        $fromArray = array($from);
        $groupby = " GROUP BY cid(" . $_datainfo->pieColumnCat['cid'] . ") ";
        $queryEngine = new QueryEngine();
        $rst = array();
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, $groupby, null, null, null);
        $rst['pieAggType'] = $pieAggType;
        $rst['pieColumnCat'] = $_datainfo->pieColumnCat['columnName'];
        $rst['sid'] = $sid;
        $rst['table'] = $table;
        //$queryResult = json_decode('{"string":"aaa","number":"bbb","content":[{"Category":" 2.0","AggValue":"1"},{"Category":" 3.0","AggValue":"2"},{"Category":" 4.0","AggValue":"3"}]}');
        $this->queryResult = $rst;
        return $rst;
    }
}
