{checkActionsTpl location="tpl_pligg_story_comments_submit_start"}
<h3><a name="discuss">{#PLIGG_Visual_Comment_Send#}</a></h3>	
<div style="padding-left:10px;">
	<textarea name="comment_content" id="comment_content" class="comment-form" rows="3" style="width: 97%;"/>{if isset($TheComment)}{$TheComment}{/if}</textarea></div><br />
{if isset($register_step_1_extra)}
	<br />
	{$register_step_1_extra}
{/if}
<div style="padding-left:10px;" >
<input type="hidden" name="process" value="newcomment" />
<input type="hidden" name="randkey" value="{$randkey}" />
<input type="hidden" name="link_id" value="{$link_id}" />
<input type="hidden" name="user_id" value="{$user_id}" />
<input type="submit" name="submit" value="{#PLIGG_Visual_Comment_Submit#}" class="log2" />
</div>
{checkActionsTpl location="tpl_pligg_story_comments_submit_end"}
<br />
