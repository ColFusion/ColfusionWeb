<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include(mnminclude.'smartyvariables.php');

// -------------------------------------------------------------------------------------

// breadcrumbs and page titles
$navwhere['text1'] = 'user_guide';
$navwhere['link1'] = 'advancedsearch.php';//getmyurl('advancesearch', '');
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'user_guide');
$main_smarty->assign('category_option', $category_option );

// pagename
define('pagename', 'user_guide'); 
$main_smarty->assign('pagename', pagename);

// sidebar
$main_smarty = do_sidebar($main_smarty);

$main_smarty->assign('headers', $header_items);

// show the template
$main_smarty->assign('tpl_center', $the_template . '/user_guide_center');
$main_smarty->display($the_template . '/pligg.tpl');
?>