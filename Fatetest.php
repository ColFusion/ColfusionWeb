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
$navwhere['text1'] = 'Fatima';//($main_smarty->get_config_vars('PLIGG_Visual_Search_Advanced'));
$navwhere['link1'] = 'fatetest.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'Fatima');



$result= mysql_query("SELECT * FROM colfusion_modules")
 or die(mysql_error()); 

 while($info = mysql_fetch_array( $result )) 
 { 
 $rs .= "<tr>"; 
 $rs .= "<td>".$info['name'] . "</td> "; 
 $rs .= "<td>".$info['folder'] . "</td> "; 
 $rs .= "</tr>";
 } 
$main_smarty->assign('mod', $rs );
		  
$result1= mysql_query("SELECT * FROM colfusion_totals")
 or die(mysql_error()); 

 while($info = mysql_fetch_array( $result1 )) 
 { 
 $rs1 .= "<tr>"; 
 $rs1 .= "<td>".$info['name'] . "</td> "; 
 $rs1 .= "<td>".$info['total'] . "</td> "; 
 $rs1 .= "</tr>";
 } 
$main_smarty->assign('total', $rs1 );
// pagename
define('pagename', 'Fatima'); 
$main_smarty->assign('pagename', pagename);

// sidebar
$main_smarty = do_sidebar($main_smarty);

$main_smarty->assign('headers', $header_items);

// show the template
$main_smarty->assign('tpl_center', $the_template . '/fati2');
$main_smarty->display($the_template . '/pligg.tpl');
?>
