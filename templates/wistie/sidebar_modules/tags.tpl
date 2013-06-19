{php}
	include_once(mnminclude.'tags.php');
	global $main_smarty;
	
	$cloud=new TagCloud();
	$cloud->smarty_variable = $main_smarty; // pass smarty to the function so we can set some variables
	$cloud->word_limit = tags_words_limit_s;
	$cloud->min_points = tags_min_pts_s; // the size of the smallest tag
	$cloud->max_points = tags_max_pts_s; // the size of the largest tag
	
	$cloud->show();
	$main_smarty = $cloud->smarty_variable; // get the updated smarty back from the function
{/php}

<div class="sidebar-headline">
	<div class="sidebartitle"><img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;<a href="{$URL_tagcloud}">{#PLIGG_Visual_Top_5_Tags#}</a></div>
</div>

{checkActionsTpl location="tpl_widget_tags_start"}

<div class="sidebar-content tagformat">
	{section name=customer loop=$tag_number}
		
		<span style="font-size: {$tag_size[customer]}pt">
			<a href="{$tag_url[customer]}">{$tag_name[customer]}</a>
		</span>
		
	{/section}
	{checkActionsTpl location="tpl_widget_tags_end"}
</div>