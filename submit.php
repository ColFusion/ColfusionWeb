<?php
set_time_limit(120);
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
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include(mnminclude.'smartyvariables.php');

if (!$_COOKIE['referrer'])
	check_referrer();

// html tags allowed during submit
if (checklevel('god'))
	$Story_Content_Tags_To_Allow = Story_Content_Tags_To_Allow_God;
elseif (checklevel('admin'))
$Story_Content_Tags_To_Allow = Story_Content_Tags_To_Allow_Admin;
else
	$Story_Content_Tags_To_Allow = Story_Content_Tags_To_Allow_Normal;
$main_smarty->assign('Story_Content_Tags_To_Allow', htmlspecialchars($Story_Content_Tags_To_Allow));

// breadcrumbs and page titles
$navwhere['text1'] = $main_smarty->get_config_vars('PLIGG_Visual_Breadcrumb_Submit');
$navwhere['link1'] = getmyurl('submit', '');
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', $main_smarty->get_config_vars('PLIGG_Visual_Breadcrumb_Submit'));
$main_smarty = do_sidebar($main_smarty);

//to check anonymous mode activated
global $current_user;
if($current_user->authenticated != TRUE)
{
	$vars = '';
	check_actions('anonymous_story_user_id', $vars);
	if ($vars['anonymous_story'] != true)
		force_authentication();
}
/*
 if ($vars['anonymous_story'] == true)
 {
$anonymous_userid = $db->get_row("SELECT user_id from " . table_users . " where user_login = 'anonymous' ");
$anonymous_user_id = $anonymous_userid->user_id;
//echo "val".$anonymous_user_id;
}
*/
// module system hook
$vars = '';
check_actions('submit_post_authentication', $vars);

$_POST['randkey'] = rand(10000,10000000);
if(!empty($_GET['trackback']))
	$_POST['trackback'] = $_GET['trackback'];


// determine which step of the submit process we are on
$phase = isset($_POST["phase"]) && is_numeric($_POST["phase"]) ? $_POST["phase"] : 0;

// If show URL input box is disabled, go straight to step 2
if($phase == 0 && Submit_Show_URL_Input == false) {
	$phase = 1;
}
switch ($phase) {
	case 0:
		// Link to this page, before starting submit process.
		echo 'submit0 start.';
		do_submit0();
		break;
	case 1:
		echo 'submit1 start.';
		do_submit1();
		break;
	case 2:
		echo 'submit2 start.';
		do_submit2();
		break;
	case 3:
		echo 'submit3 start.';
		do_submit3();
		break;
}

exit;

// enter URL before submit process
function do_submit0() {
	global $main_smarty, $the_template;
	$main_smarty->assign('submit_rand', rand(10000,10000000));
	$main_smarty->assign('Submit_Show_URL_Input', Submit_Show_URL_Input);
	$main_smarty->assign('Submit_Require_A_URL', Submit_Require_A_URL);

	define('pagename', 'submit');
	$main_smarty->assign('pagename', pagename);

	$main_smarty->assign('tpl_center', $the_template . '/submit_step_1');
	$vars = '';
	check_actions('do_submit0', $vars);
	$main_smarty->display($the_template . '/pligg.tpl');
}

