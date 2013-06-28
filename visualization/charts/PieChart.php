<?php
require_once('Chart.php');
class PieChart extends Chart {
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query();
    }
    function query(){
        /*
         * Here implement the query code;
         */
        return '{"string":"aaa","number":"bbb","content":[{"Category":" 2.0","AggValue":"1"},{"Category":" 3.0","AggValue":"2"},{"Category":" 4.0","AggValue":"3"}]}';
    }
}