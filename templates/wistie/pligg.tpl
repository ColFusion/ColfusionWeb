<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="{#PLIGG_Visual_Language_Direction#}" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
	{checkActionsTpl location="tpl_pligg_head_start"}
	{include file="meta.tpl"}

	<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/style.css" media="screen" />
	{if $pagename eq "submit"}<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/wick.css" />{/if}

	<link href="{$my_pligg_base}/templates/{$the_template}/css/image-slider.css" rel="stylesheet" type="text/css" />
	<link href="{$my_pligg_base}/css/chat_reset.css" rel="stylesheet" type="text/css" />
	<link href="{$my_pligg_base}/css/chat_indexchat.css" rel="stylesheet" type="text/css" />

	<!------------------------------------------------------------------------>
	<!--link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/dropdown.css" media="screen" /-->
	<!--link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/dropdown-default.css" media="screen" /-->
	<!------------------------------------------------------------------------>

	<script src="{$my_pligg_base}/templates/{$the_template}/js/image-slider.js" type="text/javascript"></script>

	{if not $no_jquery_in_pligg}
		<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.min.js"></script>
	{/if}
	<script src="{$my_pligg_base}/javascripts/jquery.form.js"></script>

	{if $Voting_Method eq 2}
		<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/star_rating/star.css" media="screen" />
	{/if}

	{checkForCss}
	{checkForJs}		

	{if $pagename neq "published" && $pagename neq "upcoming"}
		{if $Spell_Checker eq 1}			
			<script src="{$my_pligg_base}/3rdparty/speller/spellChecker.js" type="text/javascript"></script>
		{/if}
	{/if}	

	{if preg_match('/index.php$/',$templatelite.server.SCRIPT_NAME)}	
		{if $get.category}
			{if $get.page>1}
				<title>{$navbar_where.text2} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Breadcrumb_Published_Tab#} | {#PLIGG_Visual_Name#}</title>
			{else}
				<title>{$navbar_where.text2} | {#PLIGG_Visual_Breadcrumb_Published_Tab#} | {#PLIGG_Visual_Name#}</title>
			{/if}
		{elseif $get.page>1}
			<title>{#PLIGG_Visual_Breadcrumb_Published_Tab#} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Name#}</title>
		{else}
			<title>{#PLIGG_Visual_Name#} - {#PLIGG_Visual_RSS_Description#}</title>
		{/if}
	{elseif preg_match('/upcoming.php$/',$templatelite.server.SCRIPT_NAME)}	
		{if $get.category}
			{if $get.page>1}
				<title>{$navbar_where.text2} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Breadcrumb_Unpublished_Tab#} | {#PLIGG_Visual_Name#}</title>
			{else}
				<title>{$navbar_where.text2} | {#PLIGG_Visual_Breadcrumb_Unpublished_Tab#} | {#PLIGG_Visual_Name#}</title>
			{/if}
		{elseif $get.page>1}
			<title>{#PLIGG_Visual_Breadcrumb_Unpublished_Tab#} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Name#}</title>
		{else}
			<title>{#PLIGG_Visual_Breadcrumb_Unpublished_Tab#} | {#PLIGG_Visual_Name#}</title>
		{/if}
	{elseif preg_match('/submit.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>{#PLIGG_Visual_Submit#} | {#PLIGG_Visual_Name#}</title>
	{elseif preg_match('/editlink.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>{#PLIGG_Visual_EditStory_Header#}: {$submit_url_title} | {#PLIGG_Visual_Name#}</title>
	{elseif preg_match('/advancedsearch.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>{#PLIGG_Visual_Search_Advanced#} | {#PLIGG_Visual_Name#}</title>
	{elseif preg_match('/search.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>{#PLIGG_Visual_Search_SearchResults#} '{if $get.search}{$get.search}{else}{$get.date}{/if}' | {#PLIGG_Visual_Name#}</title>

	{elseif preg_match('/searchbycategory.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>Search by Category | {#PLIGG_Visual_Name#}</title>

	{elseif preg_match('/groups.php$/',$templatelite.server.SCRIPT_NAME)}	
		{if $get.page>1}
			<title>{#PLIGG_Visual_Groups#} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Name#}</title>
		{else}
			<title>{#PLIGG_Visual_Groups#} | {#PLIGG_Visual_Name#}</title>
		{/if}
	{elseif preg_match('/editgroup.php$/',$templatelite.server.SCRIPT_NAME)}	
		<title>{$group_name} | {#PLIGG_Visual_Name#}</title>
	{elseif preg_match('/group_story.php$/',$templatelite.server.SCRIPT_NAME)}	
		{if $groupview!='published'}
			{if $groupview eq "upcoming"}
				{assign var='tview' value=#PLIGG_Visual_Group_Upcoming#}
			{elseif $groupview eq "shared"}
				{assign var='tview' value=#PLIGG_Visual_Group_Shared#}
			{elseif $groupview eq "members"}
				{assign var='tview' value=#PLIGG_Visual_Group_Member#}
			{/if}

			{if $get.page>1}
				<title>{$group_name} | {if $get.category}{$navbar_where.text2} | {/if}{$tview} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Name#}</title>
			{else}
				<title>{$group_name} | {if $get.category}{$navbar_where.text2} | {/if}{$tview} | {#PLIGG_Visual_Name#}</title>
			{/if}
		{elseif $get.page>1}
			<title>{$group_name} | {#PLIGG_Page_Title#} {$get.page} | {#PLIGG_Visual_Name#}</title>
		{else}
			<title>{$group_name} - {$group_description} | {#PLIGG_Visual_Name#}</title>
		{/if}
	{elseif $pagename eq "register_complete"}
		<title>{#PLIGG_Validate_user_email_Title#} | {#PLIGG_Visual_Name#}</title>
	{elseif $pagename eq "404"}
		<title>{#PLIGG_Visual_404_Error#} | {#PLIGG_Visual_Name#}</title>
	{else}	
		<title>{$posttitle} | {$pretitle} {#PLIGG_Visual_Name#}</title>
	{/if}

	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="{$my_base_url}{$my_pligg_base}/rss.php"/>
	<link rel="icon" href="{$my_pligg_base}/favicon.ico" type="image/x-icon"/>

	
	{if $pagename eq 'published'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}/{$navbar_where.text2}/" />{/if}
	{if $pagename eq 'index'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}/" />{/if}
	{if $pagename eq 'story'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}{$navbar_where.link2}" />{/if}
	
	{checkActionsTpl location="tpl_pligg_head_end"}
	
	<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/vis.js">

	<?php include_once(realpath(dirname(__FILE__)) . "/../../analyticstracking.php") ?>
</head>

<body dir="{#PLIGG_Visual_Language_Direction#}" {$body_args}>
	{checkActionsTpl location="tpl_pligg_body_start"}

	{literal}
		<script type="text/javascript" language="JavaScript">
			function checkForm() {
				answer = true;
				if (siw && siw.selectingSomething)
					answer = false;
				return answer;
			}
		</script>
	{/literal}

	{checkActionsTpl location="tpl_pligg_banner_top"}

	{include file=$tpl_header.".tpl"}

	<!-- START CONTENT -->
	<div id="content" style="z-index: 1;">

		<!-- START MAIN COLUMN -->
		{if $pagename eq "submit" || $pagename eq "home" || $pagename eq "advancedsearch" || $pagename eq "user_guide" || $pagename eq "uploadlocalfile" || $pagename eq "story" || $pagename eq "visualization"}
			<div id="leftcol-superwide">
		{else}
			<div id="leftcol-wide">
		{/if}

			{if $pagename eq "group_story"}
				<div id="group_navbar"></div>
			{/if}

			{*include file="templates/".$the_template"/page_title.tpl"*}
			
			{checkActionsTpl location="tpl_pligg_content_start"}

			{checkActionsTpl location="tpl_pligg_above_center"}

			{include file=$tpl_center.".tpl"}

			{checkActionsTpl location="tpl_pligg_below_center"}

			{checkActionsTpl location="tpl_pligg_content_end"}
		</div>
		<!-- END MAIN COLUMN -->

		{checkActionsTpl location="tpl_pligg_columns_start"}

		{if $pagename neq "story" && $pagename neq "submit" && $pagename neq "profile" && $pagename neq "login" && $pagename neq "register" && $pagename neq "edit"}
		{/if}

		{if $pagename neq "submit" && $pagename neq "story" &&  $pagename neq "home" && $pagename neq "advancedsearch" && $pagename neq "user_guide" && $pagename neq "uploadlocalfile" && $pagename neq "visualization" && $pagename neq "notification" && $pagename neq "chat"}
			<!-- START RIGHT COLUMN -->
			<div id="rightcol">
				{include file=$tpl_right_sidebar".tpl"}
			</div>
			<!-- END RIGHT COLUMN -->
		{/if}
		<!--
		{if $pagename eq "chat"}
			START CHAT SIDEBAR 
			<div id="rightcol">
				{include file=$tpl_chat_sidebar".tpl"}
			</div>
			END CHAT SIDEBAR 
		{/if}-->

		{checkActionsTpl location="tpl_pligg_banner_bottom"}

		{include file=$tpl_footer.".tpl"}
	</div>
	<!-- END CONTENT -->
	<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-migrate-1.2.1.min.js"></script>
	<script type="text/javascript" src="{$my_pligg_base}/javascripts/index_chat/jquery.ajax_chat.js?<?php echo $rndnumber; ?>"></script>
	<script type="text/javascript" src="{$my_pligg_base}/javascripts/index_chat/own_id.inc.php"></script>
	<div style="position: absolute; top: 0px; right: 0px; z-index: 100; width: 150px; height: 300px; border: none;">
		{php}
			$sql_username = 'root';
			$sql_password = '';
			$database = 'colfusion_chat';
			//connect to MySQL	
			$mysql['connection_id'] = mysql_connect('localhost',$sql_username, $sql_password);
			mysql_select_db($database);

			mysql_query("set names utf8");

			global $current_user;
		    if($current_user->user_login != null){
		    	$_SESSION['username'] = $current_user->user_login; 
		    	$_SESSION['user_id'] = $current_user->user_id;
		    	$own_id = $_SESSION['user_id'];
		    			

			    //load users from database
				$users = mysql_query("SELECT id,username FROM `colfusion_chat`.`index_users` WHERE id!='".$_SESSION['user_id']."' HAVING id IN (SELECT `friend_to` FROM `colfusion`.`colfusion_friends` WHERE `friend_from`=".$_SESSION['user_id'].")");
				print '<div class="chat_user_bg">Friends<div>';
				if(mysql_num_rows($users) > 0){
					while($user = mysql_fetch_assoc($users)){
						//ALT tag contains user ID and user name 
						print '<div class="chat_user_bg hasFriends"><a href="#" alt="'.$user['id'].'|'.$user['username'].'" class="chat_user">'.$user['username'].'</a></div>';
					}
				}
				else
					print '<div class="chat_user_bg">You do not have any friend yet.<div>';
			}
			if (isset($_SESSION['chatbox_status'])) {
				print '<script type="text/javascript">';
				print '$(function() {';
				foreach ($_SESSION['chatbox_status'] as $openedchatbox) {
					print 'PopupChat('.$openedchatbox['partner_id'].',"'.$openedchatbox['partner_username'].'",'.$openedchatbox['chatbox_status'].');';
				}
				print "});";
				print '</script>';
			}
		{/php}
	</div>
	<div id="player_div"></div>
	<script src="{$my_pligg_base}/templates/xmlhttp.php" type="text/javascript"></script> {* this line HAS to be towards the END of pligg.tpl *}
</body>

</html>