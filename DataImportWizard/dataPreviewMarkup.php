<div class="dataPreviewTableWrapper">
    <div class="preview-story">
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
                       <div class='lightbox-content' align="left">


                            <div id="hintmessage">
                                 <span href="#" data-toggle="tooltip" data-placement="bottom" title="You can be here to edit data. Please click save button if you want the changes to be persistent. You also can visit http://openrefine.org/ to get help."> 
                                    <i class="icon-info-sign" style="font-size:20px"></i>
                                </span>
                                <font size="5" color="#1ea4e9">Editing:</font>
                                <font size="5"><span id="storyTitleOpenRefinePopUp"/> </font>    
                                <div class="pull-right">
                                    <button class="btn btn-link" type="button" data-dismiss="lightbox" data-bind="click: $root.refreshPreview" aria-hidden="true">Close this dialog</button>
                              </div>                        
                            </div>
                            <div>
                                  <iframe name="testframe" width="1200" height="1100" 

                                data-bind="attr: {'src':  openRefineURL()}"></iframe>
                            </div>
                        </div>
                     </div>

                    <span class="pull-right btn-link" data-bind="visible: isEditLinkVisible(), click: swithToOpenRefine">&nbsp;&nbsp;[Edit]</span><!--Alex-->
                    <span class="pull-right btn-link" data-bind="click: $root.refreshTablePreview">[Refresh]</span><!--Alex-->
                    <span id="isEditingMsg" class="pull-right"></span>
                    
                    <table id="tfhover" class="tftable" border="1" style="white-space: nowrap;">
                        <tr data-bind="foreach: headers">
                            <th data-bind="text: name"></th>
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
    <script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script>    
</div>
