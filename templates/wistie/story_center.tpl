<!-- Hiddent visualization form to submit post ajax request to visualization page for story visualizaiton -->

<form id="visualizationParaForm" style="display: none;" target="_blank" method="POST" action="">
    <input type="hidden" name="tableName" id="visualTableNameParam" />
    <input type="hidden" name="sid" id="visualSidParam" value="{$sid}" />
    <input type="hidden" name="title" id="visualTitleParam" />
    <input type="hidden" name="dataset" id="visualDatasetParam" />
</form>

<!-- End of hidden visualization form -->

<div id="upload_result">
    <table style="margin: 0 0 9px 10px;">
        <tr>
            <td class="step1_input_title" style="vertical-align: top; width: 100px;">
                <span style="margin-top: 5px; font-weight: bold">{#PLIGG_Visual_Submit2_Attachments#}:</span>
            </td>
            <td>
                <table class="fileList" id="attachmentList2">
                    <tr id="attachmentLoadingIcon2">
                        <td>
                            <img src="{$my_pligg_base}/images/ajax-loader.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

<section>
        {include file=$the_template."/storyMetadataEdit.tpl"}
    </section>

<!-- Status Section -->
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

<!-- Relationships section -->

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

<!-- End of Relationships section -->

<input type="hidden" id="sid" value="{$sid}" />

{literal}

    <script type="text/javascript">
      
        var sid = $.url().param('title');
        var dataPreviewViewModel;
        var relationshipViewModel;
        var storyStatusViewModel;

        $(document).ready(function () {
            
            fetchDatasetProfile();
            
            storyMetadataViewModel = new StoryMetadataViewModel($("#sid").val());
            ko.applyBindings(storyMetadataViewModel, document.getElementById("storyMetadataDiv"));

            // Load attachment list one for showing one for editing
            // TODO: change to knockout model and do call to the server only once.
            fileManager.loadSourceAttachments(sid, $("#attachmentList"), $("#attachmentLoadingIcon"));   
            fileManager.loadSourceAttachments(sid, $("#attachmentList2"), $("#attachmentLoadingIcon2"));   

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