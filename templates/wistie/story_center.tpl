<link href="{$my_pligg_base}/css/bootstrap.min.css" rel="stylesheet" />
<link href="{$my_pligg_base}/css/bootstrap-wizard.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/bootstrap-lightbox.min.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/storyStatus.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/dataTableModel.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/addRelationship.css" />
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
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout.mapping.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/dataSourceUtil.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Utils.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/DataPreviewViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StoryStatusViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/NewRelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/ProgressBarViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/fileManager.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/hogan.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>


{literal}
    <style>
        #newRelationshipBtn {
            margin: 0 0 13px 15px;
            display: block;
        }

        #profile_datasetDescription {
            width: 75%;
            display: inline-block;
            word-wrap: break-word;
            margin-left: 8px;
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
    var storyStatusViewModel;

    $(document).ready(function () {

        fileManager.loadSourceAttachments(sid, $('#attachmentList'));

        $.ajax({
            type: 'POST',
            url: "DataImportWizard/dataPreviewMarkup.php",
            data: {},
            success: function (data) {
                $("#dataPreviewContainer").append(data);
                ko.applyBindings(dataPreviewViewModel, document.getElementById("dataPreviewContainer"));
            },
            dataType: 'html'
        });

        dataPreviewViewModel = new DataPreviewViewModel(sid);
        relationshipViewModel = new RelationshipViewModel(sid);
        storyStatusViewModel = new StoryStatusViewModel(sid, dataPreviewViewModel);

        ko.applyBindings(relationshipViewModel, document.getElementById("mineRelationshipsContainer"));
        ko.applyBindings(storyStatusViewModel, document.getElementById("storyStatus"));

        // dataPreviewViewModel.getTablesList();
        relationshipViewModel.mineRelationships(10, 1);
    });

    window.onload = function showData() {
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
    };


    function savefile() {
        var filetype = saveform.filetype.value;

        xmlhttp.open("GET", my_pligg_base + "/display_data.php?filetype=" + filetype, false);
        xmlhttp.send(null);
        alert(my_pligg_base + "/display_data.php?filetype=" + filetype);
    }

    function dopage(url) {
        document.getElementById('upload_result').innerHTML = "Loading...";

        xmlhttp.open("GET", my_pligg_base + "/" + url, false);
        xmlhttp.send(null);

        if (xmlhttp.responseText != "") {
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

    function openVisualizationPage() {
        $('#visualizationParaForm').find('#visualTableNameParam').val(dataPreviewViewModel.currentTable().tableName);
        $('#visualizationParaForm').find('#visualTitleParam').val($('#dataset_title').text());
        $('#visualizationParaForm').attr('action', my_pligg_base + "/visualization/dashboard.php");

        var inputObj = {
            sid: sid,
            oneSid: true,
            tableName: dataPreviewViewModel.currentTable().tableName,
            title: $('#dataset_title').text()
        };

        $('#visualizationParaForm').find('#visualDatasetParam').val(JSON.stringify(inputObj));


        document.getElementById('visualizationParaForm').submit();
    }
</script>

{/literal}

<form id="visualizationParaForm" style="display: none;" target="_blank" method="POST" action="">
    <input type="hidden" name="tableName" id="visualTableNameParam" />
    <input type="hidden" name="sid" id="visualSidParam" value="{$sid}" />
    <input type="hidden" name="title" id="visualTitleParam" />
    <input type="hidden" name="dataset" id="visualDatasetParam" />
</form>

<div id="upload_result">
    <table style="margin: 0 0 9px 10px;">
        <tr>
            <td class="step1_input_title" style="vertical-align: top; width: 100px;">
                <span style="margin-top: 5px; font-weight: bold">{#PLIGG_Visual_Submit2_Attachments#}:</span>
            </td>
            <td>
                <table class="fileList" id="attachmentList">
                    <tr id="attachmentLoadingIcon">
                        <td>
                            <img src="{$my_pligg_base}/images/ajax-loader.gif" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

{literal}
<div id="storyStatus">
    <div style="font-weight: bold; padding-left: 10px;">Status:</div>
    <div class="storyStatusTableListWrapper">
        <div class="storyStatusTableListHeader">
            <span class="statusHeader statusHeader-tableName">Table Name</span>
            <span class="statusHeader statusHeader-records">Record Processed</span>
            <span class="statusHeader statusHeader-status">Status</span>
            <span class="statusHeader statusHeader-timeStart">Time Start</span>
            <span class="statusHeader statusHeader-timeEnd">Time End</span>
        </div>
        <ul data-bind="foreach: datasetStatus" class="storyStatusTableList" style="margin: 0;">
            <li data-bind="with: $data" class="storyStatus">
                <span data-bind="text: tableName" class="statusTableName statusCol"></span>
                <span class="statusRecordsProcessed statusCol">
                    <span data-bind="text: numberProcessRecords"></span>
                </span>
                <span data-bind="style: { 'color': $root.getStatusTextColor(status) }" class="statusStatus statusCol">
                    <span style="padding-right: 3px;">
                        <i data-bind="attr: { 'class': $root.getStatusIcon(status) }"></i>
                    </span>
                    <span data-bind="visible: status != 'error', text: status"></span>
                    <span data-bind="visible: ErrorMessage, text: ErrorMessage"
                          class="statusErrorMessage statusCol"
                          style="float: right;">                        
                    </span>
                </span>
                <span data-bind="text: TimeStart" class="statusTimeStart statusCol"></span>
                <span data-bind="text: TimeEnd" class="statusTimeEnd statusCol"></span>
            </li>
        </ul>
    </div>
</div>
{/literal}

<div id="dataPreviewContainer"></div>

{include file='relationships.tpl'}
{include file='addRelationships.tpl'}
{literal}
    <script type="text/javascript">
        $(function () {
            $('.searchDatasetBtn').prop('disabled', true);
            loadInitialFromDataSet();
        });
    </script>
{/literal}

<input type="hidden" id="sid" value="{$sid}" />
<br style="clear: both" />
{if count($related_story) neq 0}
    {checkActionsTpl location="tpl_pligg_story_related_start"}
    <div id="related" style="padding-left: 10px;">
        <h2>{#PLIGG_Visual_Story_RelatedStory#}</h2>
        <ol>
            {section name=nr loop=$related_story}
                <li><a href="{$related_story[nr].url}">{$related_story[nr].link_title}</a><br />
                </li>
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
            <br />
        {checkActionsTpl location="anonymous_comment_form"}
            <div align="center" class="login_to_comment">
                <a href="{$login_url}">{#PLIGG_Visual_Story_LoginToComment#}</a> {#PLIGG_Visual_Story_Register#} <a href="{$register_url}">{#PLIGG_Visual_Story_RegisterHere#}</a>.
            </div>
        {/if}
    </form>
</div>
{checkActionsTpl location="tpl_pligg_story_comments_end"}
