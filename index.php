<?php
    //the source code displays the page for searching by category
    
    include_once('Smarty.class.php');
    $main_smarty = new Smarty;
    
    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'tags.php');
    include(mnminclude.'user.php');
    include(mnminclude.'smartyvariables.php');
    
    // breadcrumbs and page titles
    $navwhere['text1'] = 'Home Page';
    $navwhere['link1'] = 'index.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'Homepage');
    
    //pagename
    define('pagename', 'home');
    $main_smarty->assign('pagename', pagename);
    
    //sidebar
    $main_smarty = do_sidebar($main_smarty);
    
    // pagename 
    define('pagename', 'home');
    $main_smarty->assign('pagename', pagename);

    //show the template
    $main_smarty->assign('tpl_center', $the_template . '/index_center');
    $main_smarty->display($the_template . '/pligg.tpl');
?>