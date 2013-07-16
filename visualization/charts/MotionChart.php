<?php
require_once('Chart.php');
class MotionChart extends Chart {
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
	$queryResult = json_decode('[{"disease":"flu","year":"2000","month":"10","numberOfCases":"123","precipitation":"13","state":"PA"},{"disease":"phthisis","year":"2000","month":"10","numberOfCases":"126","precipitation":"15","state":"CA"},{"disease":"anemia","year":"2000","month":"10","numberOfCases":"128","precipitation":"17","state":"NY"}]');        
        $this->queryResult = $queryResult;
        return $queryResult;
    }
}
