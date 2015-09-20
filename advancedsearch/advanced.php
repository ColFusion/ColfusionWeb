<?php
    include_once('../Smarty.class.php');
    $main_smarty = new Smarty;

    include('../config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'smartyvariables.php');
    // breadcrumbs and page titles
    $navwhere['text1'] = 'advanced search';
    $navwhere['link1'] = 'hightlight.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'advanced search');
    $main_smarty->assign('value',$rst);

    // pagename
    define('pagename', 'advanced search');
    $main_smarty->assign('pagename', pagename);

    //sidebar
    $main_smarty = do_sidebar($main_smarty);
    //show the template
    $main_smarty->assign('tpl_center', $the_template . '/advanced');
    $main_smarty->assign('no_jquery_in_pligg', true);
    $main_smarty->assign('tpl_jsFilesAtBottom', $the_template . '/advanced_jsFilesAtBottom');
    $main_smarty->assign('tpl_cssInHTMLHead', $the_template . '/advanced_cssInHTMLHead');
    $main_smarty->display($the_template . '/pligg.tpl');
?>