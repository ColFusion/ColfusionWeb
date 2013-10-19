<?php

	require_once realpath(dirname(__FILE__)) . '/../RESTCaller/CurlCaller.php';
	require_once realpath(dirname(__FILE__)) . '/../conf/ColFusion_JAVA_REST_API.php';

	$curlCaller = new CurlCaller();

	$res = $curlCaller->CallAPI("GET", REST_HOST . ":" . REST_PORT . "/ColFusionJAPI/webapi/provenance/6", false);

	var_dump($res);
?>