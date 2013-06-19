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
            <i id="newRelationshipBtn" class="icon-plus" title="Add New Relationship"><span style="font-size: 12px;">Add New Relationship</span></i>
        </div>     
    </div>
{/literal}
<div data-bind="visible: isContainerShowned" id="newRelContainer">
    <h4 style="padding-left: 5px;">New Relationship</h4>
    <div id="relDescriptionContainer">
        <table id="newRelDesTable">
            <tr>
                <td class="desTitle">Name: </td>
                <td><input data-bind="value: name" style="width: 97%;" type="text"/></td>
            </tr>
            <tr>
                <td class="desTitle">Description: </td>
                <td><textarea data-bind="value: description" style=" width: 97%; height: 100px;resize: none;"></textarea></td>
            </tr>
        </table>
    </div>
    {literal}
        <div id="dataSetMatchContainer">
            <table style="width: 100%">
                <tr>
                    <td style="width: 50%; vertical-align: top; border-right: rgb(174, 218, 243); border-right-width: 2px; border-right-style: solid;">
                        <div id="fromDataSetWrapper">
                            <div class="dataSetTitle">From:</div>
                            <div id="fromDataSet" data-bind="template: { name: 'dataSet-template', data: fromDataSet }">
                            </div>
                        </div>      
                    </td>
                    <td style="width: 50%; vertical-align: top;">
                        <div id="toDataSetWrapper">
                            <div class="dataSetTitle">To:</div>
                            <div id="toDataSet"  data-bind="template: { name: 'dataSet-template', data: toDataSet }">                             
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <script type="text/html" id="dataSet-template">          
            <table class="dataSetDesTable">
            <tr>
            <td class="dataSetDesTitle">Dataset: </td>                       
            <td>
            <div class="input-append">
            <input type="text" class="sidInput" data-bind="value: sid"/>
            <span class="add-on" data-bind="click: loadTableList"><i class="icon-search"></i></span>
            </div>
            </td>
            </tr>
            <tr data-bind="style:{ visibility: tableList().length > 1 ? 'visible' : 'hidden'}">
            <td class="dataSetDesTitle">Table: </td>
            <td>
            <select data-bind='options: tableList, 
            optionsCaption: "Select a table", 
            value: chosenTableName'>                                                     
            </select>
            </td>
            </tr>
            </table>
            <div class="tableInfoTableWrapper">
            <table class="tableInfoTable" data-bind="with: currentTable">              
            <tr>                                
            <th style="width: 100px">Column Name</th>
            <th style="width: 80px">Type</th>
            <th style="width: 80px">Unit/Format</th>
            <th style="width: 150px; text-align: center;">Description</th>
            </tr>
            <tbody data-bind="foreach: rows">
            <tr>                                    
            <td data-bind="text: colfusionDataColumn.dname_chosen()"></td>
            <td data-bind="text: colfusionDataColumn.dname_value_type()"></td>      
            <td data-bind="text: colfusionDataColumn.dname_value_unit()"></td>
            <td data-bind="text: colfusionDataColumn.dname_value_description()"></td>                        
            </tr>
            </tbody>      
            </table>
            </div>
        </script>

        <div id="relationshipTransformationContainer" data-bind="foreach: links">
            <div class="accordion linkContainer" style="margin-bottom: 5px;" data-bind="attr: { id : 'accordion' + $index() }">
                <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" 
                           data-bind="text: 'Link #' + ($index() + 1), attr: { dataparent : '#accordion' + $index(), href : '#collapse' + $index() }">
                        </a>
                    </div>
                    <div data-bind="attr: { id : 'collapse' + $index() }" class="accordion-body collapse in">
                        <div class="accordion-inner">
                            <div>
                                <span>Enter column names from "From" and "To" parts of the relationship</span
                                <span><i data-bind="click: $parent.removeLink" class="icon-remove removeLinkBtn" title="Remove this link"></i></span>
                            </div>
                            <table class="linkContainerTable">
                                <tr>
                                    <td class="fromLinkPartContainer" data-bind="template: {name: 'linkPart-template', data: fromLinkPart}"></td>
                                    <td class="toLinkPartContainer"  data-bind="template: {name: 'linkPart-template', data: toLinkPart}"></td>
                                </tr>                           
                            </table>

                            <script type="text/html" id="linkPart-template">
                                <span data-bind="foreach: colfusionDataColumns, typeahead: $data">
                                <div style="margin-bottom: 7px;">
                                <input data-bind="value: dname_chosen" type="text" class="linkColumnNameInput"/>
                                <input data-bind="value: cid" type="hidden" class="linkColumnCidInput"/>
                                <i data-bind="visible: $index() > 0, click: $parent.removeDataColumn" title="Remove this column" class="icon-remove-sign"></i>
                                </div>                                    
                                </span>
                                <div><i data-bind="click: addDataColumn" class="icon-plus addLinkColumnBtn" title="Add Column"></i></div>
                            </script>

                        </div>
                    </div>
                </div>
            </div>        
        </div>
        <button data-bind="click: addLink" class="btn">Add Link</button>

    {/literal}    
    <div id="matchingContainer">
    </div>
    <div id="confidenceContainer">
        <div id="confidenceSliderContainer">
            <span id="confidenceText">Confidence: </span>
            <span  data-bind="text: confidenceValue" style="font-weight: bold;" id="slideValue"></span>
            <input data-bind="value: confidenceValue" type="hidden" id="confidenceValueInput"/>
            <table class="confidenceDesTable">
                <tr>
                    <td>Not Sure</td>
                    <td style="text-align: center">Strongly Belief</td>
                    <td style="text-align: right">Confident</td>
                </tr>
            </table>
            {literal}
                <div id="confidenceSlider" data-bind="slider: confidenceValue, sliderOptions: {min: 0, max: 1, step: 0.1}"></div>
            {/literal}
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
            <textarea data-bind="value: confidenceComment" style=" width: 95%; height: 80px;resize: none;"></textarea>
        </div>
    </div>
    <div style="margin-left: 10px;" class="submitRelPanel">
        <button data-bind="click: addRelationship" class="btn btn-primary">Submit</button>
        <button data-bind="click: cancelAddingRelationship" id="cancelAddingRelationshipBtn" class="btn" style="margin-left: 3px;">Cancel</button>
        <img data-bind="visible: isAddingRelationship" style="margin-left: 5px" src="{$my_pligg_base}/images/ajax-loader.gif"/>
        <span data-bind="visible: isAddingSuccessful" class="resultText successText"><i class="icon-ok-sign"></i>The relation has been saved.</span>
        <span data-bind="visible: isAddingFailed" class="resultText errorText"><i class="icon-remove-sign"></i>Some errors occur at server. Please try again.</span>
    </div>   
</div>
{literal}
    <script>
        var relationshipViewModel;

        $(function() {
        relationshipViewModel = new RelationshipViewModel();
        ko.applyBindings(relationshipViewModel, document.getElementById("newRelContainer"));
        loadInitialFromDataSet();

        $('#newRelationshipBtn').click(function(event) {
        relationshipViewModel.isContainerShowned(true);
        });
        });

        // If sid is assigned, load from date set after page is loaded.
        function loadInitialFromDataSet() {
        var fromDataSetSidInput = $('#fromDataSetWrapper').find('.dataSetDesTable').find('.sidInput');
        $(fromDataSetSidInput).prop('disabled', 'disabled').val(sid).trigger('change');
        relationshipViewModel.fromDataSet().loadTableList();
        }
    </script>
{/literal}