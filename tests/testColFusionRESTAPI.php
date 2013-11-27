<?php

	require_once realpath(dirname(__FILE__)) . '/../RESTCaller/CurlCaller.php';
	require_once realpath(dirname(__FILE__)) . '/../conf/ColFusion_JAVA_REST_API.php';

	$curlCaller = new CurlCaller();
	$sid=1;
	$user_id=2;
	$table_name=3;
	$columns=4;
	$condition=5;
	$res = $curlCaller->CallAPI("GET", REST_HOST . ":" . REST_PORT . "/RESTfulProject/REST/WebService/GetFeeds?sid=".$sid."&user_id=".$user_id."&table_name=".$table_name."&columns=".$columns."&condition=".$condition, false);

	var_dump($res);
?>