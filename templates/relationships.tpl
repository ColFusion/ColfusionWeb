{literal}
    <div id="minedRelContainer">
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
                                    <div style="display: inline;"><span data-bind='text: numberOfVerdicts'/></div>
                                    <div style="display: inline;"><span data-bind='text: numberOfApproved'/></div>
                                    <div style="display: inline;"><span data-bind='text: numberOfReject'/></div>
                                    <div style="display: inline;"><span data-bind='text: avgConfidence'/></div>
                                </td>
                                <td><span data-bind="click: $root.showMoreClicked.bind($data, $index()), attr: { id:  'mineRelRecSpan' + $index() }" style="cursor: pointer;">More...</span></td>
                            </tr>
                            <tr data-bind="attr: { id:  'mineRelRec' + $index() }" style="display: none;">
                                <td colspan="5">
                                    <div>Name:  <div style="display: inline;"><span data-bind='text: name'/></div></div>
                                    <div>Description:  <div style="display: inline;"><span data-bind='text: description'/></div></div>
                                    <div>CreationTime:  <div style="display: inline;"><span data-bind='text: creationTime'/></div></div>
                                    <div>From Table:  <div style="display: inline;"> <span data-bind='text: tableNameFrom'/></div></div>
                                    <div>To Table:  <div style="display: inline;"><span data-bind='text: tableNameTo'/></div></div>
                                </td>
                            </tr>                       
                        </tbody>
                    </table>      
                </div>        
            </div>          
        </div>     
    </div>
{/literal}