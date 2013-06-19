<?php
    include('../config.php');
	
	$titleNo = $_POST['titleNo'];
	$columnCat = $_POST['columnCat'];
	$columnAgg = $_POST['columnAgg'];
	$columnAggType = $_POST['columnAggType'];
	$where = $_POST['where']; 
	
	/*
	$titleNo = 23;
	$columnCat = "sex";
	$columnAgg = "elevation";
	$columnAggType = "Sum";
	*/
	
	$res = $db->query("call doJoin('" . $titleNo . "')");
	
	$sql = "SELECT `" . $columnCat . "` AS 'Category', ";
	  
	switch($columnAggType) {
		case "Count":
			$sql .= "COUNT(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Sum":
			$sql .= "SUM(`" . $columnAgg . "`) AS 'AggValue' ";
			break;	
		case "Avg":
			$sql .= "AVG(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Max":
			$sql .= "MAX(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
		case "Min":
			$sql .= "MIN(`" . $columnAgg . "`) AS 'AggValue' ";
			break;
	}
	
	$sql .= "FROM resultDoJoin ";
	if (!empty($where))
        $sql .= $where;	
	$sql .= " GROUP BY `" . $columnCat . "` ";
	
	//echo $sql . "<br>";

    $rst = $db->get_results($sql);
    $rows = array();
    foreach ($rst as $r) {
        $rows[] = $r;
    }
    echo json_encode($rows);
	    
?>