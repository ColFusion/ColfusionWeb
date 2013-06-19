<link href="bootstrap.min.css" rel="stylesheet" />
<link href="bootstrap-wizard.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/bootstrap-lightbox.min.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/dataTableModel.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/relationship.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/sourceAttachment.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/typeahead.js-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/parsley.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/parsley_custom.css" />

<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/bootstrap.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/persist-min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/parsley.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/purl.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.2.1.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/dataSourceUtil.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/dataTableModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/fileManager.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/hogan.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>


{literal}
    <style>
        #newRelationshipBtn{
            margin: 0 0 13px 15px; 
            display: block;
        }
    </style>
    <script type="text/javascript">

        var xmlhttp;

        if (window.XMLHttpRequest)
        xmlhttp = new XMLHttpRequest();
        else if (window.ActiveXObject)
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        else
        alert("Your browser does not support XMLHTTP!");

        var sid = $.url().param('title');
        var dataPreviewViewModel;
        var relationshipViewModel;

        $(document).ready(function() {

        fileManager.loadSourceAttachments(sid, $('#attachmentList'));

        $.ajax({
        type: 'POST',
        url: "DataImportWizard/dataPreviewMarkup.php",
        data: {},
        success: function(data) {
        $("#dataPreviewContainer").append(data);
        ko.applyBindings(dataPreviewViewModel, document.getElementById("dataPreviewContainer"));
        },
        dataType: 'html'
        });

        dataPreviewViewModel = new DataPreviewViewModel(sid);
        ko.applyBindings(dataPreviewViewModel, document.getElementById("mineRelationshipsContainer"));

        // Load table list.
        dataPreviewViewModel.getTablesList();

        //TODO: good candidate for ko
        dataPreviewViewModel.mineRelationships(10, 1);
        });

        window.onload = function showData()
        {
        xmlhttp.open("GET", my_pligg_base + "/display_data.php?count=5", false);
        xmlhttp.send(null);

        if (xmlhttp.responseText !== "") {
        $('#upload_result').prepend(xmlhttp.responseText);
        var dataset_title = $('#dataset_title').text();
        dataset_title = dataset_title ? dataset_title : "New Dataset";           
        $('#fromDataSetWrapper').find('.dataSetDesTable').find('.sidInput').val(dataset_title);
        }

        else {
        document.getElementById('upload_result').innerHTML = "nothing";
        }
        }


        function savefile()
        {
        var filetype = saveform.filetype.value;

        xmlhttp.open("GET", my_pligg_base + "/display_data.php?filetype=" + filetype, false);
        xmlhttp.send(null);
        alert(my_pligg_base + "/display_data.php?filetype=" + filetype);


        }
        function goBack()
        {
        window.history.back()
        }

        function dopage(url) {
        document.getElementById('upload_result').innerHTML = "Loading...";

        xmlhttp.open("GET", my_pligg_base + "/" + url, false);
        xmlhttp.send(null);

        if (xmlhttp.responseText != "")
        {
        document.getElementById('upload_result').innerHTML = xmlhttp.responseText;
        document.getElementById('btn_all').style.display = 'none';
        document.getElementById('btn_hide').style.display = 'block';
        //document.getElementById('hint').style.display='block';
        }

        else {
        document.getElementById('upload_result').innerHTML = 'nothing';
        }

        }
        function go_visualization() {
        //window.location.href = my_pligg_base+"/visualization/dashboard.php";
        titleNum = location.href.substring(location.href.indexOf("=") + 1);
        window.open(my_pligg_base + "/visualization/dashboard.php?title=" + titleNum, " _blank");
        }

    </script>

{/literal}

<div id="upload_result">	
    <table style="margin: 0 0 9px 10px;">
        <tr>
            <td class="step1_input_title" style="vertical-align: top; width: 100px;">
                <span style="margin-top: 5px; font-weight: bold">{#PLIGG_Visual_Submit2_Attachments#}:</span>
            </td>
            <td>
                <table class="fileList" id="attachmentList"> 
                    <tr id="attachmentLoadingIcon"><td><img src="{$my_pligg_base}/images/ajax-loader.gif"/></td></tr>              
                </table>       
            </td>
        </tr>
    </table>
</div>

<div id="dataPreviewContainer"> </div>

{include file='relationships.tpl'}
{include file='addRelationships.tpl'}
{literal}
<script type="text/javascript">
    $(function(){
        $('.searchDatasetBtn').prop('disabled', true);
        loadInitialFromDataSet();        
    });
</script>
{/literal}

<!--
<center><div style="padding-left:10px;"><table>
            <tr><td><input id="btn_all" class="button_max" type="submit" value="Show All Data" onclick="show_all_data()" />
                    <input id="btn_hide" class="button_max" type="submit" value="Show Less Data" onclick="show_less_data()" /></td>
                <td><form id="submitForm" action="" method="post"><input type="hidden" name="refresh" value="1"/><input id="btn_all" class="button_max" type="submit" value="Refresh" onclick="refresh_data()" />
                        <input type="button" value="Visualization" onclick="go_visualization();"></form></td>
            </tr></table></div></center>

<center>
    <form action= "" method="post" id="saveform">
        Save data as: <select name="filetype"><option value="1">XLS file for Excel</option><option value="2">TXT file for Notepad</option><option value="3">SQL file for Database</option></select>
        <input name="save_as" class="button_max" type="submit" value="Go" onClick="savefile()"/></form>
</center>
</br></br>
-->

<center><input type="button" value="Back" onclick="goBack()"></center>
<input type="hidden" id="sid" value="{$sid}"/>
<br style="clear:both" />
{if count($related_story) neq 0}
    {checkActionsTpl location="tpl_pligg_story_related_start"}
    <div id="related" style="padding-left:10px;">
        <h2>{#PLIGG_Visual_Story_RelatedStory#}</h2>	
        <ol>
            {section name=nr loop=$related_story}
                <li><a href = "{$related_story[nr].url}">{$related_story[nr].link_title}</a><br/></li> 
                {/section}
        </ol>
    </div>
    {checkActionsTpl location="tpl_pligg_story_related_end"}
{/if}

{checkActionsTpl location="tpl_pligg_story_comments_start"}
<div id="comments">
    <form action="" method="post" id="thisform">
        <h3><a name="comments" class="comments_title">{#PLIGG_Visual_Story_Comments#}</a></h3>
            {checkActionsTpl location="tpl_pligg_story_comments_individual_start"}
            {$the_comments}
            {checkActionsTpl location="tpl_pligg_story_comments_individual_end"}
            {if $user_authenticated neq ""}
                {include file=$the_template."/comment_form.tpl"}
            {else}
            <br/>
            {checkActionsTpl location="anonymous_comment_form"}
            <div align="center" class="login_to_comment">
                <a href="{$login_url}">{#PLIGG_Visual_Story_LoginToComment#}</a> {#PLIGG_Visual_Story_Register#} <a href="{$register_url}">{#PLIGG_Visual_Story_RegisterHere#}</a>.
            </div>
        {/if}
    </form>
</div>
{checkActionsTpl location="tpl_pligg_story_comments_end"}
