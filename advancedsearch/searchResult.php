<?php
	/***** List of titles below the advanced search conditions *****/
	include('../config.php');

	include(mnmpath.'advancedsearch/AdvSearch.php');
	
	/***** Get requested variables *****/
	$search = $_POST['search'];
	$variable = $_POST['variable'];
	$select = $_POST['select'];
	$condition = $_POST['condition'];

	$avdSearch = new AdvSearch();
	
	$avdSearch->setSearchKeywords($search);

	$avdSearch->setWhereVariable($variable);
	$avdSearch->setWhereRule($select);
	$avdSearch->setWhereCondition($condition);
	
 	echo json_encode($avdSearch->doSearch());
	
// 	/***** Test data *****/
// 	//$search = ['Households','Married Couples'];
// 	//$variable = ['Location','Eid'];
// 	//$select = ['=','='];
// 	//$condition = ['Taipei','31'];

// 	/***** Initial variables *****/
// 	$sql_col = "";
// 	$result = array(); // array for results {"TitleID":title_id,"Title":link_title,"Dname":dname_string}

// 	/***** Set searching query *****/
// 	for($i=0; $i<count($search); $i++){
// 		$sql_col .= "Dname = '".$search[$i]."'";
//         if(!empty($search[$i+1])){
//         	$sql_col .= " OR ";
//         }
//     }
// 	$sql = "SELECT DISTINCT link_id TitleID,link_title Title FROM colfusion_links,colfusion_temporary "
// 			."WHERE colfusion_links.link_id = colfusion_temporary.sid "
// 			."AND ".$sql_col." ";
// 	if(count($variable) >= 1){
// 		if($select[0] == "like"){
// 			$sql .= "AND ".$variable[0].$select[0]."'%".$condition[0]."%' ";
// 		} else{
// 			$sql .= "AND ".$variable[0]."="."'".$condition[0]."' ";
// 		}
// 	}
// 	if(count($variable) > 1){
// 		for($i=1 ; $i<count($variable) ; $i++){
// 			$sql .= "AND ".$variable[$i].$select[$i]."'".$condition[$i]."' ";
// 		}
// 	}

// 	/***** Query Result *****/
// 	$rst = $db->get_results($sql);
// 	foreach ($rst as $r) {
// 		$result[] = $r;
// 	}

// 	for($i=0 ; $result[$i]!=null ; $i++){
// 		$result[$i]->Dname = "";
// 		$sql = "SELECT DISTINCT Dname FROM colfusion_temporary WHERE sid = ".$result[$i]->TitleID." AND ".$sql_col;
// 		$rst = $db->get_results($sql);
// 		foreach ($rst as $r){
// 			$result[$i]->Dname .= ",".$r->Dname;
// 		}
// 		$result[$i]->Dname = substr($result[$i]->Dname,1);
// 	}

	/***** Print result *****/
//	echo json_encode($result);

//	session_start();
	$send["search"] = $search;
	$send["variable"] = $variable;
	$send["select"] = $select;
	$send["condition"] = $condition;
	$_SESSION['JSend'] = $send;
	//$_SESSION['JSend'] = json_encode($send);
?>