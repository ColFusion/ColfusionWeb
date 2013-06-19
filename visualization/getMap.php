<?php
    include('../config.php');
	
	$titleNo = $_POST['titleNo'];
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];	
	$mapTooltip = $_POST['mapTooltip'];
    $where = $_POST['where']; 
	
	$tips = "";
/*
	$latitude = "latitude";
	$longitude = "longitude";
	$mapTooltip = ['sex', 'elevation'];
	$titleNo = 23;
*/	
	$res = $db->query("call doJoin('" . $titleNo . "')");	
	
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
	
	$sql = "SELECT `" . $latitude . "` as 'latitude', `" . $longitude . "` as 'longitude', " . $tips;
	$sql .= " FROM resultDoJoin ";
	if (!empty($where))
        $sql .= $where;

	$rst = $db->get_results($sql);
	$rows = array();
	foreach ($rst as $r) {
		$rows[] = $r;
	}
	echo json_encode($rows);
	
?>