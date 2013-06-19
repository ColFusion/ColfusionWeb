<?php
	/***** Table of total result shown in a newly open window *****/
	include('../config.php');

	$search = $_POST['search'];
	$sid = $_POST['sid'];
	$variable = $_POST['variable'];
	$select = $_POST['select'];
	$condition = $_POST['condition'];

	/***** Test data *****/
	//$search = ['Households','Married Couples','Family Households'];
	//$sid = 238;
	//$variable = ['Location','Eid'];
	//$select = ['=','='];
	//$condition = ['Taipei','31'];

	/***** Initial variables *****/
	$dname = "";
	$column = ['Spd','Drd','Dname','Location','AggrType','Start','End','Value'];
	$sql_col = "";
	$row = array(); // Temporary array for dataset result
	$json = array(); // Array stored final result which will then be send back to JS
	for($i=0; $i<count($search); $i++){
		$dname .= "Dname = '".$search[$i]."'";
        if(!empty($search[$i+1])){
        	$dname .= " OR ";
        }
    }
    for($i=0; $i<count($column); $i++){
		$sql_col .= $column[$i];
        if(!empty($column[$i+1])){
        	$sql_col .= ",";
        }
    }

	/***** Rotation one *****/
	$sql = "SELECT DISTINCT ".$sql_col." FROM colfusion_temporary,colfusion_links "
			."WHERE colfusion_temporary.sid = colfusion_links.link_id "
			."AND ".$dname." AND sid = ".$sid." ";
	if(count($variable) >= 1){
		if($select[0] == "like"){
			$sql .= "AND ".$variable[0].$select[0]."'%".$condition[0]."%' ";
		} else{
			$sql .= "AND ".$variable[0]."="."'".$condition[0]."' ";
		}
	}
	if(count($variable) > 1){
		for($i=1 ; $i<count($variable) ; $i++){
			$sql .= "AND ".$variable[$i].$select[$i]."'".$condition[$i]."' ";
		}
	}

	/***** Query Result -> Temporary array *****/
	$rst = $db->get_results($sql);
	foreach ($rst as $r) {
		//$result .= ",".$r->search;
		$row[] = $r;
	}

	/***** Temporary array -> Final array (rotate) *****/
	for($i=0,$num=0 ; $row[$i]!=null ; $num++){
		for($m=0 ; $m<count($column) ; $m++){
			if($column[$m] != "Dname"){
				if($column[$m] != "Value"){
					$json[$num][$column[$m]] = $row[$i]->$column[$m];
				} else {continue;}
			} else{
				for($j=0 ; $j<count($search) ; $j++){
					$json[$num][$search[$j]] = $row[$i + $j]->Value;
				}
				$m += count($search) - 1;
			}
		}
		$i += count($search);
	}

	/***** Print result (encoded as JSON object) *****/
	echo json_encode($json);
?>