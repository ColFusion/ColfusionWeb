<div class="pagewrap">

{literal}
<script>
function advsubmit(form){
	if(document.getElementById('search').value) {
		form.submit();
	} else {
		document.getElementById('response').style.color = '#a44848';
		document.getElementById('search').focus();	
	}
}

    function goBack()
        {
            window.history.back()
        }
/*function SEO2submit(form)
{
    var datastr = '';
    var fields  = form.getElementsByTagName('INPUT');
    for (var i=0; i<fields.length; i++)
     	if (fields[i].type=="text")
	    if (fields[i].name=="search")
	    	datastr += (fields[i].value ? encodeURIComponent(fields[i].value) : '-') + '/';
	    else
	    	datastr += fields[i].name + '/' + encodeURIComponent(fields[i].value) + '/';
     	else if (fields[i].type=="radio" && fields[i].checked)
	    datastr += fields[i].name + '/' + encodeURIComponent(fields[i].value) + '/';
    fields  = form.getElementsByTagName('SELECT');
    for (var i=0; i<fields.length; i++)
     	    for (var j=0; j<fields[i].length; j++)
		if (fields[i][j].selected)
	    	    datastr += fields[i].name + '/' + encodeURIComponent(fields[i][j].value) + '/';

	document.location.href=form.action+datastr+'adv/1';
}*/
</script>
{/literal}

<div id="categories">
	<h2 id="cattitle">Search by Categories</h2>
    <ul>
    {section name=thecat loop=$cat_array}
        {if $lastspacer eq ""}{assign var=lastspacer value=$cat_array[thecat].spacercount}{/if}
        {if $cat_array[thecat].auto_id neq 0}

        {if $cat_array[thecat].spacercount < $submit_lastspacer}</ul></li>{/if}
        {if $cat_array[thecat].spacercount > $submit_lastspacer}<ul>{/if}

        <li{if $cat_array[thecat].principlecat neq 0} class="dir"{/if}>
            <a href="{$URL_queuedcategory, $cat_array[thecat].safename}{php}
                    global $URLMethod;
                    if ($URLMethod==2) print "/";
                {/php}">{$cat_array[thecat].name}</a>
        {if $cat_array[thecat].principlecat eq 0}</li>{else}{/if}{assign var=submit_lastspacer value=$cat_array[thecat].spacercount}{/if}
    {/section}
    {checkActionsTpl location="tpl_widget_categories_end"}
    {if $cat_array[thecat].spacercount < $submit_lastspacer}{$lastspacer|repeat_count:'</ul></li>'}{/if}
    </ul>
</div>

<div id="detailed">
<h2 id="dettitle">Advanced Search</h2>
<form method="get" action="{$URL_search}" 
{php}
global $URLMethod;
if ($URLMethod==2) print "onsubmit='SEO2submit(this); return false;'";
{/php}
>

<div id="keyword">
<small style="float:right;">{#PLIGG_Visual_Search_Keywords_Instructions#}</small>
<label class="label" style="color: #11a3ac;">{#PLIGG_Visual_Search_Keywords#}:</label>
<input name="search" id="search" type="text" size="30"/>
<span id="response" style="margin-left: 5px;">*required</span>
<br /><br />
</div>

<div class="condition">
<label class="label">{#PLIGG_Visual_Search_Story#}:</label>
	<select name="slink">
		<option value="3" selected="selected">{#PLIGG_Visual_Search_Story_Title_and_Description#}</option>
		<option value="1">{#PLIGG_Visual_Search_Story_Title#}</option>
		<option value="2">{#PLIGG_Visual_Search_Story_Description#}</option>												
	</select>

<br /><br />
	
<label class="label">{#PLIGG_Visual_Search_Category#}:</label>
	<select name="scategory" >
		{$category_option}
	</select>

<br /><br />
	<!--label>{#PLIGG_Visual_Search_Comments#}:</label>
		<input type="radio" name="scomments" value="1" /> {#PLIGG_Visual_Search_Advanced_Yes#} &nbsp;&nbsp;<input type="radio" name="scomments" value="0" checked="checked"/> {#PLIGG_Visual_Search_Advanced_No#}
	<br /-->
	<label>{#PLIGG_Visual_Search_Tags#}:</label>
		<input type="radio" name="stags" value="1" checked="checked" /> {#PLIGG_Visual_Search_Advanced_Yes#} &nbsp;&nbsp;<input type="radio" name="stags" value="0" /> {#PLIGG_Visual_Search_Advanced_No#}
	<br /><br />

	<label>{#PLIGG_Visual_Search_User#}:</label>
		<input type="radio" name="suser" value="1" /> {#PLIGG_Visual_Search_Advanced_Yes#} &nbsp;&nbsp;<input type="radio" name="suser" value="0" checked="checked" /> {#PLIGG_Visual_Search_Advanced_No#}
	
<br /><br />
{include file=$the_template."/date_picker.tpl"}
<label>{#PLIGG_Visual_Advanced_Search_Date#}</label>
<input name="date" type="text" size="10">
<input type=button value="{#PLIGG_Visual_Advanced_Search_Select#}" onclick="displayDatePicker('date', false, 'ymd', '-');">

{php}
if (enable_group=='true') {
{/php}
<br /><br />
<label>{#PLIGG_Visual_Search_Group#}:</label>
	<select name="sgroup">
		<option value="3" selected="selected">{#PLIGG_Visual_Search_Group_Named_and_Description#}</option>
		<option value="1">{#PLIGG_Visual_Search_Group_Name#}</option>
		<option value="2">{#PLIGG_Visual_Search_Group_Description#}</option>												
	</select>
{php}	
}
{/php}
<!--label>{#PLIGG_Visual_Search_Status#}:</label>
<select name="status">
	<option value="all" selected="selected">{#PLIGG_Visual_Search_Status_All#}</option>
	<option value="published">{#PLIGG_Visual_Search_Status_Published#}</option>
	<option value="queued">{#PLIGG_Visual_Search_Status_Upcoming#}</option>												
</select-->

</div><br style="clear:both;" /><br />
<input name="adv" type="hidden" value="1" />		
<input name="advancesearch" value="&nbsp;Search&nbsp; " type="button" class="log2" onclick="advsubmit(this.form)"/>
</form>
</div>
</br></br>
<center><input type="button" value="Back" onclick="goBack()"></center>
</div>