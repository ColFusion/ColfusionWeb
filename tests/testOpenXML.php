<?php
	require_once (realpath(dirname(__FILE__)) . '/../DAL/DatasetDAO.php');


	$test = file_get_contents("/opt/local/apache2/htdocs/Colfusion/temp/1048/1048.xml");

	$datasetDAO = new DatasetDAO();

	$datasetDAO->saveProvenanceXML(1085, $test);

	var_dump($test);

	//SAVE TO DB!

?>


