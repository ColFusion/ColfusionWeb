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
        <button id="finishYourSubmissionButton" onclick="submitDataSubmissionForm()" class="btn" data-loading-text="Submitting..." data-complete-text="Submitted!" >Finish your submission</button>
        <span id="submitMetadataLoadingIcon" class="hide"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
        <span id="submitMetadataErrorMessage" class="hide text-error"></span>
    </div>

</div>

{literal}
<script>
    
    storyMetadataViewModel = new StoryMetadataViewModel("");
    ko.applyBindings(storyMetadataViewModel, document.getElementById("storyMetadataDiv"));

    storyMetadataViewModel.createNewStory($("#user_id").val(), initNewStoryPage);

    // Load attachment list.
    fileManager.loadSourceAttachments(sid, $("#attachmentList"), $("#attachmentLoadingIcon"));

    function submitDataSubmissionForm() {
        if (isSubmitFormValid()) {
            storyMetadataViewModel.status("queued");

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
                    
                }
                else {
                    saveMetadataButton.button('reset');
                    canceleMetadataButton.button('reset');
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