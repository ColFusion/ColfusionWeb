{literal}
<div class="dataPreviewTableWrapper">
    <div class="preview-story" id = "statisticsView">
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="storyStatisticsViewModel.getTablesList();">
            Expand/Close
        </button>
        <h3 class="preview-title">Statistics</h3>
        <div class="storycontent" id="storyStatisticsContainer">
            <!--<div class="storycontent">-->
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
                <div data-bind="visible: isError" style="color: red;">Some errors occur when trying to retrieve data. Please try again.</div>

                <div data-bind="with: currentTable">
                    <div id="dataPreviewTableWrapper" data-bind="horizontalScrollable: $data, style: { width: $root.tableList().length > 1 ? '82%' : '100%' }">
                        <table id="tfhover" class="tftable" border="1" style="white-space: nowrap;">
                            <tr data-bind="foreach: headers">
                                <th><span data-bind="text: name"></span><i class="icon-adjust" data-bind="click: $root.getPieChart" style="{cursor: pointer !important;}"></i>
                                    <i class="icon-adjust" data-bind="click: $root.getColumnChart" style="{cursor: pointer !important;}"></i>
                                    </th>
                            </tr>
                            <tbody class="dataPreviewTBody" data-bind="foreach: rows">
                                <tr class="datatr" data-bind="foreach: cells">
                                    <td data-bind="text: $data"></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <div id="previewTableNavigations">
                        <div style="display: inline-block;margin-right: 4px;" id="dataPreviewLoadingIcon" class="dataPreviewLoadingIcon">
                            <img data-bind="visible: $parent.isLoading" src="images/ajax-loader.gif" />
                        </div>
                        <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
                        <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() < totalPage(), click: $parent.goToNextPage" title="Next Page"></i>                        
                    </div>

                    </div>

                    
                    
                </div>
            <div id="statChartsContainer" />
            </div>
            
        </div>
    <!--</div>-->
    <script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script> 
</div>





{/literal}
