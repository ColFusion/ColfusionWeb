{literal}
    <div class="preview-story">
        <h3 class="preview-title">Relationships</h3>
        <div class="storycontent" id="mineRelationshipsContainer">
            <div data-bind="visible: isRelationshipDataLoading" id="mineRelationshipLoadingIcon">
                <span> Relationships Mining In Projgress... </span>
                <img src="images/ajax-loader-wt.gif" style="padding-left: 220px;"/>
            </div>
            <div data-bind="visible: isNoRelationshipData" style="color: grey;">This dataset has no relationships yet</div>
            <div data-bind="with: mineRelationshipsTable" id="mineRelationshipsTableWrapper">
                <table id="tfhover" class="tftable" border="1" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>From</th>
                            <th>To</th>
                            <th>Creator</th>
                            <th>Stat</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: rawData">                            
                        <tr>
                            <td>
                                <div style="display: inline;"><a data-bind='attr: { href: "story.php?title=" + sidFrom }, text: titleFrom' > </a></div>.
                                <div style="display: inline;"><span data-bind='text: newDnameFrom'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><a data-bind='attr: { href: "story.php?title=" + sidTo }, text: titleTo' > </a></div>.
                                <div style="display: inline;"><span data-bind='text: newDnameTo'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><span data-bind='text: creatorLogin'/></div>
                            </td>
                            <td>
                                <div style="display: inline;"><span data-bind='text: numberOfVerdicts'/></div>,
                                <div style="display: inline;"><span data-bind='text: numberOfApproved'/></div>,
                                <div style="display: inline;"><span data-bind='text: numberOfReject'/></div>,
                                <div style="display: inline;"><span data-bind='text: avgConfidence'/></div>
                            </td>
                            <td><span data-bind="click: $root.showMoreClicked.bind($data, rel_id), attr: { id:  'mineRelRecSpan_' + rel_id }" style="cursor: pointer;">More...</span></td>
                        </tr>
                        <tr data-bind="attr: { id:  'mineRelRec_' + rel_id }" style="display: none;">
                            <td data-bind="visible: !$root.isRelationshipInfoLoaded[rel_id]" class="relLoadingIcon">
                                Loading...
                            </td>
                            <td data-bind="if: $root.isRelationshipInfoLoaded[rel_id]" colspan="5">   
                                <div data-bind="with: $root.relationshipInfos[rel_id]">
                                    <div>Name:  <div style="display: inline;"><span data-bind='text: name'/></div></div>
                                    <div>Description:  <div style="display: inline;"><span data-bind='text: description'/></div></div>
                                    <div>Creator  <div style="display: inline;"> <span data-bind='text: creator'/></div></div>
                                    <div>CreatedTime:  <div style="display: inline;"><span data-bind='text: createdTime'/></div></div>
                                    <div>FromTableName:  <div style="display: inline;"><span data-bind='text: fromTableName'/></div></div>
                                    <div>ToTableName:  <div style="display: inline;"><span data-bind='text: toTableName'/></div></div>
                                    <div data-bind="foreach: links" class="links">
                                        <div class="link">
                                            <div data-bind="text: fromPart" class="fromPart"></div>
                                            <div data-bind="text: toPart" class="toPart"></div>
                                        </div>
                                    </div>
                                    <div data-bind="if: yourComment()">
                                        <div data-bind="with: yourComment" class="yourComment">
                                            <div data-bind="text: userName"></div>
                                            <div data-bind="text: comment"></div>
                                            <div data-bind="text: confidence"></div>
                                        </div>
                                    </div>
                                    <div data-bind="foreach: comments">
                                        <div class="comment">
                                            <div data-bind="text: userName"></div>
                                            <div data-bind="text: comment"></div>
                                            <div data-bind="text: confidence"></div>
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