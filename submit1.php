<?php

set_time_limit(120);
// The source code packaged with this file is Free Software, Copyright (C) 2005 by
// Ricardo Galli <gallir at uib dot es>.
// It's licensed under the AFFERO GENERAL PUBLIC LICENSE unless stated otherwise.
// You can get copies of the licenses here:
// 		http://www.affero.org/oagpl.html
// AFFERO GENERAL PUBLIC LICENSE is also included in the file called "COPYING".
include_once('config.php');

include_once('Smarty.class.php');
$main_smarty = new Smarty;

require_once(realpath(dirname(__FILE__)) . "/vendor/autoload.php");

Logger::configure(realpath(dirname(__FILE__)) . '/conf/log4php.xml');

$logger = Logger::getLogger("generalLog");


include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include(mnminclude.'smartyvariables.php');

include_once('DAL/QueryEngine.php');

if (!$_COOKIE['referrer'])
	check_referrer();


// breadcrumbs and page titles
$navwhere['text1'] = $main_smarty->get_config_vars('PLIGG_Visual_Breadcrumb_Submit');
$navwhere['link1'] = getmyurl('submit1', '');
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


// determine which step of the submit process we are on
$phase = isset($_POST["phase"]) && is_numeric($_POST["phase"]) ? $_POST["phase"] : 0;

switch ($phase) {
	case 0:
		// Initial rendering of the page.
		do_submit0();
		break;
	case 1:
		// When the Finish your submisison butotn was clicked.
		do_submit1();
		break;
}


exit;

/**
 * Initial rendering of the page when user just come the Submit Data page.
 * 
 * @return [type] [description]
 */
function do_submit0() {
	global $main_smarty, $db, $dblang, $current_user, $the_template;
	
	$linkres = new Link();
	 if ($_POST['category']){
		$cats = explode(',',$_POST['category']);
		foreach ($cats as $cat){
			if ($cat_id = $db->get_var("SELECT category_id FROM ".table_categories." WHERE category_name='".$db->escape(trim($cat))."'")){
				$linkres->category = $cat_id;
				break;
			}
		}
	}
	$edit = false;
	if (is_numeric($_GET['id'])){
		$linkres->id = $_GET['id'];
	}
	else{
		$author = $current_user->user_id;
		$linkres->author=$current_user->user_id;
			$main_smarty->assign('StorySummary_ContentTruncate', StorySummary_ContentTruncate);
			$main_smarty->assign('SubmitSummary_Allow_Edit', SubmitSummary_Allow_Edit);
			$main_smarty->assign('enable_tags', Enable_Tags);

			$main_smarty->assign('submit_link_group_id', $linkres->link_group_id);

			include_once(mnminclude.'dbtree.php');
			$array = tree_to_array(0, table_categories, FALSE);

			$array = array_values(array_filter($array, "allowToAuthorCat"));

			$main_smarty->assign('submit_lastspacer', 0);
			$main_smarty->assign('submit_cat_array', $array);
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

	$queryEngine = new QueryEngine();
	$sid = $queryEngine->simpleQuery->getNewSid($current_user->user_id, 'draft');
	
	$main_smarty->assign('sid', $sid);
	
	$main_smarty->assign('tpl_extra_fields', $the_template . '/submit_extra_fields');
	$main_smarty->assign('tpl_center', $the_template . '/submit_step_21');
	$main_smarty->assign('tpl_jsFilesAtBottom', $the_template . '/submit_step_21_jsFilesAtBottom');
	$main_smarty->assign('tpl_cssInHTMLHead', $the_template . '/submit_step_21_cssInHTMLHead');
	

	define('pagename', 'submit');
	$main_smarty->assign('pagename', pagename);

	$main_smarty->display($the_template . '/pligg.tpl');

}

// submit step 1
function do_submit1() {
	global $db, $main_smarty, $dblang, $the_template, $linkres, $current_user, $Story_Content_Tags_To_Allow;
	
	$linkres=new Link();
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




		if(!isset($_POST['summarytext'])){
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
	}
	
	$sid = $_POST["sid"];

	tags_insert_string($sid, $dblang, $linkres->tags);

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
	//$Sid=$_SESSION['newSid'];
	
	header("Location:".my_base_url.my_pligg_base."/story.php?title=$sid");
		



	$vars = '';
	check_actions('do_submit2', $vars);
	$_SESSION['step'] = 2;
	$main_smarty->display($the_template . '/pligg.tpl');

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