// submit step 1
function do_submit1() {
	global $main_smarty, $db, $dblang, $current_user, $the_template;

	$linkres=new Link;
	$linkres->randkey = sanitize($_POST['randkey'], 3);

	$edit = false;
	if (is_numeric($_GET['id']))
	{
		$linkres->id = $_GET['id'];
		$trackback=$_GET['trackback'];
	}
	else
	{
		if($_FILES['wrapper']['error'] > 0){
			$main_smarty->assign('submit_error', 'wrongtype');
			$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
			$main_smarty->display($the_template . '/pligg.tpl');
			return;
		}
		$error=$linkres->get($_FILES['wrapper']);

		if ($error) {
			$main_smarty->assign('submit_error', $error);
			$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
			$main_smarty->display($the_template . '/pligg.tpl');
			return;
				
		}


		$fname = $_FILES["wrapper"]["name"];
		$sname = explode('.', $fname);
		$linkres->title = $sname[0];

		$author = $current_user->user_id;

		$datetime = date ("Y-m-d H:i:s" , mktime(date('H'), date('i'), date('s'), date('m'), date('d'), date('Y'))) ;
		$_SESSION['EntryDate']=$datetime;
		$sql="INSERT INTO ".table_prefix."sourceinfo (UserId, EntryDate, Status) VALUES ('$author','$datetime','discard');" ;
		//$sql="INSERT INTO ".table_prefix."links (link_author, link_date, link_status) VALUES ('$author','$datetime','discard');" ;
		$rs=$db->query($sql);

		if ($rs) {
			//get sid returned from insert
			$newSid = mysql_insert_id();
		}


		$newSid=mysql_insert_id();
		$_SESSION['newSid']=$newSid;
		$linkres->newSid=$newSid;

		$target_path = "temp/";
		//echo $target_path;
		$target_path = $target_path."$newSid.ktr";

		move_uploaded_file($_FILES['wrapper']['tmp_name'], $target_path);
		//echo $_FILES['wrapper']['tmp_name'];


		$current_timestamp = $datetime;

		$sql='INSERT INTO '.table_prefix.'executeinfo (Sid ,Userid ,TimeStart)VALUES ('.$newSid.' , '.$author.',CURRENT_TIMESTAMP);';
		//print($sql);
		$rs=$db->query($sql);
		if ($rs) {
			//get eid returned from the insert
			$logID = mysql_insert_id();
			//print $logID;
		} else {
			//print (mysql_error());
			//rollback();
			$main_smarty->assign('mysql_error', mysql_error());
			$main_smarty->assign('submit_error', 'mysql_error');
			$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
			$main_smarty->display($the_template . '/pligg.tpl');
			return;
		}


		if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
			$locationOfPan = realpath(dirname(__FILE__)).'\\kettle-data-integration\\Pan_WHDV.bat';
			$command = 'cmd.exe /C ' . $locationOfPan.' /file:"'.realpath(dirname(__FILE__)).'\\'.$target_path.'" ' . '"-param:Sid=' . $newSid . '"'.' "-param:Eid='. $logID . '"';
		} else {
			$locationOfPan = realpath(dirname(__FILE__)).'/kettle-data-integration/pan.sh';
			$command = 'sh ' . $locationOfPan.' -file="'.realpath(dirname(__FILE__)).'/'.$target_path.'" ' . '-param:Sid=' . $newSid .' -param:Eid='. $logID ;
		}
		
		//$locationOfPan = 'C:\\inetpub\\colfusion\\kettle-data-integration\\Pan_WHDV.bat';
		//$locationOfPan = '/var/www/colfusion/kettle-data-integration/pan.sh';
		//$command = 'cmd.exe /C ' . $locationOfPan.' /file:"C:\\inetpub\\colfusion\\'.$target_path.'" ' . '"-param:Sid=' . $newSid . '"'.' "-param:Eid='. $logID . '"';
		//$command = 'sh ' . $locationOfPan.' -file="/var/www/colfusion/'.$target_path.'" ' . '-param:Sid=' . $newSid .' -param:Eid='. $logID ;
		//$command = 'sh ' . $locationOfPan;

		//print($command."<br><br>");

		$ret = exec($command,$outA,$returnVar);

		//print($ret);  showing successful.
		//print_r('ret:['.$ret.']<br><br>');
		//print_r($outA);

		//echo $outA;
		//print_r('retvar:'.$returnVar.'<br><br>');

		//if(strpos($ret,'error')!=false)
		if(strpos($ret,'ended successfully')===false)
		{
			$num = 0;
			$sql="UPDATE ".table_prefix."executeinfo SET ExitStatus=0, ErrorMessage='".mysql_real_escape_string(implode("\n",$outA))."', RecordsProcessed='".$num."', TimeEnd=CURRENT_TIMESTAMP WHERE EID=".$logID;
			$rs=$db->query($sql);
			if (!$rs){
				print (mysql_error());
				//rollback();
				die;
			}
				
			//echo 'Dataset cannot be immigrated at this time.<br />';
			$error = implode("<br />",$outA);
			//print($error);
				
			$errora = array();
			$errorb = array();
			$re1='(at)';
			$re2='( )';
				
			for($i=0;$i<count($outA);$i++){
				if(strstr($outA[$i],'ERROR')!= FALSE){
					break;
				}
			}
				
			$n = $i;
			for($j=$n+1;$j<count($outA);$j++){
				if($c=preg_match_all("/".$re1.$re2.'/is',$outA[$j],$matches)){
					break;
				}
			}
			for($i;$i<$j;$i++){
				array_push($errora,$outA[$i]);
			}
				
			for($o=0;$o<count($outA);$o++){
				if($c=preg_match_all("/".$re1.$re2.'/is',$outA[$o],$matches)){
					array_push($errorb,"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".$outA[$o]);
				}
			}
				
			//array_push('Dataset cannot be immigrated at this time.<br />',$error);

			$main_smarty->assign('mysql_error', implode("<br />",$errora));
			$main_smarty->assign('mysql_errordetail', implode("<br />",$errorb));
			$main_smarty->assign('submit_error', 'wrongktr');
			$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
			$main_smarty->display($the_template . '/pligg.tpl');
			return;
			//rollback();
			//print($ret);
				

				
				
			die;
		} else {
			/*//if ok update source info
			 $sql="UPDATE SourceInfo SET LastUpdated='".date('Y-m-d')."' where Sid='".$sid."'";
			//print($sql);
			$rs = mysql_query($sql);
			if (!$rs){
			print (mysql_error());
			//rollback();
			mysql_close($con);
			die;
			}*/

			//TODO parse msg to get num inserted
			$lastLine = $outA[count($outA)-1];
			preg_match("/d+\s{1}[0-9]+\s{1}l+/",$lastLine,$matches);
			$m = explode(' ',$matches[0]);
			$numProcessed = $m[1];


			$sql="UPDATE ".table_prefix."executeinfo SET ExitStatus=1, RecordsProcessed='".$numProcessed."', TimeEnd=CURRENT_TIMESTAMP WHERE EID=".$logID;
			//print($sql);
			$rs=$db->query($sql);
			if (!$rs){
				print (mysql_error());
				//rollback();
				die;
			}

			$main_smarty->assign('randkey', $linkres->randkey);
			//$main_smarty->assign('submit_url', $url);
			//$data = parse_url($url);
			//$main_smarty->assign('url', $url);
			//$main_smarty->assign('url_short', 'http://'.$data['host']);
			//$main_smarty->assign('Submit_Show_URL_Input', $Submit_Show_URL_Input);
			//$main_smarty->assign('Submit_Require_A_URL', Submit_Require_A_URL);

			$linkres->author=$current_user->user_id;

			$main_smarty->assign('StorySummary_ContentTruncate', StorySummary_ContentTruncate);
			$main_smarty->assign('SubmitSummary_Allow_Edit', SubmitSummary_Allow_Edit);
			$main_smarty->assign('enable_tags', Enable_Tags);
			$main_smarty->assign('submit_url_title', str_replace('"',"&#034;",$linkres->url_title));
			$main_smarty->assign('submit_url_description', $linkres->url_description);
			$main_smarty->assign('submit_id', $linkres->id);
			if(isset($link_title)){
				$main_smarty->assign('submit_title', str_replace('"',"&#034;",$link_title));
			}
			if(isset($link_content)){
				$main_smarty->assign('submit_content', $link_content);
			}
			$main_smarty->assign('submit_trackback', $trackback);

			$main_smarty->assign('submit_link_group_id', $linkres->link_group_id);

			//	$main_smarty->assign('submit_id', $_GET['id']);
			$main_smarty->assign('submit_title', str_replace('"',"&#034;",$linkres->title));
			$main_smarty->assign('submit_content', str_replace("<br />", "\n", $linkres->content));
			$main_smarty->assign('storylen', utf8_strlen(str_replace("<br />", "\n", $linkres->content)));
			$main_smarty->assign('submit_summary', $linkres->link_summary);
			$main_smarty->assign('submit_group', $linkres->link_group_id);
			$main_smarty->assign('submit_category', $linkres->category);
			$main_smarty->assign('submit_additional_cats', $linkres->additional_cats);
			$main_smarty->assign('tags_words', $linkres->tags);

			include_once(mnminclude.'dbtree.php');
			$array = tree_to_array(0, table_categories, FALSE);

			$array = array_values(array_filter($array, "allowToAuthorCat"));

			$main_smarty->assign('submit_lastspacer', 0);
			$main_smarty->assign('submit_cat_array', $array);
		}

		// this is the end


		/*	    if ($_POST['category'])
		 {
		$cats = explode(',',$_POST['category']);
		foreach ($cats as $cat)
			if ($cat_id = $db->get_var("SELECT category_id FROM ".table_categories." WHERE category_name='".$db->escape(trim($cat))."'"))
			{
		$linkres->category = $cat_id;
		break;
		}
		}
		$trackback=$linkres->trackback;
		}*/

	}

	//to display group drop down
	if(enable_group == "true")
	{
		$output = '';
		$group_membered = $db->get_results("SELECT group_id,group_name FROM " . table_groups . "
				LEFT JOIN ".table_group_member." ON member_group_id=group_id
				WHERE member_user_id = $current_user->user_id AND group_status = 'Enable' AND member_status='active'
				ORDER BY group_name ASC");
		if ($group_membered)
		{
			$output .= "<select name='link_group_id'>";
			$output .= "<option value = ''>".$main_smarty->get_config_vars('PLIGG_Visual_Group_Select_Group')."</option>";
			foreach($group_membered as $results)
			{
				$output .= "<option value = ".$results->group_id. ($linkres->link_group_id ? ' selected' : '') . ">".$results->group_name."</option>";
			}
			$output .= "</select>";
		}
		$main_smarty->assign('output', $output);
	}




	if($current_user->authenticated != TRUE){
		$vars = '';
		check_actions('register_showform', $vars);
	}

	$main_smarty->assign('Spell_Checker', Spell_Checker);

	$main_smarty->assign('tpl_extra_fields', $the_template . '/submit_extra_fields');
	$main_smarty->assign('tpl_center', $the_template . '/submit_step_2');

	define('pagename', 'submit');
	$main_smarty->assign('pagename', pagename);

	$vars = '';
	check_actions('do_submit1', $vars);
	$_SESSION['step'] = 1;
	$main_smarty->display($the_template . '/pligg.tpl');
}

