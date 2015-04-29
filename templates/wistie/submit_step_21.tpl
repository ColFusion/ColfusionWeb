<h1 style="font-size: 24px; font-weight: bold; padding-left: 10px; margin-bottom: 0;">{#PLIGG_Visual_Submit2_Header#}</h1>
<div id="submit">
    
    <!-- Step 1 Describe Your Data -->

    <section>
        {include file=$the_template."/storyMetadataEdit.tpl"}
    </section>

    <!-- End of Step 1 Describe Your Data -->

    <!-- Step 2 Upload Your Data -->

    <section>
        <h4 class="stepHeader">Step 2: Upload Your Data</h4>
        <hr/>

        <div class="form-horizontal" >
            <div class="control-group">
                <label class="control-label" for="open-wizard">Submission Wizard:</label>
                <div class="controls">
                    <span id='open-wizard' class='btn btn-primary'>Import data</span>                    
                </div>
            </div>

            <div class="submit_right_sidebar hidden" id="dockcontent">   
            <!-- Data Preview section markup is inserted here. The insertin is triggered at submit_step_21_jsFilesAtBottom.tpl -->                
                <div id="dataPreviewContainer"></div>
            </div>
            <div>
                <div style="clear:both;"></div>
                
                {include file=$the_template."/dataSubmissionWizard.tpl"}
               
            </div>
        </div>
    </section>
    
    <!-- End of Step 2 Upload Your Data -->
   
    <!-- Step 3 Relationship Table -->  

    <section id="dataSubmissionStep3Container" class="hidden">
        <h4 class="stepHeader">Step 3: Connect To The Puzzle (Optional)</h4>
        <hr />

        <div id="step3Wrapper">
            <div id="step3Container">
                {include file='relationships.tpl'}

                {include file='addRelationships.tpl'}
            </div>
        </div>
    </section>
  
    <!-- End of Step 3 Relationships Table-->

    <hr />

    <div class>
        <button id="finishYourDraftSubmissionButton" onclick="submitDataSubmissionForm('draft')" class="btn" data-loading-text="Saving..." data-complete-text="Saved!">Save as draft</button>
        <button id="finishYourPrivateSubmissionButton" onclick="submitDataSubmissionForm('private')" class="btn" data-loading-text="Submitting..." data-complete-text="Submitted!" disabled="true">Publish as private</button>
        <button id="finishYourSubmissionButton" onclick="submitDataSubmissionForm('queued')" class="btn" data-loading-text="Submitting..." data-complete-text="Submitted!" disabled="true">Publish as public</button>
        <span id="submitMetadataLoadingIcon" class="hide"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
        <span id="submitMetadataErrorMessage" class="hide text-error"></span>
    </div>

</div>

{literal}
<script>
    
    storyMetadataViewModel = new StoryMetadataViewModel("", $("#user_id").val());
    ko.applyBindings(storyMetadataViewModel, document.getElementById("storyMetadataDiv"));

    storyMetadataViewModel.createNewStory(initNewStoryPage);

    function submitDataSubmissionForm(storyStatus) {
        if (storyStatus == "draft" || (isSubmitFormValid() && storyStatus != "draft")) {
            storyMetadataViewModel.status(storyStatus);

            var defferedAjax = storyMetadataViewModel.submitStoryMetadata();
            var loadingIcon = $("#submitMetadataLoadingIcon");
            var errorMessage = $("#submitMetadataErrorMessage");
            var saveMetadataButton = $("#finishYourSubmissionButton");
            
            errorMessage.hide();
            saveMetadataButton.button('loading');
            loadingIcon.show();
            defferedAjax.done(function(data) {
                loadingIcon.hide();
                if (data.isSuccessful) {
                    saveMetadataButton.button('complete');
                    
                    saveMetadataButton.button('reset');


                    //TODO, FIXME: the url should be read from some settings.
                    window.location.href = ColFusionDomain + "/" + ColFusionAppName + "/story.php?title=" + storyMetadataViewModel.sid();
                    
                }
                else {
                    saveMetadataButton.button('reset');
                    
                    errorMessage.show();
                    errorMessage.text("An error occured while trying to save. Please try again.");
                }
            })
            .fail(function(data){
                loadingIcon.hide();
                saveMetadataButton.button('reset');
                errorMessage.show();
                errorMessage.text("An error occured while trying to save. Please try again.");
            });
        }
    }

</script>
{/literal}