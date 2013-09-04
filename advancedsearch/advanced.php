<html>
<head>
    <link rel="stylesheet" href="searchCSS.css" />
    <link rel="stylesheet" href="bootstrap.css" />
    <link rel="stylesheet" href="bootstrap-responsive.css" />
    <link rel="stylesheet" type="text/css" href="../css/font-awesome.css" />
    <link rel="stylesheet" href="bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="../css/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <link rel="stylesheet" href="../css/parsley.css" />
    <link rel="stylesheet" href="../css/parsley_custom.css" />
    <link rel="stylesheet" href="../css/dataTableModel.css" />
    <link rel="stylesheet" href="../css/advanced.css" />
    <link rel="stylesheet" href="../css/relationship.css" />
    <link rel="stylesheet" href="../css/addRelationship.css" />
    <link rel="stylesheet" href="../css/relGraph.css" />
    <style>        
        .fromLinkPartWrapper, .toLinkPartWrapper {
            width: 42%;
        }
        
        .mergePercentageTextWrapper {
            width: 5%;
        }
    </style>

    <script type="text/javascript" src="../javascripts/classify.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.mousewheel.js"></script>
    <script type="text/javascript" src="../javascripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="../javascripts/parsley.min.js"></script>
    <script type="text/javascript" src="../javascripts/persist-min.js"></script>
    <script type="text/javascript" src="../javascripts/cytoscape.js-2.0.2/cytoscape.js"></script>
    <script type="text/javascript" src="../javascripts/knockout-2.3.0.js"></script>
    <script type="text/javascript" src="../javascripts/knockout.mapping.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/Utils.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/AdvancedSearchViewModel.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/DataPreviewViewModel.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/RelationshipViewModel.js"></script>
    <script type="text/javascript" src="../javascripts/knockout_models/RelationshipModel.js"></script>
    <script type="text/javascript" src="../javascripts/dataSourceUtil.js"></script>
    <script type="text/javascript" src="../javascripts/generalUtils.js"></script>
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
    $main_smarty->assign('no_jquery_in_pligg', true);
    $main_smarty->display($the_template . '/pligg.tpl');
    ?>
</body>
</html>
