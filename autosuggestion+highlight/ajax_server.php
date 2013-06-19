<?php

include('../config.php');

$keyword = $_POST['data'];

$sql1="SELECT link_title 
FROM colfusion_links 
WHERE link_title like '%" . $keyword% . "%' ";

$title = array();

$rst1 = $db->get_results($sql1);


echo '<ul class="list">';

foreach($rst1 as $row)
{
	$title[] = $row->link_title;
	//$content[] = $row->link_content;
	//$test = $row->link_title;
	
	echo '<li><a href=\'javascript:void(0);\'>'.$title[].'</a></li>';
	//echo '<li><a href=\'javascript:void(0);\'>'.$content[].'</a></li>';
}
echo "</ul>";



$sql2="SELECT link_content 
FROM colfusion_links
WHERE link_content like '%" . $keyword . "%'";


//$title = array();
$content = array();

$rst2 = $db->get_results($sql);


echo '<ul class="list">';

foreach($rst2 as $row)
{
	//$title[] = $row->link_title;
	$content[] = $row->link_content;
	//$test = $row->link_title;
	
	//echo '<li><a href=\'javascript:void(0);\'>'.$title[].'</a></li>';
	echo '<li><a href=\'javascript:void(0);\'>'.$content[].'</a></li>';
}
echo "</ul>";

/*
	include("config.php");
	$keyword = $_POST['data'];
	$sql = "select name from ".$db_table." where ".$db_column." like '".$keyword."%' limit 0,20";
	//$sql = "select name from ".$db_table."";
	$result = mysql_query($sql) or die(mysql_error());
	if(mysql_num_rows($result))
	{
		echo '<ul class="list">';
		while($row = mysql_fetch_array($result))
		{
			$str = strtolower($row['name']);
			$start = strpos($str,$keyword); 
			$end   = similar_text($str,$keyword); 
			$last = substr($str,$end,strlen($str));
			$first = substr($str,$start,$end);
			
			$final = '<span class="bold",color="red>'.$first.'</span>'.$last;
		
			echo '<li><a href=\'javascript:void(0);\'>'.$final.'</a></li>';
		}
		echo "</ul>";
	}
	else
		echo 0;
*/
?>	   