// submit step 2
function do_submit2() {
	global $db, $main_smarty, $dblang, $the_template, $linkres, $current_user, $Story_Content_Tags_To_Allow;

	$linkres=new Link;
	$main_smarty->assign('auto_vote', auto_vote);
	$main_smarty->assign('Submit_Show_URL_Input', Submit_Show_URL_Input);
	$main_smarty->assign('Submit_Require_A_URL', Submit_Require_A_URL);
	$main_smarty->assign('link_id', sanitize($_POST['id'], 3));
	define('pagename', 'submit');
	$main_smarty->assign('pagename', pagename);

	$linkres->store();

	$linkres->id = sanitize($_POST['id'], 3);
	$thecat = get_cached_category_data('category_id', $linkres->category);
	$main_smarty->assign('request_category_name', $thecat->category_name);




	/*	if(!isset($_POST['summarytext'])){
		$linkres->link_summary = utf8_substr(sanitize($_POST['bodytext'], 4, $Story_Content_Tags_To_Allow), 0, StorySummary_ContentTruncate - 1);
	$linkres->link_summary = close_tags(str_replace("\n", "<br />", $linkres->link_summary));
	} else {
	$linkres->link_summary = sanitize($_POST['summarytext'], 4, $Story_Content_Tags_To_Allow);
	$linkres->link_summary = close_tags(str_replace("\n", "<br />", $linkres->link_summary));
	if(utf8_strlen($linkres->link_summary) > StorySummary_ContentTruncate){
	loghack('SubmitAStory-SummaryGreaterThanLimit', 'username: ' . sanitize($_POST["username"], 3).'|email: '.sanitize($_POST["email"], 3), true);
	$linkres->link_summary = utf8_substr($linkres->link_summary, 0, StorySummary_ContentTruncate - 1);
	$linkres->link_summary = close_tags(str_replace("\n", "<br />", $linkres->link_summary));
	}
	}*/


	tags_insert_string($_SESSION['newSid'], $dblang, $linkres->tags);

	//$main_smarty->assign('the_story', $linkres->print_summary('full', true));

	$main_smarty->assign('tags', $linkres->tags);
	if (!empty($linkres->tags)) {
		$tags_words = str_replace(",", ", ", $linkres->tags);
		$tags_url = urlencode($linkres->tags);
		$main_smarty->assign('tags_words', $tags_words);
		$main_smarty->assign('tags_url', $tags_url);
	}

	$main_smarty->assign('submit_url_title', $linkres->url_title);
	$main_smarty->assign('submit_id', $linkres->id);

	$main_smarty->assign('submit_title', str_replace('"',"&#034;",$link_title));
	$main_smarty->assign('submit_content', $link_content);

	include(mnminclude.'redirector.php');
	$x = new redirector($_SERVER['REQUEST_URI']);
	$Sid=$_SESSION['newSid'];
	header("Location:/colfusion/story.php?title=$Sid");
		



	$vars = '';
	check_actions('do_submit2', $vars);
	$_SESSION['step'] = 2;
	$main_smarty->display($the_template . '/pligg.tpl');

}

