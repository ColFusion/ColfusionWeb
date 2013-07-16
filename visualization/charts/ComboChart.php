<?php
require_once('Chart.php');
class ComboChart extends Chart{
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
        $queryResult =  json_decode('[{"Category":"aaa","AVG":"13","MAX":"18","MIN":"12"},{"Category":"bbb","AVG":"14","MAX":"16","MIN":"11"},{"Category":"ccc","AVG":"10","MAX":"14","MIN":"6"},{"Category":"ddd","AVG":"43","MAX":"45","MIN":"14"}]');
        $this->queryResult = $queryResult;
        return $queryResult;
    }
}
