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
        if($_datainfo == null){
            
        }else{
            $this->datainfo = $_datainfo;
        }
        $queryResult = json_decode('{"cat":"aaa","agg":"bbb","content":[["Year", "Sales"],["2004",15],["2005",12],["2006",16],["2007",18]]}');
        $this->queryResult = $queryResult;
        return $queryResult;
    }
}
