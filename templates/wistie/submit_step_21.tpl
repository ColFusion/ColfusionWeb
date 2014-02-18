<h1 style="font-size: 24px; font-weight: bold; padding-left: 10px; margin-bottom: 0;">{#PLIGG_Visual_Submit2_Header#}</h1>

<div id="submit">
    
    {checkActionsTpl location="tpl_pligg_submit_step2_start"}

    <!-- Step 1 Describe Your Data -->

    <section>
        <form id="submitNewDataForm" class="form-horizontal" name="submitNewDataForm" action="submit1.php" method="post" enctype="multipart/form-data">

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

    <input onclick="submitDataSubmissionForm()" class="btn " type="submit" value="{#PLIGG_Visual_Submit2_Continue#}" id="final"  disabled = true />

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