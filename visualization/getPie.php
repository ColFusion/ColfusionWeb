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

	$res = $db->query("call doJoin('" . $titleNo . "')");
	
	$sql = "SELECT `" . $pieColumnCat . "` AS 'Category', ";
	  
	switch($pieAggType) {
		case "Count":
			$sql .= "COUNT(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Sum":
			$sql .= "SUM(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;	
		case "Avg":
			$sql .= "AVG(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Max":
			$sql .= "MAX(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
		case "Min":
			$sql .= "MIN(`" . $pieColumnAgg . "`) AS 'AggValue' ";
			break;
	}
	
	$sql .= "FROM resultDoJoin ";
	if (!empty($where))
        $sql .= $where;

	$sql .= " GROUP BY `" . $pieColumnCat . "` ";
	
	//echo $sql . "<br>";

    $rst = $db->get_results($sql);
    $rows = array();
    foreach ($rst as $r) {
        $rows[] = $r;
    }
    echo json_encode("[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
    
?>