<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Group chat</title>

<link rel="stylesheet" type="text/css" href="../css/jScrollPane.css" />
<link rel="stylesheet" type="text/css" href="../css/chatRoom.css" />

</head>

<body>
<script>
	var test = <?php echo $_GET['room']; ?>;
	var url = document.URL;
	var base = url.substring(0, url.indexOf("chat"));
</script>

<div id="chatBody">
	<!-- Chat content -->
	<div id="chatContainer">
		<div id="chatLineHolder"></div>

		<div id="chatBottomBar">
			<div class="tip"></div>
			<div id="submitForm">
				<input id="chatText" name="chatText" maxlength="255" />
				<input type="submit" id="submitButton" value="Submit" />
			</div>
		</div>
	</div>

	<!-- Online user list -->
	<div id="chatSide">
		<div id="sidebar-header">
			<ul>
				<li class="selected"><a>Online Users</a></li>
			</ul>
		</div>
		<div id="chatUsers"></div>
	</div>
</div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script src="../javascripts/jquery.mousewheel.js"></script>
<script src="../javascripts//jScrollPane.min.js"></script>
<script src="../javascripts/knockout_models/Chat_model.js"></script>
</body>
</html>