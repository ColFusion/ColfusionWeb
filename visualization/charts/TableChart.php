
<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class TableChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
      //  $this->query($this->datainfo);
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
	$color = $_datainfo->color;
	$tableColumns = $_datainfo->tableColumns;
	$perPage = $_datainfo->perPage; // controls how many tuples shown on each page
	$pageNo = $_datainfo->currentPage; // controls which page to show, got from JS function
	$where = $_datainfo->where;

	$from = (object) array('inputObj' => $inputObj, 'tableName' => $table);
	$fromArray = array($from);
	
	$queryEngine = new QueryEngine();
	$totalTuple = $queryEngine->doQuery("SELECT COUNT(*)", $fromArray, null, null, null, null, null);
	$tp;
    
	foreach($totalTuple[0] as $value){
	    $tp = $value;
	}
	
	$totalPage = ceil(intval($tp) / intval($perPage));
	$startPoint = ($pageNo - 1) * $perPage;
	$cols = '';
	if(empty($tableColumns)) {
	    //echo("Please select the columns!");
	}
	else {
	    for($i=0; $i < count($tableColumns); $i++){
			    $cols .= "cid(" . $tableColumns[$i]['cid'] . ") as ".$tableColumns[$i]['columnName']." ";
			    if(!empty($tableColumns[$i+1])){
				    $cols .= ", ";
			    }
	    }
	}
	$select = "SELECT " . $cols;
	$resultDoQuery = $queryEngine->doQuery($select, $fromArray, null, null, null, $perPage, $pageNo);

	$returnedColumns = array();

	if (isset($resultDoQuery) && count($resultDoQuery) > 0) {
		$returnedColumns = array_keys(get_object_vars($resultDoQuery[0]));
	}

	$rst['content'] = $resultDoQuery;
	$rst["perPage"] = $perPage;
	$rst["totalPage"] = $totalPage;
	$rst['totalTuple'] = $totalTuple;
	$rst["pageNo"] = $pageNo;
	$rst['color'] = $color;
	
	$rst['tableColumns'] = $tableColumns;
	$rst['returnedColumns'] = $returnedColumns;
	$rst['currentPage'] = $pageNo;
	$rst['sid'] = $sid;
        $rst['table'] = $table;
    	//$rst = json_decode('{"column":["ID","la","rownum","long","dvalue"],"data":[{"rownum":"1","ID":" 2.0","la":" 35.273637","long":" 108.0","dvalue":" 2.0"},{"rownum":"2","ID":" 3.0","la":" 40.234","long":" 119.0","dvalue":" 3.0"},{"rownum":"3","ID":" 4.0","la":" 29.873","long":" 125.0","dvalue":" 4.0"}],"Control":{"perPage":"50","totalPage":1,"pageNo":"1","cols":["ID","la","long","dvalue"],"color":"blue"}}');
        $this->queryResult = $rst;
        return $rst;
    }
}
