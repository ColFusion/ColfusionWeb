{literal}
<script type="text/javascript">
	function show_detail()
		{		
				document.getElementById('btn_show').style.display='none';
				document.getElementById('btn_hide').style.display='block';
				document.getElementById('details').style.display='block';													
		}

    function hide_detail()
		{		
				document.getElementById('btn_show').style.display='block';
				document.getElementById('btn_hide').style.display='none';
				document.getElementById('details').style.display='none';													
		}

</script>
{/literal}


{*Step 2 Errors*}

<fieldset>
{if $submit_error eq 'wrongtype'}
	<p class="error">WRONG FILE TYPE: only .ktr file can be accepted</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="javascript:gPageIsOkToExit=true;window.history.go(-1);" value="{#PLIGG_Visual_Submit2Errors_Back#}" class="submit">
	</form>
{/if}


{if $submit_error eq 'mysql_error'}
	<p class="error">{$mysql_error}{#PLIGG_Visual_Submit2Errors_InvalidURL#}{if $submit_url eq "http://"}. {#PLIGG_Visual_Submit2Errors_InvalidURL_Specify#}{else}: {$submit_url}{/if}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="javascript:gPageIsOkToExit=true;window.history.go(-1);" value="{#PLIGG_Visual_Submit2Errors_Back#}" class="submit">
	</form>
{/if}

{if $submit_error eq 'wronglocation'}
	<p class="error">{$location_error}{#PLIGG_Visual_Submit2Errors_InvalidURL#}{if $submit_url eq "http://"}. {#PLIGG_Visual_Submit2Errors_InvalidURL_Specify#}{else}: {$submit_url}{/if}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="javascript:gPageIsOkToExit=true;window.history.go(-1);" value="{#PLIGG_Visual_Submit2Errors_Back#}" class="submit">
	</form>

{/if}

{if $submit_error eq 'wrongktr'}
	<p class="error">Error Message:<br />{$mysql_error}</p>
	<div id="details" class="error" style="display:none">Error Details:<br />{{$mysql_errordetail}</div>
    <center><table><tr>
	<td>
	   <input id="btn_show" class="button_max" style="display:block" type="submit" value="Show Detailed Error" onClick="show_detail()" />
       <input id="btn_hide" class="button_max" style="display:none" type="submit" value="Hide Detailed Error" onClick="hide_detail()" />
    </td></tr>
	
	<tr><td><center><form id="thisform">
		<input type=button onclick="javascript:gPageIsOkToExit=true;window.history.go(-1);" value="{#PLIGG_Visual_Submit2Errors_Back#}" class="submit" />
	</center></form></td>
	</tr></table></center>
{/if}

{checkActionsTpl location="tpl_pligg_submit_error_2"}

{*Step 3 Errors*}

{if $submit_error eq 'badkey'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_BadKey#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'hashistory'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_HasHistory#}: {$submit_error_history}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'urlintitle'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_URLInTitle#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'incomplete'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_Incomplete#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'long_title'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_Long_Title#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'long_content'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_Long_Content#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'long_tags'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_Long_Tags#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'long_summary'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_Long_Summary#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{if $submit_error eq 'nocategory'}
	<p class="error">{#PLIGG_Visual_Submit3Errors_NoCategory#}</p>
	<br/>
	<form id="thisform">
		<input type="button" onclick="gPageIsOkToExit=true; document.location.href='{$my_base_url}{$my_pligg_base}/{$pagename}.php?id={$link_id}';" value="{#PLIGG_Visual_Submit3Errors_Back#}" class="submit" />
	</form>
{/if}

{checkActionsTpl location="tpl_pligg_submit_error_3"}

</fieldset>
