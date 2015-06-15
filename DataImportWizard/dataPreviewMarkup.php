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
                                <div align="left" style="margin-top:15px">
                                <font size="5" color="#1ea4e9">Editing:</font>
                                <font size="5"><span id="storyTitleOpenRefinePopUp"/> </font>    
                            </div>
                            
                           
                                <div align="right">
                                    <button id="closeDialog" class="btn btn-link" type="button" data-bind="click: $root.refreshPreview" aria-hidden="true">Close this dialog</button>
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
                                  <iframe id="OpenRefineIframe"
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
                            
                            <th style="font-style:Italic">
                                Chosen Name: <span data-bind="text: name" style="font-weight:normal;font-style:normal"></span>
                                <br/><br/>
                                Value Type: <span data-bind="text: variableValueType" style="font-weight:normal;font-style:normal"></span>
                                 <br/><br/>
                                Original Name: <span data-bind="text: originalName" style="font-weight:normal;font-style:normal"></span>
                                <br/><br/>
                                Description: <span data-bind="text: description" style="font-weight:normal;font-style:normal"></span>
                                <br/><br/>
                                Variable Measuring Unit: <span data-bind="text: variableMeasuringUnit" style="font-weight:normal;font-style:normal"></span>
                                <br/><br/>
                                Variable Value Format: <span data-bind="text: variableValueFormat" style="font-weight:normal;font-style:normal"></span>
                                <br/><br/>
                                Missing Value: <span data-bind="text: missingValue" style="font-weight:normal;font-style:normal"></span>
                                <br/>
                                <span class="pull-right btn-link" data-bind="visible:isColumnMetaEdit(),click: $root.Modify.bind($data,cid(),name(),variableValueType(),description(),variableMeasuringUnit(),variableValueFormat(),missingValue(),$index())" style="font-weight:normal;font-style:normal">[Edit]</span>
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




    <div class="preview-story" id="editColumnData" data-bind="with:currentTable, visible: $root.isEditColumnData()">
        <span style="font-size:20px; font-weight:bolder">Column Information</span><br/>
        <span style="width:860px; margin-left:20px; height:36px;  margin-top:10px">Edit column description. Please click Save button after you finish editing. You can also click the Cancel button to ignore the changes you make and </span>
        <span style="width:860px; margin-left:20px; height:36px;  margin-top:10px">go back to previous version.</span>
        <div data-bind="with:headers()[$root.index()]">
        <div  class="control-group" style="margin-left:18px; width:870px; height:50px">
       <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Chosen Name <span class="text-error">*</span>:</label>
       <span>
       <input id="columName" name="columnName" data-required="true" type="text" data-bind="value: name" style="width:676px; height:20px; margin-left:20px; text-align:start"/><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'chosen name')" style="width:45px; height:15px; margin-left:180px">[History]</a>
        </span>
        <span style="color:red;margin-left:200px" data-bind="visible: $root.isChosenNameEmpty()">Chosen Name should not be empty!</span>
     </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Value Type <span class="text-error">*</span>:</label>
        <span>
       <select id="valueType" name="valueType" data-required="true" type="text" data-bind="options:$root.selectValueType, value: variableValueType, event:{change:$root.valueTypeChange}" style="width:676px; margin-left:20px; text-align:start"></select><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'data type')" style="width:45px; height:15px; margin-left:180px">[History]</a>
   </span>
        </div><br/>
        <div  class="control-group" style="margin-left:18px; width:870px; height:50px">
       <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Original Name <span class="text-error"></span>:</label>
       <span>
       <input id="columName" name="columnName" data-required="true" type="text" data-bind="value: originalName" style="width:676px; height:20px; margin-left:20px; text-align:start" readOnly="true"/><br/>
        </span>
     </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px; height:130px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Description <span class="text-error"></span>:</label>
       <textarea id="description" name="description" data-required="true" type="text" data-bind="value: description" rows="5" style="width:676px; height:110px; margin-left:20px; text-align:start"></textarea><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'description')" style="width:45px; height:15px; margin-left:180px">[History]</a>
        </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Variable Measuring Unit <span class="text-error"></span>:</label>
       <select id="variableMeasuringUnit" name="variableMeasuringUnit" data-required="true" type="text" data-bind="options:$root.selectUnit, value: variableMeasuringUnit" style="width:676px; margin-left:20px; text-align:start"></select><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'value unit')" style="width:45px; height:15px; margin-left:180px">[History]</a>
        </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Variable Value Format <span class="text-error"></span>:</label>
       <select id="variableValueFormat" name="variableValueFormat" data-required="true" type="text" data-bind="options:$root.selectFormat, value: variableValueFormat" style="width:676px; margin-left:20px; text-align:start"></select><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'format')" style="width:45px; height:15px; margin-left:180px">[History]</a>
        </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px; height:50px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Missing Value <span class="text-error"></span>:</label>
       <input id="missingValue" name="missingValue" data-required="true" type="text" data-bind="value: missingValue" style="width:676px; height:20px; margin-left:20px; text-align:start"/><br/>
       <a href="#columnhistoryModal" data-toggle="modal" class="inputHistoryLink btn-link" data-bind="click: $root.showColumnMetaHistory.bind($data,'missing value')" style="width:45px; height:15px; margin-left:180px">[History]</a>
        </div><br/>
        <div class="control-group" style="margin-left:18px; width:870px; height:50px">
        <label style="text-align:right; width:160px; height:25px; float:left; display:block; padding-top:5px">Reason <span class="text-error"></span>:</label>
       <textarea id="reason" name="missingValue" data-required="true" type="text" style="width:676px; height:50px; margin-left:20px; text-align:start" rows="3"></textarea>
        </div><br/>
        <div style="text-align:right">
        <button id="saveMetadataButton" class="btn btn-primary" data-bind="click: $root.editColumnSave" data-loading-text="Saving..." data-complete-text="Saved!">Save</button>
        <button id="canceleMetadataButton" class="btn" data-bind="click: $root.editColumnCancel" data-loading-text="Cancel">Cancel</button>
    </div> 
