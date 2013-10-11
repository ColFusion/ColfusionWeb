{literal}
    <div class="preview-story">
        <h3 class="preview-title">Statistics</h3>
        <div class="storycontent" id="mineRelationshipsContainer">
            <div data-bind="visible: isRelationshipDataLoading" id="mineRelationshipLoadingIcon">
                <span> Relationships Mining In Projgress... </span>
                <img src="images/ajax-loader-wt.gif" style="padding-left: 220px;"/>
            </div>
            <div data-bind="visible: isNoRelationshipData" style="color: grey;">This dataset has no relationship yet</div>
            <div data-bind="visible: isMiningRelationshipsError" style="color: red;">Some errors occur when mining relationships.</div>
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
								<div data-bind="attr: { id: 'relInfoLoadingIcon_' + rel_id }, visible: !$root.isError[rel_id]()" class="relInfoLoadingIcon" style="text-align: center;">
									<img src="images/ajax-loader.gif" />
								</div>
								<div data-bind="attr: { id: 'relInfoErrorMessage_' + rel_id }, 
												visible: $root.isError[rel_id]()" style="text-align: center;">
									<span style="color: red;">Failed to load relationship information.</span>
								</div>   
								<div data-bind="if: $root.isRelationshipInfoLoaded[rel_id]">
								    <div data-bind="with: $root.relationshipInfos[rel_id]">
								        {/literal}
								        {include file='relationshipInfo.html'}
								        {literal}
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