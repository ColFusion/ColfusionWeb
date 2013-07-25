<?php

    include_once(realpath(dirname(__FILE__)) . '/../config.php');
    include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

    error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
    ini_set('display_errors', 1);


	$from = new stdClass;
    $from->sid = 840;
    $from->tableName = "tableNameFrom";
    $from->links = array("cid(890)", "cid(891)"); // size of this array should be equal to the size of array in To
	
    $to = new stdClass;
    $to->sid = 840;
    $to->tableName = "tableNameFrom";
    $to->links = array("cid(890)", 'cid(891)');
	
	$queryEngine = new QueryEngine();
	
	echo json_encode($queryEngine->CheckDataMatching($from, $to));

?>	