</div>
    </div>







 <div id="columnhistoryModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="historyModalLabel" aria-hidden="false" style="display:block">
          <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
            <h3 id="historyModalLabel" data-bind="text: historyLogHeaderText"></h3>
          </div>
          <div class="modal-body">
            <div id="fetchInProgressDiv" data-bind="visible: isFetchHistoryInProgress">
                <span id="fetchInProgressLoadingIcon" data-bind="visible: isFetchHistoryInProgress()">
                    <img src="/images/ajax-loader.gif"/>
                </span>
            </div>
            <div id="contentDiv" >
                <table class="table table-hover" data-bind="with: columnMetadataHistory">
                    <tr>
                        <th>Date Saved</th>
                        <th>Author</th>
                        <th>Value</th>
                        <th>Reason</th>
                    </tr>
                    <tbody data-bind="foreach: historyLogRecords">
                        <tr>
                            <td data-bind="text: whenSaved"></td>
                            <td data-bind="with: author">
                                <span data-bind="text: authorInfo"></span>
                            </td>
                            <td data-bind="text: itemValue"></td>
                            <td data-bind="text: reason"></td>
                        </tr>
                    </tbody>               
                </table>
            </div>
            <div id="fetchFailedMsgDiv" data-bind="visible: isFetchHistoryErrorMessage().length > 0">
                <span data-bind="text: isFetchHistoryErrorMessage" class="text-error"></span>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            <!-- <button class="btn btn-primary">Save changes</button> -->
          </div>
        </div>






    <script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script> 
    <script type="text/javascript" language="javascript">
        var autoHeight = document.documentElement.clientHeight*0.8;
        var autoWidth = document.documentElement.clientWidth*0.8;
        $("#OpenRefineIframe").height(autoHeight);
        $("#OpenRefineIframe").width(autoWidth);

    </script>
    
</div>

