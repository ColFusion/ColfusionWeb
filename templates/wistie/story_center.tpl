<!-- Hiddent visualization form to submit post ajax request to visualization page for story visualizaiton -->

<form id="visualizationParaForm" style="display: none;" target="_blank" method="POST" action="">
    <input type="hidden" name="tableName" id="visualTableNameParam" />
    <input type="hidden" name="sid" id="visualSidParam" value="{$sid}" />
    <input type="hidden" name="title" id="visualTitleParam" />
    <input type="hidden" name="dataset" id="visualDatasetParam" />
</form>

<!-- End of hidden visualization form -->

<!-- Cataloging Information -->

<section>
    <div class="preview-story">
        <h3 class="preview-title">Dataset Information</h3>
        <div class="storycontent" style="padding-top: 0px;">
            <div id="showMetadataSection" data-bind="visible: !isInEditMode()">
                <span class="pull-right btn-link" data-bind="visible: !isInEditMode(), click: switchToEditMode">[Edit]</span>
                <span id="metadataLoadingIcon" data-bind="visible: isFetchCurrentValuesInProgress()"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
                <table data-bind="visible: !isFetchCurrentValuesInProgress()" class="table" style="margin-bottom: 0px;">
                    <tr>
                        <td style="vertical-align: top; width: 100px;">Dataset Title</td>
                        <td><span data-bind="text: title"></span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; width: 100px;">Submitted by</td>
                        <td><span data-bind="text: title"></span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; width: 100px;">Date Submitted</td>
                        <td><span data-bind="text: dateSubmitted"></span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; width: 100px;">Description</td>
                        <td><span data-bind="text: description" style="white-space: pre-wrap"></span></td>
                    </tr>
                    <tr data-bind="visible: tags">
                        <td style="vertical-align: top; width: 100px;">Tags</td>
                        <td><span data-bind="text: tags" style="white-space: pre-wrap"></span></td>
                    </tr>
                    <tr id="attachedFilesRow">
                        <td class="step1_input_title" style="vertical-align: top; width: 100px;">{#PLIGG_Visual_Submit2_Attachments#}</td>
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
            <div id="editMetadataSection" data-bind="visible: isInEditMode()">
                {include file=$the_template."/storyMetadataEdit.tpl"}
                
                <div class="pull-right">
                    <span id="saveMetadataErrorMessage" class="hide text-error"></span>
                    <span id="saveMetadataLoadingIcon" class="hide"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
                    <button id="saveMetadataButton" class="btn btn-primary" onclick="saveMetadataForm()" data-loading-text="Saving..." data-complete-text="Saved!">Save</button>
                    <button id="canceleMetadataButton" class="btn" onclick="cancelMetadataForm()" data-loading-text="Cancel">Cancel</button>
                </div>
            </div>
        </div>
    </div>

</section>

<!-- End of cataloging information -->


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
            
            storyMetadataViewModel = new StoryMetadataViewModel(sid);
            storyMetadataViewModel.hideFormLegend();
            ko.applyBindings(storyMetadataViewModel, document.getElementById("editMetadataSection"));
            ko.applyBindings(storyMetadataViewModel, document.getElementById("showMetadataSection"));
            

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

        function saveMetadataForm() {
            if (isSubmitFormValid()) {
                var defferedAjax = storyMetadataViewModel.submitStoryMetadata();
                var loadingIcon = $("#saveMetadataLoadingIcon");
                var errorMessage = $("#saveMetadataErrorMessage");
                var saveMetadataButton = $("#saveMetadataButton");
                var canceleMetadataButton = $("#canceleMetadataButton");

                
                errorMessage.hide();
                saveMetadataButton.button('loading');
                canceleMetadataButton.button('loading');
                loadingIcon.show();
                defferedAjax.done(function(data) {
                    loadingIcon.hide();
                    if (data.isSuccessful) {
                        saveMetadataButton.button('complete');
                        storyMetadataViewModel.saveChanges();
                    }
                    else {
                        saveMetadataButton.button('reset');
                        canceleMetadataButton.button('reset');
                        errorMessage.show();
                        errorMessage.text("An error occured while trying to save. Please try again.");
                    }
                });
                
                defferedAjax.fail(function(data, textStatus){
                    loadingIcon.hide();
                    saveMetadataButton.button('reset');
                    canceleMetadataButton.button('reset');
                    errorMessage.show();
                    errorMessage.text("An error occured while trying to save. Please try again.");
                });
            }
        }

        function cancelMetadataForm() {
            var loadingIcon = $("#saveMetadataLoadingIcon");
            var errorMessage = $("#saveMetadataErrorMessage");
            var saveMetadataButton = $("#saveMetadataButton");
            var canceleMetadataButton = $("#canceleMetadataButton");

            loadingIcon.hide();
            saveMetadataButton.button('reset');
            canceleMetadataButton.button('reset');
            errorMessage.hide();

            storyMetadataViewModel.cancelChanges();
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