<?php
/*
$host    = "localhost"; // Host name
$db_name = "colfusion";		// Database name
$db_user = "root";		// Database user name
$db_pass = "";			// Database Password
$db_table= "colfusion_misc_data";		// Table name
$db_column = "name";	// Table column from which suggestions will get shown
*/

include('../config.php');

$sql="SELECT * 
FROM colfusion_links
WHERE link_title like '%$searchsite%'
or link_content like '%$searchsite%'";

$title = array();

$rst = $db->get_results($sql);

foreach($rst as $row)
{
	$title[] = $row->link_title;
	$content[] = $row->link_content;
}
/*
foreach($title as $name)
{
	echo $name . "	";
}*/


 //$conn = mysql_connect($host,$db_user,$db_pass)or die(mysql_error());
//         mysql_select_db($db_name,$conn)or die(mysql_error());

?>