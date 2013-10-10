<html>
	<head>
		<script type="text/javascript" src="../javascripts/jquery-1.9.1.js"></script>  
    	<script type="text/javascript" src="../javascripts/knockout-2.3.0.js"></script>
    	<script type="text/javascript" src="../javascripts/knockout_models/Notification_model.js"></script>
    	
	</head>
<body>
    <?php
    include_once('../Smarty.class.php');
    $main_smarty = new Smarty;

    include('../config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'smartyvariables.php');

    // breadcrumbs and page titles
    $navwhere['text1'] = 'notification';
    $navwhere['link1'] = 'hightlight.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'notification');
    $main_smarty->assign('value',$rst);

    // pagename
    define('pagename', 'notification');
    $main_smarty->assign('pagename', pagename);

    //sidebar
    $main_smarty = do_sidebar($main_smarty);

    $main_smarty->assign('tpl_center', $the_template . '/notification');
    $main_smarty->assign('no_jquery_in_pligg', true);
    $main_smarty->display($the_template . '/pligg.tpl');

    ?>
    <script type="text/javascript">
            $(function() {
                //var NotificationViewModel = new NotificationViewModel();
                ko.cleanNode(document.getElementById('notification'));
                ko.applyBindings(new NotificationViewModel, document.getElementById('notification'));
            });
    	</script>
</body>
</html>