// submit step 3
function do_submit3() {
	global $db;

	$linkres=new Link;
	$linkres->id = sanitize($_POST['id'], 3);
	if(!is_numeric($linkres->id))die();

	if(!Submit_Complete_Step2 && $_SESSION['step']!=2)die('Wrong step');
	$linkres->read();

	totals_adjust_count($linkres->status, -1);
	totals_adjust_count('queued', 1);

	$linkres->status='queued';

	$vars = array('linkres'=>&$linkres);
	check_actions('do_submit3', $vars);

	if ($vars['linkres']->status=='discard')
	{
		$vars = array('link_id' => $linkres->id);
		check_actions('story_discard', $vars);
	}
	elseif ($vars['linkres']->status=='spam')
	{
		$vars = array('link_id' => $linkres->id);
		check_actions('story_spam', $vars);
	}


	$linkres->store_basic();
	$linkres->check_should_publish();

	if(isset($_POST['trackback']) && sanitize($_POST['trackback'], 3) != '') {
		require_once(mnminclude.'trackback.php');
		$trackres = new Trackback;
		$trackres->url=sanitize($_POST['trackback'], 3);
		$trackres->link=$linkres->id;
		$trackres->title=$linkres->title;
		$trackres->author=$linkres->author;
		$trackres->content=$linkres->content;
		$res = $trackres->send();
	}

	$vars = array('linkres'=>$linkres);
	check_actions('submit_pre_redirect', $vars);
	if ($vars['redirect'])
		header('Location: '.$vars['redirect']);
	elseif($linkres->link_group_id == 0)
	header("Location: " . getmyurl('upcoming'));
	else
	{
		$redirect = getmyurl("group_story", $linkres->link_group_id);
		header("Location: $redirect");
	}
	die;
}

