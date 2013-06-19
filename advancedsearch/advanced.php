<html>
	<head>
		<script type="text/javascript" src="jquery-1.9.1.js"></script>
		<script type="text/javascript" src="searchJS.js"></script>
		<link rel="stylesheet" href="searchCSS.css">
		<link rel="stylesheet" href="bootstrap.css">
		<link rel="stylesheet" href="bootstrap-responsive.css">
		<link rel="stylesheet" type="text/css" href="../css/dataTableModel.css" />
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
			$main_smarty->display($the_template . '/pligg.tpl');
		?>
	</body>
</html>