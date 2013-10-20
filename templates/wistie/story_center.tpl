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
<script type="text/javascript" src="{$my_pligg_base}/javascripts/moment.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/purl.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout.mapping.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/dataSourceUtil.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/generalUtils.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Utils.js"></script>
<!--edit by jason-->
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Notification_model.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/DataPreviewViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StoryStatusViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/NewRelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/ProgressBarViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StatisticsViewModel.js"></script>
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
  
    var sid = $.url().param('title');
    var dataPreviewViewModel;
    var storyStatisticsViewModel;
    var relationshipViewModel;
    var storyStatusViewModel;

    $(document).ready(function () {
        
        fetchDatasetProfile();
        
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


        storyStatisticsViewModel = new StoryStatisticsViewModel(sid);
        dataPreviewViewModel = new DataPreviewViewModel(sid);
        relationshipViewModel = new RelationshipViewModel(sid);
        storyStatusViewModel = new StoryStatusViewModel(sid, dataPreviewViewModel);

        ko.applyBindings(relationshipViewModel, document.getElementById("mineRelationshipsContainer"));
        ko.applyBindings(storyStatusViewModel, document.getElementById("storyStatus"));
        ko.applyBindings(storyStatisticsViewModel, document.getElementById("storyStatisticsContainer"));

        relationshipViewModel.mineRelationships(10, 1);
    });

    function fetchDatasetProfile() {
        $.ajax({
            url: my_pligg_base + "/display_data.php?count=5",
            success: function(data) {
                $('#upload_result').prepend(data);
                var datasetTitle = $('#dataset_title').text() || "New Dataset";
                $('#fromDataSetWrapper').find('.dataSetDesTable').find('.sidInput').val(datasetTitle);
            }
        });
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
                            <img src="{$my_pligg_base}/images/ajax-loader.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

{literal}
<div id="storyStatus">
    <div style="padding-left: 10px; padding-bottom: 8px;">
        <span style="font-weight: bold;">Status ( refresh 
        <span data-bind="text: lastStatusUpdatedTimeText" class="lastRefreshTime"></span>    
        ):</span>
        <i data-bind="visible: isStatusShown, click: function () { isStatusShown(false) }" class="icon-collapse storyStatusCollapseIcon"></i>
        <i data-bind="visible: !isStatusShown(), click: function () { isStatusShown(true) }" class="icon-collapse-top storyStatusCollapseIcon"></i>
    </div>     
    {/literal}
    {include file='storyStatusTableList.tpl'}
    {literal}
</div>
{/literal} 

<div id="dataPreviewContainer"></div>

{include file='storyStatistics.tpl'}

{include file='relationships.tpl'}
{if $isAuthenticated}
{include file='addRelationships.tpl'}
{/if}
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