// assign any errors found during submit
function link_errors($linkres)
{
	global $main_smarty, $the_template, $cached_categories;
	$error = false;

	if(sanitize($_POST['randkey'], 3) !== $linkres->randkey) { // random key error
		$main_smarty->assign('submit_error', 'badkey');
		$error = true;
	}
	if($linkres->status != 'discard' && $linkres->status != 'draft') { // if link has already been submitted
		$main_smarty->assign('submit_error', 'hashistory');
		$main_smarty->assign('submit_error_history', $linkres->status);
		$error = true;
	}
	$story = preg_replace('/[\s]+/',' ',strip_tags($linkres->content));
	if(utf8_strlen($linkres->title) < minTitleLength  || utf8_strlen($story) < minStoryLength ) {
		$main_smarty->assign('submit_error', 'incomplete');
		$error = true;
	}
	if(utf8_strlen($linkres->title) > maxTitleLength) {
		$main_smarty->assign('submit_error', 'long_title');
		$error = true;
	}
	if (utf8_strlen($linkres->content) > maxStoryLength ) {
		$main_smarty->assign('submit_error', 'long_content');
		$error = true;
	}
	if(utf8_strlen($linkres->tags) > maxTagsLength) {
		$main_smarty->assign('submit_error', 'long_tags');
		$error = true;
	}
	if (utf8_strlen($linkres->summary) > maxSummaryLength ) {
		$main_smarty->assign('submit_error', 'long_summary');
		$error = true;
	}
	if(preg_match('/.*http:\//', $linkres->title)) { // if URL is found in link title
		$main_smarty->assign('submit_error', 'urlintitle');
		$error = true;
	}
	if(!$linkres->category > 0) { // if no category is selected
		$main_smarty->assign('submit_error', 'nocategory');
		$error = true;
	}
	foreach($cached_categories as $cat) {
		if($cat->category__auto_id == $linkres->category && !allowToAuthorCat($cat)) { // category does not allow authors of this level
			$main_smarty->assign('submit_error', 'nocategory');
			$error = true;
		}
	}

	if($error == true){
		$main_smarty->assign('link_id', $linkres->id);
		$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
		$main_smarty->display($the_template . '/pligg.tpl');
		die();
	}

	return $error;
}
// assign any errors found during captch checking
function link_catcha_errors($linkerror)
{
	global $main_smarty, $the_template;
	$error = false;

	if($linkerror == 'captcha_error') { // if no category is selected
		$main_smarty->assign('submit_error', 'register_captcha_error');
		$main_smarty->assign('tpl_center', $the_template . '/submit_errors');
		$main_smarty->display($the_template . '/pligg.tpl');
		#		$main_smarty->display($the_template . '/submit_errors.tpl');
		$error = true;
	}
	return $error;
}

function allowToAuthorCat($cat) {
	global $current_user, $db;

	$user = new User($current_user->user_id);
	if($user->level == "god")
		return true;
	else if($user->level == "admin" && ((is_array($cat) && $cat['authorlevel'] != "god") || $cat->category_author_level != "god"))
		return true;
	else if((is_array($cat) && $cat['authorlevel'] == "normal") || $cat->category_author_level == "normal")
		// DB 11/12/08
	{
		$group = is_array($cat) ? $cat['authorgroup'] : $cat->category_author_group;
		if (! $group)
			return true;
		else
		{
			$group = "'".preg_replace("/\s*(,\s*)+/","','",$group)."'";
			$groups = $db->get_row($sql = "SELECT a.* FROM ".table_groups." a, ".table_group_member." b
					WHERE   a.group_id=b.member_group_id AND
					b.member_user_id=$user->id   AND
					a.group_status='Enable' AND
					b.member_status='active' AND
					a.group_name IN ($group)");
			if ($groups->group_id)
				return true;
		}
	}
	/////
	return false;
}
?>
