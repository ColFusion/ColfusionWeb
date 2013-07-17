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
	$s = $db->get_row("SELECT UserId, Title, link_content, EntryDate, LastUpdated FROM ".table_prefix."sourceinfo s inner join colfusion_links l on s.sid = l.link_id  WHERE Sid = $Sid");
	$user_id=$s->UserId;
	$u = $db->get_row("SELECT * FROM ".table_prefix."users WHERE user_id = '$user_id'");
	$lastUpdated=$s->LastUpdated;
	if(is_null($lastUpdated) === TRUE){
	    $lastUpdated = $s->EntryDate;
	}
	
	echo '<br/>
            <span style="font-weight:bold;padding-left:10px;">Dataset Title: </span>
            <span id="dataset_title">'.$s->Title.'</span>              
                <br />
                <span style="font-weight:bold;padding-left:10px;">Submit by:</span> '
                .$u->user_login.
                '<br />
                    <span style="font-weight:bold;padding-left:10px;">Date Submitted:</span> '
                .$s->EntryDate.
                '<br />
                    <span style="font-weight:bold;padding-left:10px;">Date Last Refreshed:</span> '
                .$lastUpdated.
                '<br /> 
                <span style="font-weight:bold;padding-left:10px;float:left;">Description: </span>
                <span id="profile_datasetDescription">'.$s->link_content.'</span><br/><br/>'
                ."\n";	
?>