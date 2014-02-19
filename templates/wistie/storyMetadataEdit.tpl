<div id="storyMetadataDiv">
    <span id="metadataLoadingIcon" data-bind="visible: isFetchCurrentValuesInProgress()"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
    <form id="submitNewDataForm" class="form-horizontal" name="submitNewDataForm" action="submit1.php" method="post" enctype="multipart/form-data" data-bind="visible: !isFetchCurrentValuesInProgress()">

        <legend class="stepHeader">Step 1: Describe Your Data</legend>

        <div class="control-group">
            <label class="control-label" for="title">{#PLIGG_Visual_Submit2_Title#}:</label>
            <div class="controls">
                <input id="title" name="title" data-required="true" type="text" class="input-block-level" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="bodytext">{#PLIGG_Visual_Submit2_Description#}:</label>
            <div class="controls">
                <textarea id="bodytext"  name="bodytext"  data-required="true" class="input-block-level"> </textarea>
            </div>
        </div>

        {if $enable_tags}

            <div class="control-group">
                <label class="control-label" for="tags">{#PLIGG_Visual_Submit2_Tags#}:</label>
                <div class="controls">
                    <input  type="text" id="tags" class="wickEnabled input-block-level" name="tags" />
                    <script type="text/javascript" language="JavaScript" src="{$my_pligg_base}/templates/{$the_template}/js/tag_data.js"></script> 
                    <script type="txt/javascript" language="JavaScript" src="{$my_pligg_base}/templates/{$the_template}/js/wick.js"></script> 
                </div>
            </div>

        {/if}

        <div class="control-group">
            <label class="control-label" for="attachmentList">{#PLIGG_Visual_Submit2_Attachments#}
                <img src="help.png" width="15" height="15" title="" data-original-title="You can attach any files which contain any additional information about the data being submitted in step 2.">:</label>
            <div class="controls">
                <ul class="fileList" id="attachmentList"> 
                    <li>
                        <span id="attachmentLoadingIcon"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
                    </li>
                    <li>
                        <span><a id="uploadAttachmentLink" style="color: #a44848;"><i class="icon-cloud-upload" style="margin-right: 5px;"></i>Add Files...</a></span>
                    </li>
                </ul>  
            </div>
        </div>

        <input type="hidden" name="url" id="url" value="{$submit_url}" />
        <input type="hidden" name="phase" value="1" />
        <input type="hidden" name="randkey" value="{$randkey}" />
        <input type="hidden" name="id" value="{$submit_id}" />
        <input type="hidden" id="sid" name="sid" value="{$sid}"/>
    </form> 
</div>


<!-- Attachments Pop Up -->

<div id="uploadAttachmentLightBox" class="lightbox hide fade"  tabindex="-1" role="dialog" aria-hidden="true">
    <div class='lightbox-content'>
        <div class="pull-right">
            <button class="btn btn-link" type="button" data-dismiss="lightbox" aria-hidden="true">Close this dialog</button>
        </div>
        <div>
            <iframe width="1000" height="500" src="{$my_pligg_base}/fileManagers/sourceAttachmentUploadPage.php?sid={$sid}"></iframe>
        </div>
    </div>
</div>

<!-- End of Attachments Pop Up -->

<!-- Apply KO bindings -->

<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StoryMetadataViewModel.js"></script>

{literal}
    <script>

        // Open attachment upload page.
        $('#uploadAttachmentLink').click(function() {
            $('#uploadAttachmentLightBox').lightbox({resizeToFit: false});
        });

        // When lightbox is closed, refresh attachment list.
        $('#uploadAttachmentLightBox').bind('hidden', function(e) {
            // Refresh attachment list.
            fileManager.loadSourceAttachments(sid, $("#attachmentList"), $("#attachmentLoadingIcon"));
            var lightBoxContentDom = $('#uploadAttachmentLightBox').find('.lightbox-content');
            var iframeDom = $(lightBoxContentDom).find('iframe');
            $(iframeDom).remove();
            $(iframeDom).appendTo(lightBoxContentDom);
        });

        // Validates story metadata form and submits if it is valid.
        function submitDataSubmissionForm() {
            var form = $('#submitNewDataForm');
            form.parsley({
                'excluded': 'input[type=radio], input[type=checkbox]'
            });
            
            if (form.parsley('validate')){
                form.submit();
            }
        }    
    </script>
{/literal}
<!-- End of apply KO bindings -->