{literal}
    <div id="newRelWrapper">
        <form id="newRelWrapperForm">
            <i 
                data-bind="click: function(data, event) {newRelationshipViewModel.isContainerShowned(!newRelationshipViewModel.isContainerShowned());}" 
                id="newRelationshipBtn" 
                class="icon-plus" 
                title="Add New Relationship">
                <span style="font-size: 12px;">Add New Relationship</span>
            </i>
            <div data-bind="visible: isContainerShowned" id="newRelContainer">
                <h4 style="padding-left: 5px;">New Relationship</h4>
                <div id="relDescriptionContainer">
                    <table id="newRelDesTable">
                        <tr>
                            <td class="desTitle">Name: </td>
                            <td><input data-bind="value: name" data-required="true" style="width: 97%;" type="text"/></td>
                        </tr>
                        <tr>
                            <td class="desTitle">Description: </td>
                            <td><textarea data-bind="value: description" data-required="true" style=" width: 97%; height: 100px;resize: none;"></textarea></td>
                        </tr>
                    </table>
                </div>   
                <div id="dataSetMatchContainer">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 50%; vertical-align: top; border-right: rgb(174, 218, 243); border-right-width: 2px; border-right-style: solid;">
                                <div id="fromDataSetWrapper" class="dataSetWrapper">
                                    <div class="dataSetTitle">From:</div>
                                    <div id="fromDataSet" data-bind="template: { name: 'dataSet-template', data: fromDataSet }">
                                    </div>
                                </div>      
                            </td>
                            <td style="width: 50%; vertical-align: top;">
                                <div id="toDataSetWrapper" class="dataSetWrapper">
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
                    <div class="input-append" style="margin-top: -10px;">
                    <input type="text" class="sidInput" data-bind="searchDatasetTypeahead: $data"/>
                    <button class="btn add-on searchDatasetBtn" data-bind="click: loadTableList" style="margin-top: 10px;">Search</button>
                    </div>
                    </td>
                    </tr>
                    <tr data-bind="style:{ visibility: tableList().length > 1 ? 'visible' : 'hidden'}">
                    <td class="dataSetDesTitle">Table: </td>
                    <td>
                    <select data-bind='options: tableList, 
                    optionsCaption: "Select a table", 
                    value: chosenTableName'
                    style="width: 290px;">                                                     
                    </select>
                    </td>
                    </tr>
                    </table>
                    <div data-bind="visible: isLoadingTableInfo()" style="padding: 30px 0 0 200px;">
                        <img src="images/ajax-loader.gif" />
                    </div>
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

                <div id="relationshipTransformationContainer">
                    <table data-bind="visible: fromDataSet().currentTable() && toDataSet().currentTable()" style="width: 100%; vertical-align: middle;">
                        <thead>
                            <tr style="width: 100%">
                                <th colspan=3 style="text-align: left; padding-left: 10px;">
                                    Enter column names from "From" and "To" parts of the relationship
                                </th>           
                            </tr>
                        </thead>
                        <input type="hidden" data-min="1" data-bind="value: links().length" />
                        <tbody style="width: 100%" data-bind="template:{name:'link-template', foreach: links}">
                        </tbody>
                        <tfoot>
                            <tr style="width:100%">
                                <td colspan="3" style="padding: 0 10px 0 10px">
                                    <button type="button" data-bind="click: addLink" class="btn" >
                                        Add row
                                    </button>                                  
                                    <button type="button" data-bind="click: checkDataMatching" class="btn" >
                                        Check data matching
                                    </button>
                                    <!--
                                    <button type="button" data-bind="click: testDataEncoding" class="btn" >
                                        Test Data Encoding
                                    </button>
                                    -->
                                    <span data-bind="visible: isPerformingDataMatchingCheck">
                                        <img  src="images/ajax-loader.gif"/>
                                        <span>Performing data matching in selected columns...</span>
                                    </span>
                                    <span data-bind="text: dataMatchingCheckResult"></span>                            
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    <script id="link-template" type="text/html">
                        <tr style="width:100%; height: 38px;">
                        <td data-bind="with: fromLinkPart" style="width: 54.5%; border-right: rgb(174, 218, 243); border-right-width: 2px; border-right-style: solid; padding: 0 10px 0 10px;">
                        <input data-bind="multipleTypeahead: $data" class="linkDataColumnNameInput" type="text" style="width: 405px;"/>
                        </td>
                        <td  data-bind="with: toLinkPart" style="padding: 0 10px 0 10px">                  
                        <input data-bind="multipleTypeahead: $data" class="linkDataColumnNameInput" type="text" style="width: 405px;"/>
                        </td>
                        <td style="width: 10%; vertical-align: middle;">
                        <i data-bind="click: $root.removeLink" class="icon-remove-sign" title="Remove this row" style="font-size: 18px;"></i>
                        <input type="hidden"/>
                        </td>        
                        </tr>
                    </script>
                </div>   
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
                        <div id="confidenceSlider" data-bind="slider: confidenceValue, sliderOptions: {min: -1, max: 1, step: 0.1}"></div>
                        <table class="confidenceDesTable">
                            <tr>
                                <td>-1</td>
                                <td style="text-align: center">0</td>
                                <td style="text-align: right">1</td>
                            </tr>
                        </table>
                    </div>
                    <div id="confidenceComment">
                        <div style="margin-bottom: 10px">Confidence comment:</div>
                        <textarea data-bind="value: confidenceComment" data-required="true" style=" width: 95%; height: 80px;resize: none;"></textarea>
                    </div>
                </div>
                <div style="margin-left: 10px;" class="submitRelPanel">
                    <button data-bind="click: addRelationship" class="btn btn-primary">Submit</button>
                    <button data-bind="click: cancelAddingRelationship" id="cancelAddingRelationshipBtn" class="btn" style="margin-left: 3px;">Cancel</button>
                    <img data-bind="visible: isAddingRelationship" style="margin-left: 5px" src="images/ajax-loader.gif"/>
                    <span data-bind="visible: isAddingSuccessful" class="resultText successText"><i class="icon-ok-sign"></i>The relation has been saved.</span>
                    <span data-bind="visible: isAddingFailed" class="resultText errorText"><i class="icon-remove-sign"></i>Some errors occur at server. Please try again.</span>
                </div>   
            </div>
        </form>
    </div>   
    <script type="text/javascript">
        var newRelationshipViewModel = new NewRelationshipViewModel();

        $(function() {
            ko.applyBindings(newRelationshipViewModel, document.getElementById("newRelWrapper"));
        });

        // If sid is assigned, load from date set after page is loaded.
        function loadInitialFromDataSet() {
            var fromDataSetSidInput = $('#fromDataSetWrapper').find('.dataSetDesTable').find('.sidInput');
            var fromDataSetSidSearchBtn = $('#fromDataSetWrapper').find('.dataSetDesTable').find('button');
            $(fromDataSetSidInput).add(fromDataSetSidSearchBtn).prop('disabled', 'disabled').trigger('change');
            newRelationshipViewModel.fromDataSet().sid(sid);
            newRelationshipViewModel.fromDataSet().loadTableList();
        }
    </script>
{/literal}