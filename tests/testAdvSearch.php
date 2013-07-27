<?php
    include_once(realpath(dirname(__FILE__)) . '/../advancedsearch/AdvSearch.php');

    error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
    ini_set('display_errors', 1);


    $searchFor = 'Ccode, WarNum';

	$avdSearch = new AdvSearch();
    
    $avdSearch->setSearchKeywords($searchFor);

    $avdSearch->setWhereVariable($variable);
    $avdSearch->setWhereRule($select);
    $avdSearch->setWhereCondition($condition);
    
    echo json_encode($avdSearch->doSearch());

?>	