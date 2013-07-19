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
	$sid = $_datainfo->sid;
	$table = $_datainfo->table;
	$firstColumn = $_datainfo->firstColumn;
	$dateColumn = $_datainfo->dateColumn;
	$otherColumns = $_datainfo->otherColumns;
	$where = $_datainfo->where; 	
	$valueColumns = "";
        if(empty($otherColumns)){
	    echo("Please select the columns!");
        }else{
	    for($i=0; $i < count($otherColumns); $i++){
		$valueColumns .= "`" . $otherColumns[$i] . "` as 'valueColumn" . $i . "'";
		if(!empty($otherColumns[$i+1])){
			$valueColumns .= ", ";
		}
	    }
	}
	$select = "SELECT `" . $firstColumn . "` as 'firstColumn', `" . $dateColumn . "` as 'dateColumn', ";
	$select .= $valueColumns;
	if (!empty($where))
        $select .= $where;
        $from = (object) array('sid' => $sid, 'tableName' => $table);
        $fromArray = [$from];
	$queryEngine = new QueryEngine();
        $rst = array();
	$rst['firstColumn'] = 'disease';
	$rst['dateColumn'] = 'date';
	$rst['otherColumns'] = array('numberofCase','precipitation','state');
	foreach($otherColumns as $value){
	    array_push($rst['otherColumns'],$value);
	}
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
	$rst['content'] = json_decode('[{"disease":"flu","year":"2000","month":"10","numberOfCases":"123","precipitation":"13","state":"PA"},{"disease":"phthisis","year":"2000","month":"10","numberOfCases":"126","precipitation":"15","state":"CA"},{"disease":"anemia","year":"2000","month":"10","numberOfCases":"128","precipitation":"17","state":"NY"}]');        
        $this->queryResult = $rst;
        return $rst;
    }
}
