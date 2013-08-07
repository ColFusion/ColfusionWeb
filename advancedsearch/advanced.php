<html>
<head>
    <link rel="stylesheet" href="searchCSS.css" />
    <link rel="stylesheet" href="bootstrap.css" />
    <link rel="stylesheet" href="bootstrap-responsive.css" />
    <link rel="stylesheet" type="text/css" href="../css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="../css/dataTableModel.css" />
    <style type="text/css">
        #advancedsearch table{
            vertical-align: middle;
        }

        #advancedsearch table input, table select{
            margin-bottom: 0 !important;
        }

        #advancedsearch td {
            height: 40px;
        }

        .addFilterBtn:hover, .removeFilterBtn:hover{
            cursor:pointer;
        }
                 
        .tableNameText, .columnText{
            color: black;
        }
    </style>

    <script type="text/javascript" src="jquery-1.9.1.js"></script>
    <script type="text/javascript" src="bootstrap.min.js"></script>
    <script type="text/javascript" src="searchJS.js"></script>
    <script type="text/javascript" src="../javascripts/persist-min.js"></script>
    <script type="text/javascript" src="../javascripts/knockout-2.3.0.js"></script>
    <script type="text/javascript" src="../javascripts/knockout.mapping.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/AdvancedSearchViewModel.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/DataPreviewViewModel.js"></script>
    <script type="text/javascript" src="../javascripts/dataSourceUtil.js"></script>
    <script type="text/javascript">
            $(function() {
                var advancedSearchViewModel = new AdvancedSearchViewModel();
                ko.applyBindings(advancedSearchViewModel, document.getElementById('advanced'));
            });
    </script>
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
