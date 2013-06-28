<?php
    include('../config.php');
    include('../DAL/QueryEngine.php');

    // get submitted form information from dashboard.php
	$titleNo = $_POST['titleNo']; 
    $tableColumns = $_POST['tableColumns'];
    $perPage = $_POST['perPage']; // controls how many tuples shown on each page
    $pageNo = $_POST['currentPage']; // controls which page to show, got from JS function
    $where = $_POST['where']; 

	/*
    $tableColumns = ['sex','elevation'];
    $perPage = 50; // controls how many tuples shown on each page
    $pageNo = 1; // controls which page to show, got from JS function
    $titleNo = 23; // controls which sid to go
*/

	//$res = $db->query("call doJoin('" . $titleNo . "')");	
		
    // initial variables
    $cols = "";
    $totalTuple = 0; // amount of tuples in colfusion_temporary
    $totalPage = 0; // amount of pages for the whole result, which is calculated by totalTuple/perPage
    $startPoint = 0;
	
    $querEngine = new QueryEngine();
    
//	$sql = "SELECT COUNT(*) FROM resultDoJoin ";
	$totalTuple = $querEngine->doQuery("SELECT COUNT(*)", $titleNo, "", "", "");   //$db->get_var($sql);	
	
	$totalPage = ceil($totalTuple / $perPage);
    $startPoint = ($pageNo - 1) * $perPage;	
	
    if(empty($tableColumns)) {
    	//echo("Please select the columns!");
    }
	else {
        for($i=0; $i < count($tableColumns); $i++){
			$cols .= "`" . $tableColumns[$i] . "`";
			if(!empty($tableColumns[$i+1])){
				$cols .= ",";
			}
        }
	}

	$sql = "SELECT " . $cols;
	//$sql .= " FROM resultDoJoin ";
  //  if (!empty($where))
  //      $sql .= $where;

	//$sql .= " LIMIT ".$startPoint.",".$perPage;
	
    $rst = $querEngine->doQuery($sql, $titleNo, "", "", ""); // $db->get_results($sql);
    
    $rows = array();
    foreach ($rst as $r) {
        $json_array["data"][] = $r;
    }
	
	$json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = $totalPage;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["cols"] = $cols;
	
   /*  echo json_encode($json_array); */
	echo "{'data':[{'rownum':'1','ID':' 2.0','la':' 35.273637','long':' 108.0','dvalue':' 2.0'},{'rownum':'2','ID':' 3.0','la':' 40.234','long':' 119.0','dvalue':' 3.0'},{'rownum':'3','ID':' 4.0','la':' 29.873','long':' 125.0','dvalue':' 4.0'}],'Control':{'perPage':'50','totalPage':1,'pageNo':'1','cols':'`ID`,`la`,`long`,`dvalue`'}}";
	
	
	/*
    if(empty($column)){
    	echo("Please select the columns!");
    }else{
        for($i=0; $i < count($column); $i++){
            if(strcmp($display,"sqlStyle") == 0){
                $sql_col .= $column[$i];
                if(!empty($column[$i+1])){
                    $sql_col .= ",";
                }
            }
            if(strcmp($display,"excelStyle") == 0){
                $sql_col .= "Dname = '".$column[$i]."'";
                if(!empty($column[$i+1])){
                    $sql_col .= " OR ";
                }
            }
        }
    }
    // calculate the amount of tuples in colfusion_temporary
    //$sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary where sid = '" . $titleNo . "'";
    if(strcmp($display,"sqlStyle") == 0){
        if($titleNo != 0){
            $sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary WHERE sid = ".$titleNo;
        } else {
            $sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary";
        }
        // $sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary";
    }
    if(strcmp($display,"excelStyle") == 0){
        if($titleNo != 0){
            $sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary WHERE sid = ".$titleNo." AND ".$sql_col;
        } else {
            $sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary WHERE ".$sql_col;
        }
        //$sql_count = "SELECT COUNT(*) Total FROM colfusion_temporary WHERE ".$sql_col;
    }
    $rst_count = $db->get_results($sql_count);
    foreach ($rst_count as $rst_count) {
        $totalTuple = $rst_count->Total;
    }
    // calculate the amount of pages for the whole result
    if(strcmp($display,"sqlStyle") == 0){
        $totalPage = ceil($totalTuple / $perPage);
    }
    if(strcmp($display,"excelStyle") == 0){
        $perPage = $perPage * count($column);
        $totalPage = ceil($totalTuple / $perPage);
    }

    // add control data to json["Control"]
    $json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = $totalPage;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["sql_col"] = $sql_col;

    // selecting results to show
    //$sql = "SELECT ".$sql_col." FROM colfusion_temporary where sid = " . $titleNo;
    $startPoint = ($pageNo - 1) * $perPage;
    if(strcmp($display,"sqlStyle") == 0){
        if($titleNo != 0){
            $sql = "SELECT ".$sql_col." FROM colfusion_temporary"." WHERE sid = ".$titleNo." LIMIT ".$startPoint.",".$perPage;
        } else {
            $sql = "SELECT ".$sql_col." FROM colfusion_temporary LIMIT ".$startPoint.",".$perPage;
        }
        // $sql = "SELECT ".$sql_col." FROM colfusion_temporary LIMIT ".$startPoint.",".$perPage;
    }
    if(strcmp($display,"excelStyle") == 0){
        if($titleNo != 0){
            $sql = "SELECT Dname,Start,End,Value,Location FROM colfusion_temporary WHERE sid = ".$titleNo." AND ".$sql_col." LIMIT ".$startPoint.",".$perPage;
        } else {
            $sql = "SELECT Dname,Start,End,Value,Location FROM colfusion_temporary WHERE ".$sql_col." LIMIT ".$startPoint.",".$perPage;
        }
        // $sql = "SELECT Dname,Start,End,Value,Location FROM colfusion_temporary WHERE ".$sql_col." LIMIT ".$startPoint.",".$perPage;
    }
    // $sql = "SELECT ".$sql_col." FROM colfusion_temporary";
    $rst = $db->get_results($sql);
    foreach ($rst as $r) { // get all results to array temp
        $json_array["Page".$pageNo][] = $r;
    }

    $json = json_encode($json_array);
    echo $json;
	*/
?>