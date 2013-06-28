<?php
require_once('Chart.php');
class ColumnChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query();
    }
    function query(){
        /*
         * Here implement the query code;
         */
        
        return '{"vAxis":"aaa","hAxis":"bbb",seriesNumber:"3","content":[{"Category":" 2.0","AggValue":"1"},{"Category":" 3.0","AggValue":"1"},{"Category":" 4.0","AggValue":"1"}]}';
        //echo json_encode($rows);
    }
}
