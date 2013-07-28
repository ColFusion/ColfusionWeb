<?php
    //include_once(realpath(dirname(__FILE__)) . '/../advancedsearch/AdvSearch.php');

    require(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

    error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
    ini_set('display_errors', 1);


   // Connecting to the default port 7474 on localhost
    $client = new Everyman\Neo4j\Client();

    print_r($client->getServerInfo());

?>	