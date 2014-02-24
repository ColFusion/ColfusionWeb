<div id="storyMetadataDiv">
    <span id="metadataLoadingIcon" data-bind="visible: isFetchCurrentValuesInProgress()"><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
    <form id="submitNewDataForm" class="form-horizontal" name="submitNewDataForm" action="submit1.php" method="post" enctype="multipart/form-data" data-bind="visible: !isFetchCurrentValuesInProgress()">

        <legend class="stepHeader" data-bind="visible: showFormLegend()">Step 1: Describe Your Data</legend>

        <span data-bind="visible: isInEditMode()">Edit dataset description. Please click Save button after you finish editing. You can also click the Cancel button to ignore the changes you make and go back to previous version. </span>

        <!-- Title -->
        <div class="control-group">
            <label class="control-label" for="title">{#PLIGG_Visual_Submit2_Title#} <span class="text-error">*</span>:</label>
            <div class="controls">
                <input id="title" name="title" data-required="true" type="text" class="input-block-level" data-bind="value: title" />
                <span class="inputHistoryLink btn-link" data-bind="visible: isInEditMode()">[History]</span>
            </div>
        </div>
        
        <!-- Authors -->
        <div class="control-group">
            <label class="control-label" for="title">Authors:</label>
            <div class="controls">
 
                <div class="input-append">
                    <input type="text" class="sidInput" data-bind="searchUsersTypeahead: $data" placeholder="Type here" />
                    <button class="btn add-on searchDatasetBtn" data-bind="click: addAuthor">Add Author </button>
                </div>

                <table class="table">
                    <thead data-bind="visible: storyAuthors().length > 0">
                        <tr>
                            <th>Last Name, First Name <span class="text-error">*</span></th>
                            <th>Role <span class="text-error">*</span></th>
                            <th> </th>
                        </tr>
                    </thead>
                    <tbody data-bind='foreach: storyAuthors'>
                        <tr>
                            <td>

                                <input style="width: 100%; " disabled="true" data-required="true" data-bind="value: login" />
                            </td>
                            <td>
                            <select style="width: 100%" data-required="true" data-trigger="change" 
                            data-bind="value: roleId" >
                                <option value="">Select Role...</option>
                                
                                <!-- ko foreach: authorRoles -->
                                    <option data-bind="value: $data.roleId, text: $data.roleName ">
                                        
                                    </option>
                                <!-- /ko -->
                            </select>

<!--
                                <select style="width: 100%" data-bind='options: authorRoles, optionsText: "storyUserRoleName", optionsCaption: "Select...", value: authorRole' data-required="true" data-trigger="change"> </select>
                                -->
                            </td>
                            
                            <td>
                                <a href='#' data-bind='click: $parent.removeAuthor'>Remove</a>
                            </td>
                        </tr>
                    </tbody>
                </table>

               
            </div>
        </div>

        <!-- Description -->
        <div class="control-group">
            <label class="control-label" for="bodytext">{#PLIGG_Visual_Submit2_Description#} <span class="text-error">*</span>:</label>
            <div class="controls">
                <textarea id="bodytext"  name="bodytext"  data-required="true" class="input-block-level" data-bind="value: description"> </textarea>
                <span class="inputHistoryLink btn-link" data-bind="visible: isInEditMode()">[History]</span>
            </div>
        </div>

        <!-- Tags -->
        <div class="control-group">
            <label class="control-label" for="tags">{#PLIGG_Visual_Submit2_Tags#}:</label>
            <div class="controls">
                <input type="text" id="tags" class="wickEnabled input-block-level" name="tags" data-bind="value: tags"/>
                <span class="inputHistoryLink btn-link" data-bind="visible: isInEditMode()">[History]</span>
                <script type="text/javascript" language="JavaScript" src="{$my_pligg_base}/templates/{$the_template}/js/tag_data.js"></script> 
                <script type="txt/javascript" language="JavaScript" src="{$my_pligg_base}/templates/{$the_template}/js/wick.js"></script> 
            </div>
        </div>

        <span data-bind="visible: isInEditMode()">Note, that if you remove an attached file, you will NOT be able to restore it by clicking Cancel button. </span>

        <div class="control-group">
            <label class="control-label" for="attachmentList">{#PLIGG_Visual_Submit2_Attachments#}
                <img src="help.png" width="15" height="15" title="" data-original-title="You can attach any files which contain any additional information about the data being submitted in step 2.">:</label>
            <div class="controls">
                <table class="fileList" id="attachmentList"> 
                    <li id="attachmentLoadingIcon">
                        <span ><img src="{$my_pligg_base}/images/ajax-loader.gif"/></span>
                    </li>
                    <li>
                        <span><a id="uploadAttachmentLink" style="color: #a44848;"><i class="icon-cloud-upload" style="margin-right: 5px;"></i>Add Files...</a></span>
                    </li>
                </table>  
            </div>
        </div>

        <input type="hidden" name="url" id="url" value="{$submit_url}" />
        <input type="hidden" name="phase" value="1" />
        <input type="hidden" name="randkey" value="{$randkey}" />
        <input type="hidden" name="id" value="{$submit_id}" />
        <input type="hidden" name="user_id" id="user_id" value="{$user_id}" />
        <input type="hidden" id="sid" name="sid" data-bind="value: sid" value="{$sid}"/>
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

        function isSubmitFormValid() {
            var form = $('#submitNewDataForm');

            //TODO, FIXME not the best solution
            form.parsley('destroy');

            form.parsley({
                'excluded': 'input[type=radio], input[type=checkbox]'
            });
            
            return form.parsley('validate');
        }
    </script>
{/literal}
<!-- End of apply KO bindings -->