<div class="dataPreviewTableWrapper">
    <div class="preview-story" data-bind="visible: isPreviewStory">
    <!--
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="openVisualizationPage()">
            <i class="icon-bar-chart" style="margin-right: 5px;"></i>
            Visualize
        </button>
        -->
        <h3 class="preview-title">Data Preview</h3>

        <div class="storycontent" id="dataPreviewContainer">
            <ul data-bind="visible: tableList().length > 1, foreach: tableList" class="tableList" id="previewTableList">
                <li data-bind="click: $root.chooseTable" class="tableListItem">
                    <span class="chosenTableBullet">
                        <i data-bind="visible: isChoosen" class="chosenIcon icon-caret-right"></i>
                    </span>
                    <span class="tableText" data-bind="text: tableName"></span>
                </li>
            </ul>
            <!-- ko if: $data.hasOwnProperty("isRefreshingUpdateStatus") -->
            <div data-bind="visible: isRefreshingUpdateStatus() && !isNoData() && !currentTable()" style="color: grey;">
                Processing Data...
            </div>
            <!-- /ko -->
            <div data-bind="visible: isNoData" style="color: grey;">This table has no data or the data are being processed.</div>
            <!-- Since we would need to rewrite it the back end in java anyway, for now here is a hack to not show error message if for example the target database is not created yet-->
            <div data-bind="visible: isError" style="color: grey;">This table has no data or the data are being processed.</div>
            <div data-bind="with: currentTable">
                <div id="dataPreviewTableWrapper" data-bind="horizontalScrollable: $data, style: { width: $root.tableList().length > 1 ? '82%' : '100%' }">

                     <div id="editpopup" class="lightbox hide fade"  tabindex="-1" role="dialog" aria-hidden="true">
                       <div class='lightbox-content' height="1000">


                            <div id="hintmessage">
                                <div align="left">
                                <font size="5" color="#1ea4e9">Editing:</font>
                                <font size="5"><span id="storyTitleOpenRefinePopUp"/> </font>    
                            </div>
                            
                           
                                <div align="right">
                                    <button class="btn btn-link" type="button" data-dismiss="lightbox" data-bind="click: $root.refreshPreview" aria-hidden="true">Close this dialog</button>
                              </div><br>
                           
                            <div>
                                <div align="left">
                                <font size="2.5">Please click save button if you want the changes to be persistent. To learn how to edit data with OpenRefine, please visit: <a href="http://openrefine.org/" target="_blank">http://openrefine.org/</a></font>
                            </div>
                                <div align="right">
                                    <button class="btn btn-link" type="button" data-dismiss="lightbox" data-bind="click: $root.refreshPreview" aria-hidden="true" style="visibility:hidden">Close this dialog</button>
                              </div>
                            </div>
                               
                              
                            </div>
                                                    
                            
                            <div>
                                  <iframe width="1500" height="770" 
                                data-bind="attr: {'src':  openRefineURL()}">
                            </iframe>
                            </div>
                        </div>
                     </div>
                   <span class="pull-right btn-link" data-bind="visible: isProjectLoading()">
                     <img src="images/ajax-loader.gif" style="width:15px; height:15px;padding-left:10px"/>
                    </span>
                    <span class="pull-right btn-link" data-bind="visible: isEditLinkVisible(), click: swithToOpenRefine">&nbsp;&nbsp;[Edit]</span>
                     <!--Alex-->
                    <span class="pull-right btn-link" data-bind="click: $root.refreshTablePreview">[Refresh]</span><!--Alex-->
                    <span id="isEditingMsg" class="pull-right"></span>
                    <span id="metabutton" class="pull-left btn-link" data-bind="click: showColumnMetaData">[Details]</span>
                    <table id="tfhover" class="tftable" border="1" style="white-space: nowrap;">
                        <tr data-bind="foreach: headers, visible: isHeaderVisible()">
                            <th>
                                <span data-bind="text: name"></span>
                                </th>
                            </tr>
                            <tr data-bind="foreach: headers, visible: isHeaderMetaVisible()">
                            
                            <th>
                                Name: <span data-bind="text: name"></span>
                                <br/>
                                ValueType: <span data-bind="text: variableValueType"></span>
                                 <br/>
                                OriginalName: <span data-bind="text: originalName"></span>
                                <br/>
                                Description: <span data-bind="text: description"></span>
                                <br/>
                                VariableMeasuringUnit: <span data-bind="text: variableMeasuringUnit"></span>
                                <br/>
                                VariableValueFormat: <span data-bind="text: variableValueFormat"></span>
                                <br/>
                                MissingValue: <span data-bind="text: missingValue"></span>
                                <br/>
                                <span class="pull-right btn-link" data-bind="click: $root.Modify.bind($data,name(),variableValueType(),originalName(),description(),variableMeasuringUnit(),variableValueFormat(),missingValue())">[Modify]</span>
                            </th>
                        </tr>
                        <tbody class="dataPreviewTBody" data-bind="foreach: rows">
                            <tr class="datatr" data-bind="foreach: cells">
                                <td data-bind="text: $data"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="previewTableNavigations">
                    <div style="display: inline-block;margin-right: 4px;" id="dataPreviewLoadingIcon" class="dataPreviewLoadingIcon">
                        <img data-bind="visible: $parent.isLoading" src="images/ajax-loader.gif" />
                    </div>
                    <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
                    <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() < totalPage(), click: $parent.goToNextPage" title="Next Page"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="preview-story" id="editColumnData" data-bind="visible: isEditColumnData">
        <div style="margin-left:120px">
        Name <span class="text-error">*</span>:
       <input id="columName" name="columnName" data-required="true" type="text" data-bind="value: columnName" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        ValueType <span class="text-error">*</span>:
       <input id="valueType" name="valueType" data-required="true" type="text" data-bind="value: variableValueType" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        OriginalName <span class="text-error">*</span>:
       <input id="originalName" name="originalName" data-required="true" type="text" data-bind="value: originalName" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        Description <span class="text-error">*</span>:
       <input id="description" name="description" data-required="true" type="text" data-bind="value: description" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        VariableMeasuringUnit <span class="text-error">*</span>:
       <input id="variableMeasuringUnit" name="variableMeasuringUnit" data-required="true" type="text" data-bind="value: variableMeasuringUnit" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        VariableValueFormat <span class="text-error">*</span>:
       <input id="variableValueFormat" name="variableValueFormat" data-required="true" type="text" data-bind="value: variableValueFormat" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="margin-left:120px">
        MissingValue <span class="text-error">*</span>:
       <input id="missingValue" name="missingValue" data-required="true" type="text" data-bind="value: missingValue" style="width:500px; margin-left:15px"/>
        </div><br/>
        <div style="text-align:right">
        <button id="saveMetadataButton" class="btn btn-primary" data-bind="click: $root.editColumnSave" data-loading-text="Saving..." data-complete-text="Saved!">Save</button>
        <button id="canceleMetadataButton" class="btn" data-bind="click: $root.editColumnCancel" data-loading-text="Cancel">Cancel</button>
    </div>
    </div>
    <script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script>    
</div>
