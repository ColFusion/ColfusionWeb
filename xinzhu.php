﻿<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'smartyvariables.php');

// breadcrumbs and page titles
$navwhere['text1'] = 'Linqing';
$navwhere['link1'] = 'linqing.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'Linqing');
$main_smarty->assign('category_option', $category_option );

$output = '';

$formula = $db->get_results("SELECT * FROM " . table_formulas );
foreach($formula as $formulas)
{
	$output .= "<tr style='background-color:#F2F2F2' height='40px'><td>" . $formulas->id . " </td>";
	$output .= "<td>" . $formulas->type . " </td>";
	$output .= "<td>" . $formulas->enabled . " </td>";
	$output .= "<td>" . $formulas->title . " </td>";
	$output .= "<td>" . $formulas->formula . " </td></tr>";
}

$main_smarty->assign('output',$output); 

//pagename
define('pagename', 'home');
$main_smarty->assign('pagename', pagename);
    
//sidebar
$main_smarty = do_sidebar($main_smarty);
    
//show the template
$main_smarty->assign('tpl_center', $the_template . '/linqing_center');
$main_smarty->display($the_template . '/pligg.tpl');

?>