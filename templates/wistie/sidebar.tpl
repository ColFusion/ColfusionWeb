{checkActionsTpl location="tpl_pligg_sidebar_start"}

{if $pagename eq "published" || $pagename eq "upcoming" && $pagename neq "groups"}
<!-- START SORT -->
	<div class="sidebar-headline">
		<div class="sidebartitle">
			<img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;{#PLIGG_Visual_Pligg_Queued_Sort#} {#PLIGG_Visual_TopUsers_TH_News#}
		</div>
	</div>

	<div class="sidebar-content">
		<ul class="sidebarlist">
		{if $setmeka eq "" || $setmeka eq "recent"}<li id="active">
				<a id="current" href="{$index_url_recent}">
					<span class="active">{#PLIGG_Visual_Recently_Pop#}</span>
				</a>
		{else}<li>
				<a href="{$index_url_recent}">{#PLIGG_Visual_Recently_Pop#}</a>
		{/if}</li>
		
		{if $setmeka eq "today"}<li id="active" href="{$index_url_today}">
			<a href="{$index_url_today}" id="current">
					<span class="active">{#PLIGG_Visual_Top_Today#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_today}">{#PLIGG_Visual_Top_Today#}</a>
		{/if}</li>
		
		{if $setmeka eq "yesterday"}<li id="active">
			<a id="current" href="{$index_url_yesterday}">
				<span class="active">{#PLIGG_Visual_Yesterday#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_yesterday}">{#PLIGG_Visual_Yesterday#}</a>
		{/if}</li>
		
		{if $setmeka eq "week"}<li id="active">
			<a id="current" href="{$index_url_week}">
				<span class="active">{#PLIGG_Visual_This_Week#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_week}">{#PLIGG_Visual_This_Week#}</a>
		{/if}</li>
		
		{if $setmeka eq "month"}<li id="active">
			<a id="current" href="{$index_url_month}">
				<span class="active">{#PLIGG_Visual_This_Month#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_month}">{#PLIGG_Visual_This_Month#}</a>
		{/if}</li>
		
		{if $setmeka eq "year"}<li id="active">
			<a id="current" href="{$index_url_year}">
				<span class="active">{#PLIGG_Visual_This_Year#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_year}">{#PLIGG_Visual_This_Year#}</a>
		{/if}</li>
				
		{if $setmeka eq "alltime"}<li id="active">
			<a id="current" href="{$index_url_alltime}">
				<span class="active">{#PLIGG_Visual_This_All#}</span>
			</a>
		{else}<li>
			<a href="{$index_url_alltime}">{#PLIGG_Visual_This_All#}</a>
		{/if}</li>
		
		</ul>
	</div>
<!-- END SORT -->
{/if}
	
{if $pagename eq "user"}
	<div class="sidebar-headline">
		<div class="sidebartitle">
			<img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;<a href="{$user_url_personal_data}">{#PLIGG_Visual_Profile#}</a>
		</div>
	</div>

	<div class="sidebar-content" id="navcontainer">
		<ul class="sidebarlist" id="navlist">
		{checkActionsTpl location="tpl_pligg_profile_sort_start"}
		<li class="navbut{$nav_pd}"><a href="{$user_url_personal_data}"><span>{#PLIGG_Visual_User_PersonalData#}</span></a></li>
		{if $user_login eq $user_logged_in}
		<li class="navbut{$nav_set}"><a href="{$user_url_setting}"><span>{#PLIGG_Visual_User_Setting#}</span></a></li>
		{/if}
		<li class="navbut{$nav_ns}"><a href="{$user_url_news_sent}"><span>{#PLIGG_Visual_User_NewsSent#}</span></a></li>
		<li class="navbut{$nav_nu}"><a href="{$user_url_news_unpublished}"><span>{#PLIGG_Visual_User_NewsPublished#}</span></a></li>
		<li class="navbut{$nav_np}"><a href="{$user_url_news_published}"><span>{#PLIGG_Visual_User_NewsUnPublished#}</span></a></li>
		<li class="navbut{$nav_c}"><a href="{$user_url_commented}"><span>{#PLIGG_Visual_User_NewsCommented#}</span></a></li>
		<li class="navbut{$nav_nv}"><a href="{$user_url_news_voted}"><span>{#PLIGG_Visual_User_NewsVoted#}</span></a></li>
		<li class="navbut{$nav_s}"><a href="{$user_url_saved}"><span>{#PLIGG_Visual_User_NewsSaved#}</span></a></li>
		{checkActionsTpl location="tpl_pligg_profile_sort_end"}
		</ul>
	</div>
{/if}
        
{checkActionsTpl location="tpl_pligg_sidebar_middle"}

	
{*if $user_authenticated ne true} {assign var=sidebar_module value="login"}{include file=$the_template_sidebar_modules."/wrapper2.tpl"} {/if*}

{if $pagename eq "groups"}
	<!-- START GROUP SORT -->
		
	<div class="sidebar-headline">
	<div class="sidebartitle"><img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;{#PLIGG_Visual_Group_Sort#}</div>
	</div>
		<div class="sidebar-content">
			<ul class="sidebar-list">
				{checkActionsTpl location="tpl_pligg_group_sort_start"}
				{if $sortby eq "members"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Sort_Members#}
					</a></span></li>
				{else} 
					<li><a href="{$group_url_members}">
						{#PLIGG_Visual_Group_Sort_Members#}
					</a></li>
				{/if}
				{if $sortby eq "name"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Sort_Name#}
					</a></span></li> 
				{else}
					<li><a href="{$group_url_name}">
						{#PLIGG_Visual_Group_Sort_Name#}
					</a></li>
				{/if}
				{if $sortby eq "newest"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Sort_Newest#}
					</a></span></li>
				{else}
					<li><a href="{$group_url_newest}">
						{#PLIGG_Visual_Group_Sort_Newest#}
					</a></li>
				{/if}
				{if $sortby eq "oldest"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Sort_Oldest#}
					</a></span></li>
				{else}
					<li><a href="{$group_url_oldest}">
						{#PLIGG_Visual_Group_Sort_Oldest#}
					</a></li>
				{/if}
				{checkActionsTpl location="tpl_pligg_group_sort_end"}
			</ul>
		</div>
	<!-- END GROUP SORT -->
	{/if}

	 {if $pagename eq "group_story"}
	<!-- START GROUP SORT -->
		
	<div class="sidebar-headline">
	<div class="sidebartitle"><img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;{#PLIGG_Visual_Group_Sort#}</div>
	</div>
		<div class="sidebar-content">
			<ul class="sidebar-list">
				{checkActionsTpl location="tpl_pligg_group_sort_start"}
				{if $groupview eq "published"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Published#}
					</a></span></li>
				{else} 
					<li><a href="{$groupview_published}">
						{#PLIGG_Visual_Group_Published#}
					</a></li>
				{/if}
				{if $groupview eq "upcoming"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Upcoming#}
					</a></span></li> 
				{else}
					<li><a href="{$groupview_upcoming}">
						{#PLIGG_Visual_Group_Upcoming#}
					</a></li>
				{/if}
				{if $groupview eq "shared"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Shared#}
					</a></span></li>
				{else}
					<li><a href="{$groupview_sharing}"">
						{#PLIGG_Visual_Group_Shared#}
					</a></li>
				{/if}
				{if $groupview eq "members"}
					<li id="active"><span class="active"><a id="current">
						{#PLIGG_Visual_Group_Member#}
					</a></span></li>
				{else}
					<li><a href="{$groupview_members}">
						{#PLIGG_Visual_Group_Member#}
					</a></li>
				{/if}
				{checkActionsTpl location="tpl_pligg_group_sort_end"}
			</ul>
		</div>
	<!-- END GROUP SORT -->

	{/if}
	

{if $pagename neq 'user'}
	{if $Enable_Tags} {assign var=sidebar_module value="tags"}{include file=$the_template_sidebar_modules."/wrapper.tpl"} {/if}
	{checkActionsTpl location="tpl_pligg_sidebar_comments"}
{/if}

{checkActionsTpl location="tpl_pligg_sidebar_stories_u"}
{checkActionsTpl location="tpl_pligg_sidebar_stories"}
{checkActionsTpl location="tpl_pligg_sidebar_comments"}
{checkActionsTpl location="tpl_pligg_sidebar_end"}