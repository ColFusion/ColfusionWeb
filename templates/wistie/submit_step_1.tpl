<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery/jquery.js"></script><script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery/jquery.blockUI.js"></script>{literal}<script type="text/javascript">function blockUI()		{			$.blockUI({ message: '<div>Uploading...</div>'});			}function goBack()  {        var ref = document.referrer;        //alert(ref);             if(ref != null)        {        	if (ref.indexOf("html") != -1)            {                          	    window.location.href = "http://colfusion.exp.sis.pitt.edu/colfusion/index.php";      	            }            else        	    window.history.back();        }        else	        {         	//alert("No previous URL!");        	window.location.href = "http://colfusion.exp.sis.pitt.edu/colfusion/index.php";        }  }</script>{/literal}<div id="submit">	<div id="submit_content">		<!--h2>{#PLIGG_Visual_Submit1_Instruct#}:</h2>		{checkActionsTpl location="tpl_pligg_submit_step1_start"}		<!--ul class="instructions">			{if #PLIGG_Visual_Submit1_Instruct_1A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_1A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_1B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_2A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_2A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_2B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_3A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_3A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_3B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_4A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_4A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_4B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_5A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_5A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_5B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_6A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_6A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_6B#}</li>{/if}			{if #PLIGG_Visual_Submit1_Instruct_7A# ne ''}<li><strong>{#PLIGG_Visual_Submit1_Instruct_7A#}:</strong> {#PLIGG_Visual_Submit1_Instruct_7B#}</li>{/if}		</ul-->		<p>If you will share local data, please click <a href="{$my_base_url}{$my_pligg_base}/upload_file.php">here</a> to upload your file first.</p>		{checkActionsTpl location="tpl_pligg_submit_step1_middle"}		<h2>{#PLIGG_Visual_Submit1_NewsSource#}</h2>		<form action="{$URL_submit}" method="post" enctype="multipart/form-data" id="thisform">			<label for="wrapper">{#PLIGG_Visual_Submit1_NewsURL#}:</label>			<input type="file" name="wrapper" id="wrapper" size="55" />			<br/ >			{checkActionsTpl location="tpl_pligg_submit_step1_end"}							<input type="hidden" name="phase" value=1>			<input type="hidden" name="randkey" value="{$submit_rand}">			<input type="hidden" name="id" value="c_1">			<input type="submit" value="{#PLIGG_Visual_Submit1_Continue#}" class="submit-s" onclick='blockUI()'/>					</form>		<br />		<center><input type="button" value="Back" onclick="goBack()"></center>		{if $Submit_Require_A_URL neq 1}{#PLIGG_Visual_Submit_Editorial#}{/if}	</div></div>