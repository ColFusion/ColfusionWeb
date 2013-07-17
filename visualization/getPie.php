<?php
    include('../config.php');
	
	$titleNo = $_POST['titleNo'];
	$pieColumnCat = $_POST['pieColumnCat'];
	$pieColumnAgg = $_POST['pieColumnAgg'];
	$pieAggType = $_POST['pieAggType'];
    $where = $_POST['where']; 
	
	/*
	$titleNo = 23;
	$pieColumnCat = "sex";
	$pieColumnAgg = "elevation";
	$pieAggType = "Count";
	*/

	//$res = $db->query("call doJoin('" . $titleNo . "')");
	
	$select = "SELECT `" . $pieColumnCat . "` AS 'Category', ";
	  
	switch($pieAggType) {
		case "Count":
			$select .= "COUNT(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Sum":
			$select .= "SUM(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;	
		case "Avg":
			$select .= "AVG(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Max":
			$select .= "MAX(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Min":
			$select .= "MIN(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
	}
	
	$from = (object) array('sid' => $sid, 'tableName' => $table_name);	

	
	$groupby .= " GROUP BY `" . $pieColumnCat . "` ";
	
	$queryEngine = new QueryEngine();
	$rst = $queryEngine->doQuery($select, $from, null, $groupby, null, null, null);
	
	//echo $sql . "<br>";

	
	
	
   // $rst = $db->get_results($sql);
    $rows = array();
    foreach ($rst as $r) {
        $rows[] = $r;
    }
    echo json_encode("[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
    
?>