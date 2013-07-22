<?php
require_once('Chart.php');

include_once(realpath(dirname(__FILE__)) . '/../../DAL/QueryEngine.php');

class MapChart extends Chart {
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
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
            $temp = new stdClass;;
            foreach($_datainfo as $key => $value){
                $temp->$key = $value;
            }
            $_datainfo = $temp;
            $this->datainfo = $_datainfo;
        }
        $sid = $_datainfo->sid;
        $table = $_datainfo->table;
	$latitude = $_datainfo->latitude;
	$longitude = $_datainfo->longitude;
        //$_datainfo->mapTooltip = array("ID","dvalue");
        if(isset($_datainfo->mapTooltip)){
            $mapTooltip = $_datainfo->mapTooltip;
        }
        $where = $_datainfo->where; 
	$tips = "";	
        if(empty($mapTooltip)) {
            //echo("Please select the columns!");
        }
	else {
            for($i=0; $i < count($mapTooltip); $i++){
                $tips .= "`" . $mapTooltip[$i] . "`";
                if(!empty($mapTooltip[$i+1])){
                        $tips .= ",";
                }
            }
	}	
	$select = "SELECT `" . $latitude . "` as 'latitude', `" . $longitude . "` as 'longitude'";
        if(isset($_datainfo->mapTooltip)){
            $select .= ", ".$tips; 
        }
	$from = (object) array('sid' => $sid, 'tableName' => $table);
        $fromArray = array($from);
	if (!empty($where))
        $select .= $where;
        $queryEngine = new QueryEngine();
	//$rst = $db->get_results($sql);
        $rst = array();
        $rst['content'] = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);
        if(isset($_datainfo->mapTooltip)){
            $rst['mapTooltip'] = $mapTooltip;
        }
        
        //$rst['content'] = json_decode('[{"latitude":"37.4232","longitude":"-122.0853","ID":"1","dvalue":"3"},{"latitude":"37.42234","longitude":"-122.0134","ID":"2","dvalue":"5"},{"latitude":"37.4452","longitude":"-122.0753","ID":"3","dvalue":"4"}]');
        $this->queryResult = $rst;
        return $rst; 
    }
}
