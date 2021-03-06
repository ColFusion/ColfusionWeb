<?php
    include_once('../Smarty.class.php');
    $main_smarty = new Smarty;

    include('../config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'smartyvariables.php');

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

<!--
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Group chat</title>

<link rel="stylesheet" type="text/css" href="../css/jScrollPane.css" />
<link rel="stylesheet" type="text/css" href="../css/chat_page.css" />
<link rel="stylesheet" type="text/css" href="../css/chat.css" />

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script src="../javascripts/jquery.mousewheel.js"></script>
<script src="../javascripts/jScrollPane.min.js"></script>
<script src="../javascripts/chat_script.js"></script>

</head>

<body>

<div id="chatContainer">

    <div id="chatTopBar" class="rounded"></div>
    <div id="chatLineHolder"></div>
    
    <div id="chatUsers" class="rounded"></div>
    <div id="chatBottomBar" class="rounded">
    	<div class="tip"></div>
        
        <form id="loginForm" method="post" action="">
            <input id="name" name="name" class="rounded" maxlength="16" value="<?php echo $_GET['name']?>" readonly/>
            <input id="email" name="email" class="rounded" value="<?php echo $_GET['email']?>" readonly/>
            <input type="submit" class="blueButton" value="Login" />
        </form>
        <script type="text/javascript">
            $(document).ready(function(){
                $('#loginForm').submit();
            });
        </script>
        <form id="submitForm" method="post" action="">
            <input id="chatText" name="chatText" class="rounded" maxlength="255" />
            <input type="submit" class="blueButton" value="Submit" />
        </form>
        
    </div>
    
</div>

</body>
</html>
-->