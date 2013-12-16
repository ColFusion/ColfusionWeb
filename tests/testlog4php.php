<?php

	require_once(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

	Logger::configure(realpath(dirname(__FILE__)) . '/../conf/log4php.xml');

	$logger = Logger::getLogger("generalLog");
	$logger->info("This is an informational message.");
	$logger->warn("I'm not feeling so good...");

?>