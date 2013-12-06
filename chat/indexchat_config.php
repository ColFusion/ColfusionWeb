<?php
require_once realpath(dirname(__FILE__)) . '/../libs/dbconnect.php';
require_once realpath(dirname(__FILE__)) . '/../conf/chat_conf.php';

//CHAT_DB
//EZSQL_DB_USER
//EZSQL_DB_PASSWORD
	
//connect to MySQL	
$mysql['connection_id'] = mysql_connect(CHAT_HOST,EZSQL_DB_USER, EZSQL_DB_PASSWORD);
mysql_select_db(CHAT_DB);

mysql_query("set names utf8");

?>