<?php

	
    include_once(realpath(dirname(__FILE__)) . '/../advancedsearch/AdvSearch.php');

    error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
    ini_set('display_errors', 1);

	
	/***** Get requested variables *****/
	$search = $_POST['search'];

	$search = array('A', 'G', 'X', 'K');


	$variable = $_POST['variable'];
	$select = $_POST['select'];
	$condition = $_POST['condition'];

	$avdSearch = new AdvSearch();
	
	$avdSearch->setSearchKeywords($search);

	$avdSearch->setWhereVariable($variable);
	$avdSearch->setWhereRule($select);
	$avdSearch->setWhereCondition($condition);
	
 	echo json_encode($avdSearch->doSearch());
?>