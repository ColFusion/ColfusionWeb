<?php

include('../config.php');

$keyword = $_POST['data'];


$title = array();

$rst1 = $db->get_results($sql1);


echo '<ul class="list">';

foreach($rst1 as $row)
{
	$title[] = $row->link_title;
	$content[] = $row->link_content;
	$test = $row->link_title;
	
	echo '<li><a href=\'javascript:void(0);\'>'.$title[].'</a></li>';
	echo '<li><a href=\'javascript:void(0);\'>'.$content[].'</a></li>';
}
echo "</ul>";




?>	   
