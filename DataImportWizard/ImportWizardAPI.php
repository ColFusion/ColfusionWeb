<?php
	include(realpath(dirname(__FILE__)) . '/../config.php');
	include(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
	 
	$action = $_GET["action"];
		
	$action();
		
	exit;

	// Expects sid in post
    function MineRelationships() {
    	
    	$queryEngine = new QueryEngine();
	   
    	//$table_name = $_POST["table_name"];
    	$perPage = $_POST["perPage"];
    	$pageNo = $_POST["pageNo"];
    	
    	
    	
    	$result = $queryEngine->MineRelationships($_POST["sid"]);
    	
    	
    	
    	$columns = NULL;
    	
    	foreach ($result as $r) {
    		$json_array["data"][] = $r;
    			
    		if ($columns === NULL) {
    			if (is_array($r))
    				$columns = implode(",", array_keys($r));
    			else
    				$columns = implode(",", array_keys(get_object_vars($r)));
    		}
    	}
    	
    //	$totalTuple = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, $table_name);
    //	$totalPage = ceil($totalTuple / $perPage);
    	
    	$json_array["Control"]["perPage"] = $perPage;
    	$json_array["Control"]["totalPage"] = 40;
    	$json_array["Control"]["pageNo"] = $pageNo;
    	$json_array["Control"]["cols"] = $columns;
    	
    	echo json_encode($json_array);
	}
	
?>	