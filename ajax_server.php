<?php

include('config.php');

$searchsite = $_POST['data'];

$sql="SELECT * "
     . "FROM colfusion_links "
     . "WHERE link_title like '%" . $searchsite . "%' "
     . "or link_content like '%" . $searchsite . "%'";

$title = array();

$rst = $db->get_results($sql);


echo '<ul class="list">';

foreach($rst as $row)
{
	$title[] = $row->link_title;
	$content[] = $row->link_content;
	$test = $row->link_title;
	
	echo '<li style="color:red;" ><a href=\'javascript:void(0);\'>'.$test.'</a></li>';
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
			
			$final = '<span class="bold">'.$first.'</span>'.$last;
		
			echo '<li><a href=\'javascript:void(0);\'>'.$final.'</a></li>';
		}
		echo "</ul>";
	}
	else
		echo 0;
*/
?>	   
