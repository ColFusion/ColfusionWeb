<?php
// The source code packaged with this file is Free Software, Copyright (C) 2005 by
// Ricardo Galli <gallir at uib dot es>.
// It's licensed under the AFFERO GENERAL PUBLIC LICENSE unless stated otherwise.
// You can get copies of the licenses here:
// 		http://www.affero.org/oagpl.html
// AFFERO GENERAL PUBLIC LICENSE is also included in the file called "COPYING".

include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'group.php');
include(mnminclude.'smartyvariables.php');
include_once(mnminclude.'user.php');

// determine which step of the submit process we are on


	global $current_user, $globals, $the_template, $smarty, $db;
	$Sid=$_SESSION['requestID'];
	$s = $db->get_row("SELECT * FROM ".table_prefix."sourceinfo  WHERE Sid = $Sid");
	$user_id=$s->UserId;
	$u = $db->get_row("SELECT * FROM ".table_prefix."users WHERE user_id = '$user_id'");
	$lastUpdated=$s->LastUpdated;
	if(is_null($lastUpdated) === TRUE){
	    $lastUpdated = $s->EntryDate;
	}
	
	echo '<br/><span style="font-weight:bold;padding-left:10px;">Dataset Title: </span><span id="dataset_title">'.$s->Title.'</span><br /><span style="font-weight:bold;padding-left:10px;">Submit by:</span> '.$u->user_login.'<br /><span style="font-weight:bold;padding-left:10px;">Date Submitted:</span> '.$s->EntryDate.'<br /><span style="font-weight:bold;padding-left:10px;">Date Last Refreshed:</span> '.$lastUpdated.'<br /><br/>'."\n";
	
//	if(isset($_GET["count"]) && is_numeric($_GET["count"]))
//		{
//			$count=$_GET["count"];
//			$sql = "select * from colfusion_temporary where Sid = '$Sid' LIMIT 0,$count;";
//		}
//	else 
//			$sql = "select * from colfusion_temporary where Sid = '$Sid';";
//	$u = $db->get_row("SELECT * FROM colfusion_users WHERE user_id = '$user_id'");
//	
//	$rs = mysql_query($sql);
//
//	$url = 'display_data.php';
//	if(isset($_GET["page"])){
//		$page = $_GET["page"];
//	}else{
//		$page = 1;
//	}
//	$total = mysql_num_rows($rs);
//	$num = 30;
//	$pagenum = ceil($total/$num);
//	if($pagenum < $page){
//		$page = $pagenum;
//	}
//	$prepg = $page - 1;
//	$nextpg = ($page==$pagenum ? 0 : $page+1);
//	$offset = ($page - 1) * $num;
//	$pagenav="Page <b>".$page. "</b>, Displaying no. <B>".($total?($offset+1):0)."</B>-<B>".min($offset+30,$total)."</B> records, $total in total ";
	//$pagenav2.=" <a href=javascript:dopage('$url?page=1');>First</a> ";
	// if($prepg) $pagenav2.=" <a href=javascript:dopage('$url?page=$prepg');>Prev</a> "; else $pagenav2.=" Prev ";
	// if($nextpg) $pagenav2.=" <a href=javascript:dopage('$url?page=$nextpg');>Next</a> "; else $pagenav2.=" Next ";

//	for($i = 1; $i<=$pagenum; $i++){ 
//		  $pagenav2.=" <span>&nbsp;<a class=page href=javascript:dopage('$url?page=$i');>$i</a></span> "; 
 //      
	//}

	//$pagenav2.=" <a href=javascript:dopage('$url?page=$pagenum');>Last</a> ";
	//$pagenav2.="</select>，$pagenum pages in total";


//	if($page>$pagenum){
//      echo "Error : Can Not Found The page ".$page;
//       Exit;
//    }


/*
	if (mysql_num_rows($rs) >0){
	    if(isset($_GET["count"]) && is_numeric($_GET["count"]))
		{
			echo '<center><b><font size="2">First five lines are shown for preview.</font></b></center>'."\n";			
			echo '<center><div style=""><table cellspacing="0" cellpadding="9" style=>'."\n";

			echo '<thead><tr style="background-color:#000033;color:#FFFFFF;"><td>Spd</td><td>Drd</td><td>Dname</td><td>Location</td><td>AggrType</td><td>Start</td><td>End</td><td>Value</td></tr></thead>'."\n";
			echo '<tbody>'."\n";
			$rc=0;
			while($row = mysql_fetch_array($rs)){
				//alternating row color
				echo '<tr style="background-color:#';
				if ($rc % 2){
					echo 'F3F3F3';
				} else{
					echo 'CCCCCC';
				}

				$Spd = $row['Spd'];
				echo ';"><td nowrap>'.$row['Spd'].'</td><td nowrap>'.$row['Drd'].'</td><td nowrap>'.$row['Dname'].'</td><td nowrap><span title="Country:'.$row['Country'].' - CountrySubDiv:'.$row['CountrySubDiv'].' - Locality:'.$row['LID'].'">'.$row['Location'].'</span></td><td nowrap>'.$row['AggrType'].'</td><td nowrap>'.$row['Start'].'</td><td nowrap>'.$row['End'].'</td><td nowrap>'.$row['Value'].'</td></tr>'."\n";
				$rc++;
			}
			echo '</tbody>'."\n";
			echo '</table></div></center>'."\n";
	    }else{
	    	$sql2 =  "select * from colfusion_temporary where Sid = '$Sid' LIMIT $offset, $num;";
	    	//echo $sql2;
	    	$rs2 = mysql_query($sql2);
	    	echo '<center><div style=""><table cellspacing="0" cellpadding="9" style=>'."\n";

			echo '<thead><tr style="background-color:#000033;color:#FFFFFF;"><td>Spd</td><td>Drd</td><td>Dname</td><td>Location</td><td>AggrType</td><td>Start</td><td>End</td><td>Value</td></tr></thead>'."\n";
			echo '<tbody>'."\n";
			$rc2=0;
			while($row2 = mysql_fetch_array($rs2)){
				//alternating row color
				echo '<tr style="background-color:#';
				if ($rc2 % 2){
					echo 'F3F3F3';
				} else{
					echo 'CCCCCC';
				}

				$Spd = $row2['Spd'];
				echo ';"><td nowrap>'.$row2['Spd'].'</td><td nowrap>'.$row2['Drd'].'</td><td nowrap>'.$row2['Dname'].'</td><td nowrap><span title="Country:'.$row2['Country'].' - CountrySubDiv:'.$row2['CountrySubDiv'].' - Locality:'.$row2['LID'].'">'.$row2['Location'].'</span></td><td nowrap>'.$row2['AggrType'].'</td><td nowrap>'.$row2['Start'].'</td><td nowrap>'.$row2['End'].'</td><td nowrap>'.$row2['Value'].'</td></tr>'."\n";
				$rc2++;
			}
			echo '</tbody>'."\n";
			echo '</table></div></center>'."\n";
			echo '<br />';
			echo '<center>'.$pagenav.'</center><br />';
			echo '<center>'.$pagenav2.'</center><br />';
	    }
	
	}
	else 
		echo '<div style="color:red;">no data submitted</div>';

	if(isset($_GET["filetype"]) && is_numeric($_GET["filetype"])){
        echo $_GET["filetype"];
    }	
    */
?>