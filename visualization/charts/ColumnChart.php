<?php
//error_reporting(E_ALL);
//ini_set('display_errors', 1);

require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');
//error_reporting(E_ALL);
//ini_set('display_errors', 1);


class ColumnChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
    }

    function query($datainfo){
        /*
         * Here implement the query code;
         */
        
        if(is_null($datainfo)) {
            $datainfo = $this->datainfo;
            $temp = new stdClass;
            foreach($datainfo as $key => $value){
                $temp->$key = $value;
            }
            $datainfo = $temp;
        }else{
            $temp = new stdClass;
            foreach($datainfo as $key => $value){
                $temp->$key = $value;
            }
            $datainfo = $temp;
            $this->datainfo = $datainfo;
        }
        $columnCat = $datainfo->columnCat;
        $columnAgg = $datainfo->columnAgg;
        $columnAggType = $datainfo->columnAggType;
        $select = "SELECT `" . $columnCat . "` AS 'Category', ";
    $sid = $datainfo->sid;
        $table = $datainfo->table;
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
        $fromArray = array($from);
        $groupby = " GROUP BY `" . $columnCat . "` ";
        //$queryResult = json_decode('{"cat":"aaa","agg":"bbb","content":[["Year", "Sales"],["2004",15],["2005",12],["2006",16],["2007",18]]}');
        $queryEngine = new QueryEngine();
        $rst = array();
        
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, $groupby, null, null, null);
        $rst['columnCat'] = $columnCat;
        $rst['columnAggType'] = $columnAggType;
        $rst['sid'] = $sid;
        $rst['table'] = $table;
        //$rst['pieAggType'] = $pieAggType;
        //$rst['$pieColumnCat'] = $pieColumnCat;
        $this->queryResult = $rst;
        return $rst;
    }
    
}

?>
