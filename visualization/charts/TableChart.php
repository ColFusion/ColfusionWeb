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
        
        return '{"currentPage":"0","perPage":"3","totalPage":"2","color":"blue","tableColumns":["RowNum","Country","State","City","Year","Month","Day"],"data":[["1","China","Hebei","A","1988","May","31"],["2","China","Hebei","A","1988","May","31"],["3","China","Hebei","A","1988","May","31"],["4","China","Hebei","A","1988","May","31"]]}';
        
    }
}
