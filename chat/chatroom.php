<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Group chat</title>

<link rel="stylesheet" type="text/css" href="../css/jScrollPane.css" />
<link rel="stylesheet" type="text/css" href="../css/chat.css" />

</head>

<body>
<script>
	var test = <?php 
	echo $_GET['room'];
?>;
</script>
<div id="chatContainer">

    <div id="chatLineHolder"></div>

	<div id="sidebar-header">
	    <ul>
			<li class="selected"><a>Online Users</a></li>
		</ul>
	</div>
	<div id="chatUsers" class="rounded"></div>
	

    <div id="chatBottomBar" class="rounded">
    	<div class="tip"></div>
	    <div id="submitForm">
            <input id="chatText" name="chatText" class="rounded" maxlength="255" />
            <input type="submit" id="submitButton" value="Submit" />
        </div>
        
    </div>
    
</div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script src="../javascripts/jquery.mousewheel.js"></script>
<script src="../javascripts//jScrollPane.min.js"></script>
<script src="../javascripts/knockout_models/Chat_model.js"></script>
</body>
</html>



