<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'smartyvariables.php');

// breadcrumbs and page titles
$navwhere['text1'] = 'Visualization';
$navwhere['link1'] = 'visualization.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'Visualization');
$main_smarty->assign('category_option', $category_option );



//pagename
define('pagename', 'visualization');
$main_smarty->assign('pagename', pagename);
    
//sidebar
//$main_smarty = do_sidebar($main_smarty);
    
//show the template
$main_smarty->assign('tpl_center', $the_template . '/visualization_center');
$main_smarty->display($the_template . '/pligg.tpl');

?>