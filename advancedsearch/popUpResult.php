<?php
	session_start();
	$dataToSend = $_SESSION['JSend'];
	$searchArray = $dataToSend["search"];
	$variableArray = $dataToSend["variable"];
	$selectArray = $dataToSend["select"];
	$conditionArray = $dataToSend["condition"];

	$search = "";
	$variable = "";
	$select = "";
	$condition = "";

	for($i=0; $i<count($searchArray); $i++){
		$search .= $searchArray[$i];
        if(!empty($searchArray[$i+1])){
        	$search .= ",";
        }
    }
    for($i=0; $i<count($variableArray); $i++){
		$variable .= $variableArray[$i];
		$select .= $selectArray[$i];
		$condition .= $conditionArray[$i];
        if(!empty($variableArray[$i+1])){
        	$variable .= ",";
        	$select .= ",";
        	$condition .= ",";
        }
    }
?>

<html>
	<head>
		<script type="text/javascript" src="jquery-1.9.1.js"></script>
		<script type="text/javascript" src="searchJS.js"></script>
	</head>
	<body onload="searchData()">
		<table id="searchResults"></table>
		<input type="hidden" name="sid" value="<?php echo $_GET['sid']; ?>" />
		<input type="hidden" name="search" value="<?php echo $search; ?>" />
		<input type="hidden" name="variable" value="<?php echo $variable; ?>" />
		<input type="hidden" name="select" value="<?php echo $select; ?>" />
		<input type="hidden" name="condition" value="<?php echo $condition; ?>" />
	</body>
</html>