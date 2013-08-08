<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class MotionChart extends Chart {
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query(null);
    }
    function query($_datainfo){
        /*
         * Here implement the query code;
         */
	
	if(is_null($_datainfo)){
            $_datainfo = $this->datainfo;
            $temp = new stdClass;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
        }else{
            $temp = new stdClass;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
            $this->datainfo = $_datainfo;
        }
	$sid = $_datainfo->sid;
	$table = $_datainfo->table;
	$inputObj = $_datainfo->inputObj;
	$firstColumn = $_datainfo->firstColumn;
	$dateColumn = $_datainfo->dateColumn;
	$otherColumns = $_datainfo->otherColumns;
	$where = $_datainfo->where; 	
	$valueColumns = "";
    $valueColumnsArray = array();

    if(empty($otherColumns)){
	    echo("Please select the columns!");
    }
    else{
	    for($i=0; $i < count($otherColumns); $i++){
		  $valueColumns .= "cid(" . $otherColumns[$i]['cid'] . ") as 'valueColumn" . $i . "'";
          array_push($valueColumnsArray, "valueColumn" . $i);

		  if(!empty($otherColumns[$i+1])){
			$valueColumns .= ", ";
		  }
	    }
	}

	$select = "SELECT cid(" . $firstColumn['cid'] . ") as 'firstColumn', cid(" . $dateColumn['cid'] . ") as 'dateColumn', ";
	$select .= $valueColumns;
	if (!empty($where))
        $select .= $where;

    $from = (object) array('inputObj' => $inputObj, 'tableName' => $table);
    $fromArray = array($from);
	$queryEngine = new QueryEngine();

//TODO: Return date as three separate values: year, month, day

    $rst = array();
    $rst['firstColumn'] = $firstColumn['cid'];
    $rst['dateColumn'] = $dateColumn['cid'];
    $rst['originalOtherColumns'] = $otherColumns;
    $rst['otherColumns'] = $valueColumnsArray;//array('numberofCase','precipitation','state');
    $rst['sid'] = $sid;
    $rst['table'] = $table;
    echo $select;
    $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);

//    foreach($valueColumns as $value){
//       array_push($rst['otherColumns'], $value);
//    }
      
    $this->queryResult = $rst;
    return $rst;

   // $rst = array();
	//$rst['firstColumn'] = 'disease';
	//$rst['dateColumn'] = 'date';
	//$rst['otherColumns'] = array('numberofCase','precipitation','state');
	  
	//$rst['content'] = json_decode('[{"disease":"flu","year":"2000","month":"10","numberOfCases":"123","precipitation":"13","state":"PA"},{"disease":"phthisis","year":"2000","month":"10","numberOfCases":"126","precipitation":"15","state":"CA"},{"disease":"anemia","year":"2000","month":"10","numberOfCases":"128","precipitation":"17","state":"NY"}]');        
       
    }
}
