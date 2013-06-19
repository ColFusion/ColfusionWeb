
<a id="c{$comment_id}"></a>
{checkActionsTpl location="tpl_pligg_story_comments_single_start"}
<div class="comment-wrap" {if $comment_status neq "published"}style="background-color: #FFFBE4;border:1px solid #DFDFDF;"{/if}>
	<div class="comment-left"> 
		{if $UseAvatars neq "0"}<a href="{$user_view_url}"><img src="{$Avatar_ImgSrc}" align="absmiddle"/></a><br />{/if}      
	</div>

	{if $hide_comment_edit neq 'yes'}
		<div class="comment-hover">
			&nbsp;&nbsp;&nbsp;&nbsp;{$comment_content}
			<div class="subtext commenttools">			
			
			
					 	 {$comment_age} {#PLIGG_Visual_Comment_Ago#}    by
						{if $is_anonymous}<strong>{#PLIGG_Visual_Comment_Manage_Unregistered#}</strong>{/if} <span style="text-transform:capitalize"><a href="{$user_view_url}">{$user_username}</a><!-- {if $user_rank neq ''} (#{$user_rank}){/if} --></span>
						{if $isadmin eq 1}| <a href="{$my_base_url}{$my_pligg_base}/admin/admin_users.php?mode=view&user={$user_userlogin}">{#PLIGG_Visual_Comment_Manage_User#} {$user_userlogin}</a>
					| 	
					<a href="{$edit_comment_url}" style="color:#d98500;">{#PLIGG_Visual_Comment_Edit#}</a> | <a href="{$delete_comment_url}" style="color:#bc0b0b;">{#PLIGG_Visual_Comment_Delete#}</a>
				{else}	  
					{if $user_username eq 'you'}
						| <a href="{$edit_comment_url}">{#PLIGG_Visual_Comment_Edit#}</a> 
					{/if}
				{/if}
			</div>
		</div>
	{/if} 
		<br clear="all" />
</div>

{checkActionsTpl location="tpl_pligg_story_comments_single_end"}
<br clear="all" />
