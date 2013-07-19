<?php
require_once('Chart.php');
class ColumnChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query();
    }
    function query($_datainfo){
        /*
         * Here implement the query code;
         */
        include(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
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
        $columnCat = $_datainfo->columnCat;
        $columnAgg = $_datainfo->columnAgg;
        $columnAggType = $_datainfo->columnAggType;
        $select = "SELECT `" . $columnCat . "` AS 'Category', ";
	$sid = $_datainfo->sid;
        $table = $_datainfo->table;
	switch($columnAggType) {
		case "Count":
			$select .= "COUNT(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Sum":
			$select .= "SUM(`" . $columnAgg . "`) AS 'AggValue' ";
			break;	
		case "Avg":
			$select .= "AVG(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Max":
			$select .= "MAX(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Min":
			$select .= "MIN(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
	}
	$from = (object) array('sid' => $sid, 'tableName' => $table);
        $fromArray = [$from];
	$groupby .= " GROUP BY `" . $columnCat . "` ";
        //$queryResult = json_decode('{"cat":"aaa","agg":"bbb","content":[["Year", "Sales"],["2004",15],["2005",12],["2006",16],["2007",18]]}');
        $queryEngine = new QueryEngine();
        $rst = array();
        
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, $groupby, null, null, null);
        $rst['columnCat'] = $columnCat;
        $rst['columnAggType'] = $columnAggType;
        //$rst['pieAggType'] = $pieAggType;
        //$rst['$pieColumnCat'] = $pieColumnCat;
        $this->queryResult = $rst;
        return $rst;
    }
}
