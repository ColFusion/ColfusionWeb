<!DOCTYPE html>
<html>
<head>
	{checkActionsTpl location="tpl_pligg_head_start"}

	{include file="meta.tpl"}

	<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/style.css" media="screen" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="{$my_base_url}{$my_pligg_base}/rss.php"/>	
	<link rel="shortcut icon" href="{$my_pligg_base}/Cicon.png" >
	<link rel="icon" href="{$my_pligg_base}/Cicon.png" >
	
	{if $pagename eq 'published'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}/{$navbar_where.text2}/" />{/if}
	{if $pagename eq 'index'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}/" />{/if}
	{if $pagename eq 'story'}<link rel="canonical" href="{$my_base_url}{$my_pligg_base}{$navbar_where.link2}" />{/if}

	{if $Voting_Method eq 2}
		<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/css/star_rating/star.css" media="screen" />
	{/if}	

	{checkForCss}

	{if $tpl_cssInHTMLHead|count_characters > 0}
		{include file=$tpl_cssInHTMLHead.".tpl"}
	{/if}

	<script type="text/javascript" src="{$my_pligg_base}/javascripts/global.js"></script> 

	{* For Google Analytics *}
	{literal}
	<script>
		  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		  ga('create', 'UA-44682006-1', 'pitt.edu');
		  ga('send', 'pageview');

	</script>
	{/literal}
	

	{* Need to Move all the way to the bottom of the page *}
	{if not $no_jquery_in_pligg}
		<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.min.js"></script>
	{/if}

	{checkForJs}		

	{if $pagename neq "published" && $pagename neq "upcoming"}
		{if $Spell_Checker eq 1}			
			<script src="{$my_pligg_base}/3rdparty/speller/spellChecker.js" type="text/javascript"></script>
		{/if}
	{/if}	
	
    {if $tpl_jsFilesAtBottom}
		{include file=$tpl_jsFilesAtBottom.".tpl"}
	{/if}

	<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery.form.js"></script> 
	<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/vis.js"></script>

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

	{checkActionsTpl location="tpl_pligg_head_end"}
</head>
<body dir="{#PLIGG_Visual_Language_Direction#}" {$body_args}>


	{checkActionsTpl location="tpl_pligg_body_start"}
	       
    {checkActionsTpl location="tpl_pligg_banner_top"}
   
   	{include file=$tpl_header.".tpl"}

	<!-- START CONTENT -->
    <div id="content">

		<!-- START MAIN COLUMN -->
        {if $pagename eq "submit" || $pagename eq "home" || $pagename eq "advancedsearch" || $pagename eq "user_guide" || $pagename eq "uploadlocalfile" || $pagename eq "story" || $pagename eq "visualization"}
            <div id="leftcol-superwide">
        {else}
            <div id="leftcol-wide">
        {/if}
			
	        {if $pagename eq "group_story"}
	        	<div id="group_navbar">
	        	</div>
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
	
		{if $pagename neq "submit" && $pagename neq "story" &&  $pagename neq "home" && $pagename neq "advancedsearch" && $pagename neq "user_guide" && $pagename neq "uploadlocalfile" && $pagename neq "visualization"}
		<!-- START RIGHT COLUMN -->
			<div id="rightcol">
				{include file=$tpl_right_sidebar".tpl"}
			</div>
		<!-- END RIGHT COLUMN -->
		{/if}	

		{checkActionsTpl location="tpl_pligg_columns_end"}	

		{include file=$tpl_footer.".tpl"}	
	</div>	
	<!-- END CONTENT --> 
	
	


	

	{* this line HAS to be towards the END of pligg.tpl *}
	<script src="{$my_pligg_base}/templates/xmlhttp.php" type="text/javascript"></script> 
	
	{checkActionsTpl location="tpl_pligg_body_end"}
</body>
</html>
