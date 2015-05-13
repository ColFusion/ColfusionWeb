<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/storyStatus.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/sourceAttachment.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/typeahead.js-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/parsley.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/parsley_custom.css" />
<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/css/userDataset.css" />

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
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StoryStatusViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/ProgressBarViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/UserDatasetViewModel.js"></script>

{literal}
<script type="text/javascript">
    $(function () {
        ko.applyBindings(new UserDatasetViewModel(), document.getElementById('datasetListContainer'));
    });
</script>

<div id="datasetListContainer">
    <div data-bind="foreach: datasets" id="datasetList">
        <div class="datasetContainer">
            <div class="datasetTitle">
                <a data-bind="text: name, attr: { 'href': '{/literal}{$my_pligg_base}/story.php?title={literal}' + sid() }"></a>
            </div>
            <div class="createdTimeText subtext">
                <span>
                    Posted by
                    <a data-bind="text: userName, attr: { 'href': '{/literal}{$my_pligg_base}/user.php?login={literal}' + userName() }"></a> 
                    at
                </span>
                <span data-bind="text: createdTime"></span>
            </div>
            <div data-bind="text: content" class="descriptionText"></div>
            <div data-bind="with: storyStatusViewModel" class="statusContainer">
                <div class="statusText">
                    <span>Status ( refresh 
                    <span data-bind="text: lastStatusUpdatedTimeText" class="lastRefreshTime"></span>
                        ):
                    </span>
                    <i data-bind="visible: isStatusShown, click: function () { isStatusShown(false) }" class="icon-collapse storyStatusCollapseIcon"></i>
                    <i data-bind="visible: !isStatusShown(), click: function () { isStatusShown(true) }" class="icon-collapse-top storyStatusCollapseIcon"></i>
                </div>
                {/literal}

                    {include file='storyStatusTableList.tpl'}
                
                {literal}
            </div>
        </div>
    </div>
</div>
{/literal}