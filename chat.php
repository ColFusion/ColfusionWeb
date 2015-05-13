<?php
    include_once('Smarty.class.php');
    $main_smarty = new Smarty;

    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'smartyvariables.php');
    
    global $current_user;
    if($current_user->authenticated != TRUE)
    {
        $vars = '';
        check_actions('anonymous_story_user_id', $vars);
        if ($vars['anonymous_story'] != true)
            force_authentication();
    }
    // breadcrumbs and page titles
    $navwhere['text1'] = 'chat';
    $navwhere['link1'] = 'hightlight.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'Chat');

    $main_smarty = do_sidebar($main_smarty);

    // pagename
    define('pagename', 'chat');
    $main_smarty->assign('pagename', pagename);

    $main_smarty->assign('tpl_center', $the_template . '/chat');
    $main_smarty->assign('no_jquery_in_pligg', true);
    $main_smarty->display($the_template . '/pligg.tpl');
?>