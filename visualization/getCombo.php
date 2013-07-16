<?php
    include('../config.php');
	
	$titleNo = $_POST['titleNo'];
	$where = $_POST['where'];	
	$comboColumnCat = $_POST['comboColumnCat'];
	$comboColumnAgg = $_POST['comboColumnAgg'];
/*
	$titleNo = 23;
	$comboColumnCat = 'sex';
	$comboColumnAgg = 'elevation';
*/	
	$res = $db->query("call doJoin('" . $titleNo . "')");
	
	$sql = "SELECT `" . $comboColumnCat . "` AS 'Category', ";
	$sql .= "MAX(`" . $comboColumnAgg . "`) AS 'MAX', ";
	$sql .= "AVG(`" . $comboColumnAgg . "`) AS 'AVG', ";
	$sql .= "MIN(`" . $comboColumnAgg . "`) AS 'MIN' ";	
	$sql .= "FROM resultDoJoin ";
	if (!empty($where))
        $sql .= $where;		
	$sql .= " GROUP BY `" . $comboColumnCat . "` ";
	
	echo $sql;
	
	//echo $sql . "<br>";

    $rst = $db->get_results($sql);
    $rows = array();
    foreach ($rst as $r) {
        $rows[] = $r;
    }
    echo json_encode($rows);
	
	//comboColumnCat + ";" + comboColumnAgg + ";";
	
	/*
      $comboColumn = $_POST['comboColumn'];
      
      //$comboColumn = "Nonfamily Female Households";
      //$titleNo = 15;
      if($titleNo != 0){
      $sql = "SELECT DISTINCT Location, 
      AVG(CAST(Value AS DECIMAL(10,1))) AS 'AVG',MAX(Value) AS MAX,MIN(Value) AS 'MIN'
      From colfusion_temporary
      Where Dname = '" .$comboColumn. "' " .
      "AND sid = " .$titleNo. " " .
      "Group by Location";
     }
     else {
      $sql = "SELECT DISTINCT Location, 
      AVG(CAST(Value AS DECIMAL(10,1))) AS 'AVG',MAX(Value) AS MAX,MIN(Value) AS 'MIN'
      From colfusion_temporary
      Where Dname = '" .$comboColumn. "' " .
      "Group by Location";
     }


    $rst = $db->get_results($sql);
    $rows = array();
    foreach ($rst as $r) { // get all results to array temp
        $rows[] = $r;
    }
    echo json_encode($rows);
	*/
    
?>