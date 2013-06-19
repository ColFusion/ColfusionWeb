<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include_once(mnminclude.'utils.php');
include(mnminclude.'smartyvariables.php');


global $db;
$sidlistquery = "SELECT DISTINCT Sid FROM ".table_prefix."temporary";
$sidlistqueryrs = $db->get_results($sidlistquery);
$sidnum = count($sidlistqueryrs);
echo $sidnum.'<br>';
//print_r($sidlistqueryrs);
for($m = 0; $m < $sidnum; $m++){
	$Sid = $sidlistqueryrs[$m]->Sid;
	echo 'Current Sid is '.$Sid.'<br>';

	
	$dnamelistquery = "SELECT DISTINCT Dname FROM ".table_prefix."temporary WHERE Sid = ".$Sid;
	$dnamelist = $db->get_results($dnamelistquery);
	$num = count($dnamelist);
	echo 'Column number is '.$num.'<br>';
	//print_r( $dnamelist);

	$starttidquery = "SELECT Tid FROM ".table_prefix."temporary WHERE Sid = ".$Sid.' ORDER BY Tid LIMIT 0,1;';
	$starttidrs = $db->get_row($starttidquery);
	$starttid = $starttidrs->Tid;
	echo 'Start Tid is '.$starttid.'<br>';

	$endtidquery = "SELECT MAX(Tid) FROM ".table_prefix."temporary WHERE Sid = ".$Sid;
	//echo $endtidquery.'<br>';
	$endtidrs = $db->get_row($endtidquery);
	$endtidarray = (array)$endtidrs;
	$endtid = $endtidarray['MAX(Tid)'];
	echo 'End Tid is '.$endtid.'<br>';

	$totalrow = ($endtid-$starttid+1)/$num;
	echo 'Total row is '.$totalrow.'<br>';

	$i = $starttid-1;
	
	
	if($i <= $endtid){
		for($j = 1; $j <= $totalrow; $j++){
			for($k = 1; $k <= $num; $k++){
				$i = $i+1;
				$updatesql = "UPDATE ".table_prefix."temporary SET rownum = ".$j.", columnnum = ".$k." WHERE Tid = ".$i;
				$db->query($updatesql);
				echo $updatesql.'<br>';
			}
		}
	}
	
}


?>