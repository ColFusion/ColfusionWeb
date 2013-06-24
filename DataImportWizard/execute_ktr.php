<?php

set_time_limit(0);
// The source code packaged with this file is Free Software, Copyright (C) 2005 by
// Ricardo Galli <gallir at uib dot es>.
// It's licensed under the AFFERO GENERAL PUBLIC LICENSE unless stated otherwise.
// You can get copies of the licenses here:
// 		http://www.affero.org/oagpl.html
// AFFERO GENERAL PUBLIC LICENSE is also included in the file called "COPYING".

include_once('../Smarty.class.php');
$main_smarty = new Smarty;

include('../config.php');
include(mnminclude . 'html1.php');
include(mnminclude . 'link.php');
include(mnminclude . 'tags.php');
include(mnminclude . 'user.php');
include(mnminclude . 'smartyvariables.php');

global $current_user, $db, $dblang;

$author = $current_user->user_id;

$sid = getSid();
$ktrFilePath = mnmpath . "temp/$sid.ktr";

$sql = 'INSERT INTO ' . table_prefix . 'executeinfo (Sid ,Userid ,TimeStart)VALUES (' . $sid . ' , ' . $author . ',CURRENT_TIMESTAMP);';
//print($sql);
$rs = $db->query($sql);
if ($rs) {
    //get eid returned from the insert
    $logID = mysql_insert_id();
    //print $logID;
} else {
    print (mysql_error());
    return;
}

if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
    $locationOfPan = mnmpath . 'kettle-data-integration\\Pan_WHDV.bat';
    $command = 'cmd.exe /C ' . $locationOfPan . ' /file:"' . $ktrFilePath . '" ' . '"-param:Sid=' . $sid . '"' . ' "-param:Eid=' . $logID . '"';
} else {
    $locationOfPan = mnmpath . 'kettle-data-integration/pan.sh';
    $command = 'sh ' . $locationOfPan . ' -file="' . $ktrFilePath . '" ' . '-param:Sid=' . $sid . ' -param:Eid=' . $logID;
}

$ret = exec($command, $outA, $returnVar);

if (strpos($ret, 'ended successfully') === false) {
    $num = 0;
    $sql = "UPDATE " . table_prefix . "executeinfo SET ExitStatus=0, ErrorMessage='" . mysql_real_escape_string(implode("\n", $outA)) . "', RecordsProcessed='" . $num . "', TimeEnd=CURRENT_TIMESTAMP WHERE EID=" . $logID;
    $rs = $db->query($sql);
    if (!$rs) {
        print (mysql_error());
        //rollback();
        die;
    }

    $error = implode("<br />", $outA);
    //print($error);

    $errora = array();
    $errorb = array();
    $re1 = '(at)';
    $re2 = '( )';

    for ($i = 0; $i < count($outA); $i++) {
        if (strstr($outA[$i], 'ERROR') != FALSE) {
            break;
        }
    }

    $n = $i;
    for ($j = $n + 1; $j < count($outA); $j++) {
        if ($c = preg_match_all("/" . $re1 . $re2 . '/is', $outA[$j], $matches)) {
            break;
        }
    }
    for ($i; $i < $j; $i++) {
        array_push($errora, $outA[$i]);
    }

    for ($o = 0; $o < count($outA); $o++) {
        if ($c = preg_match_all("/" . $re1 . $re2 . '/is', $outA[$o], $matches)) {
            array_push($errorb, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" . $outA[$o]);
        }
    }

    $mysql_error = implode("<br />", $errora);
    $mysql_errordetail = implode("<br />", $errorb);

    $msg = '<p class="error">Error Message:<br />' . $mysql_error . '</p><div id="details" style="display:none">' . $mysql_errordetail . '</div>
	<center>
	   <span id="btn_all" class="button_max" style="display:block" onclick="show_detail()">Show Detailed Error</span>
       <span id="btn_hide" class="button_max" style="display:none" onclick="hide_detail()">Hide Detailed Error</span>
    </center>';


    //TODO: fix this
    $jsCode = "<script type='text/javascript'>
	function show_detail()
		{		
				document.getElementById('btn_show').style.display='none';
				document.getElementById('btn_hide').style.display='block';
				document.getElementById('details').style.display='block';													
		}
		
    function hide_detail()
		{		
				document.getElementById('btn_show').style.display='block';
				document.getElementById('btn_hide').style.display='none';
				document.getElementById('details').style.display='none';													
		}
    
    </script>";

    $result = new stdClass;
    $result->isSuccessful = false;
    $result->message = $msg . $jsCode;
    $result->pentaho_cmd = $command;
    echo json_encode($result);

    return;
} else {
    //TODO parse msg to get num inserted
    $lastLine = $outA[count($outA) - 1];
    preg_match("/d+\s{1}[0-9]+\s{1}l+/", $lastLine, $matches);
    $m = explode(' ', $matches[0]);
    $numProcessed = $m[1];

    $sql = "UPDATE " . table_prefix . "executeinfo SET ExitStatus=1, RecordsProcessed='" . $numProcessed . "', TimeEnd=CURRENT_TIMESTAMP WHERE EID=" . $logID;
    //print($sql);
    $rs = $db->query($sql);
    if (!$rs) {
        print (mysql_error());
        //rollback();
        die;
    }

    $sid = getSid();

    $dnamelistquery = "SELECT DISTINCT Dname FROM " . table_prefix . "temporary WHERE Sid = $sid";
    $dnamelist = $db->get_results($dnamelistquery);
    $num = count($dnamelist);
    //echo $num.'<br>';
    //print_r( $dnamelist);

    $query = "UPDATE `colfusion_temporary` AS t, 
       (SELECT @rownumN:=@rownumN+1 as rownumN, `Tid`, `rownum`
        FROM `colfusion_temporary`, (select @rownumN := -1) rn
        where `Sid` = $sid
       ) AS r
SET t.`rownum` = r.rownumN DIV $num + 1
WHERE t.`Tid` = r.`Tid`";
    $db->query($query);

    $query = "UPDATE `colfusion_temporary` AS t, 
       (SELECT @rownumN:=@rownumN+1 as rownumN, `Tid`, `rownum`
        FROM `colfusion_temporary`, (select @rownumN := -1) rn
        where `Sid` = $sid
       ) AS r
SET t.`columnnum` = r.rownumN % $num + 1
WHERE t.`Tid` = r.`Tid`";
    $db->query($query);

    $result = new stdClass;
    $result->isSuccessful = true;
    $result->message = 'Success!';
    $result->pentaho_cmd = $command;
    echo json_encode($result);
}

exit;

function getSid() {
    // determine which step of the submit process we are on
    if (isset($_POST["sid"]))
        $sid = $_POST["sid"];
    else if (isset($_GET["sid"]))
        $sid = $_GET["sid"];
    else {
        echo json_encode("no sid");
        die();
    }

    return $sid;
}

?>