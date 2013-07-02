<?php
require_once('Chart.php');
class MapChart extends Chart {
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query();
    }
    function query(){
        /*
         * Here implement the query code;
         */
      return '[{"la":"37.4232","long":"-122.0853","ID":"1","dvalue":"3"},{"la":"37.42234","long":"-122.0134","ID":"2","dvalue":"5"},{"la":"37.4452","long":"-122.0753","ID":"3","dvalue":"4"}]';
        
    }
}
