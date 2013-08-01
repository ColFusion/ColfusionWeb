<?php
// The source code packaged with this file is Free Software, Copyright (C) 2005 by
// Ricardo Galli <gallir at uib dot es>.
// It's licensed under the AFFERO GENERAL PUBLIC LICENSE unless stated otherwise.
// You can get copies of the licenses here:
// 		http://www.affero.org/oagpl.html
// AFFERO GENERAL PUBLIC LICENSE is also included in the file called "COPYING".

ini_set('include_path', '.');

define('LOG_FILE','cache/log.php');
error_reporting(E_ALL ^ E_NOTICE ^ E_STRICT ^ E_WARNING);
ini_set('display_errors', 1);
ini_set('error_log','cache/log.php');

// experimental caching
// 0 = off
// 1 = on
define('caching', 1);

define('summarize_mysql', 1);

if (get_magic_quotes_gpc()) {
    function stripslashes_deep($value)
    {
        $value = is_array($value) ?
                    array_map('stripslashes_deep', $value) :
                    stripslashes($value);

        return $value;
    }

    $_POST = array_map('stripslashes_deep', $_POST);
    $_GET = array_map('stripslashes_deep', $_GET);
    $_COOKIE = array_map('stripslashes_deep', $_COOKIE);
    $_REQUEST = array_map('stripslashes_deep', $_REQUEST);
}

// Sanitize GET variables used in templates
if ($main_smarty)
{
    $get = array();
    foreach ($_GET as $k => $v)
	$get[$k] = stripslashes(htmlentities(strip_tags($v),ENT_QUOTES,'UTF-8'));
    $get['return'] = addslashes($get['return']);
    $main_smarty->assign('get',$get);           
}

// CSFR/XSFR protection
if(!isset($_SESSION)) @session_start();
if ($_SESSION['xsfr'])
    $xsfr_first_page = 0;
else
{
    $xsfr_first_page = 1;
    $_SESSION['xsfr'] = 1;
}

// DO NOT EDIT THIS FILE. USE THE ADMIN PANEL (logged in as "god") TO MAKE CHANGES
// IF YOU MUST MAKE CHANGES MANUALLY, EDIT SETTINGS.PHP


define("mnmpath", dirname(__FILE__).'/');
define("mnminclude", dirname(__FILE__).'/libs/');
define("mnmmodules", dirname(__FILE__).'/modules/');

include_once mnminclude . 'pre_install_check.php';

include_once 'settings.php';
function sanit($var){
return addslashes(htmlentities(strip_tags($var),ENT_QUOTES,'UTF-8'));
}
if ($my_base_url == ''){
	define('my_base_url', "http://" . $_SERVER["HTTP_HOST"]);
	if(isset($_REQUEST['action'])){$action = sanit($_REQUEST['action']);}else{$action="";}
	
	$pos = strrpos($_SERVER["SCRIPT_NAME"], "/");
	$path = substr($_SERVER["SCRIPT_NAME"], 0, $pos);
	if ($path == "/"){$path = "";}

	define('my_pligg_base', $path);
	$my_pligg_base = $path;
} else {
	define('my_base_url', $my_base_url);
	define('my_pligg_base', $my_pligg_base);
}

$pathWithoutSlash = strtolower(substr($my_pligg_base, 1));
define('my_pligg_base_no_slash', $pathWithoutSlash);

define('urlmethod', $URLMethod);

if(isset($_COOKIE['template'])){
	$thetemp = str_replace('..','',sanit($_COOKIE['template']));
} 

// template check
$file = dirname(__FILE__) . '/templates/' . $thetemp . "/pligg.tpl";
unset($errors);
if (!file_exists($file)) { $errors[]='You may have typed the template name wrong or "'. $thetemp . '" does not exist. Click <a href = "admin/admin_config.php?page=Template">here</a> to fix it.'; }
if (isset($errors)) {
	$thetemp = "wistie";
	$file = dirname(__FILE__) . '/templates/' . $thetemp . "/pligg.tpl";
	if (!file_exists($file)) {echo 'The default Wistie template does not exist anymore. Please fix this by reuploading the Wistie template!'; die();}

	foreach ($errors as $error) {
		$output.="<p><b>Error:</b> $error</p>\n";
		}		
	
	if (strpos($_SERVER['SCRIPT_NAME'], "admin_config.php") == 0 && strpos($_SERVER['SCRIPT_NAME'], "login.php") == 0){
		echo "<p><b>Error:</b> $error</p>\n";
 		die();
	}
}


define('The_Template', $thetemp);

if(Enable_Extra_Fields){include mnminclude.'extra_fields.php';}

// Don't touch behind this
$local_configuration = $_SERVER['SERVER_NAME'].'-local.php';
//@include($local_configuration);

include_once mnminclude.'define_tables.php';

//
// start summarization and caching of mysql data
//

	// added to replace 55 redundant queries with 1
	// used with the following functions in /lib/link.php
	//	function category_name() {
	//	function category_safe_name() {
	// cache the data if caching is enabled

		if(caching == 1){
			$db->cache_dir = mnmpath.'cache';
			$db->use_disk_cache = true;
			$db->cache_queries = true;
		}
		
		// if this query changes, be sure to change the 'clear the cache' code in admin_categories.php
		$the_cats = loadCategoriesForCache();
		$cached_categories = $the_cats;

		$db->cache_queries = false;
	
	// a simple cache type system for the users table
	// used in the read() function of /libs/user.php
	$cached_users = array();
	
	// a simple cache type system for the totals table
	// functions related to this are in /libs/html1.php	
	$cached_totals = array();

	$cached_votes = array();

	$cached_links = array();

	$cached_comments = array();

	$cached_saved_links = array();
//
// end summarization and caching of mysql data
//

ob_start();
include_once mnminclude.'db.php';
include mnminclude.'utils.php';
if(!isset($include_login) || $include_login !== false){
	// if $include_login is set to false (like in jspath.php and xmlhttp.php), then we don't
	// include login, because login will run a query right away to check user credentials
	// and these two files don't require that.
	include_once mnminclude.'login.php';
}
if (!file_exists(dirname(__FILE__) . '/languages/lang_'.$language.'.conf')) {$language = 'english';}
define('pligg_language', $language);
if (!file_exists(dirname(__FILE__) . '/languages/lang_'.$language.'.conf')) {die('The language file /languages/lang_' . $language . '.conf does not exist. Either this file is missing or you did not rename lang.conf after an upgrade. Try renaming /languages/lang.conf to /languages/lang_' . $language . '.conf.');}

include_once(mnmmodules . 'modules_init.php');
include mnminclude.'utf8/utf8.php';
include_once(mnminclude.'dbtree.php');


function loadCategoriesForCache($clear_cache = false) {
	global $db;
	$sql = "select * from ".table_categories." ORDER BY lft ASC;";
	if ($clear_cache)
	$db->un_cache($sql);
	return $db->get_results($sql);
}

?>
