<?php

include_once(realpath(dirname(__FILE__)) . '/GlobalStatEngine.php');

include_once(realpath(dirname(__FILE__)) . '/../config.php');
//include('config.php');

include_once(realpath(dirname(__FILE__)) . '/../Smarty.class.php');
$main_smarty = new Smarty;


include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'smartyvariables.php');


// breadcrumbs and page title
$navwhere['text1'] = $main_smarty->get_config_vars('PLIGG_Visual_Breadcrumb_SiteStatistics');
$navwhere['link1'] = getmyurl('global_statistics', '');
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', $main_smarty->get_config_vars('PLIGG_Visual_Breadcrumb_SiteStatistics'));
$main_smarty = do_sidebar($main_smarty);

// pagename
define('pagename', 'globalStatistics'); 
$main_smarty->assign('pagename', pagename);


$globalStatEngine = new GlobalStatEngine();
$outputs= $globalStatEngine->GetGlobalStatisticsSummary();

$main_smarty->assign('numberOfStories', $outputs->numberOfStories);
$main_smarty->assign('numberOfDvariables', $outputs->numberOfDvariables);
$main_smarty->assign('numberOfRelationships', $outputs->numberOfRelationships);
$main_smarty->assign('numberOfRecords', $outputs->numberOfRecords);
$main_smarty->assign('numberOfUsers', $outputs->numberOfUsers);

$main_smarty->assign('tpl_center', $the_template . '/global_statistics_center');
$main_smarty->display($the_template . '/pligg.tpl');

?>