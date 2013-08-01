{literal}
    <div class="preview-story">
        <h3 class="preview-title">Relationships</h3>
        <div class="storycontent" id="mineRelationshipsContainer">
            <div data-bind="visible: isRelationshipDataLoading" id="mineRelationshipLoadingIcon">
                <span> Relationships Mining In Projgress... </span>
                <img src="images/ajax-loader-wt.gif" style="padding-left: 220px;"/>
            </div>
            <div data-bind="visible: isNoRelationshipData" style="color: grey;">This dataset has no relationships yet</div>
            <div data-bind="visible: !isNoRelationshipData(), with: mineRelationshipsTable" id="mineRelationshipsTableWrapper">
                <table id="tfhover" class="tftable" border="1" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>From</th>
                            <th>To</th>
                            <th>Creator</th>
                            <th>Statistics</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: rawData">                            
                        <tr data-bind="attr: { 'id' : 'relationship_' + rel_id}" class="relationshipInfoRow">
                            <td>
                                <div style="display: inline;"><a data-bind='attr: { href: titleFrom ? "story.php?title=" + sidFrom : ""}, text: titleFrom ? titleFrom : "this"' > </a></div>.
                                <div style="display: inline;"><span data-bind='text: tableNameFrom'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><a data-bind='attr: { href: "story.php?title=" + sidTo }, text: titleTo' > </a></div>.
                                <div style="display: inline;"><span data-bind='text: tableNameTo'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><span data-bind='text: creatorLogin'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><span data-bind='bootstrapTooltip: numberOfVerdicts' class="numOfVerdicts"/>Number of Feedbacks</div>, 
                                <div style="display: inline;"><span data-bind='bootstrapTooltip: parseFloat(Math.round(avgConfidence * 100) / 100).toFixed(2)' class="avgConfidence"/>Average Confidence</div>
                            </td>
                            <td><span data-bind="click: $root.showMoreClicked.bind($data, rel_id), attr: { id:  'mineRelRecSpan_' + rel_id }" style="cursor: pointer;">More...</span></td>
                        </tr>
                        <tr data-bind="attr: { id:  'mineRelRec_' + rel_id }" style="display: none;">
                            <td class="relationshipInfo" colspan="5">
                                <div data-bind="attr: { id:  'relInfoLoadingIcon_' + rel_id }" style="text-align: center;">
                                    <img src="images/ajax-loader.gif"/>
                                </div>
                                <div data-bind="if: $root.isRelationshipInfoLoaded[rel_id]">
                                    <div data-bind="with: $root.relationshipInfos[rel_id]">
                                        <table class="relProfile">
                                            <tr>
                                                <td class="profileHeader">Name:</td>
                                                <td data-bind='text: name' class="profileContent"></td>
                                                <td rowspan="2">
                                                    <button data-bind="click: checkDataMatching" class="btn" style="width: 180px;">Check Data Matching</button>                   
                                                </td>
                                                <td data-bind="visible: isOwned()" rowspan="2"><button data-bind="click: $root.removeRelationship.bind($data, rid)" class="btn btn-danger deleteRelBtn">Delete</button></td>
                                            </tr>           
                                            <tr><td class="profileHeader">Creator:</td><td data-bind='text: creator' class="profileContent"></td></tr>
                                            <tr><td class="profileHeader">CreatedTime:</td><td data-bind='text: createdTime' class="profileContent"></td></tr>
                                            <tr><td class="profileHeader">Description:</td><td data-bind='text: description' class="profileContent"></td></tr>
                                        </table>                                                 
                                        <div class="linkProfileContainer">                                       
                                            <div data-bind="template: { name: 'linkProfile-template', data: fromDataset }" class="fromProfile linkProfile">
                                            </div>
                                            <div data-bind="template: { name: 'linkProfile-template', data: toDataset }" class="toProfile linkProfile">
                                            </div>
                                            <script type="text/html" id="linkProfile-template">          
                                                <table class="linkProfileTable">
                                                <tr>
                                                <td data-bind="text: ($data == $parent.fromDataset()) ? 'From:' : 'To:'" style="font-weight: bold;"></td>
                                                </tr>
                                                <tr>
                                                <td class="linkProfileHeader">Dataset:</td>
                                                <td class="linkProfileContent">
                                                <a data-bind="text: name() || 'New Dataset', attr: {href: name()? '{/literal}{$my_pligg_base}{literal}/story.php?title=' + sid() : '#'}"></a>
                                                </td>
                                                </tr>
                                                <tr>
                                                <td class="linkProfileHeader">Table:</td>
                                                <td class="linkProfileContent" data-bind='text: shownTableName'></td>
                                                </tr>
                                                </table>
                                            </script>
                                        </div>
                                        <div data-bind="foreach: links" class="links">
                                            <div class="link">
                                                <div class="fromPart linkPart">
                                                    <span data-bind="text: fromPart" class="linkPartText"></span>
                                                </div>
                                                <div class="toPart linkPart">
                                                    <span data-bind="text: toPart" class="linkPartText"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="seeCommentsContainer">
                                            <a data-bind="click: showComments, visible: isCommentHided()" class="seeCommentText">See Feedbacks</a>
                                            <a data-bind="click: hideComments, visible: !isCommentHided()" class="hideCommentText">Hide Feedbacks</a>
                                        </div>
                                        <div data-bind="visible: !isCommentHided() && isCommentLoading()" style="text-align: center; padding-top: 7px;">
                                            <img src="images/ajax-loader.gif"/>
                                        </div>
                                        <div data-bind="visible: isCommentLoadingError()" class="alert alert-error commentErrorMsg">
                                            Some errors occur when loading feedbacks, please try again.
                                        </div>
                                        <div data-bind="visible: !isCommentHided() && !isCommentLoading() && !isCommentLoadingError()" class="commentContainer">
                                            <div data-bind="with: editingComment" class="yourCommentEditor">
                                                <div data-bind="visible: $parent.isYourCommentEditing()" id="confidenceContainer">
                                                    <div id="confidenceSliderContainer">
                                                        <span id="confidenceText">Confidence: </span>
                                                        <span  data-bind="text: confidence" style="font-weight: bold;" id="slideValue"></span>
                                                        <input data-bind="value: confidence" type="hidden" id="confidenceValueInput"/>
                                                        <table class="confidenceDesTable">
                                                            <tr>
                                                                <td>Wrong</td>
                                                                <td style="text-align: center">Not Sure</td>
                                                                <td style="text-align: right">Correct</td>
                                                            </tr>
                                                        </table>
                                                        <div id="confidenceSlider" data-bind="slider: confidence, sliderOptions: {min: 0, max: 1, step: 0.1}"></div>
                                                        <table class="confidenceDesTable">
                                                            <tr>
                                                                <td>0</td>
                                                                <td style="text-align: center">0.5</td>
                                                                <td style="text-align: right">1</td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div id="confidenceComment">
                                                        <div style="margin-bottom: 10px">Confidence comment:</div>
                                                        <textarea data-bind="value: comment" data-required="true" style=" width: 95%; height: 80px;resize: none;"></textarea>
                                                        <div style="float: right; margin-right: 6px;">
                                                            <span data-bind="visible: $parent.isSavingYourComment()" style="margin-right: 10px;"><img src="images/ajax-loader.gif"/></span>
                                                            <button data-bind="click: $parent.saveComment" class="btn btn-primary">Save</button>
                                                            <button data-bind="click: $parent.cancelEditingComment" class="btn">Cancel</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div data-bind="visible: !yourComment() && !isYourCommentEditing()" class="addCommentContainer">
                                                <div style="text-align: center; padding-top: 18px;">You have no feedback of this relationship. <a data-bind="click: editComment">Click here to add your feedback.</a></div>
                                            </div>
                                            <div data-bind="if: yourComment()">
                                                <div data-bind="template: { name: 'comment-template', data: yourComment }, visible: !isYourCommentEditing()" class="comment yourComment">                                             
                                                </div>
                                            </div>
                                            <div data-bind="foreach: comments">
                                                <div data-bind="template: { name: 'comment-template', data: $data }" class="comment">                                            
                                                </div>
                                            </div>
                                            <script type="text/html" id="comment-template">   
                                                <div class="confidenceContainer">
                                                <div data-bind="text: confidence" class="confidenceText">
                                                </div>
                                                <div class="confidenceStaticText">
                                                Confidence
                                                </div>
                                                </div>
                                                <div class="commentBody">
                                                <div class="commentHeader">                   
                                                <div class="userName"><a data-bind="text: userName, attr: { href: '{/literal}{$my_pligg_base}{literal}/user.php?login=' + userName()}"></a></div>
                                                <div data-bind="text: '&lt;' + userEmail() + '&gt;'" class="userEmail"></div>
                                                <div data-bind="visible: isControlPanelShown()" class="commentControlPanel">
                                                <i data-bind="click: $parent.editComment" class="icon-edit"></i>
                                                <i data-bind="click: $parent.removeComment" class="icon-trash"></i>
                                                </div>
                                                <div data-bind="text: commentTime" class="commentTime"></div>
                                                </div>
                                                <div class="commentContent">
                                                <div data-bind="text: comment"></div>
                                                </div>
                                                </div>
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>                                    
                    </tbody>
                </table>      
            </div>        
        </div>    
    </div>     

{/literal}